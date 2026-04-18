{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) consoleKeyMap timeZone;
in
{
  nix = {
    settings = {
      download-buffer-size = 250000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      http-connections = 50;
      max-substitution-jobs = 20;
    };
  };

  # Proxy for nix-daemon to speed up downloads in restricted networks
  systemd.services.nix-daemon.environment = {
    http_proxy = "socks5h://127.0.0.1:1080";
    https_proxy = "socks5h://127.0.0.1:1080";
    all_proxy = "socks5h://127.0.0.1:1080";
  };
  time.timeZone = "${timeZone}";
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
  environment.variables = {
    ZANEYOS_VERSION = "2.3.1";
    ZANEYOS = "true";
  };
  console.keyMap = "${consoleKeyMap}";
  system.stateVersion = "23.11"; # Do not change!

  # Enable nix-ld for running unpackaged programs like adb
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Common libraries needed for Android tools
    stdenv.cc.cc.lib
    zlib
    openssl
    libGL
    # Android-specific libraries
    jdk11
    android-tools
    androidenv.androidPkgs.platform-tools
  ];
}
