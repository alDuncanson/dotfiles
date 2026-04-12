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
      transparent = false;
    };
    luaConfigPost = ''
      local function sync_background_with_macos()
        local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
        if not handle then
          return
        end

        local appearance = handle:read("*a")
        handle:close()

        local background = appearance:match("Dark") and "dark" or "light"
        if vim.o.background ~= background then
          vim.o.background = background
          vim.cmd.colorscheme("gruvbox")
        end
      end

      sync_background_with_macos()

      vim.api.nvim_create_autocmd("FocusGained", {
        desc = "Sync gruvbox background with macOS appearance",
        callback = sync_background_with_macos,
      })
    '';
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
