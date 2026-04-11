{
  vim = {
    binds.whichKey.enable = true;
    git.enable = true;
    hideSearchHighlight = true;
    languages = {
      enableExtraDiagnostics = true;
      enableTreesitter = true;
      enableFormat = true;
      markdown.enable = true;
      nix.enable = true;
      python.enable = true;
      rust.enable = true;
      yaml.enable = true;
    };
    lsp = {
      enable = true;
      formatOnSave = true;
      trouble.enable = true;
    };
    statusline.lualine.enable = true;
    telescope.enable = true;
    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
    };
    theme = {
      enable = true;
      name = "gruvbox";
      style = "dark";
      transparent = true;
    };
    ui = {
      borders.enable = true;
      breadcrumbs.enable = true;
      noice.enable = true;
    };
    utility = {
      motion.flash-nvim.enable = true;
      yazi-nvim = {
        enable = true;
        setupOpts.open_for_directories = true;
      };
    };
  };
}
