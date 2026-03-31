{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
  };
  home.file."./.config/ghostty/config.ghostty".text = ''

    #theme = Aura
    #theme = Dracula
    #theme = Aardvark Blue
    #theme = GruvboxDarkHard
    # Custom cloud palette tuned for wallpapers/clouds.jpg
    background = #242332
    foreground = #e1dbe2
    cursor-color = #f0c3a7
    cursor-text = #242332
    selection-background = #4a4b62
    selection-foreground = #f8ebed
    palette = 0=#242332
    palette = 1=#cf97a8
    palette = 2=#a5b3ab
    palette = 3=#e8c1ad
    palette = 4=#aab0cf
    palette = 5=#bb9fc0
    palette = 6=#c9b8c5
    palette = 7=#dad4de
    palette = 8=#5c5f77
    palette = 9=#e3b1ba
    palette = 10=#bccac0
    palette = 11=#f0d1bc
    palette = 12=#c3cae5
    palette = 13=#d4b8d6
    palette = 14=#decbd5
    palette = 15=#f5eef2
    adjust-cell-height = 10%
    window-theme = dark
    window-height = 32
    window-width = 110
    background-opacity = 0.95
    #background-opacity-cells = true
    background-blur-radius = 60
    cursor-style = bar
    mouse-hide-while-typing = true

    # keybindings
    keybind = alt+s>r=reload_config
    keybind = alt+s>x=close_surface

    keybind = alt+s>n=new_window
    keybind = alt+s>q=toggle_quick_terminal
    keybind = alt+s>p=toggle_command_palette
    keybind = alt+s>u=jump_to_prompt:-1
    keybind = alt+s>w=write_scrollback_file:open

    # tabs
    keybind = alt+s>c=new_tab
    keybind = alt+s>shift+l=next_tab
    keybind = alt+s>shift+h=previous_tab
    keybind = alt+s>comma=move_tab:-1
    keybind = alt+s>period=move_tab:1

    # quick tab switch
    keybind = alt+s>1=goto_tab:1
    keybind = alt+s>2=goto_tab:2
    keybind = alt+s>3=goto_tab:3
    keybind = alt+s>4=goto_tab:4
    keybind = alt+s>5=goto_tab:5
    keybind = alt+s>6=goto_tab:6
    keybind = alt+s>7=goto_tab:7
    keybind = alt+s>8=goto_tab:8
    keybind = alt+s>9=goto_tab:9

    # split
    keybind = alt+s>\=new_split:right
    keybind = alt+s>-=new_split:down

    keybind = alt+s>j=goto_split:bottom
    keybind = alt+s>k=goto_split:top
    keybind = alt+s>h=goto_split:left
    keybind = alt+s>l=goto_split:right

    keybind = alt+s>z=toggle_split_zoom

    keybind = alt+s>e=equalize_splits

    # other
    #copy-on-select = clipboard

    font-size = 12
    #font-family = JetBrainsMono Nerd Font Mono
    #font-family-bold = JetBrainsMono NFM Bold
    #font-family-bold-italic = JetBrainsMono NFM Bold Italic
    #font-family-italic = JetBrainsMono NFM Italic

    font-family = BerkeleyMono Nerd Font
    #font-family = Iosevka Nerd Font
    # font-family = SFMono Nerd Font

    title = "GhosTTY"

    wait-after-command = false
    shell-integration = detect
    window-save-state = always
    gtk-single-instance = true
    unfocused-split-opacity = 0.5
    quick-terminal-position = center
    shell-integration-features = cursor,sudo
  '';
}
