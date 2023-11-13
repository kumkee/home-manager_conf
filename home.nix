{
  # config,
  pkgs,
  ...
}: {
  targets.genericLinux.enable = true;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "liang";
  home.homeDirectory = "/home/liang";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # system tools -----------------------
    openssh
    unzip
    ripgrep # telescope needed this
    bash-completion # needed for systemctl
    dos2unix
    shadowsocks-libev
    proxychains-ng
    cloudflared
    # Development ------------------------
    gcc
    nodejs_20
    python3
    dotnet-sdk
    azure-functions-core-tools
    mitmproxy
    ## jre_minimal # for ltex_ls
    # nix language tools -----------------
    nil # lsp
    alejandra # formatter
    # node packages ----------------------
    nodePackages.http-server
    nodePackages.typescript
    nodePackages.ts-node
    elmPackages.elm
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".profile".source = ./profile;
    # For global npm packages installation
    ".npmrc".text = ''
      prefix = ''${HOME}/.npm-packages
    '';
    ".editorconfig".source = ./configs/editorconfig.ini;
    ".config/nvim/ftplugin".source = ../nvim_custom/configs/ftplugin;
    ".config/nvim/lua/custom".source = ../nvim_custom;
    ".ssh/authorized_keys".source = ../ssh/authorized_keys;
    ".ssh/config".source = ../ssh/config; # linking .ssh/ has no write permission
    ".stylua.toml".source = ../nvim_custom/configs/stylua.toml;
    ".vale.ini".source = ./configs/vale.ini;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/liang/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    # For global npm packages installation
    NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
    PROXYCHAINS_CONF_FILE = "$HOME/.config/home-manager/configs/proxychains.conf";
    WINHOME = "/mnt/c/Users/273/";
    DOTNET_ROOT = "${pkgs.dotnet-sdk}";
  };

  # For global npm packages installation
  home.sessionPath = [
    "$HOME/.npm-packages/bin"
    "$HOME/.local/share/nvim/mason/bin"
  ];

  home.shellAliases = {
    "ss-nep" = "ss-local -v -c ~/.config/secrets/ss-neptune.json";
    "ss-earth" = "ss-local -v -c ~/.config/secrets/ss-earth.json";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = ["git" "vi-mode" "systemd" "sudo"];
    };
    initExtra = ''
      source $HOME/.config/completion/dotnet.sh
      source $HOME/.config/completion/elm-sh-completion/elm-completion.sh
    '';
  };

  programs.git = {
    enable = true;
    userName = "Jinjun Liang";
    userEmail = "kumkee@users.noreply.github.com";
    extraConfig = {
      init = {defaultBranch = "main";};
      pull = {
        rebase = false;
        ff = true;
      };
      push = {default = "simple";};
      fetch = {prune = true;};
      diff = {colorMoved = "zebra";};
      "url \"ssh://git@github.com/\"" = {insteadOf = "https://github.com/";};
    };
    aliases = {
      l =
        "log --graph --decorate --date=short --format="
        + "'%C(bold blue)%h %C(bold green)%ad %C(auto)%d  %C(white)%s%C(reset)'";
      lg = "log --graph --decorate --oneline";
      pm = "push origin HEAD:main";
    };
  };

  programs.tmux = {
    enable = true;
    escapeTime = 10;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "screen-256color";
    tmuxinator.enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      fpp
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
    ];
    extraConfig = ''
      # navigate between panes
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      # resize the pane
      bind-key -r J resize-pane -D 5
      bind-key -r K resize-pane -U 5
      bind-key -r H resize-pane -L 5
      bind-key -r L resize-pane -R 5
      # clear-history
      bind-key C-l send-keys C-l 'tmux clear-history' Enter
    '';
  };
}
