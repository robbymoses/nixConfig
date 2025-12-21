{ pkgs, ... }:
{
  imports = [
    ./ada-lovelace.nix
  ];

  # Enable NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  
  
  hardware.nvidia = {
    # Enable modesetting for Wayland compatibility
    modesetting.enable = true;
    
    # Enable power management
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    
    # Enable PRIME for hybrid graphics offload
    prime = {
      # Use PRIME offload mode - Intel by default, NVIDIA on demand
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      
      # GPU bus IDs
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
    
    # Enable nvidia-settings
    nvidiaSettings = true;
  };
  
  # Environment variables for proper GPU handling
  environment.variables = {
    # Default to Intel, allow NVIDIA offload when needed
    DRI_PRIME = "0";  # Use Intel by default
  };
  
  # Useful packages for GPU management
  environment.systemPackages = with pkgs; [
    nvidia-vaapi-driver  # For hardware video acceleration
    vulkan-tools         # For Vulkan support testing
    mesa-demos             # For OpenGL info
    
    # Create wrapper scripts for explicit GPU usage
    (writeShellScriptBin "nvidia-run" ''
      __NV_PRIME_RENDER_OFFLOAD=1 __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only exec "$@"
    '')
    
    (writeShellScriptBin "intel-run" ''
      DRI_PRIME=0 exec "$@"
    '')
  ];
}
