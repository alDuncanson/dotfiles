{
  description = "dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nvf,
    ...
  }: let
    supportedSystems = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forEachSystem = nixpkgs.lib.genAttrs supportedSystems;
    neovimFor = system:
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          {
            config = import ./modules/nvim.nix;
          }
        ];
      }).neovim;
  in {
    homeConfigurations = {
      al = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        extraSpecialArgs = {
          username = "al";
        };
        modules = [
          nvf.homeManagerModules.default
          ./home.nix
          {
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };

    packages = forEachSystem (system: {
      default = neovimFor system;
      neovim = neovimFor system;
    });

    apps = forEachSystem (system: {
      default = {
        type = "app";
        program = "${neovimFor system}/bin/nvim";
      };
      neovim = {
        type = "app";
        program = "${neovimFor system}/bin/nvim";
      };
    });
  };
}
