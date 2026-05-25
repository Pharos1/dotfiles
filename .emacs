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
(global-set-key (kbd "M-;") 'move-end-of-line)  ; overwrites comment-dwim\

;;; Delete
(global-set-key (kbd "M-O") 'kill-word)
(global-set-key (kbd "M-U") 'backward-kill-word)
(global-set-key (kbd "M-L") 'delete-char)
(global-set-key (kbd "M-J") 'delete-backward-char)
(global-set-key (kbd "M-:") 'kill-line)  ; overwrites eval-expression (elisp)

(defun backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (kill-line (- 1 arg)))
(global-set-key (kbd "M-H") 'backward-kill-line)

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

;;; Custom file
(load-file custom-file)
