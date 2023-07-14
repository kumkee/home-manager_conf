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
    # system tools
    openssh
    unzip
    # Development
    nodejs_20
    python3
    dotnet-sdk_7
    # nix language tools
    nil
    alejandra
    # node packages
    nodePackages.http-server
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
    initExtra = ''
      source $HOME/.config/completion/dotnet.sh
    '';
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = ["git" "vi-mode" "systemd" "sudo"];
    };
  };

  programs.git = {
    enable = true;
    userName = "Jinjun Liang";
    userEmail = "kumkee@users.noreply.github.com";
    extraConfig = {
      init = {defaultBranch = "main";};
      pull = {
        rebase = false;
        ff = false;
      };
      push = {default = "simple";};
      fetch = {prune = true;};
      diff = {colorMoved = "zebra";};
    };
    aliases = {
      l = "log --graph --decorate --date=short --format='%C(bold blue)%h %C(bold green)%ad %C(auto)%d  %C(white)%s%C(reset)'";
      lg = "log --graph --decorate --oneline";
      pm = "push origin HEAD:main";
    };
  };
}
