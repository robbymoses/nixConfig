{ config, pkgs, pkgsStable, lib, ... }:

{
  imports = [
    ../../modules/components/hyprland.nix
    ../../modules/components/bluetooth.nix
    ../../modules/components/pipewire.nix
    ../../modules/components/docker.nix
    ../../modules/terminalApps.nix
    ../../modules/guiApps.nix
    ./custom/module/duo_kb_udev.nix
  ];

  # Define the Hostname
  networking.hostName = "versatilis";

  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  terminalAppGroups.enabledGroups = [ "personal" ];
  guiApps.enabledGroups = [ "personal" ];

  # Custom scripts
  # environment.etc."udev/keyboard_attach.sh" = {
  #   source = ./custom/scripts/keyboard_attach.sh;
  #   mode = "0755";
  # };

  # environment.etc."udev/keyboard_detach.sh" = {
  #   source = ./custom/scripts/keyboard_detach.sh;
  #   mode = "0755";
  # };

  # # Custom udev rules for duo keyboard
  # services.udev.extraRules = ''
  #   ACTION=="remove", \
  #   SUBSYSTEM=="input", \
  #   ENV{NAME}=="Primax Electronics Ltd. ASUS Zenbook Duo Keyboard", \
  #   ENV{ID_USB_INTERFACE_NUM}=="00", \
  #   RUN+="/etc/udev/keyboard_attach.sh removed"

  #   ACTION=="add", \
  #   SUBSYSTEM=="input", \
  #   ENV{NAME}=="Primax Electronics Ltd. ASUS Zenbook Duo Keyboard", \
  #   ENV{ID_USB_INTERFACE_NUM}=="00", \
  #   RUN+="/etc/udev/keyboard_attach.sh added"
  # '';
}
