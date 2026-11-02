{ config, lib, ... }:
let
  inherit (config.dotfiles) inputs;
  topConfig = config;
  profile = config.dotfiles.profiles.thinkpad;
in
{
  dotfiles.profiles.thinkpad = {
    system = "x86_64-linux";
    userName = "al";
    modules = [
      "gh"
      "git"
      "lazygit"
      "nvim"
      "ssh"
    ];
    homeModule = ./home.nix;
  };

  flake.nixosConfigurations.thinkpad = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.home-manager
      (
        { pkgs, ... }:
        {
          nixpkgs.config = topConfig.dotfiles.nixpkgs.config;
          nixpkgs.overlays = topConfig.dotfiles.nixpkgs.overlays;

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

          users.users.${profile.userName} = {
            isNormalUser = true;
            description = "Al Duncanson";
            extraGroups = [
              "networkmanager"
              "wheel"
            ];
          };

          programs.firefox.enable = true;
          services.gnome.gnome-keyring.enable = true;
          security.pam.services.greetd.enableGnomeKeyring = true;
          environment.extraInit = ''
            if [ -z "$SSH_AUTH_SOCK" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
              export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
            fi
          '';

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
            users.${profile.userName}.imports = profile.homeModules;
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
