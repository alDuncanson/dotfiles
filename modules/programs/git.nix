{ ... }:
{
  dotfiles.home.shared = {
    programs.git = {
      enable = true;
      signing = {
        format = "ssh";
        key = "~/.ssh/github_signing.pub";
        signByDefault = true;
      };
      settings = {
        diff.submodule = "log";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        fetch.prune = true;
        init.defaultBranch = "main";
      };
    };
  };
}
