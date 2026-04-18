{
  config,
  ...
}:
{
  imports = [
    ./zshrc-personal.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    dotDir = config.home.homeDirectory;
    syntaxHighlighting = {
      enable = true;
      highlighters = [
        "main"
        "brackets"
        "pattern"
        "regexp"
        "root"
        "line"
      ];
    };
    historySubstringSearch.enable = true;

    history = {
      ignoreDups = true;
      save = 10000;
      size = 10000;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "extract"
        "colored-man-pages"
      ];
    };

    initContent = ''
      setopt AUTO_CD
      setopt APPEND_HISTORY
      setopt COMPLETE_IN_WORD
      setopt EXTENDED_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_FIND_NO_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_VERIFY
      setopt INTERACTIVE_COMMENTS
      unsetopt BEEP
      unsetopt FLOW_CONTROL

      export KEYTIMEOUT=1
      export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

      mkdir -p "$HOME/.cache/zsh"
      zmodload zsh/complist

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Z}' \
        'r:|[._-]=* r:|=*' \
        'l:|=* r:|=*'
      if (( ''${+LS_COLORS} )); then
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      fi
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"
      zstyle ':completion:*:descriptions' format '[%d]'
      zstyle ':completion:*' rehash true
      zstyle ':completion:*' squeeze-slashes true

      autoload -Uz edit-command-line
      zle -N edit-command-line

      take() {
        [[ -n "$1" ]] || return 1
        mkdir -p -- "$1" && cd -- "$1"
      }

      bindkey "\eh" backward-word
      bindkey "\ej" down-line-or-history
      bindkey "\ek" up-line-or-history
      bindkey "\el" forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^X^E' edit-command-line

      if [ -f $HOME/.zshrc-personal ]; then
        source $HOME/.zshrc-personal
      fi

      # Launch fastfetch on first terminal spawn
      if [[ -z "$FASTFETCH_LAUNCHED" ]]; then
        export FASTFETCH_LAUNCHED=1
        fastfetch
      fi
    '';

    shellAliases = {
      sv = "sudo nvim";
      v = "nvim";
      c = "clear";
      fr = "dcli rebuild";
      fu = "dcli update";
      rebuild = "dcli rebuild";
      update = "dcli update";
      cleanup = "dcli cleanup";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      cat = "bat";
      man = "batman";
      hosts = "dcli list-hosts";
      switch = "dcli switch-host";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      reload = "exec zsh";
    };
  };
}
