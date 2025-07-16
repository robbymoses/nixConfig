# NixOS Latin-Themed Host Configurations

This repository contains modular NixOS configurations for multiple host machines, each named with a Latin theme:

- **operari**: Work PC
- **quies**: Personal laptop
- **domus**: Homelab server

Each host configuration is located in the `hosts/` directory and imports shared modules from `modules/` for easy customization and reuse. Package sets and services are managed per host, allowing for flexible and maintainable system setups.

See each host's `flake.nix` for specific configuration details.