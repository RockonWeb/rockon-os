{ pkgs }:

pkgs.writeShellScriptBin "cliphist-picker" ''
  selected="$(${pkgs.cliphist}/bin/cliphist list | ${pkgs.fuzzel}/bin/fuzzel --dmenu --with-nth 2)"

  [ -z "$selected" ] && exit 0

  printf '%s\n' "$selected" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
''
