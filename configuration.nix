{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware.nix ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  time.timeZone = "Europe/Bucharest";

  networking = {
    hostName = "vision";
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };
    extraHosts = ''
      127.0.0.1 local.cosmoz.com
    '';
  };

  services.upower.enable = true;
  programs.dconf.enable = true;
  security.pam.services.swaylock = { };
  services.dbus.packages = [ pkgs.gcr ];

  fonts = {
    fontconfig.defaultFonts. monospace = [ "DejaVuSansMono Nerd Font" ];
    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) dejavu_fonts noto-fonts-emoji ];
  };

  hardware.sane.enable = true;

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
      "adbusers"
    ];
  };

  programs.evolution.enable = true;

  services.openvpn.servers = {
    plumelo = {
      config = "config /home/iulian/.config/plumelo.ovpn";
      autoStart = false;
      updateResolvConf = true;
    };
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  programs.adb.enable = true;

}
