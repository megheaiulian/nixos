{ config, pkgs, lib, ... }:
{
  imports = [ ./hardware.nix ./wg.nix ];

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
  services.dbus.packages = [ pkgs.gcr ];

  programs.sway.enable = true;
  programs.sway.wrapperFeatures.gtk = true;
  programs.sway.extraPackages = [ ];
  services.logind.lidSwitch = "hibernate";

  fonts = {
    fontconfig.defaultFonts.monospace = [ "DejaVuSansMono Nerd Font" ];
    fonts = with pkgs; [ (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; }) dejavu_fonts noto-fonts-emoji ];
  };

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  hardware.sane.netConf = "192.168.4.111";
  services.printing.drivers = with pkgs; [ hplip ];


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
      "lxd"
    ];
    subUidRanges = [{ startUid = 100000; count = 65536; }];
    subGidRanges = [{ startGid = 100000; count = 65536; }];
  };

  programs.adb.enable = true;
  hardware.bluetooth.enable = true;

  # virtualisation.wine.enable = true;
  virtualisation.lxd.enable = true;
  virtualisation.lxc.lxcfs.enable = true;

  programs.geary.enable = true;
  services.gnome.evolution-data-server.enable = true;
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;
  environment.systemPackages = with pkgs; [ gnome.gnome-calendar ];
  system.stateVersion = "22.11";
}
