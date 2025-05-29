{ config, pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };    
  };

  environment.systemPackages = with pkgs; [
    #docker-compose
    lazydocker
  ];
}
