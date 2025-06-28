source $HOME/.config/code_nvim/vim-plug/plugins.vim

" autocmd FileType python :setlocal tabstop=1
" autocmd FileType * ...
" autocmd WinEnter,WinNew,BufAdd * ...
" let g:python_recommended_style = 0

" " easymotion
" map  k <Plug>(easymotion-prefix)p<leader><leader>
"

" for NERD Commenter
filetype plugin on


let mapleader = "p"

"/******************
 "* NERD COMMENTER *
 "******************/
"map <C-/> <leader>c<space>
map <C-/> <leader>c<space>
imap <C-/> <leader>c<space>

map <Tab> >>
map <S-Tab> <<

map  <leader>i <Plug>(easymotion-f)
map  <leader>n <Plug>(easymotion-F)
map  <leader>u <Plug>(easymotion-k)
map  <leader>e <Plug>(easymotion-j)


nnoremap o i|onoremap o i|xnoremap o i

" Up & down
nnoremap e j|onoremap e j|xnoremap e j
nnoremap u k|onoremap u k|xnoremap u k

" For nativation in VS code over foldded blocks.
let navInFoldedBlock = 0

if navInFoldedBlock
    if exists('g:vscode')
        nnoremap u :<C-u>call VSCodeCall('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>
        nnoremap e :<C-u>call VSCodeCall('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>

        nnoremap U :<C-u>call VSCodeCall('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 10 })<CR>
        nnoremap E :<C-u>call VSCodeCall('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 10 })<CR>
    else
        nnoremap E 5j|onoremap E 5j|xnoremap E 5j
        nnoremap U 5k|onoremap U 5k|xnoremap U 5k
    endif
else
    nnoremap E 5j|onoremap E 5j|xnoremap E 5j
    nnoremap U 5k|onoremap U 5k|xnoremap U 5k
endif

 if exists('g:vscode')
    nnoremap zl <Cmd>call VSCodeNotify('extension.autofold')<CR>
    nnoremap zu <Cmd>call VSCodeNotify('editor.unfoldAll')<CR>

    "nnoremap zn <Cmd>call VSCodeNotify('editor.foldRecursively')<CR>
    nnoremap zi <Cmd>call VSCodeNotify('editor.unfoldRecursively')<CR>

    "nnoremap z2 <Cmd>call VSCodeNotify('editor.foldLevel2')<CR>

    nnoremap / <Cmd>call VSCodeNotify('actions.find')<CR>
    nnoremap b <Cmd>call VSCodeNotify('editor.action.nextMatchFindAction')<CR>
    nnoremap B <Cmd>call VSCodeNotify('editor.action.previousMatchFindAction')<CR>

else
    " Uncomment to enable
endif


"Map Enter to go to end of line in insert mode then enter to create a new line. That seems the only reliable way
nnoremap <CR> o

" map the left and to word and back
nnoremap n b|onoremap n b|xnoremap n b
nnoremap i w|onoremap i w|xnoremap i w
nnoremap b n|onoremap b n|xnoremap b n

" disalbe movement keys to force use easymotion
" noremap n <NOP>
" noremap e <NOP>
" noremap i <NOP>
" noremap u <NOP>

" l & y to behaive as home and end
nnoremap l 0|onoremap l 0|xnoremap l 0
nnoremap y $|onoremap y $|xnoremap y $

" Undo & Redo
nnoremap L u|onoremap L u|xnoremap L u
nnoremap Y <C-r>|onoremap Y <C-r>|xnoremap Y <C-r>

" copy
nnoremap c y|onoremap c y|xnoremap c y
nnoremap c y|onoremap c y|xnoremap c y

" cut
nnoremap x d
vnoremap x d

"paste
" nnoremap v p | vnoremap v p|xnoremap v p

" map b to visiual moade
" nnoremap b v | vnoremap b v|xnoremap b v
" nnoremap B V | vnoremap B V|xnoremap B V

" Change w/o buffering
nnoremap w "_c
vnoremap w "_c

" Delete w/o buffering
nnoremap d "_d
vnoremap d "_d

" Delete char  w/o buffering
nnoremap <Del> "_x
vnoremap <Del> "_x

" Undo & redo
nnoremap q u|onoremap q u|xnoremap q u
nnoremap Q <C-r>|xnoremap Q :<C-u>redo<CR>|

" The below 2 lines enable vim & system copy pasting to interwork.
set clipboard=unnamed
set clipboard=unnamedplus
