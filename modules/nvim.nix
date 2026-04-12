{pkgs}: let
  accelerated-jk = pkgs.vimUtils.buildVimPlugin {
    pname = "accelerated-jk.nvim";
    version = "8fb5dad";
    src = pkgs.fetchFromGitHub {
      owner = "rainbowhxch";
      repo = "accelerated-jk.nvim";
      rev = "8fb5dad4ccc1811766cebf16b544038aeeb7806f";
      sha256 = "03s8bw3as2d3agqvllaxicmlbp1pmabc4g2bwyh4whb50h4fm66f";
    };
  };
in {
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
      helm.enable = true;
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
    diagnostics = {
      enable = true;
      config = {
        severity_sort = true;
        float = {
          border = "rounded";
          source = "if_many";
          scope = "line";
          header = "";
          prefix = "";
        };
      };
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
    extraPlugins.smear-cursor = {
      package = pkgs.vimPlugins.smear-cursor-nvim;
      setup = ''
        require("smear_cursor").setup({
          cursor_color = "none",
          stiffness = 0.8,
          trailing_stiffness = 0.7,
          damping = 0.94,
          distance_stop_animating = 0.3,
          max_length = 12,
        })
      '';
    };
    extraPlugins.accelerated-jk = {
      package = accelerated-jk;
      setup = ''
        require("accelerated-jk").setup({
          acceleration_limit = 90,
          acceleration_table = { 3, 5, 7, 10, 13, 16, 20, 24 },
        })
        vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)", { remap = true, silent = true })
        vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)", { remap = true, silent = true })
      '';
    };
    luaConfigPost = ''
      local function apply_surface_overrides()
        local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
        local normal_float = vim.api.nvim_get_hl(0, { name = "NormalFloat", link = false })
        local win_separator = vim.api.nvim_get_hl(0, { name = "WinSeparator", link = false })
        local palette = {
          float_bg = normal_float.bg or normal.bg,
          float_border = win_separator.fg or normal_float.fg or normal.fg,
          float_title = normal_float.fg or normal.fg,
          diagnostic_error = 0x9d0006,
          diagnostic_warn = 0xaf3a03,
          diagnostic_info = 0x076678,
          diagnostic_hint = 0x427b58,
          yazi_border = win_separator.fg or normal_float.fg or normal.fg,
        }

        if vim.o.background == "dark" then
          palette = {
            float_bg = 0x32302f,
            float_border = 0x928374,
            float_title = 0x83a598,
            diagnostic_error = 0xfb4934,
            diagnostic_warn = 0xfe8019,
            diagnostic_info = 0x83a598,
            diagnostic_hint = 0x8ec07c,
            yazi_border = 0xfbf1c7,
          }
        else
          palette = {
            float_bg = 0xf2e5bc,
            float_border = 0xbdae93,
            float_title = 0x076678,
            diagnostic_error = 0x9d0006,
            diagnostic_warn = 0xaf3a03,
            diagnostic_info = 0x076678,
            diagnostic_hint = 0x427b58,
            yazi_border = 0x076678,
          }
        end

        local function set_float_hl(name, opts)
          vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", {
            bg = palette.float_bg,
            fg = normal_float.fg or normal.fg,
          }, opts or {}))
        end

        set_float_hl("NormalFloat")
        set_float_hl("FloatBorder", { fg = palette.float_border })
        set_float_hl("FloatTitle", {
          fg = palette.float_title,
          bold = true,
        })
        set_float_hl("NoicePopup")
        set_float_hl("NoicePopupBorder", { fg = palette.float_border })
        set_float_hl("DiagnosticFloatingError", { fg = palette.diagnostic_error })
        set_float_hl("DiagnosticFloatingWarn", { fg = palette.diagnostic_warn })
        set_float_hl("DiagnosticFloatingInfo", { fg = palette.diagnostic_info })
        set_float_hl("DiagnosticFloatingHint", { fg = palette.diagnostic_hint })

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
          fg = palette.yazi_border,
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
      noice = {
        enable = true;
        setupOpts = {
          views.hover = {
            position = {
              row = 2;
              col = 1;
            };
            size = {
              max_width = 88;
              max_height = 18;
            };
            border = {
              style = "rounded";
              padding = [0 1];
            };
            win_options = {
              wrap = true;
              linebreak = true;
            };
          };
        };
      };
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
