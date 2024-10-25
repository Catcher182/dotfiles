# 查询文件格式
function xdg(){
  xdg-mime query default "$(xdg-mime query filetype "$*")"
}

# 设置xdg-open文件默认打开软件
function xdg-set(){
  xdg-mime default "$(find /usr/share/applications/ ~/.local/share/applications/ -type f | fzf | sed 's/.*\///g')" "$(xdg-mime query filetype "$*")"
}

# 用fzf快速打开文件
function fopen(){
   usepath="$(fzf --preview=$fzf_preview_cmd)"
   if [ -n "$usepath" ];then
    binary_file="xlsx xls xlsm doc docx ppt pptx" # 自定义需要后台打开的文件类型
    if [[ "$binary_file" =~ ${usepath##*.} ]];then
      nohup xdg-open "$usepath" >/dev/null 2>&1 & # 后台执行
    else
      xdg-open "$usepath" # 使用默认程序打开
    fi
   fi
}

function vfzf(){
    usepath="$(fzf --preview=$fzf_preview_cmd)"
    if [ -n "$usepath" ];then
        vim ${usepath}
    fi
}

function ff(){
    usepath="$(fzf --preview=$fzf_preview_cmd)"

    if [[ -n $1 && -n "$usepath" ]]; then
        $1 "$usepath"
    elif [[ -z $1 ]]; then
        echo "$usepath"
    fi
}

# Same as above, but with previews and works correctly with man pages in different sections.
function fman() {
    man -k . | fzf -q "$1" --prompt='man> '  --preview $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}


LFCD="/home/dawn/.config/lf/lfcd.sh"                                #  pre-built binary, make sure to use absolute path
if [ -f "$LFCD" ]; then
    source "$LFCD"
fi


set-wallpaper ()
{
  ~/.config/rofi/scripts/set-wallpaper.sh "$1"
}


kp ()
{
    local pid=$(ps -ef | sed 1d | eval "fzf -m --header='[kill:process]'" | awk '{print $2}')

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
        kp
    fi
}

ks() {
    local pid=$(lsof -Pwni tcp | sed 1d | eval "fzf -m --header='[kill:tcp]'" | awk '{print $2}')
    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
        ks
    fi
}

cf(){
    [[ -n $1 ]] && cd $1 # go to provided folder or noop
    RG_DEFAULT_COMMAND="rg -i -l --hidden --no-ignore-vcs"

    selected=$(
        FZF_DEFAULT_COMMAND="rg --files" fzf \
        -e \
        --ansi \
        --disabled \
        --reverse \
        --bind="ctrl-t:top" \
        --bind="ctrl-e:down"\
        --bind="ctrl-u:up" \
        --bind="tab:down" \
        --bind="shift-tab:up" \
        --bind "f12:execute-silent:(subl -b {})" \
        --bind "change:reload:$RG_DEFAULT_COMMAND {q} || true" \
        --preview "rg -i --pretty --context 2 {q} {}" | cut -d":" -f1,2
    )

    [[ -n $selected ]] && nvim $selected
}



pimage (){
  if [[ -z $1 ]]; then
    fzf --preview=$fzf_preview_cmd --preview-window=up
  elif [[ $1 =~ ^(http|https)://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,} ]]; then
    wget -qO- "$1" | chafa
  else
    chafa "$1"
  fi
}
