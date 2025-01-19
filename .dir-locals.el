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
