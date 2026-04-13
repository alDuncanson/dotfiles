{ ... }:
{
  dotfiles.home.shared = {
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        file-style = "yellow";
        file-decoration-style = "yellow ul";
        hunk-header-style = "blue";
        hunk-header-decoration-style = "blue box";
        minus-style = "red";
        minus-emph-style = "red bold";
        minus-non-emph-style = "red";
        minus-empty-line-marker-style = "red";
        zero-style = "normal";
        plus-style = "green";
        plus-emph-style = "green bold";
        plus-non-emph-style = "green";
        plus-empty-line-marker-style = "green";
      };
    };
  };
}
