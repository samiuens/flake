{ lib }:
{
  importDir =
    dir:
    let
      go =
        d: isRoot:
        lib.concatLists (
          lib.mapAttrsToList (
            name: type:
            if type == "directory" then
              let
                subDir = d + "/${name}";
                hasDefault = builtins.pathExists (subDir + "/default.nix");
              in
              if hasDefault then [ (subDir + "/default.nix") ] else go subDir false
            else if type == "regular" && lib.hasSuffix ".nix" name && !(isRoot && name == "default.nix") then
              [ (d + "/${name}") ]
            else
              [ ]
          ) (builtins.readDir d)
        );
    in
    go dir true;
}
