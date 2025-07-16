{ config, pkgs, lib, ... }:

let
  defaultUser = config.users.defaultUser;
in
{
  config.users.users.${defaultUser} = {
    isNormalUser = true;
    description = "Me, Myself, and I";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}