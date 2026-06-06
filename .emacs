(setq custom-file "~/.emacs.custom.el")
(package-initialize)

(add-to-list 'load-path "~/.emacs.local/")

(load "~/.emacs.rc/rc.el")

;;; UI
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode)
(show-paren-mode)
(add-to-list 'default-frame-alist '(font . "Iosevka-12"))
;(global-whitespace-mode t)
;(setq whitespace-line-column 250)

;;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 1)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'tuareg-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode 'rc/set-up-whitespace-handling)
(add-hook 'java-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'scala-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'markdown-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'haskell-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'erlang-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'asm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'fasm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'go-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'nim-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'yaml-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'porth-mode-hook 'rc/set-up-whitespace-handling)

;;; Auto update dired
;; Auto refresh buffers
(global-auto-revert-mode 1)

;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; Enable relative line numbers globally
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)


;; Inhibit splash screen
(setq inhibit-startup-screen t)

(rc/require-theme 'gruber-darker)

;;; Ido
(rc/require 'smex 'ido-completing-read+)

(require 'ido-completing-read+)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;; C-mode
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode))

;;; Multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;;; Packages that don't require configuration
(rc/require
 'yaml-mode
 'glsl-mode
 'cmake-mode
 'rust-mode
 'csharp-mode
 'markdown-mode
 'dockerfile-mode
 'toml-mode
 'nginx-mode
 'kotlin-mode
 'php-mode
 'racket-mode
 'qml-mode
 'typescript-mode
 )

;(rc/require 'format-all)
;(use-package format-all
;  :commands format-all-mode
;  :hook (prog-mode . format-all-mode))

;;; Set auto-save directory
(rc/require 'no-littering)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))


;;; IJKL navigation
(global-set-key (kbd "M-n") 'scroll-up)    ; AKA pagedown
(global-set-key (kbd "M-p") 'scroll-down)  ; AKA pageup

(global-set-key (kbd "M-i") 'previous-line)
(global-set-key (kbd "M-j") 'left-char)
(global-set-key (kbd "M-k") 'next-line)
(global-set-key (kbd "M-l") 'right-char)

(global-set-key (kbd "M-u") 'backward-word)
(global-set-key (kbd "M-o") 'forward-word)

(global-set-key (kbd "M-h") 'move-beginning-of-line)
(global-set-key (kbd "M-;") 'move-end-of-line)  ; overwrites comment-dwim

;;; Delete (Without affecting the clipboard)
;; 1. Delete Word Forward
(defun my-delete-word (arg)
  "Delete characters forward until encountering the end of a word."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))
(global-set-key (kbd "M-O") 'my-delete-word)

;; 2. Delete Word Backward
(defun my-backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))
(global-set-key (kbd "M-U") 'my-backward-delete-word)

;; 3. Delete Characters
(global-set-key (kbd "M-L") 'delete-char)
(global-set-key (kbd "M-J") 'delete-backward-char)

;; 4. Delete Line Forward
(defun my-delete-line ()
  "Delete text from current position to end of current line."
  (interactive)
  (delete-region (point) (line-end-position)))
(global-set-key (kbd "M-:") 'my-delete-line)

;; 5. Delete Line Backward
(defun my-backward-delete-line ()
  "Delete text from current position to beginning of current line."
  (interactive)
  (delete-region (point) (line-beginning-position)))
(global-set-key (kbd "M-H") 'my-backward-delete-line)

;; Fix for the Minibuffer / Find File
(with-eval-after-load 'delsel
  ;; This ensures the bindings happen after minibuffer maps are loaded
  )

(define-key minibuffer-local-map (kbd "M-i") 'previous-line)
(define-key minibuffer-local-map (kbd "M-k") 'next-line)
(define-key minibuffer-local-map (kbd "M-j") 'backward-char)
(define-key minibuffer-local-map (kbd "M-l") 'right-char)

;; Duplicate line
(defun rc/duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(global-set-key (kbd "C-,") 'rc/duplicate-line)

;;; Move text
(rc/require 'move-text)
(global-set-key (kbd "M-P") 'move-text-up)
(global-set-key (kbd "M-N") 'move-text-down)

(load-file custom-file)
