{ config, pkgs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "Europe/Bucharest";

  networking.hostName = "vision";
  networking.networkmanager = {
    enable = true;
    dns = "dnsmasq";
  };

  services.upower.enable = true;

  programs.dconf.enable = true;
  security.pam.services.swaylock = { };
  services.dbus.packages = [ pkgs.gcr ];

  fonts.fontconfig.defaultFonts. monospace = [ "DejaVuSansMono Nerd Font" ];
  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) dejavu_fonts noto-fonts-emoji ];

  hardware.sane.enable = true;
  hardware.bluetooth.enable = true;

  users.users.iulian = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "disk"
      "audio"
      "video"
      "networkmanager"
      "systemd-journal"
      "scanner"
      "lp"
    ];
  };
}
