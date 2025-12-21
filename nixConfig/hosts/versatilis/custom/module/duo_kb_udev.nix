{ config, pkgs, lib, ... }:

let
  keyboardHandler = pkgs.runCommand "keyboard-udev-handler" { } ''
    mkdir -p $out/bin
    install -Dm755 ${../scripts/keyboard_handler.sh} $out/bin/keyboard_handler.sh
  '';
in {
  services.udev.extraRules = ''
    ACTION=="add|remove", \
    SUBSYSTEM=="input", \
    KERNEL=="event*", \
    ENV{ID_INPUT_KEYBOARD}=="1", \
    ENV{ID_MODEL}=="ASUS_Zenbook_Duo_Keyboard", \
    ENV{ID_USB_INTERFACE_NUM}=="00", \
    RUN+="/bin/sh -c '${keyboardHandler}/bin/keyboard_handler.sh'"
  '';
}