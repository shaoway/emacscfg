;;; init.el --- GNU Emacs Configuration  -*- lexical-binding: t; -*-

;; Copyright (C) 2025 Shaowei Wang

;;; Commentary:

;; 

;;; Code:

(use-package emacs
  :ensure nil
  :bind
  (("M-o" . other-window)
   ("C-x C-b" . ibuffer))
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
  (xref-search-program 'ripgrep)
  (grep-command "rg -nS --no-heading ")
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
  (with-current-buffer (get-buffer-create "*scratch*")
    (insert (format ";;
;;
;;
;;                ███████╗███╗   ███╗ █████╗  ██████╗███████╗
;;                ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝
;;                █████╗  ██╔████╔██║███████║██║     ███████╗
;;                ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║
;;                ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║
;;                ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝
;;
;;                Loading time : %s
;;                Packages     : %s
;;
  "
                    (emacs-init-time)
                    (number-to-string (length package-activated-list)))))
  (message (emacs-init-time)))

(use-package isearch
  :ensure nil
  :config
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "(%s/%s) ")
  (setq lazy-count-suffix-format nil)
  (setq search-whitespace-regexp ".*?"))

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

(use-package icicles
  :ensure nil
  :load-path "icicles/"
  :config (icy-mode 1))

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
