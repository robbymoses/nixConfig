{ lib }:

# A function to apply tagged configs based on enabled tags
{ name ? "taggedModule", entries, enabledTags }:

let
  # Utility: true if any tag in entry.tags is in enabledTags
  anyTagMatch =
    entryTags: enabled:
      builtins.any (tag: builtins.elem tag enabled) entryTags;

  # Filter entries where tags match
  selectedEntries = builtins.filter
    (entry: anyTagMatch entry.tags enabledTags)
    entries;

  # Extract just the `config` from each matching entry
  configsToMerge = map (entry: entry.config) selectedEntries;

  # Deep-merge all configs
  mergedConfig = lib.foldl lib.recursiveUpdate { } configsToMerge;
in
  mergedConfig
