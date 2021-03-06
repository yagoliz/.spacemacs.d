;;; packages.el --- lsp Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Fangrui Song <i@maskray.me>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst lsp-packages
  '(
     (company-lsp :requires company)
     ;; `flycheck-lsp' does not exist so we defined it as built-in to avoid
     ;; fetching it from ELPA repositories.
     ;; this logical package serves to hook all flycheck related configuration
     ;; for LSP.
     (flycheck-lsp :requires flycheck :location built-in)
     lsp-mode
     lsp-ui
     (lsp-imenu :requires imenu :location built-in)
     (lsp-ui-imenu :requires lsp-imenu :location built-in)
     ))

(defun lsp/init-company-lsp ()
  (use-package company-lsp
    :defer t
    :init
    ;; Language servers have better idea filtering and sorting,
    ;; don't filter results on the client side.
    (setq company-transformers nil
      company-lsp-async t
      company-lsp-cache-candidates nil)))

(defun lsp/init-flycheck-lsp ()
  ;; Disable lsp-flycheck.el in favor of lsp-ui-flycheck.el
  (setq lsp-enable-flycheck nil))

(defun lsp/init-lsp-mode ()
  (use-package lsp-mode
    :defer t
    :config
    (progn
      (spacemacs|hide-lighter lsp-mode))))

(defun lsp/init-lsp-ui ()
  (use-package lsp-ui
    :defer t
    :init (add-hook 'lsp-mode-hook #'lsp-ui-mode)
    :config
    (progn
      (spacemacs//lsp-sync-peek-face)
      (add-hook 'spacemacs-post-theme-change-hook
        #'spacemacs//lsp-sync-peek-face))

    (if lsp-ui-peek-expand-by-default
      (setq lsp-ui-peek-expand-function (lambda (xs) (mapcar #'car xs))))

    (if lsp-remap-xref-keybindings
      (progn (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
        (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)))

    (spacemacs/lsp-define-key
      lsp-ui-peek-mode-map
      "h" #'lsp-ui-peek--select-prev-file
      "j" #'lsp-ui-peek--select-next
      "k" #'lsp-ui-peek--select-prev
      "l" #'lsp-ui-peek--select-next-file
      )
    ))

(defun lsp/init-lsp-imenu ()
  (use-package lsp-imenu :defer t :init (add-hook 'lsp-after-open-hook #'lsp-enable-imenu)))

(defun lsp/init-lsp-ui-imenu ()
  (use-package lsp-ui-imenu :defer t :config (evil-make-overriding-map lsp-ui-imenu-mode-map)))
