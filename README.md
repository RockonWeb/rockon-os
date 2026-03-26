# rockon-os

Personal NixOS flake for my machines and workflow.

This repo started from [ZaneyOS](https://gitlab.com/zaney/zaneyos), then passed through [Black Don OS](https://gitlab.com/theblackdon/black-don-os), and is now maintained as my own setup under `rockon-os`.

Previous READMEs are preserved:

- [README-ORIGINAL-BLACK-DON-OS.md](README-ORIGINAL-BLACK-DON-OS.md)
- [README-ORIGINAL-ZANEYOS.md](README-ORIGINAL-ZANEYOS.md)

![rockon-os desktop](img/desktop-screenshot.png)

## What This Repo Is

This is not a generic starter distro. It is my personal NixOS configuration with a reusable multi-host structure.

Current focus:

- `niri` as the active Wayland compositor
- `noctalia` as the shell/bar layer
- NVIDIA-first desktop setup
- `dcli` for common rebuild and maintenance tasks
- Flake-based host management

The repository still contains upstream Hyprland-related modules, but the current home configuration imports `niri` and does not enable Hyprland by default.

## Current State

Tracked hosts in the tree:

- `rockon`: main machine
- `nix-test`: test machine
- `default`: template used by the installer

Current `rockon` defaults:

- GPU profile: `nvidia`
- Browser: `google-chrome`
- Terminal: `ghostty`
- Shell: `zsh`
- Bar/shell: `noctalia`
- Timezone: `Asia/Irkutsk`
- Keyboard layout: `us, ru`

Available hardware profiles:

- `nvidia`
- `nvidia-laptop`
- `amd`
- `intel`
- `vm`

## Repository Layout

```text
rockon-os/
├── flake.nix
├── hosts/
│   ├── default/          # Template for new machines
│   ├── nix-test/         # Test host
│   └── rockon/           # Main host
├── modules/
│   ├── core/             # System-wide NixOS modules
│   ├── drivers/          # GPU and hardware drivers
│   └── home/             # Home Manager modules, scripts, desktop config
├── profiles/             # Hardware entry points
├── wallpapers/
└── install.sh            # Host bootstrap script
```

## Install Flow

Install base NixOS first, then bootstrap this repo on top of it.

1. Install NixOS from the official ISO.
2. Log into the new system.
3. Open a shell and install the required tools:

```bash
nix-shell -p git pciutils
```

4. Clone the repo into your home directory:

```bash
cd ~
git clone https://github.com/RockonWeb/rockon-os.git
cd rockon-os
```

5. Run the installer:

```bash
./install.sh
```

The installer will:

- ask for hostname, username, timezone, keyboard, and GPU profile
- create `hosts/<hostname>/`
- create host-specific `niri` and `hyprland` override files
- add the host to `flake.nix`
- build and switch to the new system

## Daily Workflow

Main commands:

```bash
dcli rebuild
dcli rebuild-boot
dcli update
dcli list-hosts
dcli build <host>
dcli deploy <host>
dcli diag
```

Shell aliases:

```bash
fr   # dcli rebuild
fu   # dcli update
```

Development shell:

```bash
nix develop
```

The default dev shell is set up for Flutter and Android tooling.

## Where I Change Things

Most day-to-day changes happen here:

- `hosts/<host>/variables.nix`: machine-specific settings
- `hosts/<host>/default.nix`: host-level NixOS imports and services
- `modules/home/niri/keybinds.nix`: shared Niri keybinds
- `modules/home/niri/hosts/<host>/`: host-specific Niri overrides
- `modules/home/xdg.nix`: XDG defaults and app associations
- `modules/home/scripts/dcli.nix`: `dcli` implementation

## Customization Notes

Most per-host tuning lives in `hosts/<host>/variables.nix`.

Examples:

```nix
browser = "google-chrome";
terminal = "ghostty";
defaultShell = "zsh";
barChoice = "noctalia";
stylixImage = ../../wallpapers/Valley.jpg;
```

Monitors:

```nix
extraMonitorSettings = ''
  monitor=DP-2,2560x1440@165.001,0x0,1.25
'';
```

Optional features:

```nix
gamingSupportEnable = true;
enableCommunicationApps = true;
enableProductivityApps = true;
enableExtraBrowsers = true;
```

After changing the config:

```bash
dcli rebuild
```

## Path Assumptions

This repo is expected to live at:

```bash
~/rockon-os
```

Some modules and helper scripts still contain hardcoded paths for that location. A few legacy `zaneyos` references also still exist in the tree, so if I ever move the repo, those need to be cleaned up together.

## Upstream

- Origin: `git@github.com:RockonWeb/rockon-os.git`
- Upstream fork source: `https://gitlab.com/theblackdon/black-don-os`
- Original upstream: `https://gitlab.com/zaney/zaneyos`
