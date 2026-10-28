{ config, lib, ... }:
let
  inherit (config.dotfiles) inputs;
  topConfig = config;
  homeModules = [
    "lazygit"
    "nvim"
  ];
in
{
  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./hardware-configuration.nix
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
            ghostty
            htop
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
            backupFileExtension = "hm-backup";
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

              programs.i3status = {
                enable = true;
                enableDefault = false;
                general.interval = 5;
                modules = {
                  "cpu_usage" = {
                    position = 1;
                    settings.format = "cpu %usage";
                  };
                  "memory" = {
                    position = 2;
                    settings.format = "mem %used / %total";
                  };
                  "battery all" = {
                    position = 3;
                    settings = {
                      format = "%status %percentage %remaining";
                      format_down = "no battery";
                      integer_battery_capacity = true;
                      status_chr = "chr";
                      status_bat = "bat";
                      status_unk = "bat";
                      status_full = "full";
                    };
                  };
                  "tztime local" = {
                    position = 4;
                    settings.format = "%a %b %-d %H:%M";
                  };
                };
              };

              wayland.windowManager.sway = {
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
                      statusCommand = "${pkgs.i3status}/bin/i3status";
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
