;;; packages.el --- jare-private Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2014 Sylvain Benner
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq jare-private-packages
    '(
      ;; package names go here
      git-gutter
      fringe-helper
      git-gutter-fringe
      multiple-cursors
      indent-guide
      tdd-status-mode-line
      ))

;; List of packages to exclude.
(setq jare-private-excluded-packages '())

;; For each package, define a function jare-private/init-<package-name>
;;
;; (defun jare-private/init-my-package ()
;;   "Initialize my package"
;;   )
;;
;; Often the body of an initialize function uses `use-package'
;; For more info on `use-package', see readme:
;; https://github.com/jwiegley/use-package

(defun jare-private/init-multiple-cursors ()
  (use-package multiple-cursors)

  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
)

(defun jare-private/init-indent-guide ()
  (use-package indent-guide)
)

(defun jare-private/init-tdd-status-mode-line ()
  (use-package tdd-status-mode-line)
  (tdd-status-global-mode)
)

(defun jare-private/init-git-gutter ()
  (use-package git-gutter)

  (global-git-gutter-mode +1)

  ;; If you enable global minor mode
  (global-git-gutter-mode t)

  ;; If you would like to use git-gutter.el and linum-mode
  (git-gutter:linum-setup)

  (global-set-key (kbd "M-x G T") 'git-gutter:toggle)
  (global-set-key (kbd "M-x G =") 'git-gutter:popup-hunk)

  ;; Jump to next/previous hunk
  (global-set-key (kbd "M-x G p") 'git-gutter:previous-hunk)
  (global-set-key (kbd "M-x G n") 'git-gutter:next-hunk)

  ;; Stage current hunk
  (global-set-key (kbd "M-x G s") 'git-gutter:stage-hunk)

  ;; Revert current hunk
  (global-set-key (kbd "M-x G r") 'git-gutter:revert-hunk)
)

(defun jare-private/init-fringe-helper ()
  (use-package fringe-helper)
)

(defun jare-private/init-git-gutter-fringe ()
  (use-package git-gutter-fringe)
  (setq git-gutter-fr:side 'right-fringe)
)
