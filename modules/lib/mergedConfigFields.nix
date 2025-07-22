{ lib }:

mergedConfig: {
  environment.systemPackages = mergedConfig.environment.systemPackages or [];
  fonts.packages = mergedConfig.fonts.packages or [];
}
