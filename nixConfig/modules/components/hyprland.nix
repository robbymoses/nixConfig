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
  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprlock
    hyprpanel 
    rofi-wayland
    bibata-cursors
  ];
  
  security.pam.services.hyprlock = {};

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
