;;; init.el --- GNU Emacs Configuration  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Shaowei Wang

;;; Commentary:

;; 

;;; Code:

(use-package emacs
  :ensure nil
  :bind
  (("M-o" . other-window)
   ("C-x C-b" . ibuffer)
   ("C-a" . smart-beginning-of-line))
  :custom
  (cursor-type 'box )                                ; cursor type
  (ad-redefinition-action 'accept)                   ; Silence warnings for redefinition
  (cursor-in-non-selected-windows nil)               ; Hide the cursor in inactive windows
  (display-time-default-load-average nil)            ; Don't display load average
  (fill-column 80)                                   ; Set width for automatic line breaks
  (help-window-select t)                             ; Focus new help windows when opened
  (indent-tabs-mode nil)                             ; Prefer spaces over tabs
  (inhibit-startup-screen t)                         ; Disable start-up screen
  (initial-scratch-message "")                       ; Empty the initial *scratch* buffer
  (kill-ring-max 256)                                ; Maximum length of kill ring
  (load-prefer-newer t)                              ; Prefer the newest version of a file
  (mark-ring-max 256)                                ; Maximum length of mark ring
  (read-process-output-max (* 10 1024 1024))         ; Increase the amount of data reads from the process
  (scroll-conservatively most-positive-fixnum)       ; Always scroll by one line
  (select-enable-clipboard t)                        ; Merge system's and Emacs' clipboard
  (tab-width 4)                                      ; Set width for tabs
  (use-package-always-ensure t)                      ; Avoid the :ensure keyword for each package
  (vc-follow-symlinks t)                             ; Always follow the symlinks
  (view-read-only t)                                 ; Always open read-only buffers in view-mode
  (visible-bell t)                                   ; Just need it
  (split-width-threshold nil)                        ; vertical splits are preferred
  (split-height-threshold nil)
  (create-lockfiles nil)                             ; No backup files
  (make-backup-files nil)                            ; No backup files
  (backup-inhibited t)                               ; No backup files
  (ring-bell-function 'ignore)
  (ibuffer-human-readable-size t)                   ; EMACS-31
  (recentf-max-saved-items 300)                     ; default is 20
  (column-number-mode 1)                            ; Show the column number
  (fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
  (set-default-coding-systems 'utf-8)               ; Default to utf-8 encoding
  (show-paren-mode 1)                               ; Show the parent
  (custom-file (locate-user-emacs-file "custom.el"))
  (resize-mini-windows 'grow-only)
  (scroll-conservatively 8)
  (scroll-margin 5)
  (hl-line-sticky-flag nil)
  (global-hl-line-sticky-flag nil)
  (xref-search-program 'ripgrep)
  (grep-command "rg -nS --no-heading ")
  (grep-use-null-device nil)
  (grep-find-ignored-directories
   '("SCCS" "RCS" "CVS" "MCVS" ".src" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "node_modules" "build" "dist"))
  
  (frame-title-format
   (list (format "%s %%S: %%j " (system-name))
         '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))
  :config
  ;; Makes everything accept utf-8 as default, so buffers with tsx and so
  ;; won't ask for encoding (because undecided-unix) every single keystroke
  (modify-coding-system-alist 'file "" 'utf-8)
  
  (set-face-attribute 'default nil :family "Maple Mono NF CN" :height 105)

  (when (eq system-type 'darwin)
    (setq insert-directory-program "gls")
    (setq mac-command-modifier 'meta)
    (set-face-attribute 'default nil :family "Maple Mono NF CN" :height 140))

  :init
  (defun smart-beginning-of-line ()
    "Move point to first non-whitespace character or beginning-of-line.

Move point to the first non-whitespace character on this line.
If point was already at that position, move point to beginning of line."
    (interactive)
    (let ((oldpos (point)))
      (back-to-indentation)
      (and (= oldpos (point))
           (beginning-of-line))))

  (when window-system
    (setq frame-inhibit-implied-resize t)
    (setq pixel-scroll-precision-mode t))
  
  (with-current-buffer (get-buffer-create "*scratch*")
    (insert (format ";;                                                  
;;               ▄███▄   █▀▄▀█ ██   ▄█▄      ▄▄▄▄▄   
;;               █▀   ▀  █ █ █ █ █  █▀ ▀▄   █     ▀▄ 
;;               ██▄▄    █ ▄ █ █▄▄█ █   ▀ ▄  ▀▀▀▀▄   
;;               █▄   ▄▀ █   █ █  █ █▄  ▄▀ ▀▄▄▄▄▀    
;;               ▀███▀      █     █ ▀███▀            
;;                         ▀     █                   
;;                           ▀                    
;;                Loading time : %s
;;
  "
                    (emacs-init-time))))
  (message (emacs-init-time)))

(use-package isearch
  :ensure nil
  :config
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) ")
  (setq lazy-count-suffix-format nil)
  (setq search-whitespace-regexp ".*?"))

(use-package eshell
  :ensure nil
  :bind
  (("C-c e" . eshell))
  :config
  (setopt eshell-banner-message
          (concat
           (propertize "   Welcome to the Emacs Shell  \n\n" 'face '(:weight bold :foreground "red"))))

  (setq eshell-history-size 100000)
  (setq eshell-hist-ignoredups t)
  (add-hook 'eshell-mode-hook (lambda ()
                                (setenv "TERM" "xterm-256color") ;; SET TERM ENV SO MOST PROGRAMS WON'T COMPLAIN
                                ;; Locally reset scrolling behavior in term-like buffers.
                                (setq-local scroll-conservatively 0)
                                (setq-local scroll-margin 0)
                                (eshell/alias "e" "find-file $1")
                                (eshell/alias "d" "dired $1")
                                (local-set-key (kbd "C-d")
                                            (lambda ()
                                              (interactive)
                                              (insert "exit")
                                              (eshell-send-input))))))

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-strip-common-suffix t)
  (setq uniquify-after-kill-buffer-p t))

(use-package which-key
  :defer t
  :ensure nil
  :hook
  (after-init-hook . which-key-mode)
  :config
  (setq which-key-separator " ")
  (setq which-key-prefix-prefix "… ")
  (setq which-key-max-display-columns 3)
  (setq which-key-idle-delay 1)
  (setq which-key-idle-secondary-delay 0.25)
  (setq which-key-add-column-padding 1)
  (setq which-key-max-description-length 40))

(use-package epa
  :ensure nil
  :config
  ;; using password when open encypt file
  (setq epa-file-cache-passphrase-for-symmetric-encryption t)
  (setq epa-pinentry-mode 'loopback))

(use-package eglot
  :ensure nil
  :custom
  (eglot-sync-connect 0)
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  (eglot-events-buffer-config '(:size 0 :format full))
  (eglot-prefer-plaintext nil)
  (jsonrpc-event-hook nil)
  (eglot-code-action-indications nil) ;; EMACS-31 -- annoying as hell
  :init
  (fset #'jsonrpc--log-event #'ignore)

  (setq-default eglot-workspace-configuration (quote
                                               (:gopls (:hints (:parameterNames t)))))

  (add-hook 'prog-mode-hook (lambda ()
                              "Setup eglot mode with specific exclusions."
                              (unless (eq major-mode 'emacs-lisp-mode)
                                (eglot-ensure))))
  :bind (:map
         eglot-mode-map
         ("C-c l a" . eglot-code-actions)
         ("C-c l o" . eglot-code-action-organize-imports)
         ("C-c l r" . eglot-rename)
         ("C-c l f" . eglot-format)))

(use-package abbrev
  :ensure nil
  :custom
  (save-abbrevs nil)
  :config
  (define-abbrev-table 'global-abbrev-table
    '(
      ("isodate" ""
       (lambda () (insert (format "%s" (format-time-string "%Y-%m-%dT%H:%M:%S")))))
      )))

(use-package electric-pair
  :ensure nil
  :defer
  :hook (after-init-hook . electric-pair-mode))

(use-package paren
  :ensure nil
  :hook (after-init-hook . show-paren-mode)
  :custom
  (show-paren-delay 0)
  (show-paren-style 'mixed)
  (show-paren-context-when-offscreen t)) ;; show matches within window splits

(use-package dired
  :ensure nil
  :custom
  (dired-auto-revert-buffer t)
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  (dired-listing-switches "-alh --group-directories-first")
  (dired-omit-files "^\\.")                                ; with dired-omit-mode (C-x M-o)
  (dired-hide-details-hide-absolute-location t)            ; EMACS-31
  :init
  ;; Turning this ON also sets the C-x M-o binding.
  (add-hook 'dired-mode-hook (lambda () (dired-omit-mode 1))))

(use-package wdired
  :ensure nil
  :commands (wdired-change-to-wdired-mode)
  :config
  (setq wdired-allow-to-change-permissions t)
  (setq wdired-create-parent-directories t))

(use-package speedbar
  :ensure nil
  :bind
  (("M-I" . (lambda () ;; Toggles / focuses speedbar on side window
              (interactive)
              (speedbar-window)       ;; EMACS-31
              (let ((win (get-buffer-window speedbar-buffer)))
                (when win
                  (select-window win))))))
  :custom
  (speedbar-window-default-width 25)  ;; EMACS-31
  (speedbar-window-max-width 25)      ;; EMACS-31
  (speedbar-show-unknown-files t)
  (speedbar-directory-unshown-regexp "^$")
  (speedbar-indentation-width 2)
  (speedbar-use-images nil)
  (speedbar-update-flag nil)
  :config
  (setq speedbar-expand-image-button-alist
        '(("<+>" . ezimage-directory) ;; previously ezimage-directory-plus
          ("<->" . ezimage-directory-minus)
          ("< >" . ezimage-directory)
          ("[+]" . ezimage-page-plus)
          ("[-]" . ezimage-page-minus)
          ("[?]" . ezimage-page)
          ("[ ]" . ezimage-page)
          ("{+}" . ezimage-directory-plus) ;; previously ezimage-box-plus
          ("{-}" . ezimage-directory-minus) ;; previously ezimage-box-minus
          ("<M>" . ezimage-mail)
          ("<d>" . ezimage-document-tag)
          ("<i>" . ezimage-info-tag)
          (" =>" . ezimage-tag)
          (" +>" . ezimage-tag-gt)
          (" ->" . ezimage-tag-v)
          (">"   . ezimage-tag)
          ("@"   . ezimage-tag-type)
          ("  @" . ezimage-tag-type)
          ("*"   . ezimage-checkout)
          ("#"   . ezimage-object)
          ("!"   . ezimage-object-out-of-date)
          ("//"  . ezimage-label)
          ("%"   . ezimage-lock))))

(use-package ediff
  :ensure nil
  :commands (ediff-buffers ediff-files ediff-buffers3 ediff-files3)
  :init
  (setq ediff-split-window-function 'split-window-horizontally)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain)
  :config
  (setq ediff-keep-variants nil)
  (setq ediff-make-buffers-readonly-at-startup nil)
  (setq ediff-show-clashes-only t))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-help-at-pt t) ;; EMACS-31
  (eldoc-echo-area-use-multiline-p nil)
  (eldoc-echo-area-prefer-doc-buffer t)
  (eldoc-documentation-strategy 'eldoc-documentation-compose)
  :init
  (global-eldoc-mode))

(use-package org
  :ensure nil
  :defer t
  :mode ("\\.org\\'" . org-mode)
  :config
  (setopt org-export-backends '(ascii html icalendar latex odt md))
  (setq
   ;; Start collapsed for speed
   org-startup-folded t

   ;; Edit settings
   org-hide-leading-stars t
   org-auto-align-tags nil
   org-tags-column 0
   org-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t

   ;; Org styling, hide markup etc.
   org-hide-emphasis-markers t
   org-pretty-entities t
   org-use-sub-superscripts nil ;; We want the above but no _ subscripts ^ superscripts

   ;; Agenda styling
   org-agenda-tags-column 0
   org-agenda-block-separator ?─
   org-agenda-time-grid
   '((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
   org-agenda-current-time-string
   "◀── now ─────────────────────────────────────────────────")

  ;; Ellipsis styling
  (setq org-ellipsis " ▼ ")
  (set-face-attribute 'org-ellipsis nil :inherit 'default :box nil)


  ;; Keywords
  ;; As seen in https://github.com/gregnewman/gmacs/blob/master/gmacs.org
  (setq org-todo-keywords
        (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)" "PROJECTDONE(e)")
                (sequence "WAITING(w@/!)" "SOMEDAY(s@/!)" "|" "CANCELLED(c@/!)"))))
  (setq org-todo-keyword-faces
        (quote (("TODO" :foreground "lime green" :weight bold)
                ("NEXT" :foreground "cyan" :weight bold)
                ("DONE" :foreground "dim gray" :weight bold)
                ("PROJECTDONE" :foreground "dim gray" :weight bold)
                ("WAITING" :foreground "tomato" :weight bold)
                ("SOMEDAY" :foreground "magenta" :weight bold)
                ("CANCELLED" :foreground "dim gray" :weight bold))))

  ;; Anytime a task is marked done the line states `CLOSED: [timestamp]
  (setq org-log-done 'time)

  ;; Load babel only when org loads
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (js . t)
     (emacs-lisp . t)
     (org . t)
     (shell . t)))
  (setq org-confirm-babel-evaluate nil))

(use-package markdown-ts-mode
  :ensure nil
  :mode "\\.md\\'"
  :defer t
  :config
  (add-to-list 'treesit-language-source-alist '(markdown "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
  (add-to-list 'treesit-language-source-alist '(markdown-inline "https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src")))

(use-package yaml-ts-mode
  :ensure yaml-ts-mode
  :mode "\\.ya?ml\\'"
  :defer t
  :config
  (add-to-list 'treesit-language-source-alist '(yaml "https://github.com/tree-sitter-grammars/tree-sitter-yaml" "master" "src")))

;;  Loads users default shell PATH settings into Emacs. Usefull
;;  when calling Emacs directly from GUI systems.
(use-package exec-path-from-shell
  :ensure nil
  :no-require t
  :defer t
  :init
  (defun set-exec-path-from-shell-PATH ()
    "Set up Emacs' `exec-path' and PATH environment the same as the user's shell.
This works with bash, zsh, or fish)."
    (interactive)
    (let* ((shell (getenv "SHELL"))
           (shell-name (file-name-nondirectory shell))
           (command
            (cond
             ((string= shell-name "fish")
              "fish -c 'string join : $PATH'")
             ((string= shell-name "zsh")
              "zsh -i -c 'printenv PATH'")
             ((string= shell-name "bash")
              "bash --login -c 'echo $PATH'")
             (t nil))))
      (if (not command)
          (message "emacs: Unsupported shell: %s" shell-name)
        (let ((path-from-shell
               (replace-regexp-in-string
                "[ \t\n]*$" ""
                (shell-command-to-string command))))
          (when (and path-from-shell (not (string= path-from-shell "")))
            (setenv "PATH" path-from-shell)
            (setq exec-path (split-string path-from-shell path-separator))
            (message ">>> emacs: PATH loaded from %s" shell-name))))))

  (add-hook 'after-init-hook #'set-exec-path-from-shell-PATH))


(use-package icicles
  :ensure nil
  :load-path "icicles/"
  :config
  (icy-mode 1))

;; Add maxima's emacs support files path to load-path
;; (use-package imaxima
;;   :ensure nil
;;   :load-path "maxima/")

;; (use-package imath
;;   :ensure nil
;;   :load-path "maxima/")

(add-to-list 'custom-theme-load-path (file-name-concat user-emacs-directory "themes"))

;; Emacs Time Stamp
;; Enabling automatic time-stamping in Emacs
;; When there is a "Time-stamp: <>" string in the first 10 lines of the file,
;; Emacs will write time-stamp information there when saving the file.
;; (Borrowed from http://home.thep.lu.se/~karlf/emacs.html)
(setq time-stamp-active t          ; Do enable time-stamps.
      time-stamp-line-limit 10     ; Check first 10 buffer lines for Time-stamp: <>
      time-stamp-format "Last changed %Y-%02m-%02d %02H:%02M:%02S by %l")
(add-hook 'write-file-hooks 'time-stamp) ; Update when saving.

;; keep this last
(when (file-exists-p custom-file)
  (load custom-file))


;;; init.el ends here
