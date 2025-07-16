{ lib, config, groupsToAdd, user ? config.users.defaultUser }:

let
  existingGroups = config.users.users.${user}.extraGroups or [];
in
lib.mkForce (lib.uniqueList (existingGroups ++ groupsToAdd))

# USAGE EXAMPLES:
# Use the config.defaultUser
# users.users.${config.users.defaultUser}.extraGroups = appendUserGroups { 
# groupsToAdd = [ "NEW_GROUP" ];
# };

# Use a Specific User:
# users.users."USER_NAME".extraGroups = appendUserGroups {
#   user = "USER_NAME";
#   groupsToAdd = [ "NEW_GROUP" ];
# };