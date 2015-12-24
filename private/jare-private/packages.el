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

(defun jare-private/init-git-gutter ()
  (use-package git-gutter)

  (global-git-gutter-mode +1)

  ;; If you enable global minor mode
  (global-git-gutter-mode t)

  ;; If you would like to use git-gutter.el and linum-mode
  (git-gutter:linum-setup)

  (evil-leader/set-key "Gt" 'git-gutter:toggle)
  (evil-leader/set-key "G=" 'git-gutter:popup-hunk)
  (evil-leader/set-key "Gp" 'git-gutter:previous-hunk)
  (evil-leader/set-key "Gn" 'git-gutter:next-hunk)
  (evil-leader/set-key "Gs" 'git-gutter:stage-hunk)
  (evil-leader/set-key "Gr" 'git-gutter:revert-hunk)
)

(defun jare-private/init-fringe-helper ()
  (use-package fringe-helper)
)

(defun jare-private/init-git-gutter-fringe ()
  (use-package git-gutter-fringe)
)
