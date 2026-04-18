{ pkgs, host }:
let
  hostConfigPath = ./hosts/${host}/niri-gaming-mode.nix;
  hostConfig =
    if builtins.pathExists hostConfigPath then
      import hostConfigPath
    else
      null;

  renderPositionCommands =
    positions:
    builtins.concatStringsSep "\n" (
      map
        (
          output:
          let
            position = builtins.getAttr output positions;
          in
          ''      niri msg output ${output} position set -- ${toString position.x} ${toString position.y}''
        )
        (builtins.attrNames positions)
    );

  normalCommands = if hostConfig == null then "" else renderPositionCommands hostConfig.normalPositions;
  gamingCommands = if hostConfig == null then "" else renderPositionCommands hostConfig.gamingPositions;
  mainOutput = if hostConfig == null then "unknown" else hostConfig.mainOutput;
in
pkgs.writeShellScriptBin "niri-gaming-mode.sh" ''
  # Toggle Niri gaming mode - adds spacing between monitors to trap cursor on the main display.
  STATE_FILE="''${XDG_RUNTIME_DIR:-/tmp}/niri-gaming-mode-state"

  ${
    if hostConfig == null then
      ''
        ${pkgs.libnotify}/bin/notify-send \
          "Gaming Mode unavailable" \
          "No per-host monitor layout configured for ${host}" \
          -i input-gaming
        exit 0
      ''
    else
      ''
        if [ -f "$STATE_FILE" ]; then
            echo "Switching to NORMAL mode - monitors adjacent"
${normalCommands}
            rm "$STATE_FILE"
            ${pkgs.libnotify}/bin/notify-send "Gaming Mode OFF" "Monitors restored to normal positions" -i input-gaming
        else
            echo "Switching to GAMING mode - cursor trapped on main monitor"
${gamingCommands}
            touch "$STATE_FILE"
            ${pkgs.libnotify}/bin/notify-send "Gaming Mode ON" "Cursor confined to main monitor (${mainOutput})" -i input-gaming
        fi
      ''
  }
''
