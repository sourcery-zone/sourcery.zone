---
title: "Blogging using Emacs Org Roam and Hugo"
author: ["Shahin"]
lastmod: 2025-02-26T11:05:55+01:00
tags: ["emacs", "org-mode", "org-roam", "hugo"]
categories: ["Quick Tips"]
draft: false
---

## Situation {#situation}

There are not many software preferences in my list that I can not
easily replace with alternatives due to how intuitive they feel. [Org](https://orgmode.org)
and [Hugo](https://gohugo.io/) are definitely among the top items of that list.

Well, their integration, even though it has existed for a long time,
is not the best out of the box. Also with the advancements of
cross-article linking, I really wanted to have it in my new blog,
which I'm going to use for daily blogging, and also publishing my long
form notes and thoughts.

Also knowing myself, I wanted to have the most straightforward setup,
with as few external package as possible. So, here is how I do it:


## My Setup {#my-setup}


### Dependencies {#dependencies}

To install dependencies, I use [devenv](https://devenv.sh) like any other project I
have. So I don't need to worry about forgetting stuff in the long
run.

First and foremost, I use it to install `hugo`:

```nix
packages = with pkgs; [
  hugo
]
```

But also to install modern web dev utilities for the blog template I
use, so:

```nix
let
  nodejs-packages = with pkgs.nodePackages; [
    vscode-langservers-extracted
    postcss-cli
  ]
in {
  name = ...;

  ...
  packages with pkgs; [
    ...
  ] ++ nodejs-packages;

  languages.javascript.enable = true;
}
```

Also to make it convenient (usually for when I'm updating something in
the theme), I add the following [process](https://devenv.sh/processes/):

```nix
processes.hugo-watch.exec = "hugo server -D";
```

So I can `devenv up` and forget!


### [Org Roam](https://orgroam.com) {#org-roam}

The next thing of course is to set up org roam. There are many
different custom setups one can apply (duh, it's [Emacs](https://www.gnu.org/savannah-checkouts/gnu/emacs/emacs.html) after all). And
that doesn't much matter here. What matters is how we use Org Roam for
this blog. So I create a `.dir-locals.el` to configure it specifically
for the given directory, and this is what I have in it:

```emacs-lisp
((org-mode . (
         (eval . (let ((project-root (locate-dominating-file default-directory ".dir-locals.el")))
                   ;; Set org-roam-directory to the 'roam' subdirectory of project-root
                   (setq-local org-roam-directory (expand-file-name "roam" project-root))
                   ;; Set org-roam-db-location inside org-roam-directory
                   (setq-local org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))
                   ;; Set org-hugo-base-dir to the 'content' sibling directory
                   ;; Re-initialize org-roam to pick up new settings
                   (when (fboundp 'org-roam-db-autosync-enable)
                     (org-roam-db-autosync-enable))
                   ;; Automatically invoke ox-hugo
                   (org-hugo-auto-export-mode)
                   )))
      ))
```

I tried to describe it in the comments, but in general what it does,
is to make sure it won't effect your main setup, and opens a new note
vault (is that what it is called?) in the given path.

Consequently, I can write my articles or notes using Org Roam, and
have the cross links out of the box. Now I need to help Hugo
understand it:


### [Org Hugo](https://ox-hugo.scripter.co/) {#org-hugo}

A few more lines in the `.dir-locals.el`, and that's also taken care of:

```emacs-lisp
((org-mode . (
         (eval . (let ((project-root (locate-dominating-file default-directory ".dir-locals.el")))
                   ;; Set org-roam-directory to the 'roam' subdirectory of project-root
                   (setq-local org-roam-directory (expand-file-name "roam" project-root))
                   ;; Set org-roam-db-location inside org-roam-directory
                   (setq-local org-roam-db-location (expand-file-name "org-roam.db" org-roam-directory))
                   ;; Set org-hugo-base-dir to the 'content' sibling directory
                   (setq-local org-hugo-base-dir (expand-file-name "." project-root))
                   ;; Do not nest them, I use tags to identify blog
                   ;; posts. I tried using sub directories, and it
                   ;; started to fail on finding links
                   (setq-local org-hugo-section "")
                   ;; Ensure ox-hugo exports yaml FrontMatter
                   (setq-local org-hugo-front-matter-format "yaml")
                   ;; Re-initialize org-roam to pick up new settings
                   (when (fboundp 'org-roam-db-autosync-enable)
                     (org-roam-db-autosync-enable))
                   ;; Automatically invoke ox-hugo
                   (org-hugo-auto-export-mode)
                   )))
      ))
```

This package is an awesome way to translate your org vault into a Hugo
friendly output. This config literally says, get every `org` file edited
in this directory, and export it after saving to the `content` folder of
the Hugo.

However, I need a bit more control, in article level, where I want to
put them into different folders according to their purpose. For that I
use the following tag:

```org
+#hugo_section: articles
```

And that's it.


### [Org Download](https://github.com/abo-abo/org-download) {#org-download}

Sometimes, I also need screenshots, and this package is what I use
globally with my Emacss configuration.

```emacs-lisp
(leaf org-download
  :url "https://github.com/abo-abo/org-download"
  :doc "Drag and drop images to Emacs org-mode"
  :ensure t
  :after org
  :custom
  (org-download-method . 'direcory)
  (org-download-heading-lvl . nil)
  (org-download-timestamp . "_%Y%m%d-%H%M%S")
  (org-image-actual-width . t)
  (org-download-screenshot-method . "grim -g \"$(slurp)\" %s")
  :config
  (customize-set-variable 'org-download-image-dir "images")

  (require 'org-download))
```

And then `org-download-screenshot` whenever I need it.


### Serving {#serving}

To serve, I push everything to [GitHub.](https://github.com/shadow-sourcerer/sourcery.zone) And from there, [Cloudflare](https://cloudflare.com)
serves it over a worker.


## How do I like it? {#how-do-i-like-it}

Well, overall I like the simplicity of the approach. There are
sometimes some hoops I need to jump to get what I need, but I assume
I'll figure them out gradually and fix it. Just like any other aspect
of this [project](/about).
