{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.homeDirectory = lib.mkDefault (
    if pkgs.stdenv.hostPlatform.isDarwin then
      "/Users/${config.home.username}"
    else
      "/home/${config.home.username}"
  );

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = lib.mkDefault "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages =
    with pkgs;
    [
      aspell
      autoconf
      automake
      bottom
      cargo-update
      cmake
      colordiff
      cookiecutter
      copier
      coreutils
      ctags
      direnv
      docker
      docker-buildx
      docker-compose
      editorconfig-core-c
      fd
      ffmpeg
      ffmpegthumbnailer
      findutils
      fzf
      gawk
      gh
      ghostscript
      git
      git-graph
      gnused
      gnutls
      harper
      imagemagick
      jq
      lazygit
      librsvg
      llvm
      lua
      lua-language-server
      gnumake
      mise
      neovim
      nixd
      nixfmt
      nkf
      pandoc
      poppler-utils
      prettier
      pstoedit
      pueue
      ripgrep
      rsync
      rtk
      ruff
      rustup
      sheldon
      ssh-copy-id
      starship
      stylua
      tdf
      tealdeer
      terminaltexteffects
      texlab
      texpresso
      tig
      tmux
      tree
      tree-sitter
      ty
      unar
      usage
      uv
      vim
      xz
      yazi
      zoxide
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      clang
      colima
      iproute2mac
      lima
      procps
    ]
    ++ lib.optionals stdev.hostPlatform.isLinux [
      gcc
    ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # Nord dircolors theme, pinned via the 'nord-dircolors' flake input.
    ".dircolors".source = "${inputs.nord-dircolors}/src/dir_colors";

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/yseki/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Create these directories on activation if they don't already exist.
  # Home Manager only creates parent directories for files it manages, so
  # otherwise-empty directories need to be made explicitly.
  home.activation.createUserDirs =
    let
      dirs = [
        "Study"
        ".local/bin"
        ".local/include"
        ".local/lib"
        ".local/share"
        ".local/src"
      ];
    in
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p $VERBOSE_ARG ${
        lib.concatMapStringsSep " " (d: ''"${config.home.homeDirectory}/${d}"'') dirs
      }
    '';

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
