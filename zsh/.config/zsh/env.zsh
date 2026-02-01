export GTK_USE_PORTAL=1
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim

export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"

export _JAVA_AWT_WM_NONREPARENTING=1

eval "$(zoxide init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"
setopt clobber

export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export OPENAI_API_KEY="$(cat ~/.config/.gp-nvim)"
# export OPENAI_API_KEY="$(cat ~/.config/.codecompanion-nvim)"

# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.

# Alternative (blocks terminal for 0-3ms)
# cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
# source ~/.cache/wal/colors-tty.sh

export LIBVIRT_DEFAULT_URI="qemu:///system"


export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

#
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
#
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

export PATH="$PATH:/home/dawn/.dotnet/tools"

eval "$(direnv hook zsh)"

# fzf
source <(fzf --zsh)

export FZF_DEFAULT_COMMAND='fd'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
export fzf_preview_cmd="/home/dawn/.config/zsh/ctpv-preview.sh {}"

export FZF_DEFAULT_OPTS='
    --multi
    --color=fg:-1,bg:-1,hl:#5a9e86,fg+:#ae85f4:underline,bg+:-1,hl+:#d50000
    --color=info:#af87ff,prompt:#5a9e86,pointer:#584d99,marker:#f06739,spinner:#f06739
    --bind=ctrl-t:top,change:top --bind ctrl-e:down,ctrl-u:up
'

# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
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
