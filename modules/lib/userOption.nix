{ lib }:

{
  options.users.defaultUser = lib.mkOption {
    type = lib.types.str;
    default = "defaultUser"; 
    description = "Default username for modules to reference";
  };
}