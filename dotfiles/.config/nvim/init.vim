set fdm=indent " indent folding
set foldlevel=99 " by default folds are not collapsed
set backup             " keep a backup file (restore to previous version)
set backupdir=~/.config/nvim/backup " set backup file directory
set dir=~/.config/nvim/swp " set swap & undo files directory
set viewdir=~/.config/nvim/views
set undofile           " keep an undo file (undo changes after closing)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands

" Use to view syntax group while testing custom syntax highlighting
nnoremap <F9> <cmd>echo synIDattr(synID(line('.'), col('.'), 1), 'name')<CR>

" Don't use Ex mode, use Q for formatting
noremap Q gq

"" Tab settings
set tabstop=4     " width that a <tab> is displayed as
set expandtab     " expand tabs to spaces (use :retab)
set shiftwidth=4  " width used in each step of autoindent (and << / >>)

" FUZZY FILE FIND
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" TAG JUMPING:

" Make ambiguous tags the default
nnoremap <C-]> g<C-]>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Make filename completion while in insert mode easier
inoremap <C-F> <C-X><C-F>

" Switch syntax highlighting on
syntax on

" Also switch on highlighting the last used search pattern.
set hlsearch

" I like highlighting strings inside C comments.
let c_comment_strings=1

" Set relative number && line on
set relativenumber
set number

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'textwidth' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

"====[ Make the 81st column stand out ]====================

highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

"=====[ Highlight matches when jumping to next ]=============
" This rewires n and N to do the highlighing...
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

"====[ Swap : and ; to make colon commands easier to type ]======
nnoremap  ;  :
nnoremap  :  ;

"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode "]======
nnoremap    v   <C-V>
nnoremap <C-V>     v

vnoremap    v   <C-V>
vnoremap <C-V>     v

"====[ Always turn on syntax highlighting for diffs ]=========================
" use the filetype mechanism to select automatically...
filetype on
augroup PatchDiffHighlight
    autocmd!
    autocmd FileType  diff   syntax enable
augroup END

""====[ Open any file with a pre-existing swapfile in readonly mode "]=========
"augroup NoSimultaneousEdits
"    autocmd!
"    autocmd SwapExists * let v:swapchoice = 'o'
"    autocmd SwapExists * echo 'Duplicate edit session (readonly)'
"    autocmd SwapExists * echohl None
"    autocmd SwapExists * sleep 1
"augroup END

"====[ Mappings to activate spell-checking alternatives ]================
nmap  ;s     :set invspell spelllang=en<CR>
nmap  ;ss    :set    spell spelllang=en-basic<CR>
" To create the en-basic (or any other new) spelling list:
"
"     :mkspell  ~/.vim/spell/en-basic  basic_english_words.txt
"
" See :help mkspell

""====[ Remember folds "]=====
"augroup AutoSaveFolds
"  autocmd!
"  autocmd BufWinLeave * mkview
"  autocmd BufWinEnter * silent! loadview
"augroup END

"====[ Plugins ]====

" Vim plug automated install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Multi-entry selection UI.
" https://github.com/junegunn/fzf
Plug 'junegunn/fzf'

" Better status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" NerdTree
Plug 'scrooloose/nerdtree'

" Theme
Plug 'KeitaNakamura/neodark.vim'

"" Better syntax highlighting
Plug 'sheerun/vim-polyglot'

" Brandon syntax highlighting
Plug '~/project/vim-brandon'

" Neovim language server protocol support
Plug 'neovim/nvim-lspconfig'

" Initialize plugin system
call plug#end()

" Use deoplete.
let g:deoplete#enable_at_startup = 1

" Airline config
let g:airline_theme = 'minimalist'
let g:airline#extensions#tabline#enabled = 1

""Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
""If you're using tmux version 2.2 or later, you can remove the outermost
""$TMUX check and use tmux's 24-bit color support
""(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
"if (empty($TMUX))
"    if (has("nvim"))
"        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
"        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"    endif
"      "For Neovim > 0.1.5 and Vim > patch 7.4.1799 <
"      "https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
"      "Based on Vim patch 7.4.1770 (`guicolors` option) <
"      "https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
"      " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
"    if (has("termguicolors"))
"        set termguicolors
"    endif
"endif

" Theme config
let g:neodark#terminal_transparent = 1
let g:neodark#use_256color = 1
colorscheme neodark
highlight Normal guibg=NONE

" Override search highlighting
highlight Search cterm=NONE ctermfg=None ctermbg=black
highlight IncSearch cterm=NONE ctermfg=None ctermbg=black
highlight OnText cterm=inverse ctermfg=None
" Inverse color of currently selected text.
function! HLNext (blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('OnText', target_pat, 101)
endfunction


" NerdTree plugin
nnoremap <C-e> :NERDTreeToggle<CR>

" ==[ Language Client config ]==

" setup the language server.
lua << EOF
local lspconfig = require('lspconfig')

function lsp_keymap(bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
end

lspconfig.rust_analyzer.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['rust-analyzer'] = {},
  },
  on_attach = function(client)
    -- Disable server side syntax highlight.
    client.server_capabilities.semanticTokensProvider = nil
    -- Use custom keymap
    lsp_keymap(bufnr)
  end,
}
EOF

" Display error signs from LSP in number column
set signcolumn=number

nnoremap <C-e> :NERDTreeToggle<CR>
