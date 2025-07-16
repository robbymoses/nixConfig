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
      #./tailscale.nix
      ./twingate.nix
      ./docker.nix
      ./flatpak.nix
    ];

  services.thermald.enable = true; # Manage Intel CPU Heat
  services.tlp.enable = true; # Manage Power Settings


  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     ngrok
     kitty
     stow
     blueman
     doctl
     kubernetes
     kubernetes-helm
     vscode
     matugen
     wallust
     spotify-player
     terraform
     zed-editor
     devpod-desktop
     neovim
     playerctl
     spotify
     jq
     zsh
     dbeaver-bin
     brave
     devbox
     direnv
     clickup
     windsurf
     code-cursor
     obsidian
     slack
     discord
     bibata-cursors
   ];

}

