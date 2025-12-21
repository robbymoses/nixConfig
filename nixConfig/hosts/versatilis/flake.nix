{
  system = "x86_64-linux";
  modules = [
    ./hardware/cpu.nix
    ./configuration.nix
    ./hardware-configuration.nix
  ];
  
  username = "rmoses";

  features = [ "hyprland" "home-manager" ];
}