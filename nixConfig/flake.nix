{
  description = "NixOS Configuration for Running Various Hosts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: 
    let
      # Helper function: given a nixpkgs input and system, get pkgs set
      pkgsFor = nixpkgsInput: system:
        import nixpkgsInput {
          inherit system;
          config.allowUnfree = true;
        };
    
      lib = inputs.nixpkgs.lib;
      
      # Helper function: dynamically load a host configuration
      loadHost = host:
        let
          hostFlake = import ./hosts/${host}/flake.nix;
          homeManagerConfig = import ./modules/users/${hostFlake.username}/home.nix {
            inherit pkgs;
            username = "${hostFlake.username}";
            homeDir = "/home/${hostFlake.username}";
          };
          
          # system is defined in the host's flake.nix
          system = hostFlake.system;
          
          # Setup pkgs, Unstable is default, Stable is a fallback
          pkgsStable = pkgsFor inputs.nixpkgs-stable system;
          pkgs = pkgsFor inputs.nixpkgs system;
       
          # Map feature names to inputs attribute sets
          featureInputs = {
            hyprland = inputs.hyprland;
            home-manager = inputs.home-manager;
          };

          extraArgsBase =[ 
           { inherit pkgsStable; }
          ];
        
          extraArgsFeatures = builtins.map (feature:
            if builtins.hasAttr feature featureInputs
              then { "${feature}Input" = featureInputs.${feature}; }
              else {} ) (hostFlake.features or []);
          
          extraArgsFinal = builtins.foldl' lib.recursiveUpdate {} (extraArgsBase ++ extraArgsFeatures);

          baseModules = [ ./modules/base.nix ] ++ hostFlake.modules;

          # Combine base modules with host-specific modules
          homeManagerModules =
            if lib.elem "home-manager" (hostFlake.features or [])
              then [
                inputs.home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.${hostFlake.username} = homeManagerConfig;
                  }
              ] else [];

          finalModules = baseModules ++ homeManagerModules;
        in
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            # Gather all modules from the host's flake.nix
            modules = finalModules;
            specialArgs = extraArgsFinal;
          };
      in {
        nixosConfigurations = {
        operari = loadHost "operari";
        versatilis = loadHost "versatilis";
       };
   }; 
} 
