{ config, pkgs, lib, ... }:

{
  isNormalUser = true;
  description = "rmoses";
  home = "/home/rmoses";
  shell = pkgs.zsh;
  extraGroups = [ "wheel" "networkmanager"];
}