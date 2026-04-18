#!/usr/bin/env bash

######################################
# Rockon OS - Simplified Installer
# A NixOS configuration for everyone
######################################

set -e  # Exit on error

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
EXPECTED_REPO_DIR="$HOME/rockon-os"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Print functions
print_header() {
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║ ${1}${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
}

print_error() {
  echo -e "${RED}✗ Error: ${1}${NC}"
}

print_success() {
  echo -e "${GREEN}✓ ${1}${NC}"
}

print_info() {
  echo -e "${BLUE}ℹ ${1}${NC}"
}

to_pci_bus_id() {
  local raw="$1"

  if [ -z "$raw" ]; then
    return 1
  fi

  raw="${raw#0000:}"

  local bus slot func
  IFS=':.' read -r bus slot func <<< "$raw"

  if [ -z "$bus" ] || [ -z "$slot" ] || [ -z "$func" ]; then
    return 1
  fi

  printf 'PCI:%d:%d:%d\n' "0x$bus" "0x$slot" "0x$func"
}

detect_first_gpu_bus_id() {
  local vendor_pattern="$1"
  local raw

  raw="$(lspci -Dnn | grep -iE 'vga|3d|display' | grep -iE "$vendor_pattern" | awk 'NR==1 { print $1 }')"

  if [ -n "$raw" ]; then
    to_pci_bus_id "$raw"
  fi
}

# Welcome
clear
print_header "Rockon OS - Simplified Installation"
echo ""
echo -e "${BLUE}Welcome! This installer will set up Rockon OS with sensible defaults.${NC}"
echo -e "${BLUE}You can customize everything later by editing your variables.nix file.${NC}"
echo ""
sleep 2

# Verify NixOS
print_header "System Verification"
if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  print_success "Running on NixOS"
else
  print_error "This installer requires NixOS"
  exit 1
fi

# Check dependencies
if ! command -v git &> /dev/null || ! command -v lspci &> /dev/null; then
  print_error "Missing dependencies. Please run:"
  echo -e "  ${GREEN}nix-shell -p git pciutils${NC}"
  exit 1
fi

# Verify repository location
if [ "$SCRIPT_DIR" != "$EXPECTED_REPO_DIR" ]; then
  print_error "This installer must be run from $EXPECTED_REPO_DIR"
  print_info "Current repository path: $SCRIPT_DIR"
  echo -e "${YELLOW}Several modules assume the repo lives at ~/rockon-os.${NC}"
  echo -e "${YELLOW}Move or re-clone the repository, then rerun the installer.${NC}"
  echo -e "  ${GREEN}cd ~ && git clone https://github.com/RockonWeb/rockon-os.git${NC}"
  exit 1
fi

cd "$SCRIPT_DIR"
print_success "All dependencies found"
echo ""

# Get hostname
print_header "Hostname Configuration"
echo -e "${YELLOW}⚠️  Do NOT use 'default' as your hostname!${NC}"
echo -e "Suggested names: my-desktop, nixos-laptop, gaming-rig"
echo ""

while true; do
  read -p "Enter hostname [nixos-desktop]: " hostname
  hostname=${hostname:-nixos-desktop}

  if [ "$hostname" = "default" ]; then
    print_error "Cannot use 'default' as hostname. Choose something else."
    continue
  fi

  if [[ ! "$hostname" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]]; then
    print_error "Invalid hostname. Use only letters, numbers, and hyphens."
    continue
  fi

  break
done

print_success "Hostname: $hostname"
echo ""

# Get username
print_header "User Configuration"
current_user=$(echo $USER)
read -p "Enter username [$current_user]: " username
username=${username:-$current_user}
print_success "Username: $username"
echo ""

# Get timezone
print_header "Timezone Configuration"
echo -e "${BLUE}Common timezones:${NC}"
echo -e "  America/New_York (Eastern)"
echo -e "  America/Chicago (Central)"
echo -e "  America/Denver (Mountain)"
echo -e "  America/Los_Angeles (Pacific)"
echo -e "  Europe/London"
echo -e "  Europe/Paris"
echo -e "  Asia/Tokyo"
echo -e "  Australia/Sydney"
echo -e "  Asia/Irkutsk"
echo ""
echo -e "${YELLOW}Tip: Find your timezone at: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones${NC}"
echo ""
read -p "Enter timezone [Asia/Irkutsk]: " timezone
timezone=${timezone:-Asia/Irkutsk}
print_success "Timezone: $timezone"
echo ""

# Get keyboard layout
print_header "Keyboard Configuration"
echo -e "${BLUE}Common keyboard layouts:${NC}"
echo -e "  us (US English)"
echo -e "  uk (UK English)"
echo -e "  de (German)"
echo -e "  fr (French)"
echo -e "  es (Spanish)"
echo -e "  it (Italian)"
echo -e "  jp (Japanese)"
echo -e "  ru (Russian)"
echo ""
read -p "Enter keyboard layout [us]: " keyboard
keyboard=${keyboard:-us}
print_success "Keyboard layout: $keyboard"
echo ""

# Detect GPU
print_header "Hardware Detection"
DETECTED_PROFILE=""

has_nvidia=false
has_intel=false
has_amd=false
has_vm=false

if lspci | grep -qi 'vga\|3d'; then
  while read -r line; do
    if echo "$line" | grep -qi 'nvidia'; then
      has_nvidia=true
    elif echo "$line" | grep -qi 'amd'; then
      has_amd=true
    elif echo "$line" | grep -qi 'intel'; then
      has_intel=true
    elif echo "$line" | grep -qi 'virtio\|vmware'; then
      has_vm=true
    fi
  done < <(lspci | grep -i 'vga\|3d')

  if $has_vm; then
    DETECTED_PROFILE="vm"
  elif $has_nvidia && $has_intel; then
    DETECTED_PROFILE="nvidia-laptop"
  elif $has_nvidia; then
    DETECTED_PROFILE="nvidia"
  elif $has_amd; then
    DETECTED_PROFILE="amd"
  elif $has_intel; then
    DETECTED_PROFILE="intel"
  fi
fi

if [ -z "$DETECTED_PROFILE" ]; then
  echo -e "${YELLOW}Could not detect GPU automatically${NC}"
  echo "Available profiles: nvidia, nvidia-laptop, amd, intel, vm"
  read -p "Enter GPU profile [amd]: " profile
  profile=${profile:-amd}
else
  echo -e "Detected GPU: ${GREEN}$DETECTED_PROFILE${NC}"
  read -p "Is this correct? [Y/n]: " confirm
  if [[ $confirm =~ ^[Nn]$ ]]; then
    echo "Available profiles: nvidia, nvidia-laptop, amd, intel, vm"
    read -p "Enter GPU profile: " profile
  else
    profile=$DETECTED_PROFILE
  fi
fi

print_success "GPU Profile: $profile"
echo ""

intel_bus_id="$(detect_first_gpu_bus_id 'intel' || true)"
nvidia_bus_id="$(detect_first_gpu_bus_id 'nvidia' || true)"

intel_bus_id=${intel_bus_id:-PCI:0:2:0}
nvidia_bus_id=${nvidia_bus_id:-PCI:1:0:0}

if [ -n "$keyboard" ]; then
  console_keymap="${keyboard%%,*}"
  console_keymap="$(printf '%s' "$console_keymap" | xargs)"
else
  console_keymap="us"
fi

print_info "Detected Intel bus ID: $intel_bus_id"
print_info "Detected Nvidia bus ID: $nvidia_bus_id"
echo ""

# Configuration summary
print_header "Configuration Summary"
echo -e "  Hostname:      ${GREEN}$hostname${NC}"
echo -e "  Username:      ${GREEN}$username${NC}"
echo -e "  Timezone:      ${GREEN}$timezone${NC}"
echo -e "  Keyboard:      ${GREEN}$keyboard${NC}"
echo -e "  GPU Profile:   ${GREEN}$profile${NC}"
echo ""
echo -e "${BLUE}Shared Settings (inherited from hosts/shared):${NC}"
echo -e "  Browser:       google-chrome"
echo -e "  Terminal:      ghostty"
echo -e "  Shell:         zsh"
echo -e "  Bar:           noctalia"
echo -e "  Window Mgrs:   Niri (default)"
echo ""

read -p "Continue with installation? [Y/n]: " proceed
if [[ $proceed =~ ^[Nn]$ ]]; then
  echo "Installation cancelled"
  exit 0
fi

# Generate hardware config
print_header "Generating Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > /tmp/hardware.nix
print_success "Hardware configuration generated"
echo ""

# Create host directory
print_header "Creating Host Configuration"
mkdir -p "hosts/$hostname"

# Copy hardware config
mv /tmp/hardware.nix "hosts/$hostname/hardware.nix"

# Create host metadata
cat > "hosts/$hostname/meta.nix" << EOF
{
  profile = "$profile";
  username = "$username";
}
EOF

# Create host default.nix
cat > "hosts/$hostname/default.nix" << EOF
{ ... }:
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../shared/default.nix
  ];
}
EOF

# Create host-packages.nix
cat > "hosts/$hostname/host-packages.nix" << EOF
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Add machine-specific packages here when needed.
  ];
}
EOF

# Create variables.nix
cat > "hosts/$hostname/variables.nix" << EOF
(import ../shared/variables.nix) // {
  # Per-machine overrides for this host.
  gitUsername = "$username";
  gitEmail = "$username@$hostname";
  timeZone = "$timezone";
  keyboardLayout = "$keyboard";
  consoleKeyMap = "$console_keymap";

  # Leave monitor overrides empty to let Niri auto-detect the connected displays.
  extraMonitorSettings = "";
  dockMonitors = [ ];

  # Prime bus IDs are auto-detected once during install and can be adjusted later.
  intelID = "$intel_bus_id";
  nvidiaID = "$nvidia_bus_id";
}
EOF

print_success "Host configuration created"
echo ""

# Window Manager configuration
print_header "Creating Window Manager Host Configurations"
# Create Niri host-specific configuration files
mkdir -p "modules/home/niri/hosts/$hostname"

# Create keybinds.nix for Niri
cat > "modules/home/niri/hosts/$hostname/keybinds.nix" << 'EOF'
{ host, ... }:
''
  // Host-specific keybinds for $HOSTNAME
  // Add your custom keybinds here

  // Example:
  // binds {
  //   Mod+Shift+B { spawn "zen"; }
  // }
''
EOF

sed -i "s/\$HOSTNAME/$hostname/g" "modules/home/niri/hosts/$hostname/keybinds.nix"

# Create outputs.nix for Niri
cat > "modules/home/niri/hosts/$hostname/outputs.nix" << 'EOF'
{ host, ... }:
''
  // Host-specific output configuration for $HOSTNAME
  // Leave this file empty to let Niri auto-detect monitors on this machine.
  // Add output blocks only if you want a fixed manual layout later.
''
EOF

sed -i "s/\$HOSTNAME/$hostname/g" "modules/home/niri/hosts/$hostname/outputs.nix"

# Create windowrules.nix for Niri
cat > "modules/home/niri/hosts/$hostname/windowrules.nix" << 'EOF'
{ host, ... }:
''
  // Host-specific window rules for $HOSTNAME
  // Add your custom window rules here

  // Example:
  // window-rule {
  //   match app-id="^firefox$"
  //   default-column-width { proportion 0.5; }
  // }
''
EOF

sed -i "s/\$HOSTNAME/$hostname/g" "modules/home/niri/hosts/$hostname/windowrules.nix"

print_success "Niri configurations created"
echo ""

# Add new host files to git so flake can see them
git add hosts/"$hostname"/ modules/home/niri/hosts/"$hostname"/ 2>/dev/null || true

print_header "Registering Host"
print_success "Host metadata created at hosts/$hostname/meta.nix"
print_info "flake.nix now auto-discovers hosts, so no manual edit is needed"
echo ""

# Validate flake
print_header "Validating Configuration"
export NIX_CONFIG="experimental-features = nix-command flakes"
if nix flake metadata --no-write-lock-file . >/dev/null 2>&1; then
  print_success "Flake syntax is valid"
else
  print_error "Flake validation failed - please check configuration"
  exit 1
fi
echo ""

# Build configuration
print_header "Building Rockon OS"
echo -e "${YELLOW}This will take 10-20 minutes depending on your hardware...${NC}"
echo ""

read -p "Ready to build? [Y/n]: " build_confirm
if [[ $build_confirm =~ ^[Nn]$ ]]; then
  echo ""
  print_info "You can build manually later with:"
  echo -e "  ${GREEN}sudo nixos-rebuild switch --flake ~/rockon-os#$hostname${NC}"
  exit 0
fi

export NIX_CONFIG="experimental-features = nix-command flakes"

if sudo nixos-rebuild switch --flake .#"$hostname"; then
  echo ""
  print_header "Installation Successful!"
  echo ""
  print_success "Rockon OS has been installed!"
  echo ""
  echo -e "${BLUE}What's next:${NC}"
  echo -e "  1. Your configuration is in: ${GREEN}~/rockon-os/hosts/$hostname/${NC}"
  echo -e "  2. Niri is available at login screen"
  echo -e "  3. Customize: ${GREEN}~/rockon-os/hosts/$hostname/variables.nix${NC}"
  echo -e "  4. Rebuild: ${GREEN}sudo nixos-rebuild switch --flake ~/rockon-os#$hostname${NC}"
  echo ""
  echo -e "${YELLOW}Tip: Update your monitor settings in variables.nix for optimal display${NC}"
  echo ""
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║${NC} ${YELLOW}IMPORTANT: A system restart is required to complete setup${NC}     ${GREEN}║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════╝${NC}"
  echo ""
  read -p "Would you like to restart now? [Y/n]: " restart_confirm
  if [[ ! $restart_confirm =~ ^[Nn]$ ]]; then
    echo ""
    print_info "Restarting system in 5 seconds... (Ctrl+C to cancel)"
    sleep 5
    sudo reboot
  else
    echo ""
    print_info "Please restart your system when ready to complete the installation"
    echo -e "  Run: ${GREEN}sudo reboot${NC}"
  fi
  echo ""
else
  echo ""
  print_error "Build failed"
  echo ""
  echo -e "${YELLOW}To retry manually:${NC}"
  echo -e "  ${GREEN}cd ~/rockon-os${NC}"
  echo -e "  ${GREEN}sudo nixos-rebuild switch --flake .#$hostname${NC}"
  exit 1
fi
