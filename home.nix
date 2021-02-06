{ pkgs, ... }: {
  home.packages = with pkgs; [
    (tor-browser-bundle-bin.override { pulseaudioSupport = true; })
    keepassxc
    kak
    nomachine-client
    parsec-client
    element-desktop
    slack
    remmina
    xdg_utils
    calibre
    openmw
  ];

  programs.chromium.enable = true;
  programs.firefox.enable = true;

  home.sessionVariables = rec {
    VISUAL = "kak";
    EDITOR = VISUAL;
  };

  services.syncthing.enable = true;

  # bash
  programs.bash.historyFile = "/sync/history/.bash_history";
  programs.starship.enable = true;

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

}
