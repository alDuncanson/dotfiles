{
  userName,
  homeDirectory,
  gitName,
  gitEmail,
  ...
}: {
  imports = [
    ./modules/base.nix
    ./modules/programs.nix
  ];

  home = {
    username = userName;
    inherit homeDirectory;
    stateVersion = "24.05";
  };

  programs.git.settings.user = {
    name = gitName;
    email = gitEmail;
  };
}
