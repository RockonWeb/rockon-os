{
  inputs,
  host,
  lib,
  ...
}:
let
  variables = import ../../hosts/${host}/variables.nix;

  windowManager = variables.windowManager or "niri";
  barChoice = variables.barChoice or "noctalia";
  defaultShell = variables.defaultShell or "zsh";
  useNvidia = variables.useNvidia or false;
in
{
  imports = [
    ./amfora.nix
    ./bash.nix
    ./bashrc-personal.nix
    ./bat.nix
    ./bottom.nix
    ./btop.nix
    ./cava.nix
    ./emoji.nix
    ./eza.nix
    ./fastfetch
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gtk.nix
    ./htop.nix
    ./kitty.nix
    ./ghostty.nix
    ./lazygit.nix
    ./nvf.nix
    ./nwg-drawer.nix
    ./obs-studio.nix
    ./rofi
    ./qt.nix
    ./scripts
    ./starship.nix
    ./stylix.nix
    ./swappy.nix
    ./tealdeer.nix
    ./tmux.nix
    ./virtmanager.nix
    ./vscode.nix
    ./wlogout
    ./xdg.nix
    ./yazi
    ./zoxide.nix
    ./environment.nix
  ]

  # Window Manager
  ++ [
    ./niri
  ]

  # Shell
  ++ lib.optionals (defaultShell == "zsh") [
    ./zsh
  ]
  ++ lib.optionals (defaultShell == "fish") [
    ./fish
  ]

  # Bar
  ++ lib.optionals (barChoice == "noctalia") [
    ./noctalia-shell
  ];

  # Allows usage in other modules for overriding settings
  _module.args = {
    inherit useNvidia;
  };
}
