{pkgs, ...}: {
  programs = {
    home-manager.enable = true;
    bat = {
      enable = true;
      config = {
        theme = "auto:system";
        theme-dark = "gruvbox-dark";
        theme-light = "gruvbox-light";
      };
    };
    starship = {
      enable = true;
      settings = builtins.fromTOML ''
        "$schema" = 'https://starship.rs/config-schema.json'

        format = """
        [](color_orange)\
        $os\
        $username\
        [](bg:color_yellow fg:color_orange)\
        $directory\
        [](fg:color_yellow bg:color_aqua)\
        $git_branch\
        $git_status\
        [](fg:color_aqua bg:color_blue)\
        $c\
        $cpp\
        $rust\
        $golang\
        $nodejs\
        $php\
        $java\
        $kotlin\
        $haskell\
        $python\
        [](fg:color_blue bg:color_bg3)\
        $docker_context\
        $conda\
        $pixi\
        [](fg:color_bg3 bg:color_bg1)\
        $time\
        [ ](fg:color_bg1)\
        $line_break$character"""

        palette = 'gruvbox_dark'

        [palettes.gruvbox_dark]
        color_fg0 = '#fbf1c7'
        color_bg1 = '#3c3836'
        color_bg3 = '#665c54'
        color_blue = '#458588'
        color_aqua = '#689d6a'
        color_green = '#98971a'
        color_orange = '#d65d0e'
        color_purple = '#b16286'
        color_red = '#cc241d'
        color_yellow = '#d79921'

        [os]
        disabled = false
        style = "bg:color_orange fg:color_fg0"

        [os.symbols]
        Windows = "󰍲"
        Ubuntu = "󰕈"
        SUSE = ""
        Raspbian = "󰐿"
        Mint = "󰣭"
        Macos = "󰀵"
        Manjaro = ""
        Linux = "󰌽"
        Gentoo = "󰣨"
        Fedora = "󰣛"
        Alpine = ""
        Amazon = ""
        Android = ""
        AOSC = ""
        Arch = "󰣇"
        Artix = "󰣇"
        EndeavourOS = ""
        CentOS = ""
        Debian = "󰣚"
        Redhat = "󱄛"
        RedHatEnterprise = "󱄛"
        Pop = ""

        [username]
        show_always = true
        style_user = "bg:color_orange fg:color_fg0"
        style_root = "bg:color_orange fg:color_fg0"
        format = '[ $user ]($style)'

        [directory]
        style = "fg:color_fg0 bg:color_yellow"
        format = "[ $path ]($style)"
        truncation_length = 3
        truncation_symbol = "…/"

        [directory.substitutions]
        "Documents" = "󰈙 "
        "Downloads" = " "
        "Music" = "󰝚 "
        "Pictures" = " "
        "Developer" = "󰲋 "

        [git_branch]
        symbol = ""
        style = "bg:color_aqua"
        format = '[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)'

        [git_status]
        style = "bg:color_aqua"
        format = '[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)'

        [nodejs]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [c]
        symbol = " "
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [cpp]
        symbol = " "
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [rust]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [golang]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [php]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [java]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [kotlin]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [haskell]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [python]
        symbol = ""
        style = "bg:color_blue"
        format = '[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)'

        [docker_context]
        symbol = ""
        style = "bg:color_bg3"
        format = '[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)'

        [conda]
        style = "bg:color_bg3"
        format = '[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)'

        [pixi]
        style = "bg:color_bg3"
        format = '[[ $symbol( $version)( $environment) ](fg:color_fg0 bg:color_bg3)]($style)'

        [time]
        disabled = false
        time_format = "%R"
        style = "bg:color_bg1"
        format = '[[  $time ](fg:color_fg0 bg:color_bg1)]($style)'

        [line_break]
        disabled = false

        [character]
        disabled = false
        success_symbol = '[](bold fg:color_green)'
        error_symbol = '[](bold fg:color_red)'
        vimcmd_symbol = '[](bold fg:color_green)'
        vimcmd_replace_one_symbol = '[](bold fg:color_purple)'
        vimcmd_replace_symbol = '[](bold fg:color_purple)'
        vimcmd_visual_symbol = '[](bold fg:color_yellow)'

        [gcloud]
        disabled = true
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };
    delta = {
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
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      initContent = ''
        vivid_theme="gruvbox-light"
        if defaults read -g AppleInterfaceStyle >/dev/null 2>&1; then
          vivid_theme="gruvbox-dark"
        fi

        export BAT_THEME="$vivid_theme"
        export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate "$vivid_theme")"
      '';
      shellAliases = {
        ga = "git add";
        gb = "git branch";
        gc = "git commit";
        gd = "git diff";
        gl = "git log --graph --decorate --oneline";
        gs = "git status";
        cat = "bat";
        ls = "eza --icons=always";
        lsl = "ls -l";
        lsls = "lsl --total-size";
        bench = "hyperfine";
      };
    };
    git = {
      enable = true;
      signing.format = null;
      settings.user = {
        name = "alDuncanson";
        email = "alDuncanson@proton.me";
      };
    };
    lazygit = {
      enable = true;
      enableZshIntegration = true;
      settings.os = {
        editPreset = "nvim-remote";
        open = ''
          if [ -z "$NVIM" ]; then
            open -- {{filename}}
          else
            nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-tab {{filename}}
          fi
        '';
      };
    };
    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        font-family = "MonoLisa Custom";
        font-size = 17;
        confirm-close-surface = false;
        mouse-hide-while-typing = true;
        quit-after-last-window-closed = true;
        theme = "dark:Gruvbox Dark,light:Gruvbox Light";
      };
    };
    nvf = {
      enable = true;
      settings = import ./nvim.nix {inherit pkgs;};
    };
  };
}
