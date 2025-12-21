{ config, lib, pkgs, ... }:

{
  # Enable Intel iGPU support for Meteor Lake (Ultra 9 185H)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    
    extraPackages = with pkgs; [
      intel-media-driver # Modern VAAPI driver for hardware acceleration
      intel-vaapi-driver # Legacy VAAPI driver (fallback)
      libvdpau-va-gl     # VDPAU driver
      intel-compute-runtime # OpenCL support
    ];
    
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };
  
  # Kernel parameters for Intel Meteor Lake
  boot.kernelParams = [
    "i915.force_probe=7d55" # Meteor Lake GT2 device ID
    "i915.enable_guc=3"     # Enable GuC firmware loading
    "i915.enable_psr=1"     # Panel Self Refresh
  ];

  # Enable early KMS for smooth boot
  boot.initrd.kernelModules = [ "i915" ];
  
  # Environment variables for hardware acceleration (Wayland/Hyprland optimized)
  environment.variables = {
    VDPAU_DRIVER = "va_gl";
    LIBVA_DRIVER_NAME = "iHD";
    # Wayland-specific variables
    WLR_NO_HARDWARE_CURSORS = "1";  # Fixes cursor issues on Intel iGPU
    WLR_RENDERER = "vulkan";        # Use Vulkan renderer for better performance
  };
}