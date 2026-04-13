{lib, ...}: let
  inherit (lib) hasSuffix;

  importNixFiles = dir:
    builtins.map (name: dir + "/${name}") (
      builtins.filter (name: hasSuffix ".nix" name) (builtins.attrNames (builtins.readDir dir))
    );
in {
  imports = importNixFiles ./programs;
}
