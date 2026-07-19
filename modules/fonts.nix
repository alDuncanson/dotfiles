{ ... }:
{
  dotfiles.home.shared = {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "MonoLisaCode" ];
        sansSerif = [ "MonoLisaText" ];
        serif = [ "MonoLisaText" ];
      };

      configFile.default-fonts.enable = true;
      configFile.fonts.enable = true;
      configFile.darwin-fonts = {
        enable = true;
        priority = 10;
        text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
          <fontconfig>
            <dir>~/Library/Fonts</dir>
            <dir>/Library/Fonts</dir>
            <dir>/System/Library/Fonts</dir>
            <dir>/System/Library/Fonts/Supplemental</dir>

            <!-- fontconfig normalizes sans-serif to sans before applying aliases on Darwin. -->
            <match target="pattern">
              <test name="family" compare="eq"><string>sans</string></test>
              <edit name="family" mode="prepend" binding="strong"><string>MonoLisaText</string></edit>
            </match>
          </fontconfig>
        '';
      };
    };
  };
}
