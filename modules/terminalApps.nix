{ pkgs, pkgsStable, config, lib, ... }:

let
  terminalAppGroups = {
    # Core terminal applications, always included when importing
    core = (with pkgs; [ 
      vim
      usbutils
      jq
      fzf
      fd
      ripgrep
      neovim
      git
      bc
      zellij
      claude-code
      tree
      helix
      zoxide
    ]) ++ (with pkgsStable; [
      # Back up option for stable packages
    ]);

    # Work specific applications
    work = (with pkgs; [  
      google-cloud-sdk
    ]) ++ (with pkgsStable; [
      # Back up option for stable packages
    ]);

    # Personal applications
    personal = (with pkgs; [ 
      
    ]) ++ (with pkgsStable; [
      # Back up option for stable packages
    ]);
  };

  selectedGroups = config.terminalAppGroups.enabledGroups or [];
  allGroups = lib.unique ([ "core" ] ++ selectedGroups);
  apps = lib.flatten (map (g: terminalAppGroups.${g} or []) allGroups);
in
{
  options.terminalAppGroups.enabledGroups = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = ''
      List of terminal application groups to install in addition to "core",
      which is always enabled by default.
    '';
  };

  config.environment.systemPackages = apps;
}
# USAGE:
# imports = [ ../components/terminal-apps.nix ];
# terminalApps.enabledGroups = [ "work" "personal" ];
