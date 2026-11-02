{ pkgs, lib, ... }:
{
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
}
