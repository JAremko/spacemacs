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
      multiple-cursors
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
