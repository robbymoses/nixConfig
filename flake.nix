{
  description = "NixOS Configuration for Running Various Hosts";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, ... }@inputs: 
    let
      # Helper function: given a nixpkgs input and system, get pkgs set
      pkgsFor = nixpkgsInput: system:
        import nixpkgsInput {
          inherit system;
          config.allowUnfree = true;
        };
    
      lib = inputs.nixpkgs-unstable.lib;
      
      # Helper function: dynamically load a host configuration
      loadHost = host:
        let
          hostFlake = import ./hosts/${host}/flake.nix;
          
          # system is defined in the host's flake.nix
          system = hostFlake.system;
          
          # Setup pkgs, Unstable is default, Stable is a fallback
          pkgsStable = pkgsFor inputs.nixpkgs-stable system;
          pkgsUnstable = pkgsFor inputs.nixpkgs system;
       
          # Map feature names to inputs attribute sets
          featureInputs = {
            hyprland = inputs.hyprland;
          };

          extraArgsBase =[ 
           { inherit pkgsStable; }
          ];
        
          extraArgsFeatures = builtins.map (feature:
            if builtins.hasAttr feature featureInputs
              then { "${feature}Input" = featureInputs.${feature}; }
              else {} ) (hostFlake.features or []);
          
          extraArgsFinal = builtins.foldl' lib.recursiveUpdate {} (extraArgsBase ++ extraArgsFeatures);
        in
          inputs.nixpkgs-unstable.lib.nixosSystem {
            inherit system;
            # Gather all modules from the host's flake.nix
            modules = [ ./modules/base.nix ] ++ hostFlake.modules;
            specialArgs = extraArgsFinal;
          };
      in {
        nixosConfigurations = {
        operari = loadHost "operari";
        versatilis = loadHost "versatilis";
       };
   }; 
} 
