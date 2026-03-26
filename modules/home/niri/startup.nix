{
  host,
  stylixImage,
  startupApps,
  barChoice,
  ...
}:
let
  # Determine which bar to launch
  # Note: waybar and dms are handled by systemd services, not spawn-at-startup
  barStartupCommand =
    if barChoice == "noctalia" then
      ''spawn-at-startup "noctalia-shell"''
    else
      ''// ${barChoice} started via systemd service'';
in
''
  spawn-at-startup "bash" "-c" "dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP=niri XDG_SESSION_TYPE=wayland && systemctl --user restart xdg-desktop-portal.service"
  spawn-at-startup "bash" "-c" "wl-paste --watch cliphist store &"
  ${barStartupCommand}
  spawn-at-startup "bash" "-c" "swww-daemon && sleep 1 && swww img '${stylixImage}'"
  spawn-at-startup "wal" "-R"
  spawn-at-startup "lxqt-policykit-agent"
  spawn-at-startup "vesktop"
  spawn-at-startup "Telegram"
''
