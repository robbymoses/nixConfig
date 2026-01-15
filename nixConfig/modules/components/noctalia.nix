{ pkgs, noctaliaInput, ... }:
{
  # install package
  environment.systemPackages = with pkgs; [
    noctaliaInput.packages.${pkgs.system}.default
  ];

  # Recommended Settings
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
