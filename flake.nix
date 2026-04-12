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
    system = "aarch64-darwin";
    pkgs = nixpkgs.legacyPackages.${system};
    neovim =
      (nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          {
            config = import ./modules/nvim.nix;
          }
        ];
      }).neovim;
  in {
    homeConfigurations = {
      al = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          nvf.homeManagerModules.default
          ./home.nix
          {
            nixpkgs.config.allowUnfree = true;
          }
        ];
      };
    };

    packages.${system} = {
      default = neovim;
      inherit neovim;
    };

    apps.${system} = {
      default = {
        type = "app";
        program = "${neovim}/bin/nvim";
      };
      neovim = {
        type = "app";
        program = "${neovim}/bin/nvim";
      };
    };
  };
}
