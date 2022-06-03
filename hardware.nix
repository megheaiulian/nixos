{ config, pkgs, lib, ... }:

{
  hardware.enableRedistributableFirmware = true;

  #kernel
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "hid-logitech-hidpp" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # efi
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # fs
  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/6e270acd-8ca8-42cb-9bc7-071a4f7ebac5";
    preLVM = true;
    allowDiscards = true;
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/386dccf4-94c9-4ef0-8e00-60e5c102d379";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8D31-DE99";
    fsType = "vfat";
  };
  swapDevices = [{ device = "/dev/disk/by-uuid/c02deae1-eeee-47cc-814f-e2394b1e0efd"; }];
  services.fstrim.enable = true;

  # resume
  boot.resumeDevice = "/dev/disk/by-label/swap";

  # zram
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = 6;
  };

  # video
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau ];

  # audio
  hardware.pulseaudio.enable = true;

  # misc
  nix.settings.max-jobs = 16;

}
