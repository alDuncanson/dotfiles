{
  username,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/programs.nix
  ];

  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.05";
  };
}
