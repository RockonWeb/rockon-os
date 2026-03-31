{ host, ... }:
''
  // Host-specific window rules for rockon
  // Keep browser and editor apps on workspace 1 at startup.
  window-rule {
    match at-startup=true app-id=r#"^google-chrome$"#
    match at-startup=true app-id=r#"^antigravity$"#
    open-on-workspace "1"
  }

  // Keep chat and music apps on workspace 2 at startup.
  window-rule {
    match at-startup=true app-id=r#"^yandex-music$"#
    match at-startup=true app-id=r#"^org\.telegram\.desktop$"#
    open-on-workspace "2"
    default-window-height { proportion 0.75; }
  }
''
