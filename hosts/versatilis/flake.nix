{
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
  
  username = "rmoses";

  features = [ "hyprland" "home-manager" ];
}