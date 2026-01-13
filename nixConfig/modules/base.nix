{ config, pkgs, pkgsStable, lib, ... }:

let
  userOption = import ./lib/userOption.nix { inherit lib; };
  appendUserGroups = import ./lib/appendUserToGroup.nix { inherit lib config; };
in
{
  imports = [
    ../modules/users/defaultUser.nix
  ];

  options = userOption.options;

  config = {
    environment.systemPackages = with pkgs; [
      # Programming
      git
      nodejs_24
      python312
      pre-commit

      # Editors (I am indecisive)
      helix
      vim

      # Networking
      curl
      wget

      # Terminal
      nushell
      jq
      ripgrep
      fd
      fzf
      tree
      htop
      zellij
    ];
    
    system.stateVersion = "25.05";
    hardware.enableRedistributableFirmware = true;

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;


    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.UTF-8";

    users.defaultUser = "rmoses";
    programs.zsh.enable = true;

    networking.networkmanager.enable = true;
  };
}
