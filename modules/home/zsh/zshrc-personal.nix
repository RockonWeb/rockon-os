{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zsh
    zsh-completions
  ];

  home.file."./.zshrc-personal".text = ''
    #!/usr/bin/env zsh
    export PATH="$HOME/Development/Repos/flutter/bin:$PATH"
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="$PATH:$HOME/.pub-cache/bin"

    export BROWSER="google-chrome"
    export EDITOR="zeditor"
    export VISUAL="$EDITOR"

    alias zr='exec zsh'
  '';
}
