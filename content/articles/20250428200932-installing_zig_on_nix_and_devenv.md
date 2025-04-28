---
title: "Installing Zig on Nix and Devenv"
author: ["Shahin"]
description: "How to install latest tagged and nightly versions of Zin in NixOS"
lastmod: 2025-04-28T20:19:39+02:00
tags: ["nixos", "devenv", "zig"]
categories: ["Quick Tips"]
draft: false
---

date: 2025-28-04

I just wanted to give [zig](https://ziglang.org/) a try using [Ziglings](https://codeberg.org/ziglings/exercises/#ziglings), and realized the
latest available of this programming language on Nix package
repository is old according to `ziglings`' standards and I'm not able to
run the project (at the time of this writing NixOS has version 0.13
available, while the latest beta version is 0.15).

A quick search later, I ended up with [zig-overlay](https://github.com/mitchellh/zig-overlay), by [Mitchell
Hashimoto](https://github.com/mitchellh), and was able to use it on [devenv](https://devenv.sh), as follows:

1.  Add the overlay to `devenv.yaml` file under `inputs` section:
    ```yaml
    inputs:
      nixpkgs:
        url: github:cachix/devenv-nixpkgs/rolling
      zig:
        url: github:mitchellh/zig-overlay
    ```

2.  Then enable the language in `devenv` like:
    ```nix
    # https://devenv.sh/languages/
    languages.zig = {
      enable = true;
      package = inputs.zig.packages.${pkgs.system}.master;
    };
    ```

And that's it!
