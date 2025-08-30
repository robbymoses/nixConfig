{ config, lib, pkgs, ... }:
{
  
  imports = [
    ./gpu.nix
  ];

  # Intel CPU configuration for Ultra 9 185H (Meteor Lake)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # Power management and thermal configuration
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  
  # Enable Intel P-State scaling driver for better power management
  boot.kernelParams = [
    "intel_pstate=active"
  ];

  # Additional packages for Intel CPU monitoring and management
  environment.systemPackages = with pkgs; [
    intel-gpu-tools  # Intel GPU debugging and monitoring tools
    powertop        # Power consumption analyzer
    util-linux      # Includes turbostat for Intel CPU frequency and idle statistics
  ];
}