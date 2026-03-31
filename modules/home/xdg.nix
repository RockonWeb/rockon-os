{ pkgs, ... }:
let
  steam-no-proxy = pkgs.writeShellScriptBin "steam-no-proxy" ''
    exec ${pkgs.coreutils}/bin/env \
      -u http_proxy \
      -u https_proxy \
      -u all_proxy \
      -u HTTP_PROXY \
      -u HTTPS_PROXY \
      -u ALL_PROXY \
      steam "$@"
  '';
in
{
  home.packages = [ steam-no-proxy ];

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "com.google.Chrome.desktop";
        "x-scheme-handler/http" = "com.google.Chrome.desktop";
        "x-scheme-handler/https" = "com.google.Chrome.desktop";
        "x-scheme-handler/about" = "com.google.Chrome.desktop";
        "application/x-extension-htm" = "com.google.Chrome.desktop";
        "application/x-extension-html" = "com.google.Chrome.desktop";
        "application/x-extension-shtml" = "com.google.Chrome.desktop";
        "application/xhtml+xml" = "com.google.Chrome.desktop";
        "application/x-extension-xhtml" = "com.google.Chrome.desktop";
        "application/x-extension-xht" = "com.google.Chrome.desktop";
      };
    };
    desktopEntries.steam = {
      name = "Steam";
      comment = "Application for managing and playing games on Steam";
      exec = "steam-no-proxy %U";
      icon = "steam";
      terminal = false;
      type = "Application";
      categories = [ "Network" "FileTransfer" "Game" ];
      mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
    };
  };

  # удалить этот override целиком
  # home.file.".local/share/applications/com.google.Chrome.desktop".text = ''
  #   [Desktop Entry]
  #   Hidden=true
  # '';
}
