(add-to-list 'load-path "~/.emacs.d")

(blink-cursor-mode -1)
(setq mouse-yank-at-point t)
; This works for normal emacs
;(set-face-attribute 'default nil :font "Terminus 10")
; For emacsclient use (see http://stackoverflow.com/questions/3984730/emacs-gui-with-emacs-daemon-not-loading-fonts-correctly)
(setq default-frame-alist '((font . "Terminus 10")))
(tool-bar-mode 0)
;(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries t)
(require 'minimap)

; evil mode
(require 'evil)
(evil-mode 1)
;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)
;; numbers
(require 'evil-numbers)
(define-key evil-normal-state-map (kbd "C-a") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C-x") 'evil-numbers/dec-at-pt)

; mail
(setq user-full-name "David Vilar")
(setq user-mail-address "david.vilar@dfki.de")
(setq mail-self-blind t)
(setq mail-default-headers "CC:\n")
(require 'bbdb)
(bbdb-initialize)
;(define-key mail-mode-map [tab] 'bbdb-complete-name)
(setq message-send-mail-function 'message-send-mail-with-sendmail)
(setq mm-text-html-renderer 'gnus-w3m)
(setq sendmail-program "/usr/bin/msmtp")


;; notmuch
(require 'notmuch)
;(evil-set-initial-state 'notmuch-show-mode 'normal)
;(evil-set-initial-state 'notmuch-search-mode 'normal)
;(evil-set-initial-state 'notmuch-hello-mode 'normal)
(defun notmuch-get-date (date) "Converts a date for notmuch processing" (substring (shell-command-to-string (concat "date --date=\"" date "\" +%s")) 0 -1))
(defun notmuch-today () "Shows today's mail" (interactive) (notmuch-search (concat (notmuch-get-date "today 0") ".." (notmuch-get-date "now"))))
(defun notmuch-week () "Shows this week's mail" (interactive) (notmuch-search (concat (notmuch-get-date "last monday") ".." (notmuch-get-date "now"))))
(defun notmuch-unread () "Shows unread mail" (interactive) (notmuch-search "tag:unread"))
(defun notmuch-mt-lists () "Shows mt-lists unread mail" (interactive) (notmuch-search "tag:unread and tag:mt-lists"))
(define-key notmuch-show-mode-map "d"
  (lambda ()
    (interactive)
      (notmuch-show-tag "+deleted")))
(define-key notmuch-search-mode-map "d"
  (lambda ()
    (interactive)
      (notmuch-show-tag "+deleted")))
(define-key notmuch-show-mode-map "j" 'next-line)
(define-key notmuch-show-mode-map "k" 'previous-line)
(define-key notmuch-search-mode-map "j" 'next-line)
(define-key notmuch-search-mode-map "k" 'previous-line)
(define-key notmuch-show-mode-map "r" 'notmuch-show-reply)
(define-key notmuch-show-mode-map "R" 'notmuch-show-reply-sender)
(define-key notmuch-search-mode-map "r" 'notmuch-search-reply-to-thread)
(define-key notmuch-search-mode-map "R" 'notmuch-search-reply-to-thread-sender)
(define-key notmuch-show-mode-map ":" 'evil-ex)
(define-key notmuch-search-mode-map ":" 'evil-ex)
(evil-ex-define-cmd "nmu" 'notmuch-unread)
(evil-ex-define-cmd "nmt" 'notmuch-today)
(evil-ex-define-cmd "nmw" 'notmuch-week)
(evil-define-command evil-nms (&optional query) (interactive "<a>") (notmuch-search query))
(evil-ex-define-cmd "nms" 'evil-nms)
(evil-ex-define-cmd "nmc" 'notmuch-mua-new-mail)
(evil-ex-define-cmd "nm" 'notmuch)
(setq notmuch-saved-searches '(
                    ("unread" . "tag:inbox AND tag:unread")
                    ("mt-lists" . "tag:mt-lists AND tag:unread")
		    ("spam" . "tag:spam")
		    ))

; Org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

; Global key bindings
(global-set-key
  [(control meta up)] '(lambda()(interactive) (scroll-down 1)))
(global-set-key
  [(control meta down)] '(lambda()(interactive) (scroll-up 1)))
(global-set-key
  [(control meta shift up)] '(lambda()(interactive) (scroll-other-window -1)))
(global-set-key
  [(control meta shift down)] '(lambda()(interactive) (scroll-other-window 1)))

; Vala
(autoload 'vala-mode "vala-mode" "Major mode for editing Vala code." t)
(add-to-list 'auto-mode-alist '("\.vala$" . vala-mode))
(add-to-list 'auto-mode-alist '("\.vapi$" . vala-mode))
(add-to-list 'file-coding-system-alist '("\.vala$" . utf-8))
(add-to-list 'file-coding-system-alist '("\.vapi$" . utf-8))

; LaTeX
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

; Python
;(load-file "/usr/share/emacs/site-lisp/emacs-for-python/epy-init.el")
;(global-linum-mode 0)
;(setq skeleton-pair nil)
;(require 'pymacs)
;(pymacs-load "ropemacs" "rope-")

; Auto-complete
(add-to-list 'load-path "/usr/share/emacs/site-lisp/auto-complete")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/usr/share/emacs/site-lisp/auto-complete/ac-dict")
(ac-config-default)
(global-auto-complete-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (quote ("~/Dropbox/org/calendar.org")))
 '(org-mobile-directory "~/Dropbox/.org-mobile")
 '(org-mobile-inbox-for-pull "~/Dropbox/.org-mobile/mobile-pull.org"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
