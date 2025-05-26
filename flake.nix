{
  description = "My Flake";
 
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.hyprland.url = "github:hyprwm/Hyprland";

  outputs = {nixpkgs, ... } @ inputs: {
    nixosConfigurations.zen = nixpkgs.lib.nixosSystem{
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [
        (import ./configuration.nix)
      ];
    };
  };
}
