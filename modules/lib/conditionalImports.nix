{ lib }:

rec {
  conditional = attrs: # attrs = [{ condition = bool; config = attrset; }, ...]
    lib.foldl' (acc v: if v.condition then acc // v.config else acc) {} attrs;
}