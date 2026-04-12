{pkgs, ...}: {
  home.packages = with pkgs; [
    # Shared work-safe CLI, Python, cloud, and infra tooling lives in modules/base.nix.
    # Add machine- or employer-specific packages and overrides here.
    glab
  ];
}
