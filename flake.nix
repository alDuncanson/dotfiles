{
  description = "dotfiles";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

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

  outputs = inputs@{
    flake-parts,
    nixpkgs,
    home-manager,
    nvf,
    ...
  }: let
    defaultSystem = "aarch64-darwin";
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    mkHome = {
      system,
      userName,
      homeDirectory,
      gitName,
      gitEmail,
      profileModule,
    }: let
      pkgs = mkPkgs system;
    in
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit gitEmail gitName homeDirectory userName;
        };
        modules = [
          nvf.homeManagerModules.default
          ./home.nix
          profileModule
        ];
      };
    personal = mkHome {
      system = defaultSystem;
      userName = "al";
      homeDirectory = "/Users/al";
      gitName = "Al Duncanson";
      gitEmail = "alDuncanson@proton.me";
      profileModule = ./profiles/personal.nix;
    };
    work = mkHome {
      system = defaultSystem;
      userName = "sn93ib";
      homeDirectory = "/Users/sn93ib";
      gitName = "Al Duncanson";
      gitEmail = "al.duncanson@gfs.com";
      profileModule = ./profiles/work.nix;
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [defaultSystem];

      perSystem = {system, ...}: let
        pkgs = mkPkgs system;
        neovim =
          (nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [
              {
                config = import ./modules/nvim.nix {inherit pkgs;};
              }
            ];
          }).neovim;
      in {
        packages = {
          default = neovim;
          inherit neovim;
        };

        apps = {
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

      flake.homeConfigurations = {
        al = personal;
        personal = personal;
        sn93ib = work;
        work = work;
      };
    };
}
