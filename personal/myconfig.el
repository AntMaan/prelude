;;; Commentary:

;;; Code:

(prelude-require-packages '(ample-theme
                            anaconda-mode
                            auto-yasnippet
                            company-anaconda
                            csharp-mode
                            ecb
                            multiple-cursors
                            helm-c-yasnippet
                            iedit
                            powerline
                            smart-mode-line-powerline-theme
                            ssh-agency
                            ))

;; When evil-mode is enabled, you don't want to use key chords
(key-chord-mode -1)

;; Setup smart line on start
(sml/setup)
(setq sml/theme 'dark)

;; Make the window slightly transparent
(set-frame-parameter (selected-frame) 'alpha '(97 97))
(add-to-list 'default-frame-alist '(alpha 97 97))

;; Make tabs 4 spaces
(setq default-tab-width 4)

;; Turn off whitespace mode
(setq prelude-whitespace nil)

(defun my-csharp-mode-hook ()
  ;; enable the stuff you want for C# here
  (electric-pair-mode 1))
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ;; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ;; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ;; list actions using C-z

(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; Automatically save and reopen last session
(desktop-save-mode 1)

;; Setup Semantic
(require 'cc-mode)
(require 'semantic)
;; Allows semantic to ask gcc for include director
(require 'semantic/bovine/gcc)

;; This keybinding is used to go to an include file when the point is on one
(global-set-key (kbd "C-c , i") 'semantic-decoration-include-visit)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)
;; EDE allows for a "project" I am using it to specify include directories
(global-ede-mode t)

;; Setup yasnippet
(require 'yasnippet)
(require 'helm-c-yasnippet)
(setq helm-yas-space-match-any-greedy t)
(global-set-key (kbd "C-c y") 'helm-yas-complete)
(yas-global-mode 1)
;; (yas-load-directory "<path>/<to>/snippets/")

;; Setup SSH_ASKPASS
(setenv "SSH_ASKPASS" "git-gui--askpass")

;; Setup helper for doxygen comments
(defun moo-doxygen ()
  "Generate a doxygen yasnippet and expand it with `aya-expand'.
The point should be on the top-level function name."
  (interactive)
  (move-beginning-of-line nil)
  (let ((tag (semantic-current-tag)))
    (unless (semantic-tag-of-class-p tag 'function)
      (error "Expected function, got %S" tag))
    (let* ((name (semantic-tag-name tag))
           (attrs (semantic-tag-attributes tag))
           (args (plist-get attrs :arguments))
           (ord 1))
      (setq aya-current
            (format
             "/**
* @brief
* $1
*
%s
* @return $%d
*/
"
             (mapconcat
              (lambda (x)
                (format "* @param %s $%d"
                        (car x) (incf ord)))
              args
              "\n")
             (incf ord)))
      (aya-expand))))


(ede-cpp-root-project "Chatty Cheetah"
                      :name "Chatty Cheetah Project"
                      :file "F:/Projects/ChattyCheetah/chatty_cheetah.c"
                      :include-path '("/"
                                      "F:/Embedded/Embedded Library/include/"
                                      "F:/Embedded/Embedded Library/hal/cc3200/"
                                      ))


(provide 'myconfig)
;;; myconfig.el ends here
