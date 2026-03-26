{pkgs, ...}: {
  home.sessionVariables = {
    # CHROME_EXECUTABLE used by Flutter development
    CHROME_EXECUTABLE = "/run/current-system/sw/bin/google-chrome-stable";
    # BROWSER used by CLI tools and applications to open URLs
    BROWSER = "xdg-open";
    http_proxy  = "http://127.0.0.1:8080";
    https_proxy = "http://127.0.0.1:8080";
    HTTP_PROXY  = "http://127.0.0.1:8080";
    HTTPS_PROXY = "http://127.0.0.1:8080";

    all_proxy   = "socks5h://127.0.0.1:1080";
    ALL_PROXY   = "socks5h://127.0.0.1:1080";

    no_proxy    = "127.0.0.1,localhost,::1";
    NO_PROXY    = "127.0.0.1,localhost,::1";
  };
}
