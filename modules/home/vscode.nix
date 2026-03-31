{ pkgs, lib, ... }:
let
  marketplaceExtensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "chatgpt";
      publisher = "openai";
      version = "26.5318.11754";
      sha256 = "sha256-o1R//wIj7YByoYG/DF6pwg7p/YIWDSxusiOJGEHqKTI=";
    }
    {
      name = "geminicodeassist";
      publisher = "Google";
      version = "2.75.0";
      sha256 = "sha256-nydm7PTcUi9XSWXrzWNttHeNFBulFRV87C5/yuCtf9k=";
    }
  ];
in
{
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "http.proxy" = "http://127.0.0.1:8080";
        "http.proxyStrictSSL" = false;
        "workbench.colorTheme" = lib.mkForce "Default Dark Modern";
        "markdown-preview-enhanced.chromePath" =
          lib.mkForce "/run/current-system/sw/bin/google-chrome-stable";

        "editor.fontSize" = lib.mkForce 16;
        "terminal.integrated.fontSize" = lib.mkForce 16;

        "geminicodeassist.project" = lib.mkForce "project-7555ff4f-a441-4630-934";
        "geminicodeassist.agentYoloMode" = true;
      };

      extensions =
        (with pkgs.vscode-extensions; [
          bbenoist.nix
          jeff-hykin.better-nix-syntax
          ms-vscode.cpptools-extension-pack
          vscodevim.vim
          mads-hartmann.bash-ide-vscode
          tamasfe.even-better-toml
          zainchen.json
        ])
        ++ marketplaceExtensions;
    };
  };
}
