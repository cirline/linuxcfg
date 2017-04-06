set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 自动缩进
set autoindent
set cindent

set smartindent		" for c to auto indent

" Tab键的宽度
set tabstop=8
" 统一缩进为4
set softtabstop=8
set shiftwidth=8
" use blank instead tab
" set expandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
" 历史记录数
set history=1000
"搜索逐字符高亮
set hlsearch
set incsearch
set helplang=cn
" 侦测文件类型
filetype on
" 载入文件类型插件
filetype plugin on
" 为特定文件类型载入相关缩进文件
filetype indent on
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-

"比较文件  
nnoremap <C-F2> :vert diffsplit 
"列出当前目录文件  
map <F3> :tabnew .<CR>  

"允许插件  
filetype plugin on
" 去掉输入错误的提示声音
set noeb
"禁止生成临时文件
set nobackup
set noswapfile
"搜索忽略大小写
set ignorecase

set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" no z a long line
set nowrap

" chinese code
set fencs=utf-8,gb2312

syntax on
:highlight Identifier ctermfg=6

" Taglist
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Use_Right_Window=1
let Tlist_Auto_Open=0

map  :w <CR> :!dot -Tpng % -O <CR> :!eog %.png & <CR>

map <F5> :!./% <CR>

source ~/linuxcfg/home/dotvim/local.vimrc

" all to html
nmap <Leader>wahh :VimwikiAll2HTML <CR>

let g:vimwiki_list = [{"syntax": "markdown", "auto_export": 0}]

