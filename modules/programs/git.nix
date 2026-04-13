{ ... }:
{
  dotfiles.home.shared = {
    programs.git = {
      enable = true;
      signing.format = null;
      settings = {
        commit.gpgsign = false;
        diff.submodule = "log";
        fetch.prune = true;
        init.defaultBranch = "main";
      };
    };
  };
}
