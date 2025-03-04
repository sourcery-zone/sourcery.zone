---
title: "C man pages in NixOS"
author: ["Shahin"]
date: 2025-03-04
lastmod: 2025-03-04T22:57:42+01:00
tags: ["nixos", "c"]
categories: ["Quick Tips"]
draft: false
---

Well, this one is simple. I was reading [Beej's guide to C programming](https://beej.us/guide/bgc/),
and learned it's possible to read C compiler's documentation using man
pages like:

```bash
man 3 printf
```

But to my surprise I got:

```text
❯ man 3 printf
No manual entry for printf in section 3
```

And it turned out to enable it, I needed to, add the following
packages to my system:

```nix
glibcInfo  # look out for the capital `I`
man-pages
```
