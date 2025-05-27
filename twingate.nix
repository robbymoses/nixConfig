{ config, pkgs, ... }:
{
  services.twingate.enable = true;

  environment.systemPackages = with pkgs; [
    twingate
  ];
}
