{
  inputs,
  config,
  ...
}: let
  mkNvfSettings = pkgs: let
  surfaceBorder = "rounded";
  surfacePadding = [0 1];
  surfaceMaxWidth = 88;
  surfaceMaxHeight = 18;
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
      servers.nil.settings = {
        nil = {
          nix.flake.autoArchive = true;
        };
      };
      trouble.enable = true;
    };
    diagnostics = {
      enable = true;
      config = {
        severity_sort = true;
        float = {
          border = surfaceBorder;
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
      setupOpts.float_opts.border = surfaceBorder;
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
      local function get_hl(name)
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
        return ok and hl or {}
      end

      local function apply_surface_overrides()
        local normal = get_hl("Normal")
        local normal_float = get_hl("NormalFloat")
        local win_separator = get_hl("WinSeparator")
        local title = get_hl("Title")
        local diagnostic_error = get_hl("DiagnosticError")
        local diagnostic_warn = get_hl("DiagnosticWarn")
        local diagnostic_info = get_hl("DiagnosticInfo")
        local diagnostic_hint = get_hl("DiagnosticHint")

        local panel_bg = normal.bg or normal_float.bg
        local panel_fg = normal.fg or normal_float.fg or title.fg
        local border_fg = win_separator.fg or normal_float.fg or panel_fg
        local title_fg = title.fg or border_fg

        local function set_surface_hl(name, opts)
          vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", {
            bg = panel_bg,
            fg = panel_fg,
          }, opts or {}))
        end

        local function set_border_hl(name, fg)
          set_surface_hl(name, { fg = fg or border_fg })
        end

        local function set_diagnostic_hl(name, diagnostic)
          set_surface_hl(name, { fg = diagnostic.fg or border_fg })
        end

        set_surface_hl("NormalFloat")
        set_border_hl("FloatBorder")
        set_surface_hl("FloatTitle", {
          fg = title_fg,
          bold = true,
        })
        set_surface_hl("NoicePopup")
        set_border_hl("NoicePopupBorder")
        set_surface_hl("NoicePopupmenu")
        set_border_hl("NoicePopupmenuBorder")
        set_surface_hl("NoiceMini")
        set_surface_hl("NoiceCmdlinePopup")
        set_border_hl("NoiceCmdlinePopupBorder")
        set_surface_hl("NoiceCmdlinePopupTitle", {
          fg = title_fg,
          bold = true,
        })
        set_surface_hl("NoiceConfirm")
        set_border_hl("NoiceConfirmBorder")

        set_diagnostic_hl("DiagnosticFloatingError", diagnostic_error)
        set_diagnostic_hl("DiagnosticFloatingWarn", diagnostic_warn)
        set_diagnostic_hl("DiagnosticFloatingInfo", diagnostic_info)
        set_diagnostic_hl("DiagnosticFloatingHint", diagnostic_hint)

        set_surface_hl("WhichKeyNormal")
        set_border_hl("WhichKeyBorder")
        set_surface_hl("WhichKeyTitle", {
          fg = title_fg,
          bold = true,
        })

        set_surface_hl("TelescopeNormal")
        set_surface_hl("TelescopePromptNormal")
        set_surface_hl("TelescopeResultsNormal")
        set_surface_hl("TelescopePreviewNormal")
        set_border_hl("TelescopeBorder")
        set_border_hl("TelescopePromptBorder")
        set_border_hl("TelescopeResultsBorder")
        set_border_hl("TelescopePreviewBorder")
        set_surface_hl("TelescopeTitle", {
          fg = title_fg,
          bold = true,
        })
        set_surface_hl("TelescopePromptTitle", {
          fg = title_fg,
          bold = true,
        })
        set_surface_hl("TelescopeResultsTitle", {
          fg = title_fg,
          bold = true,
        })
        set_surface_hl("TelescopePreviewTitle", {
          fg = title_fg,
          bold = true,
        })

        set_surface_hl("NotifyBackground")
        set_surface_hl("NotifyERRORBody")
        set_surface_hl("NotifyWARNBody")
        set_surface_hl("NotifyINFOBody")
        set_surface_hl("NotifyDEBUGBody")
        set_surface_hl("NotifyTRACEBody")
        set_border_hl("NotifyERRORBorder", diagnostic_error.fg)
        set_border_hl("NotifyWARNBorder", diagnostic_warn.fg)
        set_border_hl("NotifyINFOBorder", diagnostic_info.fg)
        set_border_hl("NotifyDEBUGBorder")
        set_border_hl("NotifyTRACEBorder")
        set_surface_hl("NotifyERRORIcon", { fg = diagnostic_error.fg or border_fg })
        set_surface_hl("NotifyWARNIcon", { fg = diagnostic_warn.fg or border_fg })
        set_surface_hl("NotifyINFOIcon", { fg = diagnostic_info.fg or border_fg })
        set_surface_hl("NotifyDEBUGIcon", { fg = border_fg })
        set_surface_hl("NotifyTRACEIcon", { fg = border_fg })
        set_surface_hl("NotifyERRORTitle", {
          fg = diagnostic_error.fg or border_fg,
          bold = true,
        })
        set_surface_hl("NotifyWARNTitle", {
          fg = diagnostic_warn.fg or border_fg,
          bold = true,
        })
        set_surface_hl("NotifyINFOTitle", {
          fg = diagnostic_info.fg or border_fg,
          bold = true,
        })
        set_surface_hl("NotifyDEBUGTitle", {
          fg = border_fg,
          bold = true,
        })
        set_surface_hl("NotifyTRACETitle", {
          fg = border_fg,
          bold = true,
        })

        vim.api.nvim_set_hl(0, "YaziFloatBorder", {
          fg = border_fg,
          bg = panel_bg,
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
      borders = {
        enable = true;
        globalStyle = surfaceBorder;
      };
      breadcrumbs.enable = true;
      noice = {
        enable = true;
        setupOpts = {
          notify.view = "mini";
          messages = {
            view_warn = "mini";
            view_error = "mini";
          };
          lsp.message.view = "mini";
          views = {
            hover = {
              position = {
                row = 2;
                col = 1;
              };
              size = {
                max_width = surfaceMaxWidth;
                max_height = surfaceMaxHeight;
              };
              border = {
                style = surfaceBorder;
                padding = surfacePadding;
              };
              win_options = {
                wrap = true;
                linebreak = true;
              };
            };
            mini = {
              border = {
                style = surfaceBorder;
                padding = surfacePadding;
              };
              size = {
                max_width = surfaceMaxWidth;
                max_height = 10;
              };
              win_options = {
                winblend = 0;
                winhighlight = {
                  Normal = "NoicePopup";
                  FloatBorder = "NoicePopupBorder";
                };
              };
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
          yazi_floating_window_border = surfaceBorder;
        };
      };
    };
  };
};
in {
  dotfiles.neovim.settings = mkNvfSettings;

  dotfiles.home.shared = {pkgs, ...}: {
    programs.nvf = {
      enable = true;
      settings = mkNvfSettings pkgs;
    };
  };

  perSystem = {system, ...}: let
    pkgs = config.dotfiles.lib.mkPkgs system;
    neovim =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [
          {
            config = mkNvfSettings pkgs;
          }
        ];
      }).neovim;
  in {
    packages = {
      default = neovim;
      inherit neovim;
    };

    apps = {
      default = {
        type = "app";
        program = "${neovim}/bin/nvim";
      };
      neovim = {
        type = "app";
        program = "${neovim}/bin/nvim";
      };
    };
  };
}
