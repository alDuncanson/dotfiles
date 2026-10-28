{ ... }:
{
  dotfiles.home.modules.gh = {
    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        aliases.co = "pr checkout";
        git_protocol = "ssh";
        prompt = "enabled";
      };
    };
  };
}
