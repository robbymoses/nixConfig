{ config, pkgs, pkgsStable, lib, ... }:

let
  userOption = import ../lib/userOption.nix { inherit lib; };
  appendUserGroups = import ../lib/appendUserGroups.nix { inherit lib config; };
in
{
  imports = [
    ../modules/users/defaultUser.nix
  ];

  options = userOption.options;

  config = {

    system.stateVersion = "25.05";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.UTF-8";

    users.defaultUser = "me";

    networking.networkmanager.enable = true;
    users.users.${config.users.defaultUser}.extraGroups = appendUserGroups [ "networkmanager" ];

    services.openssh.enable = true;
  };
}