{ host, ... }:
''
  // Host-specific output configuration for rockon
  // Configure your monitors and persistent workspaces here

  workspace "1" {
    layout {
      default-column-width { proportion 1.0; }
    }
  }

  workspace "2" {
    layout {
      default-column-width { proportion 0.5; }
    }
  }

  output "DP-2" {
    mode "2560x1440@165.001"
    scale 1.0
    position x=0 y=0
  }

  // Add more outputs as needed
  // output "HDMI-A-1" {
  //   mode "2560x1440@144.000"
  //   scale 1.0
  //   position x=1920 y=0
  // }
''
