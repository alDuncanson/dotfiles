{ config, ... }:
{
  dotfiles.profiles.work = {
    aliases = [ "sn93ib" ];
    system = config.dotfiles.defaultSystem;
    userName = "sn93ib";
    homeDirectory = "/Users/sn93ib";
    gitName = "Al Duncanson";
    gitEmail = "al.duncanson@gfs.com";
    homeModule =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          # Shared work-safe CLI, Python, cloud, and infra tooling lives in modules/base.nix.
          # Add machine- or employer-specific packages and overrides here.
          glab
          ruby_3_4
          sqlite
          sqlite.dev
          libyaml
          libyaml.dev
          pkg-config
        ];

        home.sessionVariables = {
          BUNDLE_BUILD__PSYCH = "--with-libyaml-include=${pkgs.libyaml.dev}/include --with-libyaml-lib=${pkgs.libyaml}/lib";
        };
      };
  };
}
