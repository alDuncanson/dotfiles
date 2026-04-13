{ ... }:
{
  dotfiles.home.shared = {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        aliases.co = "pr checkout";
        git_protocol = "https";
        prompt = "enabled";
      };
    };
  };
}
