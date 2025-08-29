{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hybrid-graphics;
in {
  options.services.hybrid-graphics = {
    enable = mkEnableOption "hybrid graphics power management";
    
    intelBusId = mkOption {
      type = types.str;
      description = "PCI bus ID of Intel GPU";
    };
    
    nvidiaBusId = mkOption {
      type = types.str;
      description = "PCI bus ID of NVIDIA GPU";
    };
    
    powerSupplyPath = mkOption {
      type = types.str;
      default = "/sys/class/power_supply/AC/online";
      description = "Path to AC power supply status file";
    };
  };

  config = mkIf cfg.enable {
    # Create power monitoring service
    systemd.services.hybrid-graphics-monitor = {
      description = "Hybrid Graphics Power Monitor";
      wantedBy = [ "multi-user.target" ];
      after = [ "graphical-session.target" ];
      
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 5;
        User = "root";
      };
      
      script = ''
        #!/bin/bash
        
        POWER_SUPPLY="${cfg.powerSupplyPath}"
        NVIDIA_DEVICE="/sys/bus/pci/devices/0000:01:00.0"
        
        previous_state=""
        
        log_message() {
          echo "$(date): $1" >> /var/log/hybrid-graphics.log
        }
        
        switch_to_dgpu() {
          log_message "Switching to dGPU (plugged in)"
          echo on > "$NVIDIA_DEVICE/power/control" 2>/dev/null || true
          # Optionally restart display manager for immediate effect
          # systemctl restart display-manager
        }
        
        switch_to_igpu() {
          log_message "Switching to iGPU (unplugged)"
          echo auto > "$NVIDIA_DEVICE/power/control" 2>/dev/null || true
        }
        
        while true; do
          if [[ -f "$POWER_SUPPLY" ]]; then
            current_state=$(cat "$POWER_SUPPLY" 2>/dev/null || echo "0")
            
            if [[ "$current_state" != "$previous_state" ]]; then
              case "$current_state" in
                "1")
                  switch_to_dgpu
                  ;;
                "0")
                  switch_to_igpu
                  ;;
              esac
              previous_state="$current_state"
            fi
          fi
          
          sleep 2
        done
      '';
    };
    
    # Udev rules for immediate switching
    services.udev.extraRules = ''
      # AC adapter plugged in
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="hybrid-graphics-dgpu.service"
      
      # AC adapter unplugged
      SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", TAG+="systemd", ENV{SYSTEMD_WANTS}+="hybrid-graphics-igpu.service"
    '';
    
    # One-shot services for GPU switching
    systemd.services.hybrid-graphics-dgpu = {
      description = "Switch to dGPU";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
      };
      script = ''
        echo on > /sys/bus/pci/devices/0000:01:00.0/power/control 2>/dev/null || true
        echo "$(date): Switched to dGPU" >> /var/log/hybrid-graphics.log
      '';
    };
    
    systemd.services.hybrid-graphics-igpu = {
      description = "Switch to iGPU";  
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = false;
      };
      script = ''
        echo auto > /sys/bus/pci/devices/0000:01:00.0/power/control 2>/dev/null || true
        echo "$(date): Switched to iGPU" >> /var/log/hybrid-graphics.log
      '';
    };
    
    # Create log file
    systemd.tmpfiles.rules = [
      "f /var/log/hybrid-graphics.log 0644 root root -"
    ];
  };
}