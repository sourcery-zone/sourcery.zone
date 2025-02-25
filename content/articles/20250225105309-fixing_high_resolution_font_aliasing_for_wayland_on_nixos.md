---
title: "Fixing high resolution font aliasing for Wayland on NixOS"
author: ["Shahin"]
lastmod: 2025-02-25T12:28:36+01:00
tags: ["wayland", "xwayland", "nixos"]
categories: ["Quick Tips"]
draft: false
---

date: 2025-02-25


## Problem {#problem}

With the progress on [Wayland](https://wayland.freedesktop.org/) architecture and the usability of its
software ecosystem, I'm adapting it more and more. This is quite easy
to achieve these days, specially with NixOS friendliness of
[Hyprland](https://hyprland.org/). However, I had a weird issue with my Framework 13th's high
resolution monitor.

The font's on Chrome based applications were looking pixelated, and
specially in high res, it wasn't just the look of it which wasn't
appealing, but I was losing the readability.


## Solution {#solution}

The main reason for it seems to be related to [XWayland](https://wiki.archlinux.org/title/Wayland#Xwayland). An [X Server](https://en.wikipedia.org/wiki/X_server),
designed to run under Wayland, helping applicaitons, which don't have
Wayland support out of the box.

And apparently, Chrome related stuff, by default prefer to run on
X. To address this, we can either set the following environment
variable globally in NixOS:

```nix
# somewhere in your NixOS configuration
environment.sessionVariables.NIXOS_OZONE_WL = "1";
```

Or you can use `chrome://flags` and set the following per application:

{{< figure src="/ox-hugo/_20250225-122648screenshot.png" >}}

This is of course not available for applications like Slack, which
makes the environment variable setting a more promissing option.


## Sources {#sources}

1.  [NixOS wiki: Slack](https://nixos.wiki/wiki/Slack)
2.  [nixpkgs#207984](https://github.com/NixOS/nixpkgs/issues/207984)
