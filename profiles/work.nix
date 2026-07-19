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
      { pkgs, lib, ... }:
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

        # nix-built tools (git, curl, …) verify HTTPS against NIX_SSL_CERT_FILE and
        # ignore the macOS keychain, so they break behind a corporate TLS-inspection
        # proxy. Build a bundle of the public roots (nix cacert) plus the corporate
        # root CA exported from the keychain: it validates a host whether the proxy
        # decrypts it (internal root) or passes it through undecrypted (public root —
        # e.g. github is intercepted only intermittently). Regenerated each switch;
        # export the corporate root yourself to the path it reads (see
        # NODE_EXTRA_CA_CERTS below).
        home.activation.corpCaBundle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.config/certs"
          if [ -s "$HOME/.config/certs/gfs-root-ca.pem" ]; then
            cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
              "$HOME/.config/certs/gfs-root-ca.pem" \
              > "$HOME/.config/certs/combined-ca.pem"
          else
            echo "corpCaBundle: WARNING corp root CA missing or empty at $HOME/.config/certs/gfs-root-ca.pem" >&2
            echo "corpCaBundle: git/Node HTTPS through the GFS proxy will fail until it is re-exported:" >&2
            echo "corpCaBundle:   security find-certificate -a -c <corp-root-ca> -p /Library/Keychains/System.keychain > $HOME/.config/certs/gfs-root-ca.pem" >&2
            cat ${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt \
              > "$HOME/.config/certs/combined-ca.pem"
          fi
        '';

        home.sessionVariables = {
          BUNDLE_BUILD__PSYCH = "--with-libyaml-include=${pkgs.libyaml.dev}/include --with-libyaml-lib=${pkgs.libyaml}/lib";

          # The proxy re-signs HTTPS with an internal root CA that macOS trusts but
          # Node does not, so Node CLIs (amp, npm, …) fail with
          # SELF_SIGNED_CERT_IN_CHAIN. NODE_EXTRA_CA_CERTS is additive (it extends
          # Node's bundled roots), so the keychain-exported corporate root alone is
          # enough. Re-export after a corporate CA rotation:
          #   security find-certificate -a -c <corp-root-ca> -p \
          #     /Library/Keychains/System.keychain > $NODE_EXTRA_CA_CERTS
          NODE_EXTRA_CA_CERTS = "$HOME/.config/certs/gfs-root-ca.pem";

          # git's sslCAInfo *replaces* its CA set (unlike Node's additive var), so it
          # points at the combined bundle above — which carries the public roots too,
          # so git still works when the proxy serves a host undecrypted. Work profile
          # only: on a personal machine this would drop the system roots.
          GIT_SSL_CAINFO = "$HOME/.config/certs/combined-ca.pem";
        };
      };
  };
}
