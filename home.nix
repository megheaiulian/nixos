{ pkgs, ... }: {
  imports = [ ./firefox.nix ];
  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    keepassxc
    nomachine-client
    parsec-client
    element-desktop
    slack
    remmina
    xdg_utils
    openmw
    gh
    libnotify
    tor-browser-bundle-bin
    freetube
    moonlight-qt
  ];

  programs.chromium.enable = true;
  programs.brave.enable = true;
  services.syncthing.enable = true;

  # bash
  programs.bash.historyFile = "/sync/history/.bash_history";
  programs.bash.initExtra = ''
    mend() {
      nix run nixpkgs#patchelf -- \
        --set-interpreter $(nix eval --raw 'nixpkgs#glibc')/lib64/ld-linux-x86-64.so.2 \
        --set-rpath $(nix eval --raw 'nixpkgs#gcc.cc.lib')/lib \
        $@
    }
  '';
  programs.starship.enable = true;
  programs.direnv.enable = true;

  # git
  programs.git = {
    enable = true;
    userName = "Meghea Iulian";
    userEmail = "iulian.meghea@gmail.com";
    signing = {
      key = "9FA665644E968CF6";
      signByDefault = true;
      gpgPath = "gpg";
    };
  };
  # gpg
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "gnome3";
  programs.gpg.enable = true;

  #broot
  programs.broot.enable = true;
  programs.broot.verbs = [
    {
      invocation = "p";
      execution = ":parent";
    }
    {
      invocation = "edit";
      shortcut = "e";
      execution = "$EDITOR +{line} {file}";
      leave_broot = false;
    }
    {
      invocation = "create {subpath}";
      execution = "$EDITOR {directory}/{subpath}";
    }
    {
      invocation = "view";
      execution = "less {file}";
    }
  ];

  # battery
  programs.i3status-rust.bars.bottom.blocks = pkgs.lib.mkBefore [{
    block = "battery";
    device = "BAT1";
    format = "{percentage} {time}";
  }];

  gtk.font.name = "DejaVu Sans";
  gtk.iconTheme = pkgs.lib.mkForce {
    name="Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
  };

  qt.enable = true;
  qt.platformTheme = "gnome";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

}
