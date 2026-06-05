{ config, lib, pkgs, ... }:
let
  cfg = config.smi.programs.git.signing;
  home = config.home.homeDirectory;
in
{
  options.smi.programs.git.signing = {
    enable = lib.mkEnableOption "SSH signing key for git commits";
  };

  config = lib.mkIf cfg.enable {
    home.activation.generateGitSigningKey = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      keyfile="${home}/.ssh/signing/id-ed25519-signing"
      if [ ! -f "$keyfile" ]; then
        $DRY_RUN_CMD mkdir -p -m 700 "$(dirname "$keyfile")"
        $DRY_RUN_CMD ${pkgs.openssh}/bin/ssh-keygen \
          -t ed25519 \
          -f "$keyfile" \
          -C "signing@$(hostname)" \
          -N ""
      fi
    '';

    programs.git.settings = lib.mkIf config.programs.git.enable {
      gpg.format = "ssh";
      user.signingKey = "${home}/.ssh/signing/id-ed25519-signing.pub";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
}
