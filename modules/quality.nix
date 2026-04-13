{ lib, config, ... }:
let
  topConfig = config;
  inherit (lib) filterAttrs mapAttrs' nameValuePair;
  src = ../.;
in
{
  perSystem =
    {
      pkgs,
      config,
      system,
      ...
    }:
    let
      profilesForSystem = filterAttrs (_: profile: profile.system == system) topConfig.dotfiles.profiles;
    in
    {
      formatter = pkgs.writeShellApplication {
        name = "nixfmt-tree";
        runtimeInputs = [
          pkgs.findutils
          pkgs.nixfmt
        ];
        text = ''
          if [ "$#" -eq 0 ]; then
            mapfile -t files < <(find . -type f -name '*.nix' | sort)
            if [ "''${#files[@]}" -eq 0 ]; then
              exit 0
            fi
            exec nixfmt "''${files[@]}"
          fi

          exec nixfmt "$@"
        '';
      };

      checks =
        mapAttrs' (
          name: _: nameValuePair "home-${name}" topConfig.flake.homeConfigurations.${name}.activationPackage
        ) profilesForSystem
        // {
          formatting =
            pkgs.runCommand "nixfmt-check"
              {
                nativeBuildInputs = [
                  pkgs.findutils
                  pkgs.nixfmt
                ];
              }
              ''
                cd ${src}

                while IFS= read -r file; do
                  nixfmt --check "$file"
                done < <(find . -type f -name '*.nix' | sort)

                touch "$out"
              '';

          neovim = config.packages.neovim;
        };
    };
}
