# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./hyprland.nix
      ./pipewire.nix
      ./bluetooth.nix
      ./twingate.nix
      ./docker.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.thermald.enable = true; # Manage Intel CPU Heat
  services.tlp.enable = true; # Manage Power Settings
  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "zen"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rmoses = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
     ];
   };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     kitty
     stow
     blueman
     vscode
     matugen
     wallust
     spotify-player
     playerctl
     spotify
     jq
     zsh
     dbeaver-bin
     brave
     devbox
     direnv
     clickup
   ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  
  programs.firefox.enable = true;
  programs.zsh.enable = true;
 
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];
  security.pam.services.hyprlock = {};

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  
  system.stateVersion = "25.05"; # Did you read the comment?

}

