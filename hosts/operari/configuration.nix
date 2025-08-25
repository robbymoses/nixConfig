{ config, pkgs, pkgsStable, lib, ... }:

{
  imports = [
    ../../modules/components/twingate.nix
    ../../modules/hyprlandSuite.nix
    ../../modules/components/pipewire.nix
    ../../modules/components/docker.nix
    ../../modules/components/bluetooth.nix
    ../../modules/terminalApps.nix
    ../../modules/guiApps.nix
    ../../modules/systemExtras.nix
  ];

  # Define the Hostname
  networking.hostName = "operari";

  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.graphics.enable = true;
  hardware.nvidia= {
    modesetting.enable = true;  
    open = true;
  
    powerManagement.enable = true;
  };
  terminalAppGroups.enabledGroups = [ "work" ];
  guiApps.enabledGroups = [ "work" ];
  systemExtras.enabledTags = [ "fonts" "dotfiles" ];
}
