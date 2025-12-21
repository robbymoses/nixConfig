{config, pkgs, ... }:

{
  programs.dconf.enable = true;
  
  users.users.rmoses.extraGroups = [ "libvirtd" ];
  
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
  ];
  
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
      swtpm.enable = true;
      };
    };
  };
}