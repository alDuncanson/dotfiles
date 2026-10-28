inputs:
{ lib, config, ... }:
let
  inherit (lib)
    attrNames
    attrValues
    hasSuffix
    mapAttrs
    mapAttrsToList
    mkOption
    nameValuePair
    types
    ;

  topConfig = config;

  profileType = types.submodule (
    { config, ... }:
    {
      options = {
        aliases = mkOption {
          type = types.listOf types.str;
          default = [ ];
        };

        system = mkOption {
          type = types.str;
          default = topConfig.dotfiles.defaultSystem;
        };

        userName = mkOption {
          type = types.str;
        };

        homeDirectory = mkOption {
          type = types.str;
          default =
            if hasSuffix "darwin" config.system then
              "/Users/${config.userName}"
            else
              "/home/${config.userName}";
        };

        modules = mkOption {
          type = types.listOf (types.enum (attrNames topConfig.dotfiles.home.modules));
          default = attrNames topConfig.dotfiles.home.modules;
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
        {
          home = {
            username = profile.userName;
            homeDirectory = profile.homeDirectory;
            stateVersion = config.dotfiles.home.stateVersion;
          };
        }
        config.dotfiles.home.shared
      ]
      ++ map (name: config.dotfiles.home.modules.${name}) profile.modules
      ++ [ profile.homeModule ];
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
  imports = [ (inputs.import-tree ./modules) ];

  options.dotfiles = {
    defaultSystem = mkOption {
      type = types.str;
      default = "aarch64-darwin";
    };

    inputs = mkOption {
      type = types.raw;
      readOnly = true;
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

      modules = mkOption {
        type = types.attrsOf types.deferredModule;
        default = { };
      };
    };

    profiles = mkOption {
      type = types.attrsOf profileType;
      default = { };
    };
  };

  config = {
    systems = lib.mkDefault [ config.dotfiles.defaultSystem ];

    dotfiles.inputs = inputs;

    perSystem =
      { system, ... }:
      {
        _module.args.pkgs = config.dotfiles.lib.mkPkgs system;
      };

    dotfiles.lib.mkPkgs =
      system:
      import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

    flake.homeConfigurations = canonicalHomes // aliasHomes;

    flake.homeModules = config.dotfiles.home.modules // {
      default.imports = [ config.dotfiles.home.shared ] ++ attrValues config.dotfiles.home.modules;
    };
  };
}
