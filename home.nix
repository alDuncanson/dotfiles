{...}: {
  imports = [
    ./modules/base.nix
    ./modules/programs.nix
  ];

  home = {
    username = "al";
    homeDirectory = "/Users/al";
    stateVersion = "24.05";
  };
}
