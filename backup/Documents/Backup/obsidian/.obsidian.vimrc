" Have j and k navigate visual lines rather than logical ones
nmap j gj
nmap k gk
" I like using H and L for beginning/end of line
nmap H ^
nmap L $

" Yank to system clipboard
set clipboard=unnamed


" Surround
exmap surround_wiki surround [[ ]]
exmap surround_double_quotes surround " "
exmap surround_single_quotes surround ' '
exmap surround_code surround ` `
exmap surround_brackets surround ( )
exmap surround_square_brackets surround [ ]
exmap surround_curly_brackets surround { }
exmap surround_chinese_double_quotes surround “ ”
exmap surround_chinese_brackets surround 「 」

" NOTE: must use 'map' and not 'nmap'
nunmap s
vunmap s
map s" :surround_double_quotes
map s' :surround_single_quotes
map s( :surround_brackets
map s) :surround_brackets
map s[ :surround_square_brackets
map s{ :surround_curly_brackets
map s} :surround_curly_brackets
" Surround 中文双引号
map s] :surround_chinese_brackets
map s\ :surround_chinese_brackets
map ss :surround_chinese_double_quotes
map sy :surround_chinese_double_quotes

map saw :surround_wiki
map s` :surround_code



" Emulate Folding https://vimhelp.org/fold.txt.html#fold-commands
exmap togglefold obcommand editor:toggle-fold
nmap za :togglefold
exmap unfoldall obcommand editor:unfold-all
nmap zR :unfoldall
exmap foldall obcommand editor:fold-all
nmap zM :foldall
" Emulate Tab Switching https://vimhelp.org/tabpage.txt.html#gt
" requires Pane Relief: https://github.com/pjeby/pane-relief
exmap tabnext obcommand pane-relief:go-next
nmap gt :tabnext
exmap tabprev obcommand pane-relief:go-prev
nmap gT :tabprev
" Same as CMD+\
nmap g\ :tabnext
exmap openlink obcommand editor:open-link-in-new-leaf
nmap go :openlink
nmap gd :openlink
" [g]oto [f]ile (= Follow Link under cursor)
exmap followLinkUnderCursor obcommand editor:follow-link
nmap gf :followLinkUnderCursor
" g; go to last change - https://vimhelp.org/motion.txt.html#g%3B
nmap g; u<C-r>




unmap <Space>
" mapping vs/hs as workspace split
exmap vs obcommand workspace:split-vertical
exmap sp obcommand workspace:split-vertical
exmap hs obcommand workspace:split-horizontal
nmap <Space>v :vs
nmap <Space>s :hs
" window controls
exmap wq obcommand workspace:close
exmap q obcommand workspace:close

" focus
exmap focusLeft obcommand editor:focus-left
exmap focusRight obcommand editor:focus-right
exmap focusBottom obcommand editor:focus-bottom
exmap focusTop obcommand editor:focus-top
nmap <Space>h :focusLeft
nmap <Space>l :focusRight
nmap <Space>j :focusBottom
nmap <Space>k :focusTop
" Blockquote
exmap toggleBlockquote obcommand editor:toggle-blockquote
nmap <Space>< :toggleBlockquote
nmap <Space>> :toggleBlockquote
" complete a Markdown task
exmap toggleTask obcommand editor:toggle-checklist-status
nmap <Space>x :toggleTask
" Zoom in/out
exmap zoomIn obcommand obsidian-zoom:zoom-in
exmap zoomOut obcommand obsidian-zoom:zoom-out
nmap zi :zoomIn
nmap zo :zoomOut
nmap &a :zoomOut
nmap &b :nextHeading
nmap &c :zoomIn
nmap &d :prevHeading
nmap z] &a&b&c
nmap z[ &a&d&c


" Maps pasteinto to Alt-p
map <A-p> :pasteinto


" Go back and forward
" (make sure to remove default Obsidian shortcuts for these to work)
exmap back obcommand app:go-back
nmap <Space>[ :back
exmap forward obcommand app:go-forward
nmap <Space>] :forward

