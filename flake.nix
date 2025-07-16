{
  description = "NixOS Configuration for Running Various Hosts";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
  }

  outputs = inputs: let
    # Helper function: given a nixpkgs input and system, get pkgs set
    pkgsFor = nixpkgsInput: system:
      import nixpkgsInput {
        inherit system;
        config.allowUnfree = true;
      };
    
    # Helper function: dynamically load a host configuration
    loadHost = host:
      let
        hostFlake = import ./hosts/${host}/flake.nix;
        # system is defined in the host's flake.nix
        system = hostFlake.config.system;
        # Setup pkgs, Unstable is default, Stable is a fallback
        pkgsStable = pkgsFor inputs.nixpkgs-stable system;
        pkgs = pkgsFor inputs.nixpkgs-unstable system;
      in 
      inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        # Gather all modules from the host's flake.nix
        modules = [ ./modules/base.nix ] ++ hostFlake.modules;
        specialArgs = { pkgsStable pkgs; };
      };
  in
  {
    nixosConfigurations = {
      operari = loadHost "operari";
    }
  }
}
