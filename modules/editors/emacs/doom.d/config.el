;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Frantisek Bohacek"
      user-mail-address "rutherther@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(setq evil-snipe-scope 'buffer)

(setq doom-localleader-key ",")

(add-hook 'nix-mode-hook #'lsp)

(map! :leader
      "c d" 'lsp-ui-doc-show
      "c m" #'+make/run)

(map! :map cdlatex-mode-map
   :i "TAB" #'cdlatex-tab)

(use-package! lsp-mode
        :custom
        (lsp-rust-analyzer-server-display-inlay-hints t)
        (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
        (lsp-rust-analyzer-display-chaining-hints t)
        (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
        (lsp-rust-analyzer-display-closure-return-type-hints t)
        (lsp-rust-analyzer-display-parameter-hints nil)
        (lsp-rust-analyzer-diagnostics-enable-experimental t)
        (lsp-rust-analyzer-display-reborrow-hints nil))
(use-package! lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(after! centaur-tabs (centaur-tabs-group-by-projectile-project))

;; imenu

(setq imenu-list-focus-after-activation t)
(map! :leader
      (:prefix ("t" . "Toggle")
       :desc "Toggle imenu shown in a sidebar"
      "i"
      #'imenu-list-smart-toggle))

;; vhdl

(add-hook 'vhdl-mode-hook #'lsp!)
(add-hook 'vhdl-mode-hook #'vhdl-electric-mode)
(add-hook 'vhdl-mode-hook #'vhdl-stutter-mode)

(defun my-vhdl-setup ()
  (setq vhdl-clock-edge-condition 'function)
  (setq vhdl-clock-name "clk_i")
  (setq vhdl-reset-kind 'sync)
  (setq vhdl-reset-name "rst_in")
)
  ;;(setq lsp-vhdl--params '(server-path "/home/ruther/Documents/git_cloned/rust_hdl/target/debug/vhdl_ls" server-args nil))
  ;;(setq lsp-vhdl-server-path "/home/ruther/Documents/git_cloned/rust_hdl/target/debug/vhdl_ls"))
(setq lsp-vhdl-server 'vhdl-ls)

(add-hook 'vhdl-mode-hook 'my-vhdl-setup)
(add-hook 'vhdl-ts-mode-hook 'my-vhdl-setup)

;;(add-hook 'lsp-managed-mode-hook
;;          (lambda ()
;;            (when (derived-mode-p 'vhdl-mode)
;;              (setq my/flycheck-local-cache '((lsp . ((next-checkers . (vhdl-ghdl)))))))))

(flycheck-define-checker vhdl-ghdl
"A VHDL syntax checker using ghdl."
:command ("ghdl"
        "--std=08"
        "-s"
        "--std=08"
        "--ieee=synopsys"
        (eval (concat "--workdir=" (projectile-project-root) "/work"))
        "-fexplicit"
        "-fno-color-diagnostics"
        source)
:error-patterns
((error line-start (file-name) ":" line ":" column
                ": " (message) line-end))
:modes vhdl-mode)

;; tree sitter and navigation
;;(setq treesit-language-source-alist
;;      '((rust "https://github.com/tree-sitter/tree-sitter-rust")
;;        (vhdl "https://github.com/alemuller/tree-sitter-vhdl")
;;        (python "https://github.com/tree-sitter/tree-sitter-python")))

;;(use-package! combobulate
;;  :preface (setq combobulate-key-prefix "SPC k"))

;;(setq major-mode-remap-alist
;; '((yaml-mode . yaml-ts-mode)
;;   ;;(rust-mode . rust-ts-mode)
;;   ;;(rustic-mode . rust-ts-mode)
;;   (c-mode . c-ts-mode)
;;   ;;(vhdl-mode . vhdl-ts-mode)
;;   (bash-mode . bash-ts-mode)
;;   (js2-mode . js-ts-mode)
;;   (typescript-mode . typescript-ts-mode)
;;   (json-mode . json-ts-mode)
;;   (css-mode . css-ts-mode)
;;   (python-mode . python-ts-mode)))

;;(add-hook 'lsp-ui-mode
;;  (lambda ()
;;  ))
;;

(defun my-lsp-ui-setup ()
  (setq lsp-ui-doc-position 'top)
  (setq lsp-ui-doc-max-height 30))
(add-hook 'lsp-mode-hook 'my-lsp-ui-setup)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory "~/doc/notes/org-roam")
  (org-roam-dailies-directory "journals/")
  (org-roam-capture-templates
   '(("d" "default" plain
      "%?" :target
      (file+head "pages/${slug}.org" "#+title: ${title}\n")
      :unnarrowed t)))
  :config (org-roam-db-autosync-enable))

(defun my-verilog-setup ()
  (setq verilog-indent-lists nil)
  (setq verilog-indent-level 2)
  (setq verilog-indent-level-behavioral 2)
  (setq verilog-indent-level-declaration 2)
  (setq verilog-indent-level-module 2)
  (setq verilog-case-indent 2)
  (setq verilog-cexp-indent 2)
  (setq verilog-align-ifelse t)
  (setq verilog-auto-delete-trailing-whitespace t)
  (setq verilog-auto-newline nil)
  (setq verilog-auto-save-policy nil)
  (setq verilog-auto-template-warn-unused t)
  (setq verilog-tab-to-comment t)
  (setq verilog-highlight-modules t)
  (setq verilog-highlight-grouping-keywords t)
)

(add-hook 'verilog-mode-hook 'my-verilog-setup)
