{ ... }:
{
  dotfiles.home.shared = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" = {
          IdentityFile = "~/.ssh/github_auth";
          IdentitiesOnly = true;
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
        zion = {
          HostName = "136.65.217.225";
          User = "alduncanson";
          IdentityFile = "~/.ssh/zion";
          IdentitiesOnly = true;
        };
      };
    };

    launchd.agents.ssh-add-keychain = {
      enable = true;
      config = {
        ProgramArguments = [
          "/usr/bin/ssh-add"
          "--apple-load-keychain"
        ];
        RunAtLoad = true;
      };
    };
  };
}
