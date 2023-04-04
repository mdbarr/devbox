;;; .emacs

;; Melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

(setq package-list
      '(afternoon-theme
        all-the-icons
        ascii-table
        cl-format
        cl-libify
        company
        company-nginx
        company-shell
        company-web
        csharp-mode
        docker-compose-mode
        dockerfile-mode
        editorconfig
        flycheck
        flycheck-bashate
        flycheck-css-colorguard
        flycheck-popup-tip
        flycheck-yamllint
        go-mode
        groovy-mode
        js2-mode
        json-mode
        markdown-mode
        mode-icons
        multi-web-mode
        nginx-mode
        pip-requirements
        powerline
        puppet-mode
        slack
        typescript-mode
        vue-mode
        yaml-mode))

;; fetch the list of packages available
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Menu Bars are not for winners
(menu-bar-mode -1)

;; Store auto saves out of the way
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))
;; Don't create lock files
(setq create-lockfiles nil)

;; No Tabs and default indents
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq css-indent-offset 2)
(setq-default c-basic-offset 2)
(setq mode-require-final-newline nil)
(setq cperl-indent-level 2)
;; Allow case changing
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(require 'cl-lib)
(require 'cc-mode)

(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags
      '((js-mode  "<script[^>]*>" "</script>")
        (css-mode "<style[^>]*>" "</style>")))
(setq mweb-filename-extensions '("html" "htm"))
(setq mweb-submode-indent-offset 0)
(setq mmm-submode-decoration-level 0)
(multi-web-global-mode 1)

(setq require-final-newline t)
(setq mode-require-final-newline t)

;; Groovy
(setq groovy-indent-offset 2)

;; Java
(add-hook 'java-mode-hook (lambda ()
                            (setq c-basic-offset 4)))

;; Typescript
(setq-default typescript-indent-level 2)

;; JavaScript indentatioon
(setq js-indent-level 2)
(setq js-switch-indent-offset 2)

;; js2-mode
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq js2-basic-offset 2)
(setq js2-indent-switch-body t)
(set-face-attribute 'js2-function-call nil :foreground "CadetBlue")
(set-face-attribute 'js2-object-property nil :foreground "SteelBlue")

;; Flycheck
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint
          (and root
               (expand-file-name "node_modules/.bin/eslint"
                                 root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))

(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(global-flycheck-mode)
(setq-default flycheck-disabled-checkers '(javascript-jshint))
(flycheck-add-mode 'javascript-eslint 'js2-mode)

;; Company mode
;; (global-company-mode)
;; (global-set-key (kbd "TAB") #'company-indent-or-complete-common)

;; Line numbers
(global-linum-mode)
(set-face-attribute 'default nil :background "color-16")
(set-face-attribute 'linum nil :foreground "Gray30" :background "color-16")
(defadvice linum-update-window (around linum-dynamic activate)
  (let* ((w (length (number-to-string
                     (count-lines (point-min) (point-max)))))
         (linum-format (concat "%" (number-to-string w) "d\u2502 ")))
    ad-do-it))

;; Auto delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Autorevert file buffers
(global-auto-revert-mode)

;; Revert alias and revert all file buffers
(defalias 'revert 'revert-buffer)

(defun revert-all-file-buffers ()
    "Refresh all open file buffers without confirmation.
Buffers in modified (not yet saved) state in emacs will not be reverted. They
will be reverted though if they were modified outside emacs.
Buffers visiting files which do not exist any more or are no longer readable
will be killed."
    (interactive)
    (dolist (buf (buffer-list))
      (let ((filename (buffer-file-name buf)))
        ;; Revert only buffers containing files, which are not modified;
        ;; do not try to revert non-file buffers like *Messages*.
        (when (and filename
                   (not (buffer-modified-p buf)))
          (if (file-readable-p filename)
              ;; If the file exists and is readable, revert the buffer.
              (with-current-buffer buf
                (revert-buffer :ignore-auto :noconfirm))
            ;; Otherwise, kill the buffer.
            (let (kill-buffer-query-functions) ; No query done when killing buffer
              (kill-buffer buf)
              (message "Killed non-existing/unreadable file buffer: %s" filename))))))
      (message "Finished reverting buffers containing unmodified files."))

;; UUID Insertion
(require 'subr-x)

(defun uuid ()
  (interactive)
  (insert
   (string-trim
    (shell-command-to-string "uuid"))))

;; Afernoon Theme (afternoon-theme)
(load-theme 'afternoon t)
(set-face-attribute 'mode-line-buffer-id nil :foreground "DeepSkyBlue1")

;; Powerline
(require 'powerline)
(powerline-default-theme)
(set-face-attribute 'mode-line nil :background "Gray25")
(set-face-attribute 'powerline-active1 nil :background "#175993" :box nil)
(set-face-attribute 'powerline-active2 nil :background "Gray25" :box nil)

;; vc-mode line clean up (Git-branch)
(defadvice vc-mode-line (after strip-backend () activate)
  (when (stringp vc-mode)
    (let ((noback (replace-regexp-in-string
                   (format "^ %s-" (vc-backend buffer-file-name))
                   " " vc-mode)))
      (setq vc-mode noback))))


;; slack
(require 'alert)
(setq alert-default-style 'notifier)

(require 'slack)
(setq slack-buffer-emojify t)
(setq slack-prefer-current-team t)
;; (slack-start)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 'set-from-style)
 '(package-selected-packages
   '(markdown-mode puppet-mode pip-requirements csharp-mode go-mode ascii-table vue-mode typescript-mode slack powerline nginx-mode multi-web-mode mode-icons json-mode js2-mode groovy-mode flycheck-yamllint flycheck-popup-tip flycheck-css-colorguard flycheck-bashate flycheck editorconfig dockerfile-mode docker-compose-mode company-web company-shell company-nginx company cl-libify cl-format all-the-icons afternoon-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
