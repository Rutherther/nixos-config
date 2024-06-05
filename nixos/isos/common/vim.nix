{ pkgs, ... }:

{
  programs.neovim = {
    defaultEditor = true;
    enable = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set iskeyword=!-~,^*,^45,^124,^34,192-255,^_,^.,^,,^/,^\
        syntax enable

        set relativenumber
        set cc=80
        set list

        set smarttab
        set expandtab
        set shiftwidth=2
        set tabstop=2

        highlight Comment cterm=italic gui=italic " Comments become italic
        if &diff
          colorscheme blue
        endif
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [
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
      };
    };
  };
}
