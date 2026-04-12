{
  vim = {
    binds.whichKey.enable = true;
    git.enable = true;
    hideSearchHighlight = true;
    languages = {
      enableExtraDiagnostics = true;
      enableTreesitter = true;
      enableFormat = true;
      bash.enable = true;
      hcl = {
        enable = true;
        lsp.servers = ["terraformls-hcl"];
      };
      json.enable = true;
      markdown.enable = true;
      nix.enable = true;
      python = {
        enable = true;
        lsp.servers = [
          "ruff"
          "ty"
        ];
        format.type = [
          "ruff-check"
          "ruff"
        ];
        extraDiagnostics.enable = false;
      };
      rust.enable = true;
      terraform = {
        enable = true;
        lsp.servers = ["terraformls-tf"];
        format.type = ["terraform-fmt"];
      };
      toml.enable = true;
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
      local function apply_surface_overrides()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
        local win_separator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
        local yazi_border_fg = win_separator.fg or normal_float.fg or normal.fg

        if vim.o.background == "dark" then
          yazi_border_fg = 0xfbf1c7
        else
          yazi_border_fg = 0x076678
        end

        vim.api.nvim_set_hl(0, "WhichKeyNormal", {
          fg = normal_float.fg or normal.fg,
          bg = normal.bg,
        })
        vim.api.nvim_set_hl(0, "WhichKeyBorder", {
          fg = win_separator.fg or normal_float.fg or normal.fg,
          bg = normal.bg,
        })
        vim.api.nvim_set_hl(0, "WhichKeyTitle", {
          fg = normal_float.fg or normal.fg,
          bg = normal.bg,
          bold = true,
        })
        vim.api.nvim_set_hl(0, "YaziFloatBorder", {
          fg = yazi_border_fg,
          bg = normal.bg,
          bold = true,
        })
      end

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

        apply_surface_overrides()
      end

      sync_background_with_macos()

      vim.api.nvim_create_autocmd("ColorScheme", {
        desc = "Keep popup surfaces aligned with the editor",
        callback = apply_surface_overrides,
      })

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
        setupOpts = {
          open_for_directories = true;
          highlight_hovered_buffers_in_same_directory = false;
          yazi_floating_window_border = "rounded";
        };
      };
    };
  };
}
