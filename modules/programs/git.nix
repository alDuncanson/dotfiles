{ ... }:
{
  dotfiles.home.shared = {
    programs.git = {
      enable = true;
      signing = {
        format = "ssh";
        key = "~/.ssh/github_signing.pub";
        signByDefault = true;
        allowedSigners = ''
          alDuncanson@proton.me namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAyKVkMKiF3nuqzzuYwCVYYjGXMb3cdRTrem9ON44mMd mac signing
          alDuncanson@proton.me namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5bPFGOY9ITCuFnt4f1Es8HD6xgdvJqoFf0LFN2SO6P work mac github signing
        '';
      };
      settings = {
        diff.submodule = "log";
        fetch.prune = true;
        init.defaultBranch = "main";
      };
    };
  };
}
