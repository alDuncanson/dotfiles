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

    # Load keychain-backed keys into the macOS agent at login so commit signing
    # works before any ssh connection has loaded the signing key.
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
