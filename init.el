;; Hat tip for good suggestions on a minimal set up: https://www.sandeepnambiar.com/my-minimal-emacs-setup

;; For git purposes
(setq user-full-name "Marvin Ward Jr."
      user-mail-address "choct155@gmail.com")

;; Garbage collection and large file thresholds are way too low
(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

;; Enable expansive character encodings
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Set up package management
(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/melpa")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; Observe and leverage the fact that modal editing is superior
(use-package evil
	     :ensure
	     :config (evil-mode 1))

;; VISUAL SET UP
;; Clear away the clutter
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Add visual aids to help determine position
(global-hl-line-mode 1)
(line-number-mode 1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(size-indication-mode 1)

;; Show full file path
(setq frame-title-format
      '((:eval (if (buffer-file-name)
		   (abbreviate-file-name (buffer-file-name))
		 "%b"))))

;; Make icons available for neotree
(use-package all-the-icons
  :ensure t)

;; Be able to toggle file tree
(use-package neotree
  :ensure t)
(global-set-key [f8] 'neotree-toggle)

;; Set theme
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t ;; if nil, bold is universally disabled
	doom-themes-enable-italic t) ;; if nil, italics is universally disabled
  (load-theme 'doom-material t)
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(setq doom-modeline-project-detection 'project) ;; detect project root
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-lsp t)
(setq doom-modeline-modal-icon t)


;; MISCELLANEOUS CONVENIENCES
;; Yes, kill the buffer I am in
(global-set-key (kbd "C-x k") 'kill-this-buffer)
;; Remove unnecessary white space when I save
(add-hook 'before-save-hook 'whitespace-cleanup)
;; Some minor modes should be hidden
(use-package diminish
  :ensure t)
;; Usually want pairs
(use-package smartparens
  :ensure t
  :diminish spartparens-mode
  :config
  (progn
    (require 'smartparens-config)
    (smartparens-global-mode 1)
    (show-paren-mode t)))
;; Suggestions for the next command character are helpful
(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config (which-key-mode 1))


;; CODING CONVENIENCES
;; Autocomplete
(use-package company
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

;; Syntax checking
(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; Version control
(use-package magit
  :ensure t
  :bind (("C-M-g" . magit-status)))

;; Project navigation and management
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :bind
  (("C-c p f" . helm-projectile-find-file)
   ("C-c p p" . helm-projectile-switch-project)
   ("C-c p s" . projectile-save-project-buffers))
  :config
  (projectile-mode 1))

;; Fuzzy completion
(use-package helm
  :ensure t
  :defer 2
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("M-y" . helm-show-all-kill-ring)
  ("C-x b" . helm-mini)
  :config
  (require 'helm-config)
  (helm-mode 1)
  (setq helm-split-window-inside-p t
	helm-move-to-line-cycle-in-souce t)
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1))

;; Fuzzy completion within project
(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

;; Abbreviated code snippets
(use-package yasnippet
  :ensure t)


;; LSP
;; Set prefix for lsp-command-keymap
(setq lsp-keymap-prefix "s-l")
(use-package lsp-mode
  :ensure t
  :hook
  ((python-mode . lsp)
   (scala-mode . lsp)
   (lsp-mode . lsp-lens-mode)
   (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

(use-package company-lsp
  :ensure t)

;; Debugger
(use-package dap-mode
  :ensure t
  :hook
  (lsp-mode . dap-mode)
  (lsp-mode . dap-ui-mode))

;; PYTHON
(use-package lsp-python-ms
  :ensure t
  :init (setq lsp-python-ms-auto-install-server t)
  :hook (python-mode . (lambda ()
			 (require 'lsp-python-ms)
			 (lsp))))

(use-package conda
  :ensure t
  :init
  (setq conda-anaconda-home "~/tools/miniconda3/")
  (setq conda-env-home-directory "~/tools/miniconda3/")
  :config
  (conda-env-initialize-eshell))

;; SCALA
(use-package scala-mode
  :ensure t
  :interpreter ("scala" . scala-mode))

(use-package sbt-mode
  :commands sbt-start sbt-command
  :config
  ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
  ;; allows using SPACE when in the minibuffer
  (substitute-key-definition
   'minibuffer-complete-word
   'self-insert-command
   minibuffer-local-completion-map)
   ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
   (setq sbt:program-options '("-Dsbt.supershell=false")))

(use-package lsp-metals
  :config
  (setq lsp-metals-treeview-show-when-views-received t))

;; ORG MODE
(with-eval-after-load 'org
  (setq org-startup-indented t)
  (add-hook 'text-mode-hook #'visual-line-mode))
(org-reload)
