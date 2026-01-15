{
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];
  features = [ "hyprland" "noctalia" ];
}