{ config, pkgs, lib, ... }:

{
  isNormalUser = true;
  description = "rmoses";
  home = "/home/rmoses";
  shell = pkgs.nushell;
  extraGroups = [ "wheel" "networkmanager"];
}
