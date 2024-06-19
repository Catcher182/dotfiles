# export FZF_DEFAULT_OPTS='
#     --color=fg:-1,bg:-1,hl:#5a9e86,fg+:#ffffff,bg+:#bbdefb,hl+:#d50000
#     --color=info:#af87ff,prompt:#5a9e86,pointer:#bbdefb,marker:#f06739,spinner:#f06739
#     --bind=ctrl-t:top,change:top --bind ctrl-e:down,ctrl-u:up
# '

export FZF_DEFAULT_COMMAND='fd'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
export fzf_preview_cmd="/home/dawn/.config/zsh/ctpv-no-img.sh {}"

export FZF_DEFAULT_OPTS='
    --multi
    --color=fg:-1,bg:-1,hl:#5a9e86,fg+:#ae85f4:underline,bg+:-1,hl+:#d50000
    --color=info:#af87ff,prompt:#5a9e86,pointer:#584d99,marker:#f06739,spinner:#f06739
    --bind=ctrl-t:top,change:top --bind ctrl-e:down,ctrl-u:up
'


# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)

# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # remember to use single quote here!!!
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
# zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
# 	fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white,underline' 

export _ZO_FZF_OPTS='
    --height=60%
    --layout=reverse
    --color=fg:-1,bg:-1,hl:#5a9e86,fg+:#ae85f4:underline,bg+:-1,hl+:#d50000
    --color=info:#af87ff,prompt:#5a9e86,pointer:#584d99,marker:#f06739,spinner:#f06739
    --bind=ctrl-t:top,change:top --bind ctrl-e:down,ctrl-u:up
    --preview="ls {2}"
'


export ZVM_VI_EDITOR=nvim
