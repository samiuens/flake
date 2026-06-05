{ config, lib, pkgs, ... }:
let
  cfg = config.smi.programs.ssh;
  home = config.home.homeDirectory;

  knownHosts = {
    github = "github.com";
    gitlab = "gitlab.com";
    codeberg = "codeberg.org";
  };

  providerModule =
    { name, ... }:
    {
      options = {
        enable = lib.mkEnableOption "SSH key for ${name}";
        host = lib.mkOption {
          type = lib.types.str;
          default = knownHosts.${name} or name;
          description = "SSH hostname for match block";
        };
        username = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Username on this platform";
        };
        comment = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "SSH key comment (overrides username-based default)";
        };
        insteadOf = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "URLs/prefixes to rewrite to SSH for this provider";
        };
      };
    };

  safeName = name: builtins.replaceStrings [ "." ] [ "_" ] name;

  enabledProviders = lib.filterAttrs (_: p: p.enable) cfg.providers;

  keyName = provider: sname:
    if provider.username != "" then "id-ed25519-${provider.username}" else "id-ed25519-${sname}";
in
{
  options.smi.programs.ssh.providers = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule providerModule);
    default = { };
    description = "Git providers with automatic SSH key generation";
  };

  config = {
    home.activation = lib.mapAttrs' (
      name: provider:
      let
        sname = safeName name;
      in
      lib.nameValuePair "generateSshKey_${sname}" (
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          keyfile="${home}/.ssh/${sname}/${keyName provider sname}"
          if [ ! -f "$keyfile" ]; then
            $DRY_RUN_CMD mkdir -p -m 700 "$(dirname "$keyfile")"
            ${lib.optionalString (provider.comment != "") ''comment="${provider.comment}"''}
            ${lib.optionalString (provider.comment == "" && provider.username != "") ''comment="${provider.username}@${provider.host}"''}
            ${lib.optionalString (provider.comment == "" && provider.username == "") ''comment="${sname}@$(hostname)"''}
            $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen \
              -t ed25519 \
              -f "$keyfile" \
              -C "$comment" \
              -N ""
          fi
        ''
      )
    ) enabledProviders;

    programs.ssh.matchBlocks = lib.mapAttrs' (
      name: provider:
      let
        sname = safeName name;
      in
      lib.nameValuePair provider.host {
        identityFile = "${home}/.ssh/${sname}/${keyName provider sname}";
        identitiesOnly = true;
      }
    ) enabledProviders;

    programs.git.settings = lib.mkMerge (
      lib.mapAttrsToList (_: provider:
        lib.mkIf (provider.insteadOf != [ ]) {
          url."git@${provider.host}:" = {
            insteadOf = provider.insteadOf;
          };
        }
      ) enabledProviders
    );
  };
}
