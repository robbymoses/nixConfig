{ pkgs, lib, config, ... }:

let
  applyTaggedConfigs = import ./lib/applyTaggedConfigs.nix { inherit lib; };
  mergedConfigFields = import ./lib/mergedConfigFields.nix { inherit lib; };

  taggedConfigs = [
    {
      tags = [ "core" ];
      config = {
        environment.systemPackages = with pkgs; [ 
          git
          tlp 
        ];
        services.tlp.enable = true;
        services.thermald.enable = true;
      };
    }
    {
      tags = [ "dotfiles" ];
      config = {
       environment.systemPackages = with pkgs; [
        stow
       ];
      };
    }
    {
      tags = [ "fonts" ];
      config = {
        fonts.packages = with pkgs; [ 
          nerd-fonts.jetbrains-mono
	        nerd-fonts.martian-mono 
        ];
      };
    }
  ];

  userEnabledTags = config.systemExtras.enabledTags or [];
  
  # Final merged config from entries matching the enabled tags
  mergedConfig = applyTaggedConfigs {
    name = "systemExtras";
    entries = taggedConfigs;
    enabledTags = lib.unique ([ "core" ] ++ userEnabledTags);
  };
  
in {
  options.systemExtras.enabledTags = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = ''
      Tags to enable for systemExtras. "core" is always included.
    '';
  };

  config = mergedConfigFields mergedConfig;
}
