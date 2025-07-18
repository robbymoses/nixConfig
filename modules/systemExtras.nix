{ pkgs, lib, config, ... }:

let
  applyTaggedConfigs = import ./lib/applyTaggedConfigs.nix { inherit lib; };

  taggedConfigs = [
    {
      tags = [ "core" ];
      config = {
        environment.systemPackages = with pkgs; [ git ];
      };
    }
    {
      tags = [ "fonts" ];
      config = {
        fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
      };
    }
  ];

  # Final merged config from entries matching the enabled tags
  mergedConfig = applyTaggedConfigs {
    name = "systemExtras";
    entries = taggedConfigs;
    enabledTags = lib.unique ([ "core" ] ++ config.systemExtras.enabledTags);
  };
  
in {
  options.systemExtras.enabledTags = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = ''
      Tags to enable for systemExtras. "core" is always included.
    '';
  };

  config = mergedConfig;
}
