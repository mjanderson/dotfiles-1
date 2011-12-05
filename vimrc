" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set bs=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent 
  " indenting.
  filetype plugin indent on

  au BufRead,BufNewFile *.c,*.h call Select_c_style()
  au BufRead,BufNewFile MakeFile* set noexpandtab
  
  " Use the below to highlight group when displaying bad whitespace
  highlight BadWhitespace ctermbg=red guibg=red

  " Display tabs at the beginning of a line in Python code as bad
  au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
  " Make trailing whitespace be flagged as bad
  au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
  " Wrap text after certain number of characters
  " au BufRead,BufNewFile *.py,*.pyw,*.c,*.h set textwidth=79

  au BufRead,BufNewFile *.py,*.pyw let python_highlight_all=1
  au BufRead,BufNewFile *.py,*.pyw syntax on
  au BufRead,BufNewFile *.py,*.pyw set encoding=utf-8

  " Use UNIX line endings (only for new files)
  au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix

  " map F9 to run perl programs
  autocmd FileType perl nmap <F9> :!perl %<CR>
  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=79

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event 
  " handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

:set background=dark
:imap <F7> \tab

set tabstop=4                   " Leave default for printing etc
set softtabstop=4               " But use spaces between real tabs
set shiftwidth=4
set noexpandtab                 " Use 'real' tabs if possible
set number			" Turn on line numbers
nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>

map <F5> :call CompileRunGcc()<CR>
map <F6> :call CompileGcc()<CR>
func! CompileRunGcc()
    exec "w" "Save the file
    exec "!g++ % -o %<"
    exec "! ./%<"
endfunc
func! CompileGcc()
    exec "w" "Save the file
    exec "!g++ % -o %<"
endfunc
fu Select_c_style()
    if search('^\t', 'n', 150)
	set shiftwidth=8
	set noexpandtab
    el
	set shiftwidth=4
	set expandtab
    en
endf
