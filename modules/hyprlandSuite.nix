{ hyprlandInput, config, pkgs, ... }:

{
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs.hyprland = {
    enable = true;
    package = hyprlandInput.packages.${pkgs.system}.hyprland;
    withUWSM = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
  boot.kernelParams = [
    "quiet"
    "loglevel=0"
    "systemd.show_status=false"
    "udev.log_priority=3"
  ]; 

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprlock
    hyprpanel 
    rofi-wayland
    xdg-desktop-portal
    ags
    # Break Out into desktopUtils.nix (most are hyprpanel reqs)
    bibata-cursors
    wl-clipboard
    brightnessctl
    libgtop
  ];

  services.upower.enable = true;
  
  security.pam.services.hyprlock = {};

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
