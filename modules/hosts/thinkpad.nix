{ config, lib, ... }:
let
  inherit (config.dotfiles) inputs;
  topConfig = config;
  homeModules = [
    "ghostty"
    "lazygit"
    "nvim"
  ];
in
{
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../../hosts/thinkpad/hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      (
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          boot.loader.systemd-boot.enable = true;
          boot.loader.systemd-boot.configurationLimit = 10;
          boot.loader.efi.canTouchEfiVariables = true;

          networking.hostName = "thinkpad";
          networking.networkmanager.enable = true;

          time.timeZone = "America/Detroit";

          i18n.defaultLocale = "en_US.UTF-8";
          i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
          };

          programs.sway = {
            enable = true;
            wrapperFeatures.gtk = true;
            extraPackages = with pkgs; [
              swaylock
              wmenu
              brightnessctl
              wl-clipboard
              grim
              slurp
            ];
          };

          services.greetd = {
            enable = true;
            settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
          };

          services.pulseaudio.enable = false;
          security.rtkit.enable = true;
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
          };

          users.users.al = {
            isNormalUser = true;
            description = "Al Duncanson";
            extraGroups = [
              "networkmanager"
              "wheel"
            ];
          };

          programs.firefox.enable = true;

          environment.systemPackages = with pkgs; [
            git
            yazi
            ripgrep
            fd
            amp-cli
          ];

          environment.variables.EDITOR = "nvim";

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.al = {
              imports = [
                topConfig.dotfiles.home.shared
              ]
              ++ map (name: topConfig.dotfiles.home.modules.${name}) homeModules;

              home.stateVersion = topConfig.dotfiles.home.stateVersion;

              programs.git = {
                enable = true;
                settings.user = {
                  name = "Al Duncanson";
                  email = "alDuncanson@proton.me";
                };
              };

              dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

              wayland.windowManager.sway =
                let
                  status = pkgs.writeShellScript "sway-status" ''
                    while true; do
                      battery=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -n1)
                      echo "''${battery:+bat $battery% | }$(date +'%a %b %-d %H:%M')"
                      sleep 30
                    done
                  '';
                in
                {
                  enable = true;
                  package = null;
                  config = {
                    modifier = "Mod4";
                    terminal = "ghostty";
                    menu = "wmenu-run";
                    defaultWorkspace = "workspace number 1";
                    input."type:touchpad".tap = "enabled";
                    bars = [
                      {
                        position = "top";
                        statusCommand = "${status}";
                      }
                    ];
                    keybindings = lib.mkOptionDefault {
                      "Mod4+Shift+x" = "exec ${pkgs.swaylock}/bin/swaylock -f -c 000000";
                      "XF86AudioRaiseVolume" = "exec wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+";
                      "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
                      "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
                      "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
                      "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
                      "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
                    };
                  };
                };

              services.swayidle = {
                enable = true;
                timeouts = [
                  {
                    timeout = 300;
                    command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
                  }
                  {
                    timeout = 600;
                    command = "${pkgs.sway}/bin/swaymsg 'output * power off'";
                    resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
                  }
                ];
                events.before-sleep = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
              };
            };
          };

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
          };
          nix.optimise.automatic = true;

          system.stateVersion = "24.11";
        }
      )
    ];
  };

  perSystem =
    { system, ... }:
    lib.mkIf (system == "x86_64-linux") {
      checks.nixos-thinkpad = topConfig.flake.nixosConfigurations.thinkpad.config.system.build.toplevel;
    };
}
