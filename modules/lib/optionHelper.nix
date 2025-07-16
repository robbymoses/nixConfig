{ lib }:

let
  boolOption = { name, description, default ? false }: {
    options.${name} = lib.mkOption {
      type = lib.types.bool;
      default = default;
      description = description;
    };
  };
in {
  boolOption = boolOption;
}