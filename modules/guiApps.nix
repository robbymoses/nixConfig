{ pkgs, pkgsStable, config, lib, ... }:

let
  guiAppGroups = {
    # Core GUI applications, always included when importing
    core = (with pkgs; [ 
      firefox
      obsidian 
      spotify
      vscode
      code-cursor
      catppuccin-cursors.mochaSapphire
      kitty
      dbeaver-bin
      discord
      alacritty
      ghostty
      xterm
      chromium
    ]) ++ (with pkgsStable; [
      # Back up option for stable packages
    ]);

    # Work specific applications
    work = (with pkgs; [  

    ]) ++ (with pkgsStable; [
      # Back up option for stable packages
    ]);

    # Personal applications
    personal = (with pkgs; [ 
      clickup  
    ]) ++ (with pkgsStable; [
      # Back up option for stable packages
    ]);
  };

  selectedGroups = config.guiApps.enabledGroups or [];
  allGroups = lib.unique ([ "core" ] ++ selectedGroups);
  apps = lib.flatten (map (g: guiAppGroups.${g} or []) allGroups);
in
{
  options.guiApps.enabledGroups = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = ''
      List of GUI application groups to install in addition to "core",
      which is always enabled by default.
    '';
  };

  config.environment.systemPackages = apps;
}
# USAGE:
# imports = [ ../components/gui-apps.nix ];
# guiApps.enabledGroups = [ "work" "personal" ];
