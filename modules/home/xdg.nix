{ pkgs, ... }: {
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
  };

  # удалить этот override целиком
  # home.file.".local/share/applications/com.google.Chrome.desktop".text = ''
  #   [Desktop Entry]
  #   Hidden=true
  # '';
}
