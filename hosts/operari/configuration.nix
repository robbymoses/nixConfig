{ config, pkgs, pkgsStable, lib, ... }:

{
  imports = [
    ../../modules/components/twingate.nix
    ../../modules/components/hyprland.nix
    ../../modules/components/pipewire.nix
    ../../modules/components/docker.nix
    ../../modules/terminalApps.nix
    ../../modules/guiApps.nix
  ];

  # Define the Hostname
  networking.hostName = "operari";

  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  terminalAppGroups.enabledGroups = [ "work" ];
  guiApps.enabledGroups = [ "work" ];
}