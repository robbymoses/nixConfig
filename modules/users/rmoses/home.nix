{ pkgs, username, homeDir, ... }:

let
  runtimeDir = builtins.getEnv "XDG_RUNTIME_DIR";
in
{
  programs.home-manager.enable = true;
  #programs.zsh.enable = false;

  home.packages = with pkgs; [
    home-manager
  ];

  services.ssh-agent.enable = true;

  home = {
    sessionVariables = {
      EDITOR = "nvim";
      SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
      XDG_VALUE = runtimeDir;
      TEST = "VALUE!";
    };
  };

  home.stateVersion = "25.05";
}
