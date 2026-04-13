{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    hasSuffix
    mapAttrs
    mapAttrsToList
    mkOption
    nameValuePair
    types
    ;

  importNixFiles =
    dir:
    builtins.map (name: dir + "/${name}") (
      builtins.filter (name: hasSuffix ".nix" name) (builtins.attrNames (builtins.readDir dir))
    );

  profileType = types.submodule (
    { ... }:
    {
      options = {
        aliases = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };

        system = mkOption {
          type = types.str;
        };

        userName = mkOption {
          type = types.str;
        };

        homeDirectory = mkOption {
          type = types.str;
        };

        gitName = mkOption {
          type = types.str;
        };

        gitEmail = mkOption {
          type = types.str;
        };

        homeModule = mkOption {
          type = types.deferredModule;
          default = { };
        };
      };
    }
  );

  mkHomeConfiguration =
    profile:
    let
      pkgs = config.dotfiles.lib.mkPkgs profile.system;
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        inputs.nvf.homeManagerModules.default
        {
          home = {
            username = profile.userName;
            homeDirectory = profile.homeDirectory;
            stateVersion = config.dotfiles.home.stateVersion;
          };

          programs.git.settings.user = {
            name = profile.gitName;
            email = profile.gitEmail;
          };
        }
        config.dotfiles.home.shared
        profile.homeModule
      ];
    };

  canonicalHomes = mapAttrs (_: mkHomeConfiguration) config.dotfiles.profiles;

  aliasHomes = builtins.listToAttrs (
    lib.concatLists (
      mapAttrsToList (
        _: profile: builtins.map (alias: nameValuePair alias (mkHomeConfiguration profile)) profile.aliases
      ) config.dotfiles.profiles
    )
  );
in
{
  imports = importNixFiles ./modules ++ importNixFiles ./profiles;

  options.dotfiles = {
    defaultSystem = mkOption {
      type = types.str;
      default = "aarch64-darwin";
    };

    lib.mkPkgs = mkOption {
      type = types.raw;
      readOnly = true;
    };

    home = {
      stateVersion = mkOption {
        type = types.str;
        default = "24.05";
      };

      shared = mkOption {
        type = types.deferredModule;
        default = { };
      };
    };

    neovim.settings = mkOption {
      type = types.raw;
      default = _: { };
    };

    profiles = mkOption {
      type = types.attrsOf profileType;
      default = { };
    };
  };

  config = {
    dotfiles.lib.mkPkgs =
      system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    flake.homeConfigurations = canonicalHomes // aliasHomes;
  };
}
