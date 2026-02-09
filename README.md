This repository is the "source of truth" for my neovim configuration. Using the
contained here, it is possible to clone my configuration on to any operating
system, though currently I only support two (because they're all I actually use).

Installation for NixOS
----------------------
First, I add this flake as a dependency to my system flake, like so:
```nix
{
  ...

  inputs = {
    jcc-neovim = {
      url = "github:4jamesccraven/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, self, ... }@inputs: { }
}
```
Then I set up neovim with [home-manager](https://github.com/nix-community/home-manager):
```nix
{ inputs, pkgs, ... }:

{
  home-manager.users.jamescraven = {
    programs.neovim = {
      enable = true;
      plugins = inputs.jcc-neovim.pluginList.${pkgs.stdenv.hostPlatform.system};
    };
  };
}
```
Finally, I clone this repo and symlink the config to my dotfiles:
```sh
git clone git@github.com:4jamesccraven/neovim.git && cd neovim
ln -sf "${pwd}/nvim" ~/.config/nvim
```

Installation for Arch Linux
---------------------------
I use Arch Linux for my vms because I use Arch btw, and I like to have my dots
there as well.
```sh
git clone git@github.com:4jamesccraven/neovim.git && cd neovim
./bootstrap.sh
```
Then, after entering neovim I run the following to install every treesitter
grammar known to mankind.
```lua
:= require'nvim-treesitter'.install({ 'all' }):wait(3000000)
```
