{
  description = "A flake providing the plugins for my neovim setup.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      # Additional plugins not available in nixpkgs
      pluginOverlay = (
        final: prev: {
          vimPlugins = prev.vimPlugins // {
            decisive-nvim = prev.vimUtils.buildVimPlugin {
              name = "decisive-nvim";
              src = prev.fetchFromGitHub {
                owner = "emmanueltouzery";
                repo = "decisive.nvim";
                rev = "c401541b8429b787d7dcb441e43bee63fc94737c";
                hash = "sha256-uy+Nj+hfeei8nquZCzIxDYf1eQsaPMX26IMh/opOwG0=";
              };
            };
          };
        }
      );

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
          ]
          (
            system:
            f (
              import nixpkgs {
                inherit system;
                overlays = [ pluginOverlay ];
              }
            )
          );
    in
    {
      pluginList = forAllSystems (
        pkgs:
        let
          lib = pkgs.lib;
          plgs = pkgs.vimPlugins;
          pluginJSON = builtins.fromJSON (builtins.readFile ./plugins.json);
          pluginList = map (builtins.getAttr "nix") (builtins.attrValues pluginJSON);
          plgPaths = map (
            nameOrPath:
            if (builtins.isString nameOrPath) then
              builtins.getAttr nameOrPath plgs
            else
              lib.getAttrFromPath nameOrPath plgs
          ) pluginList;
        in
        plgPaths
      );
    };
}
