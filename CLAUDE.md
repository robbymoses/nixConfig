# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Development Commands

### NixOS Configuration Management
- `sudo nixos-rebuild switch --flake .#<hostname>` - Build and switch to configuration for specific host
- `sudo nixos-rebuild switch --flake .#operari` - Build and apply operari (work PC) configuration  
- `sudo nixos-rebuild switch --flake .#versatilis` - Build and apply versatilis (laptop) configuration
- `nix flake update` - Update flake.lock dependencies
- `nix flake check` - Validate flake configuration
- `nixos-rebuild dry-build --flake .#<hostname>` - Test build without applying changes
- `nix-collect-garbage -d` - Clean up old generations and free disk space

### Development and Testing
- `nix develop` - Enter development shell if available
- `nix flake show` - Display available outputs and configurations

## Architecture Overview

This is a modular NixOS configuration supporting multiple hosts with Latin-themed names. The architecture emphasizes reusability through shared modules and flexible per-host customization.

### Core Architecture Patterns

**Host Loading System**: The main `flake.nix` uses a `loadHost` function that dynamically loads host configurations from `hosts/<hostname>/flake.nix`. Each host defines its system architecture, modules, username, and enabled features.

**Modular Package Management**: Applications are organized into logical groups:
- `terminalApps.nix` - CLI tools organized by groups (core, work, personal)
- `guiApps.nix` - GUI applications organized by groups (core, work, personal)  
- `systemExtras.nix` - System-level packages organized by tags

**Feature-Based Configuration**: Hosts declare features in their `flake.nix` (e.g., "hyprland", "home-manager") which automatically provide the necessary inputs and modules.

**Flexible Package Selection**: Each module supports selective package installation:
```nix
terminalAppGroups.enabledGroups = [ "work" ];
guiApps.enabledGroups = [ "personal" ];
systemExtras.enabledTags = [ "fonts" ];
```

### Directory Structure

- `flake.nix` - Main entry point with host loading logic and input management
- `hosts/` - Per-host configurations with their own flake.nix and configuration.nix
- `modules/base.nix` - Base system configuration imported by all hosts
- `modules/components/` - Individual service modules (docker, hyprland, bluetooth, etc.)
- `modules/lib/` - Helper functions for config merging, option handling, and conditional imports
- `modules/users/` - User-specific configurations and home-manager integration

### Key Helper Functions (modules/lib/)

- `applyTaggedConfigs.nix` - Merges configurations based on enabled tags
- `conditionalImports.nix` - Imports modules based on conditions
- `mergedConfigFields.nix` - Merges configuration fields from different sources
- `optionHelper.nix` - Simplifies NixOS option definitions
- `userOption.nix` - User-related option utilities

### Host Profiles

**operari** (Work PC): Features work-focused apps, Twingate VPN, Docker, Hyprland, system fonts
**versatilis** (Personal Laptop): Features personal apps, Bluetooth, Docker, Hyprland, home-manager integration
**domus/quies**: Placeholder hosts ready for future server/homelab configurations

### Package Organization Strategy

The configuration uses a three-tier package system:
1. **Core packages** - Always installed when importing a module
2. **Group/tag-based packages** - Selectively enabled per host
3. **Dual nixpkgs support** - Uses both unstable and stable channels with fallback options

This architecture allows adding new hosts by creating a simple flake.nix with system, modules, and features, while shared functionality remains centralized and reusable.