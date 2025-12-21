# NixOS Modular Configuration - Latin Themed Hosts

This repository provides a modular and scalable NixOS configuration for multiple machines, each named with a Latin theme:

- **operari**: Work PC
- **versatilis**: Personal laptop
- **domus**: Homelab server

## Directory Layout

```
nixConfig/
├── flake.nix                # Flake entrypoint, host loader, pkgs setup
├── flake.lock
├── README.md
├── hosts/                   # Per-host configs
│   ├── operari/
│   │   ├── configuration.nix
│   │   ├── flake.nix
│   │   └── hardware-configuration.nix
│   ├── versatilis/
│   │   ├── configuration.nix
│   │   ├── flake.nix
│   │   └── hardware-configuration.nix
│   ├── domus/
│   └── quies/
├── modules/                 # Shared modules
│   ├── base.nix
│   ├── commonServices.nix
│   ├── guiApps.nix
│   ├── terminalApps.nix
│   ├── systemExtras.nix
│   ├── components/          # Service and feature modules
│   │   ├── bluetooth.nix
│   │   ├── configuration.nix
│   │   ├── docker.nix
│   │   ├── flatpak.nix
│   │   ├── hyprland.nix
│   │   ├── pipewire.nix
│   │   ├── tailscale.nix
│   │   └── twingate.nix
│   ├── lib/                 # Helper functions
│   │   ├── appendUserToGroup.nix
│   │   ├── applyTaggedConfigs.nix
│   │   ├── conditionalImports.nix
│   │   ├── mergedConfigFields.nix
│   │   ├── optionHelper.nix
│   │   └── userOption.nix
│   └── users/
│       └── defaultUser.nix
```

## How It Works

- **Hosts**: Each host has its own folder under `hosts/` with a `flake.nix` and `configuration.nix`. These import shared modules and set host-specific options.
- **Modules**: Shared features, services, and package groups are defined in `modules/`. You can enable or disable features per host by setting options in the host config.
- **Tagging & Grouping**: Modules like `systemExtras.nix`, `guiApps.nix`, and `terminalApps.nix` use tags/groups to allow flexible selection of packages and features per host.
- **Lib Functions**: The `modules/lib/` directory contains helper functions for option handling, config merging, and conditional imports, making your config DRY and maintainable.

## Example: Enabling Features Per Host

In `hosts/operari/configuration.nix`:
```nix
imports = [
  ../../modules/components/twingate.nix
  ../../modules/components/hyprland.nix
  ../../modules/components/pipewire.nix
  ../../modules/components/docker.nix
  ../../modules/terminalApps.nix
  ../../modules/guiApps.nix
  ../../modules/systemExtras.nix
];

terminalAppGroups.enabledGroups = [ "work" ];
guiApps.enabledGroups = [ "work" ];
systemExtras.enabledTags = [ "fonts" ];
```

In `hosts/versatilis/configuration.nix`:
```nix
imports = [
  ../../modules/components/hyprland.nix
  ../../modules/components/bluetooth.nix
  ../../modules/components/pipewire.nix
  ../../modules/components/docker.nix
  ../../modules/terminalApps.nix
  ../../modules/guiApps.nix
];

terminalAppGroups.enabledGroups = [ "personal" ];
guiApps.enabledGroups = [ "personal" ];
```

## Lib Functions

- **applyTaggedConfigs.nix**: Merges configs based on enabled tags.
- **mergedConfigFields.nix**: Helper for merging config fields.
- **optionHelper.nix**: Simplifies option definitions.
- **userOption.nix**: User option utilities.
- **appendUserToGroup.nix**: Adds users to extra groups.

---

## Host-Specific Packages & Services

- **operari (Work PC)**: Enables Twingate, Hyprland, Docker, work terminal and GUI apps, and system extras (fonts).
- **versatilis (Personal Laptop)**: Enables Hyprland, Bluetooth, Docker, personal terminal and GUI apps.
- **domus/quies**: Ready for future expansion; add modules and options as needed.