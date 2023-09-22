{ inputs, config, lib, pkgs, system, ... }:

let
  extensions = inputs.nix-vscode-extensions.extensions.x86_64-linux;
in {
  programs.vscode = {
    enable = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = true;
    package = pkgs.vscodium.fhsWithPackages (ps: with ps; [ git ]);

    extensions = (with extensions.open-vsx; [
      vspacecode.vspacecode # Spacemacs like menu on space
      vspacecode.whichkey # dependency of vspacecode
      vscodevim.vim # vim keybindings
      kahole.magit # emacs magit-mode like git client
      jacobdufault.fuzzy-search # Fuzzy search
      bodil.file-browser # File browser

      usernamehw.errorlens # See error better
      nonspicyburrito.hoverlens # See hover better

      yzhang.markdown-all-in-one # Write markdown

      mkhl.direnv # Directory env
    ]) ++ (with extensions.vscode-marketplace; [
      arrterian.nix-env-selector # Nix environment
    ]);

    keybindings = [
      # VSpaceCode
      {
        key = "space";
        command = "vspacecode.space";
        when =
          "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
      }
      {
        key = "space";
        command = "vspacecode.space";
        when = "sideBarFocus && !inputFocus && !whichkeyActive";
      }
      {
        key = "ctrl+space";
        command = "vspacecode.space";
        when = "!whichkeyActive";
      }
      # Vim
      {
        key = "tab";
        command = "extension.vim_tab";
        when =
          "editorTextFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
      }
      {
        key = "tab";
        command = "-extension.vim_tab";
        when =
          "editorTextFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
      }
      # Magit
      {
        key = "p";
        command = "magit.pushing";
        when = "editorTextFocus && editorLangId == 'magit'";
      }
      {
        key = "x";
        command = "magit.discard-at-point";
        when =
          "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        key = "k";
        command = "-magit.discard-at-point";
      }
      {
        key = "-";
        command = "magit.reverse-at-point";
        when =
          "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        key = "v";
        command = "-magit.reverse-at-point";
      }
      {
        key = "shift+-";
        command = "magit.reverting";
        when =
          "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        key = "shift+v";
        command = "-magit.reverting";
      }
      {
        key = "shift+o";
        command = "magit.resetting";
        when =
          "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        key = "shift+x";
        command = "-magit.resetting";
      }
      {
        key = "x";
        command = "-magit.reset-mixed";
      }
      {
        key = "ctrl+u x";
        command = "-magit.reset-hard";
      }
      {
        key = "y";
        command = "-magit.show-refs";
      }
      {
        key = "y";
        command = "vspacecode.showMagitRefMenu";
        when =
          "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
      }

      # Support vim-like keybindings in lists, quick view etc.
      {
        key = "ctrl+j";
        command = "workbench.action.quickOpenSelectNext";
        when = "inQuickOpen";
      }
      {
        key = "ctrl+k";
        command = "workbench.action.quickOpenSelectPrevious";
        when = "inQuickOpen";
      }
      {
        key = "ctrl+j";
        command = "selectNextSuggestion";
        when =
          "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        key = "ctrl+k";
        command = "selectPrevSuggestion";
        when =
          "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        key = "ctrl+l";
        command = "acceptSelectedSuggestion";
        when =
          "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        key = "ctrl+j";
        command = "showNextParameterHint";
        when =
          "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
      }
      {
        key = "ctrl+k";
        command = "showPrevParameterHint";
        when =
          "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
      }
      {
        key = "ctrl+j";
        command = "selectNextCodeAction";
        when = "codeActionMenuVisible";
      }
      {
        key = "ctrl+k";
        command = "selectPrevCodeAction";
        when = "codeActionMenuVisible";
      }
      {
        key = "ctrl+l";
        command = "acceptSelectedCodeAction";
        when = "codeActionMenuVisible";
      }
      {
        key = "ctrl+h";
        command = "file-browser.stepOut";
        when = "inFileBrowser";
      }
      {
        key = "ctrl+l";
        command = "file-browser.stepIn";
        when = "inFileBrowser";
      }
      {
        key = "ctrl+h";
        command = "workbench.action.navigateLeft";
        when =
          "!inQuickOpen && !suggestWidgetVisible && !parameterHintsVisible && !isInDiffEditor";
      }
      {
        key = "ctrl+j";
        command = "workbench.action.navigateDown";
        when =
          "!codeActionMenuVisible && !inQuickOpen && !suggestWidgetVisible && !parameterHintsVisible";
      }
      {
        key = "ctrl+k";
        command = "workbench.action.navigateUp";
        when =
          "!codeActionMenuVisible && !inQuickOpen && !suggestWidgetVisible && !parameterHintsVisible";
      }
      {
        key = "ctrl+l";
        command = "workbench.action.navigateRight";
        when =
          "!codeActionMenuVisible && !inQuickOpen && !suggestWidgetVisible && !parameterHintsVisible && !isInDiffEditor";
      }
      {
        key = "ctrl+h";
        command = "workbench.action.compareEditor.focusSecondarySide";
        when = "isInDiffEditor && !isInDiffLeftEditor";
      }
      {
        key = "ctrl+h";
        command = "workbench.action.navigateLeft";
        when = "isInDiffEditor && isInDiffLeftEditor";
      }
      {
        key = "ctrl+l";
        command = "workbench.action.compareEditor.focusPrimarySide";
        when = "isInDiffEditor && isInDiffLeftEditor";
      }
      {
        key = "ctrl+l";
        command = "workbench.action.navigateRight";
        when = "isInDiffEditor && !isInDiffLeftEditor";
      }
      {
        key = "ctrl+h";
        command = "list.collapse";
        when = "listFocus && !inputFocus";
      }
      {
        key = "ctrl+l";
        command = "list.expand";
        when = "listFocus && !inputFocus";
      }
      {
        key = "ctrl+j";
        command = "list.focusDown";
        when = "listFocus && !inputFocus";
      }
      {
        key = "ctrl+k";
        command = "list.focusUp";
        when = "listFocus && !inputFocus";
      }
    ];

    userSettings = {
      "workbench.colorTheme" = "Default Dark Modern";
      # Editor
      "editor.lineNumbers" = "relative";
      "search.mode" = "newEditor";
      "editor.wordSeparators" = ''`~!@#$%^&*()-=+[{]}\|; ='",.<>/?_'';
      "workbench.activityBar.visible" = false;
      "workbench.editor.showTabs" = false;
      "terminal.integrated.commandsToSkipShell" =
        [ "language-julia.interrupt" "vspacecode.space" ];

      # Magit
      "magit.display-buffer-function" = "same-column";
      "magit.quick-switch-enabled" = true;

      # Vim
      "vim.easymotion" = "true";
      "vim.sneak" = true;
      "vim.smartRelativeLine" = true;
      "vim.sneakReplacesF" = true;
      "vim.targets.enable" = true;
      "vim.useSystemClipboard" = true;

      # VSpaceCode
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          "before" = [ "<space>" ];
          "commands" = [ "vspacecode.space" ];
        }
        {
          "before" = [ "," ];
          "commands" = [
            "vspacecode.space"
            {
              "command" = "whichkey.triggerKey";
              "args" = "m";
            }
          ];
        }
      ];
      "vim.visualModeKeyBindingsNonRecursive" = [
        {
          "before" = [ "<space>" ];
          "commands" = [ "vspacecode.space" ];
        }
        {
          "before" = [ "," ];
          "commands" = [
            "vspacecode.space"
            {
              "command" = "whichkey.triggerKey";
              "args" = "m";
            }
          ];
        }
      ];
    };
  };
}
