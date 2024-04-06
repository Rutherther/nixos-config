#
# Neovim
#

{ config, pkgs, lib, ... }:

{
  config = lib.mkIf config.profiles.development.enable {
    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        plugins = with pkgs.vimPlugins; [
          direnv-vim

          vim-nix
          vim-markdown

          vim-lastplace
          auto-pairs
          vim-gitgutter

          wombat256-vim
          srcery-vim

          lightline-vim
          indent-blankline-nvim

          nvim-surround
          vim-easymotion
          vim-sneak

          vim-commentary
        ];

        extraConfig = ''
          syntax enable                             " Syntax highlighting
          colorscheme srcery                        " Color scheme text

          set iskeyword=!-~,^*,^45,^124,^34,192-255,^_,^.,^,,^/,^\

          let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ }                                     " Color scheme lightline

          highlight Comment cterm=italic gui=italic " Comments become italic
          hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme

          set number                                " Set numbers
        '';
      };
    };
  };
}
