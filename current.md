# Current Inventory For `rockon`

Срез сделан для `nixosConfigurations.rockon` из `flake.nix` на основе профиля `nvidia`.

Важно: ниже я перечислил именно явно объявленные пакеты, программы, сервисы и альтернативы в репозитории. Полный runtime closure NixOS/HM я сюда не тащил, иначе список утонет в `glibc`, `shadow`, `systemd` и прочих транзитивных зависимостях.

## Статусы

- `ACTIVE` - реально участвует в текущей сборке `rockon`, то есть пакет/настройка реально попадают в систему.
- `DISABLED` - есть в конфиге, но сейчас выключено через `enable = false`, `mkIf false`, `mkForce false` или флаг в `variables.nix`.
- `COMMENTED` - закомментировано в исходниках и потому не влияет на сборку.
- `REPO_ONLY` - лежит в репозитории, но не подключено к текущему `rockon` через imports.

## Точки входа

- `flake.nix` -> `nixosConfigurations.rockon` - корневая точка, где объявлена сама сборка хоста `rockon`.
- `profiles/nvidia/default.nix` - профиль железа/графики, который собирает NVIDIA-ветку системы.
- `hosts/rockon/default.nix` - хост-специфичные настройки именно для твоей машины.
- `modules/core/default.nix` - главный импорт системных модулей.
- `modules/core/user.nix` -> `modules/home/default.nix` - вход в Home Manager и пользовательские модули.

## ACTIVE: system-level

### Активные system programs/services/options

- `drivers.nvidia.enable = true` - включает драйвер NVIDIA для дискретной видеокарты.
- `boot.lanzaboote.enable = true` - включает Lanzaboote для Secure Boot на NixOS.
- `boot.lanzaboote.autoGenerateKeys.enable = true` - автоматически генерирует ключи Secure Boot.
- `boot.lanzaboote.autoEnrollKeys.enable = true` - автоматически регистрирует эти ключи в прошивке.
- `services.displayManager.sddm.enable = true` - включает графический экран входа SDDM.
- `services.displayManager.sessionPackages = [ pkgs.niri ]` - регистрирует сессию Niri в менеджере входа.
- `services.v2raya.enable = true` - поднимает сервис/GUI для управления Xray/V2Ray-прокси.
- `networking.nftables.enable = true` - включает firewall и фильтрацию трафика через nftables.
- `networking.networkmanager.enable = true` - включает NetworkManager для управления сетями.
- `services.flatpak.enable = true` - позволяет ставить sandboxed-приложения через Flatpak.
- `xdg.portal.enable = true` - включает XDG-порталы для выбора файлов, скриншеринга и интеграции Wayland-приложений.
- `programs.nh.enable = true` - включает `nh`, упрощающий rebuild/clean/update для NixOS.
- `programs.nix-ld.enable = true` - позволяет запускать обычные ELF-бинарники вне Nix-окружения.
- `programs.steam.enable = true` - включает Steam и его системную интеграцию.
- `programs.thunar.enable = true` - включает файловый менеджер Thunar.
- `programs.fish.enable = true` on system level for completions - ставит fish на системном уровне, чтобы были completions и shell-интеграция.
- `programs.zsh.enable = true` on system level for completions - ставит zsh на системном уровне, чтобы были completions и shell-интеграция.
- `programs.dconf.enable = true` - включает backend настроек dconf для GTK/GNOME-приложений.
- `programs.seahorse.enable = true` - ставит GUI для ключей, паролей и keyring.
- `programs.mtr.enable = true` - даeт утилиту для сетевой диагностики маршрута и потерь.
- `programs.virt-manager.enable = true` - включает GUI для управления виртуальными машинами KVM/QEMU.
- `programs.niri.package = pkgs.niri` - явно выбирает пакет `niri` из nixpkgs.
- `hardware.sane.enable = true` - включает поддержку сканеров через SANE.
- `hardware.bluetooth.enable = true` - включает стек Bluetooth.
- `hardware.graphics.enable = true` - включает базовый графический стек и поддержку GPU.
- `hardware.graphics.enable32Bit = true` - добавляет 32-битные графические библиотеки для старых игр и программ.
- `hardware.enableRedistributableFirmware = true` - разрешает несвободные firmware blobs для железа.
- `hardware.i2c.enable = true` - включает доступ к шине I2C для мониторов, RGB и датчиков.
- `services.hardware.openrgb.enable = true` - поднимает сервис OpenRGB для управления подсветкой устройств.
- `services.libinput.enable = true` - включает обработку мыши, тачпада и клавиатуры через libinput.
- `services.fstrim.enable = true` - периодически делает TRIM для SSD.
- `services.gvfs.enable = true` - добавляет GVFS-интеграцию для GUI-файловых менеджеров и внешних носителей.
- `services.openssh.enable = true` - включает SSH-сервер для удаленного доступа.
- `services.blueman.enable = true` - ставит графический Bluetooth-менеджер Blueman.
- `services.tumbler.enable = true` - генерирует превью файлов для Thunar.
- `services.gnome.gnome-keyring.enable = true` - включает хранилище секретов GNOME Keyring.
- `services.upower.enable = true` - даeт информацию о батарее и питании.
- `services.udisks2.enable = true` - отвечает за монтирование дисков и съемных носителей.
- `services.smartd.enable = true` - следит за SMART-состоянием дисков.
- `services.pipewire.enable = true` - включает PipeWire как основной аудио/видео сервер.
- `services.pipewire.alsa.enable = true` - включает ALSA-совместимость через PipeWire.
- `services.pipewire.alsa.support32Bit = true` - добавляет 32-битный ALSA-слой для игр и старого софта.
- `services.pipewire.pulse.enable = true` - включает PulseAudio-совместимость через PipeWire.
- `services.pipewire.wireplumber.enable = true` - включает WirePlumber как session manager для PipeWire.
- `virtualisation.docker.enable = true` - включает Docker для контейнеров.
- `virtualisation.libvirtd.enable = true` - включает libvirtd для виртуализации через KVM/QEMU.
- `virtualisation.spiceUSBRedirection.enable = true` - позволяет пробрасывать USB-устройства в VM через SPICE.
- `virtualisation.libvirtd.qemu.swtpm.enable = true` - добавляет виртуальный TPM для виртуальных машин.
- `security.rtkit.enable = true` - даeт realtime-приоритеты, важные для аудио.
- `security.polkit.enable = true` - включает polkit для графических запросов привилегий.
- `stylix.enable = true` - включает централизованную тему оформления через Stylix.
- `thunar` plugins active: `thunar-archive-plugin` (работа с архивами прямо из Thunar), `thunar-volman` (автодействия для флешек, камер и других носителей)
- `steam.extraCompatPackages`: `proton-ge-bin` (альтернативный Proton GE для проблемных Windows-игр)
- `steam` extra libs override: `libusb1` (доступ к USB-устройствам), `udev` (обнаружение устройств), `SDL2` (ввод/аудио/окна для игр), `libXcursor` (курсор под X11), `libXi` (расширенный ввод под X11), `libXinerama` (мультиэкранность под X11), `libXScrnSaver` (работа со screensaver API), `libXcomposite` (композитинг окон), `libXdamage` (отслеживание перерисовки окон), `libXrender` (2D-рендер под X11), `libXext` (дополнительные X11-расширения), `libkrb5` (Kerberos, нужен некоторым лаунчерам), `keyutils` (kernel keyring для auth/DRM)
- `gamingSupportEnable = true`, so `hardware.steam-hardware.enable = true` (правила и udev-поддержка для Steam-девайсов) and `hardware.xpadneo.enable = true` (драйвер для Bluetooth-геймпадов Xbox)

### Явно добавленные system packages

- `hosts/rockon/default.nix`: `gedit` (простой GUI-редактор текста)
- `hosts/rockon/secure-boot.nix`: `sbctl` (управление ключами и состоянием Secure Boot)
- `modules/core/nh.nix`: `nix-output-monitor` (делает вывод сборки Nix понятнее), `nvd` (показывает diff между поколениями/деривациями)
- `modules/core/network.nix`: `networkmanagerapplet` (иконка и меню сети в трее)
- `modules/core/thunar.nix`: `ffmpegthumbnailer` (генерирует превью видео в файловом менеджере)
- `modules/core/steam.nix`: `mangohud` (оверлей FPS, frametime и нагрузки в играх)
- `modules/core/gaming-support.nix`: `gamescope` (композитор-обертка для игр), `protonup-qt` (ставит/обновляет Proton GE и похожие совместимости), `SDL2` (библиотека ввода/окон/аудио для игр), `jstest-gtk` (тестер геймпадов), `evtest` (просмотр сырых событий ввода), `antimicrox` (маппинг геймпада на клавиатуру/мышь)
- `modules/core/sddm.nix`: `sddm-astronaut` (тема оформления для экрана входа SDDM)
- `modules/core/fonts.nix`: `dejavu_fonts` (универсальный базовый шрифт), `fira-code` (моноширинный кодовый шрифт с лигатурами), `fira-code-symbols` (символы для Fira Code), `noto-fonts` (широкий набор обычных шрифтов), `noto-fonts-color-emoji` (emoji), `noto-fonts-cjk-sans` (китайский/японский/корейский sans), `font-awesome` (иконки), `jetbrains-mono` (моноширинный шрифт для кода), `material-icons` (иконки Material), `maple-mono.NF` (Nerd Font-версия Maple Mono), `nerd-fonts.fira-code` (Fira Code с патченными иконками), `nerd-fonts.droid-sans-mono` (Droid Sans Mono с иконками), `nerd-fonts.jetbrains-mono` (JetBrains Mono с иконками), `nerd-fonts.meslo-lg` (Meslo LG с иконками, популярен для prompt), `nerd-fonts.hack` (Hack с иконками), `terminus_font` (пиксельный терминальный шрифт), `inter` (UI-шрифт для интерфейсов), `corefonts` (базовые шрифты Microsoft), `vista-fonts` (дополнительные шрифты из Windows Vista)
- `modules/core/packages.nix`: `antigravity` (агентная dev-платформа/IDE), `fzf` (fuzzy-поиск по файлам и истории), `libreoffice-fresh` (офисный пакет), `openrgb` (управление RGB-подсветкой), `onlyoffice-desktopeditors` (офис с хорошей совместимостью форматов MS Office), `git` (система контроля версий), `yandex-music` (клиент Яндекс Музыки), `lxqt.lxqt-policykit` (графический polkit-агент), `xray` (ядро прокси/VPN-туннелей), `v2raya` (GUI/сервис для Xray/V2Ray), `appimage-run` (запуск AppImage-файлов), `telegram-desktop` (клиент Telegram), `google-chrome` (браузер), `android-tools` (adb/fastboot и утилиты Android), `bottom` (TUI-мониторинг системы), `brightnessctl` (управление яркостью), `cmatrix` (декоративная "матрица" в терминале), `cowsay` (ASCII-баннеры с текстом), `docker-compose` (оркестрация compose-стеков), `duf` (показывает занятость файловых систем), `dysk` (информация о дисках), `eza` (современная замена `ls`), `ffmpeg` (конвертация и обработка медиа), `file-roller` (архиватор), `gdu` (анализ размеров каталогов), `gedit` (редактор текста), `gimp` (редактор растровой графики), `mesa-demos` (тесты OpenGL/Vulkan), `gping` (ping с графиком), `tuigreet` (TUI-логин для greetd), `htop` (монитор процессов), `hyprpicker` (пипетка цветов), `eog` (просмотрщик изображений), `alacritty` (терминал), `fuzzel` (launcher/dmenu для Wayland), `inxi` (сводка по железу и системе), `killall` (завершение процессов по имени), `libnotify` (desktop-уведомления), `lm_sensors` (датчики температур и вентиляторов), `lolcat` (раскрашивает вывод), `lshw` (инвентаризация железа), `mpv` (медиаплеер), `ncdu` (анализ занятого места в терминале), `nitch` (быстрый system fetch), `nixfmt` (форматтер Nix), `nixd` (LSP-сервер для Nix), `nil` (альтернативный LSP-сервер для Nix), `onefetch` (красивое summary по git-репозиторию), `pavucontrol` (GUI-микшер PulseAudio/PipeWire), `pciutils` (утилиты для PCI-устройств), `picard` (редактор музыкальных тегов), `pkg-config` (поиск флагов и зависимостей при сборке), `playerctl` (управление медиаплеерами), `rhythmbox` (музыкальный плеер), `ripgrep` (быстрый поиск по тексту), `socat` (прокидывание сокетов и портов), `sox` (обработка аудио), `unrar` (распаковка RAR), `unzip` (распаковка ZIP), `usbutils` (информация об USB-устройствах), `v4l-utils` (утилиты для камер и video4linux), `waypaper` (GUI для обоев Wayland), `wget` (скачивание файлов по сети), `xwayland-satellite` (выносит Xwayland в отдельный процесс вне композитора), `ytmdl` (скачивает музыку с YouTube/YouTube Music), `nwg-displays` (GUI-настройка мониторов под wlroots), `nwg-drawer` (меню приложений), `nwg-look` (редактор GTK-внешнего вида под wlroots), `rofi-emoji` (выбор emoji через Rofi), `popsicle` (запись образов на USB), `gum` (интерактивные CLI-формы и меню), `gtk3` (GTK3 runtime/утилиты), `gtk4` (GTK4 runtime/утилиты), `localsend` (передача файлов по локальной сети)

## ACTIVE: Home Manager

### Активные HM programs/services/modules

- `programs.zsh.enable = true` - основной пользовательский shell.
- `programs.starship.enable = true` - красивый и информативный prompt.
- `programs.bat.enable = true` - улучшенный `cat` с подсветкой синтаксиса.
- `programs.bottom.enable = true` - мониторинг системы в TUI через `btm`.
- `programs.btop.enable = true` - еще один интерактивный монитор процессов/ресурсов.
- `programs.cava.enable = true` - аудиовизуализатор в терминале/панели.
- `programs.eza.enable = true` - современная замена `ls`.
- `programs.fastfetch.enable = true` - быстрый вывод информации о системе.
- `programs.fzf.enable = true` - fuzzy-фильтрация в shell.
- `programs.gh.enable = true` - GitHub CLI.
- `programs.git.enable = true` - настройка Git на уровне Home Manager.
- `programs.htop.enable = true` - монитор процессов.
- `programs.kitty.enable = true` - терминал Kitty.
- `programs.ghostty.enable = true` - терминал Ghostty.
- `programs.lazygit.enable = true` - TUI для работы с Git.
- `programs.nvf.enable = true` - включение Neovim через NVF-конфигурацию.
- `programs.obs-studio.enable = true` - запись экрана и стриминг.
- `programs.rofi.enable = true` - launcher и dmenu-интерфейс.
- `qt.enable = true` - базовая интеграция и тема для Qt-приложений.
- `programs.tealdeer.enable = true` - быстрые tldr-страницы по командам.
- `programs.tmux.enable = true` - терминальный мультиплексор.
- `programs.vscode.enable = true` - Visual Studio Code.
- `programs.wlogout.enable = true` - меню выхода/выключения для Wayland.
- `programs.yazi.enable = true` - TUI-файловый менеджер.
- `programs.zoxide.enable = true` - умная навигация по каталогам.
- `xdg.enable = true` - включает XDG-базовые пользовательские директории и интеграцию.
- `xdg.mime.enable = true` - управляет MIME-типами.
- `xdg.mimeApps.enable = true` - управляет приложениями по умолчанию для MIME.
- `services.nwg-drawer-stylix.enable = true` - стилизует `nwg-drawer` через Stylix.
- `Noctalia shell` is active because `barChoice = "noctalia"` - выбран Noctalia как shell/bar-слой рабочего стола.
- `Niri` module is active - активен тайлинговый Wayland-композитор Niri.
- Active user systemd services from `modules/home/niri/niri.nix`: `xwayland-satellite` (отдельный Xwayland для X11-приложений), `xdg-desktop-portal` (базовый брокер порталов), `xdg-desktop-portal-gnome` (GNOME backend для файловых диалогов/скриншеринга), `xdg-desktop-portal-gtk` (GTK backend для порталов)

### Явно добавленные home.packages

- `modules/home/bashrc-personal.nix`: `bash` (добавляет Bash в user profile для совместимости скриптов и ручного запуска)
- `modules/home/zsh/zshrc-personal.nix`: `zsh` (добавляет Zsh в user profile как основной shell)
- `modules/home/niri/niri.nix`: `niri` (сам композитор), `udiskie` (автомонтирование внешних дисков), `xwayland-satellite` (X11-приложения через отдельный Xwayland), `swww` (установка обоев под Wayland), `grim` (создание скриншотов), `slurp` (выделение области на экране), `wl-clipboard` (clipboard для Wayland), `swappy` (разметка/редактирование скриншотов), `xdg-desktop-portal-gnome` (portal backend для интеграции приложений)
- `modules/home/virtmanager.nix`: `spice-gtk` (SPICE-клиент и интеграция с VM), `virtio-win` (драйверы VirtIO для гостевых Windows)
- `modules/home/noctalia-shell/default.nix`: `inputs.noctalia.packages.${system}.default` (пакет оболочки Noctalia для панели/виджетов/desktop-shell-слоя)
- `modules/home/scripts/default.nix`: `emopicker9000` (выбор emoji и копирование/ввод), `list-keybinds` (показывает горячие клавиши), `task-waybar` (открывает/переключает центр уведомлений), `nvidia-offload` (запускает команду через дискретную NVIDIA), `wallsetter` (меняет обои по кругу через `swww`), `web-search` (быстрый поиск через Rofi), `rofi-launcher` (обертка для запуска приложений через Rofi), `screenshootin` (скриншот выделенной области с копированием), `hm-find` (ищет конфликтующие backup-файлы Home Manager), `zed-fix` (запускает Zed в обход проблемного Wayland-окружения), `niri-gaming-mode.sh` (режим игр с "запиранием" курсора на основном мониторе), `webapp-install` (создает desktop web-app), `webapp-remove` (удаляет созданный web-app), `dcli` (CLI для сборки, деплоя и обслуживания хостов)

### Активные plugins/extensions/helpers

- `programs.bat.extraPackages`: `batman` (показывает man-страницы через `bat`), `batpipe` (подсвечивает вывод в пайплайнах)
- `programs.obs-studio.plugins`: `wlrobs` (захват Wayland-экрана), `obs-pipewire-audio-capture` (захват звука через PipeWire), `obs-vkcapture` (захват Vulkan-игр), `obs-source-clone` (клонирование источников), `obs-move-transition` (анимированные переходы и движения), `obs-composite-blur` (размытие источников), `obs-backgroundremoval` (удаление фона)
- `programs.tmux.plugins`: `vim-tmux-navigator` (переход между окнами Vim и tmux), `sensible` (базовые sane defaults), `tokyo-night-tmux` (тема оформления tmux)
- `programs.yazi.plugins`: `lazygit` (быстрый вызов lazygit из Yazi), `full-border` (полные рамки интерфейса), `git` (git-индикация в файловом менеджере), `smart-enter` (умное поведение Enter)
- `programs.vscode` extensions from nixpkgs: `bbenoist.nix` (поддержка Nix), `jeff-hykin.better-nix-syntax` (улучшенная подсветка Nix), `ms-vscode.cpptools-extension-pack` (C/C++ toolchain и отладка), `vscodevim.vim` (Vim-режим), `mads-hartmann.bash-ide-vscode` (Bash IDE), `tamasfe.even-better-toml` (поддержка TOML), `zainchen.json` (улучшения для JSON)
- `programs.vscode` marketplace extensions: `openai.chatgpt` (доступ к ChatGPT в редакторе), `Google.geminicodeassist` (AI-помощник Gemini в редакторе)
- `programs.nvf` enabled major features: `telescope` (поиск файлов/буферов), `spellcheck` (проверка орфографии), `lsp` (интеграция language servers), `trouble` (панель diagnostics и references), `nix` (поддержка Nix), `clang` (поддержка C/C++), `zig` (поддержка Zig), `python` (поддержка Python), `markdown` (поддержка Markdown), `ts` (поддержка TypeScript/JavaScript), `html` (поддержка HTML), `lua` (поддержка Lua), `css` (поддержка CSS), `typst` (поддержка Typst), `rust` (поддержка Rust), `nvim-web-devicons` (иконки файлов), `nvim-cursorline` (подсветка текущей строки), `cinnamon-nvim` (цветовая схема), `fidget-nvim` (LSP-статус), `highlight-undo` (подсветка undo), `indent-blankline` (направляющие отступов), `rainbow-delimiters` (цветные скобки), `lualine` (statusline), `nvim-autopairs` (автозакрытие скобок/кавычек), `blink-cmp` (completion engine), `friendly-snippets` (готовые сниппеты), `luasnip` (движок сниппетов), `nvimBufferline` (вкладки буферов), `whichKey` (подсказки по hotkeys), `cheatsheet` (шпаргалки по командам), `git` (Git-интеграция), `gitsigns` (git-маркеры в gutter), `project-nvim` (обнаружение проектов), `dashboard-nvim` (стартовый экран), `neo-tree` (дерево файлов), `nvim-notify` (уведомления Neovim), `markdownPreview` (предпросмотр Markdown), `icon-picker` (вставка иконок/emoji), `surround` (работа с обрамляющими символами), `diffview-nvim` (удобный diff UI), `hop` (быстрые прыжки по экрану), `leap` (навигация прыжками), `borders` (оформление рамок окон), `noice` (улучшенный UI сообщений/командной строки), `colorizer` (предпросмотр цветов), `illuminate` (подсветка совпадающих символов), `smartcolumn` (умная колонка длины строки), `fastaction` (быстрый выбор code actions), `toggleterm` (встроенный терминал), `toggleterm.lazygit` (быстрый lazygit внутри toggleterm), `comment-nvim` (комментирование кода)

## DISABLED: в текущем активном пути

### Выключено флагами в `hosts/rockon/variables.nix`

- `enableNFS = false` -> `services.rpcbind` (маппинг RPC-сервисов), `services.nfs.server` (раздача NFS-шар по сети)
- `printEnable = false` -> `services.printing` (система печати CUPS), `services.avahi` (сетевое обнаружение принтеров), `services.ipp-usb` (IPP-over-USB для современных принтеров)
- `flutterdevEnable = false` -> `flutter` (SDK Flutter), `android-studio` (IDE для Android), `androidenv.androidPkgs.platform-tools` (adb/fastboot из Android SDK), `androidenv.androidPkgs.emulator` (Android Emulator), `androidenv.androidPkgs.ndk-bundle` (NDK для native Android), `jdk` (Java toolchain), `programs.adb` (системное включение adb)
- `syncthingEnable = false` -> `services.syncthing` (peer-to-peer синхронизация файлов)
- `enableCommunicationApps = false` -> `teams-for-linux` (клиент Teams), `zoom-us` (Zoom), `telegram-desktop` (Telegram), `vesktop` (клиент Discord/Vencord)
- `enableExtraBrowsers = false` -> `vivaldi` (браузер Vivaldi), `brave` (браузер Brave), `chromium` (open-source база Chrome), `google-chrome` (Chrome), `firefox` (Firefox), `helium-browser` (Helium Browser)
- `enableProductivityApps = false` -> `obsidian` (заметки/knowledge base), `gnome-boxes` (простые виртуалки), `quickemu` (быстрый запуск VM), `quickgui` (GUI для Quickemu)
- `aiCodeEditorsEnable = false` -> `claude-code` (AI coding tool в терминале), `gemini-cli` (AI agent Gemini в терминале)
- `enableHyprlock = false` - не включает Hyprlock/Hypridle, чтобы не конфликтовать с Noctalia/DMS lock screen.

### Выключено явным `enable = false` или аналогом

- `drivers.amdgpu.enable = false` - не загружается AMDGPU-ветка для видеокарт AMD.
- `drivers.nvidia-prime.enable = false` - не включен PRIME-режим для гибридной графики NVIDIA + интегрированная GPU.
- `drivers.intel.enable = false` - не активирована отдельная Intel GPU-ветка.
- `vm.guest-services.enable = false` - не включены guest services для запуска системы как виртуальной машины.
- `services.sysc-greet.enable = false` - не используется альтернативный greetd-greeter `sysc-greet`.
- `services.xserver.enable = false` - не поднимается X11-сервер, система идет по Wayland-пути.
- `services.displayManager.ly.enable = false` by default - текстовый login-manager `ly` не используется.
- `programs.neovim.enable = false` - стандартный модуль Neovim отключен в пользу NVF.
- `programs.firefox.enable = false` - Firefox не включен как системный модуль.
- `programs.hyprland.enable = false` on system level - системная ветка Hyprland выключена, активен Niri.
- `programs.hyprlock.enable = false` on system level - системная ветка lockscreen Hyprlock выключена.
- `virtualisation.podman.enable = false` - Podman не используется, выбран Docker.
- `hardware.logitech.wireless.enable = false` - не включена поддержка Logitech Unifying/Bolt на системном модуле.
- `hardware.logitech.wireless.enableGraphical = false` - не ставится GUI для настройки Logitech-устройств.
- `hardware.keyboard.qmk.enable = false` - не включены инструменты для QMK-клавиатур.
- `local.hardware-clock.enable = false` - RTC не переводится в local time, обычно чтобы не ломать время при Linux-first конфигурации.
- `programs.bash.enable = false` in Home Manager - Home Manager не управляет Bash-конфигом как отдельным shell-модулем.

### Выключено условием, хотя модуль активен

- `systemd.user.services.waybar-niri` is not created because `barChoice = "noctalia"` - сервис Waybar не создается, потому что баром выбран Noctalia.
- `systemd.user.services.dms-niri` is not created because `barChoice = "noctalia"` - сервис Dank Material Shell не создается по той же причине.
- `stylix.targets.waybar.enable = false` - Stylix не красит Waybar.
- `stylix.targets.rofi.enable = false` - Stylix не применяет тему к Rofi.
- `stylix.targets.hyprland.enable = false` - Stylix не генерирует тему для Hyprland.
- `stylix.targets.hyprlock.enable = false` - Stylix не генерирует тему для Hyprlock.
- `stylix.targets.ghostty.enable = false` - Stylix не управляет оформлением Ghostty.
- `Noctalia` settings include internal disabled toggles like `hooks.enabled = false` (внутренние hooks Noctalia выключены), `nightLight.enabled = false` (встроенный night light выключен)

### NVF explicit disabled subfeatures

- `lsp.lspkind` - иконки и kinds для completion/LSP.
- `lsp.lightbulb` - лампочка с доступными code actions.
- `lsp.lspsaga` - расширенный UI для LSP-операций.
- `lsp.lspSignature` - popup-подсказки по сигнатурам функций.
- `lsp.otter-nvim` - LSP для вложенных языков внутри markdown/quarto и похожих файлов.
- `lsp.nvim-docs-view` - отдельное окно документации по символу.
- `autocomplete.nvim-cmp` - старый completion engine, отключен в пользу `blink-cmp`.
- `treesitter.context` - sticky-контекст текущего блока кода сверху.
- `git.gitsigns.codeActions` - git code actions через gitsigns.
- `dashboard.alpha` - альтернативный стартовый экран Alpha.
- `utility.ccc` - color picker и редактор цветов.
- `utility.vim-wakatime` - трекинг времени кодинга через WakaTime.
- `utility.motion.precognition` - тренажер/подсказки по motion-навигации.
- `utility.images.image-nvim` - отображение картинок прямо в буфере.
- `ui.breadcrumbs` - breadcrumbs по текущему символу/структуре файла.
- `ui.breadcrumbs.navbuddy` - навигация по символам через Navbuddy.
- `session.nvim-session-manager` - сохранение и восстановление сессий редактора.

## COMMENTED: что найдено закомментированным

- `hosts/rockon/variables.nix`: `#waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix` (альтернативный выбор Waybar вместо Noctalia)
- `modules/home/default.nix`: `# ./hyprland` (ветка Hyprland), закомментированная fish-ветка (альтернативный shell), закомментированная DMS-ветка (альтернативный shell/UI), закомментированная waybar-ветка (альтернативная панель), `# ./swaync.nix` (центр уведомлений SwayNC)
- `modules/core/packages.nix`: `amfora` (терминальный браузер Gemini), `firefox` (браузер Firefox), `youtube-music` (клиент YouTube Music), `zen-browser` (альтернативный браузер на Firefox-базе), `zed-editor` (редактор кода Zed)
- `modules/core/ai-code-editors.nix`: `code-cursor` (AI-редактор на базе VS Code)
- `modules/core/fonts.nix`: `symbola` (резервный шрифт для редких Unicode-символов)
- `modules/core/flatpak.nix`: закомментированный `hyprland` portal block и `# pkgs.hyprland` (Hyprland-специфичная portal-интеграция)
- `modules/core/printing.nix`: `pkgs.hplipWithPlugin` (драйверы и плагины для принтеров HP)
- `modules/core/stylix.nix`: весь ручной блок `base16Scheme` (ручная цветовая палитра вместо автоматической темы)
- `modules/home/bat.nix`: `batgrep` (grep-подобный поиск с выводом через `bat`)
- `modules/home/obs-studio.nix`: `enableVirtualCamera` (виртуальная веб-камера из OBS)
- `modules/home/xdg.nix`: override, который скрывает `com.google.Chrome.desktop` (убирает дублирующий launcher Chrome)
- `modules/home/ghostty.nix`: альтернативные `theme` (тема терминала), `font-family` (шрифт), `copy-on-select` (копирование при выделении), `background-opacity-cells` (прозрачность фона)
- `modules/home/hyprland/hyprland.nix`: кастомный `package = inputs.hyprland.packages...` (использование Hyprland прямо из flake input, а не из nixpkgs)
- `modules/home/tmux.nix`: закомментированные popup-команды для `ipython` (Python REPL), `rmpc` (клиент MPD), `chat-popup` (всплывающий чат/CLI)
- `modules/home/bashrc-personal.nix` и `modules/home/zsh/zshrc-personal.nix`: примеры `EDITOR` (редактор по умолчанию), `VISUAL` (визуальный редактор), `zoxide` (умная навигация по папкам), `oh-my-posh` (альтернативный prompt)

## REPO_ONLY: есть в репо, но не подключено к текущему `rockon`

### System-side

- `modules/core/quickshell.nix`: `inputs.quickshell.packages.${system}.default` (сам Quickshell для shell/UI на Qt/QML), `qt6.qt5compat` (слой совместимости Qt5 API), `qt6.qtbase` (базовые Qt-библиотеки), `qt6.qtquick3d` (3D для Qt Quick), `qt6.qtwayland` (Wayland-поддержка Qt6), `qt6.qtdeclarative` (QML/Qt Quick), `qt6.qtsvg` (рендер SVG), `kdePackages.qt5compat` (еще один слой совместимости Qt5), `libsForQt5.qt5.qtgraphicaleffects` (графические эффекты для старых Qt5/QML-компонентов)

### Home-side modules not imported now

- `modules/home/alacritty.nix`: `programs.alacritty.enable = true` (альтернативный терминал Alacritty)
- `modules/home/fish/default.nix`: `programs.fish.enable = true` (альтернативный shell Fish), fish plugins `fzf-fish` (fuzzy-поиск в shell), `autopair` (автозакрытие скобок и кавычек), `done` (уведомления о завершении долгих команд), `sponge` (QoL-плагин для удобной работы с командной строкой)
- `modules/home/fish/fishrc-personal.nix`: explicit `home.packages = [ fish ]` (добавляет бинарник Fish в профиль пользователя)
- `modules/home/hyprland/default.nix`: whole Hyprland branch exists, but import is commented out in `modules/home/default.nix` (альтернативный desktop path на Hyprland)
- `modules/home/hyprland/hyprland.nix`: `wayland.windowManager.hyprland.enable = true` (включает Hyprland), `ydotool` service (эмуляция ввода), packages `swww` (обои), `grim` (скриншоты), `slurp` (выбор области), `wl-clipboard` (буфер обмена Wayland), `swappy` (редактор скриншотов), `ydotool` (виртуальный ввод), `hyprpolkitagent` (polkit-agent для Hyprland), `hyprland-qtutils` (Qt-утилиты для Hyprland)
- `modules/home/hyprland/pyprland.nix`: `home.packages = [ pyprland ]` (плагин-система/утилиты для Hyprland)
- `modules/home/hyprland/hyprlock.nix`: `programs.hyprlock.enable = true` (lockscreen для Hyprland)
- `modules/home/hyprland/hypridle.nix`: `services.hypridle.enable = true` (idle-daemon для блокировки/сна)
- `modules/home/swaync.nix`: `services.swaync.enable = true` (центр уведомлений SwayNC)
- `modules/home/dank-material-shell/default.nix`: quickshell package (UI-shell на Qt/QML), `dms-install` (установка DMS), `dms-uninstall` (удаление DMS), `dms-start` (запуск DMS), `dms-stop` (остановка DMS), `material-symbols-rounded` (иконки), `nerd-fonts.fira-code` (шрифт с иконками), `nerd-fonts.jetbrains-mono` (шрифт с иконками), `wl-clipboard` (clipboard), `cliphist` (история буфера обмена), `brightnessctl` (яркость), `hyprpicker` (пипетка цветов), `matugen` (генерация палитры из обоев), `lm_sensors` (датчики), `pciutils` (информация о PCI), `glib` (базовые GLib-зависимости), `networkmanager` (управление сетью), `networkmanagerapplet` (GUI-индикатор сети), `cava` (визуализатор аудио), `qt6.qtwayland` (Wayland-поддержка Qt6), `libsForQt5.qt5.qtwayland` (Wayland-поддержка Qt5), `gammastep` (night light/температура экрана)
- `modules/home/editors/doom-emacs.nix`: `emacs-gtk` (GUI Emacs), `git` (VCS), `lazygit` (TUI для Git), `ripgrep` (быстрый поиск), `libtool` (сборочные утилиты), `cmake` (система сборки), `pkg-config` (поиск библиотек), `hunspell` (проверка орфографии), `hunspellDicts.en_US` (словарь английского US), `hunspellDicts.en_AU` (словарь английского AU), `hunspellDicts.es_ES` (словарь испанского), `hunspellDicts.ru_RU` (словарь русского), `clang-tools` (C/C++ tooling), `nil` (Nix LSP)
- `modules/home/editors/doom-emacs-install.nix`: `get-doom` (скрипт установки Doom Emacs)
- `modules/home/evil-helix.nix`: `evil-helix` (редактор с modal/Vim-подходом), `cmake-language-server` (LSP для CMake), `jsonnet-language-server` (LSP для Jsonnet), `luaformatter` (форматтер Lua), `lua-language-server` (LSP для Lua), `marksman` (LSP для Markdown), `taplo` (TOML toolkit/LSP), `nil` (Nix LSP), `jq-lsp` (LSP для jq), `vscode-langservers-extracted` (HTML/CSS/JSON/ESLint language servers), `bash-language-server` (LSP для Bash), `awk-language-server` (LSP для AWK), `vscode-extensions.llvm-vs-code-extensions.vscode-clangd` (Clangd-расширение), `clang-tools` (clangd и сопутствующие инструменты), `docker-compose-language-service` (LSP для compose-файлов), `docker-compose` (управление compose-стеками), `docker-language-server` (LSP для Dockerfile), `typescript-language-server` (LSP для TypeScript)
- `modules/home/scripts/gemini-cli.nix`: `gemini-launcher` + desktop entry (launcher и ярлык для запуска Gemini CLI из меню приложений)
- `modules/home/starship-ddubs-1.nix`: альтернативный preset для `starship`, но внутри самого файла `enable = false` (запасной вариант prompt-темы)

### Waybar variants in repo, but not wired into current `rockon`

- `modules/home/waybar/Jerry-waybar.nix` - альтернативный конфиг Waybar.
- `modules/home/waybar/waybar-curved.nix` - альтернативный Waybar с акцентом на curved-стиль.
- `modules/home/waybar/waybar-ddubs.nix` - альтернативный авторский конфиг Waybar.
- `modules/home/waybar/waybar-ddubs-2.nix` - вторая вариация конфига Waybar от ddubs.
- `modules/home/waybar/waybar-dwm.nix` - Waybar в стиле DWM.
- `modules/home/waybar/waybar-dwm-2.nix` - еще одна вариация Waybar в стиле DWM.
- `modules/home/waybar/waybar-dwm2.nix` - альтернативная DWM-подобная раскладка Waybar.
- `modules/home/waybar/waybar-jak-catppuccin.nix` - Waybar с темой Catppuccin.
- `modules/home/waybar/waybar-jerry.nix` - еще один конфиг Waybar от Jerry.
- `modules/home/waybar/waybar-nekodyke.nix` - альтернативный кастомный Waybar.
- `modules/home/waybar/waybar-simple.nix` - упрощенный конфиг Waybar.
- `modules/home/waybar/waybar-tony.nix` - альтернативный конфиг Waybar от Tony.

## Архивные/backup файлы, не участвующие в сборке

- `hosts/rockon/default.nix.bak`: содержит старые `programs.throne.enable = true` (GUI-менеджер прокси) и `programs.throne.tunMode.setuid = true` (разрешение его TUN-режима с повышенными правами)
- `modules/core/packages.nix.orig`: старая ветка с `programs.hyprland.enable = true` (Hyprland как активный compositor), `programs.hyprlock.enable = true` (Hyprlock как lockscreen), `adb.enable = true` (включенный Android Debug Bridge)
- `modules/core/user.nix.bak`, `modules/core/user.nix.bak2`, `flake.nix.bak`: есть в репо, но не используются текущей сборкой, то есть это просто резервные копии

## Короткий вывод

- Сейчас реально активный desktop path у тебя: `Niri + Noctalia + SDDM + Zsh + NVF + VSCode + Ghostty/Kitty`.
- Hyprland, Fish, Waybar, SwayNC, DMS, Doom Emacs, Evil Helix и Quickshell у тебя не удалены из репо, но в текущую сборку `rockon` не подключены.
- Самые большие выключенные feature-флаги: `flutterdev`, `syncthing`, `communication`, `extra browsers`, `productivity`, `ai code editors`, `NFS`, `printing`.
