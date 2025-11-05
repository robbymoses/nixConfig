{ config, pkgs, pkgsStable, lib, ... }:

{
  imports = [
    ./gpu
    ../../modules/common-hardware/pc/laptop
    ../../modules/components/twingate.nix
    ../../modules/hyprlandSuite.nix
    ../../modules/components/pipewire.nix
    ../../modules/components/docker.nix
    ../../modules/components/bluetooth.nix
    ../../modules/terminalApps.nix
    ../../modules/guiApps.nix
    ../../modules/systemExtras.nix
    ../../modules/vm.nix
  ];

  # Define the Hostname
  networking.hostName = "operari";
  services.flatpak.enable = true;
  programs.ssh.startAgent = true;
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  # Bootloader Configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  terminalAppGroups.enabledGroups = [ "work" ];
  guiApps.enabledGroups = [ "work" ];
  systemExtras.enabledTags = [ "fonts" "dotfiles" ];
}
