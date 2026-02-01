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

pcolor() {
  if [ -n "$1" ]; then
    pastel color $1
  else
    if [ $XDG_SESSION_TYPE = "wayland" ]; then
      res=$(echo -en $(wl-paste) | pastel color 2>/dev/null)
      if [ -n "$res" ]; then
        echo -en $(wl-paste) | pastel color 2>/dev/null
      else
        pcolorpick
      fi
    else
      res=$(echo -en $(xclip -o -selection clipboard) | pastel color 2>/dev/null)
      if [ -n "$res" ]; then
        echo -en $(xclip -o -selection clipboard) | pastel color 2>/dev/null
      else
        pcolorpick
      fi
    fi
  fi
}
pcolorpick() {
  if [ $XDG_SESSION_TYPE = "wayland" ]; then
    pastel --color-picker hyprpicker pick | pastel format hex | tr -d '\n' | wl-copy
    echo -en $(wl-paste) | pastel color 2>/dev/null
  else
    pastel --color-picker gpick pick | pastel format hex | tr -d '\n' | xclip -i -selection clipboard
    echo -en $(wl-paste) | pastel color 2>/dev/null
  fi
}
pcolorpickrgb() {
  if [ $XDG_SESSION_TYPE = "wayland" ]; then
    pastel --color-picker hyprpicker pick | pastel format rgb | tr -d '\n' | wl-copy
    echo -en $(wl-paste) | pastel color 2>/dev/null
  else
    pastel --color-picker gpick pick | pastel format rgb | tr -d '\n' | xclip -i -selection clipboard
    echo -en $(wl-paste) | pastel color 2>/dev/null
  fi
}
pcolorpickhsl() {
  if [ $XDG_SESSION_TYPE = "wayland" ]; then
    pastel --color-picker hyprpicker pick | pastel format hsl | tr -d '\n' | wl-copy
    echo -en $(wl-paste) | pastel color 2>/dev/null
  else
    pastel --color-picker gpick pick | pastel format hsl | tr -d '\n' | xclip -i -selection clipboard
    echo -en $(wl-paste) | pastel color 2>/dev/null
  fi
}
pcolorto() {
  local toformat="hex"
  if [ -n "$1" ]; then
    if [[ "$1" == "hex" || "$1" == "rgb" || "$1" == "hsl" ]]; then
      toformat="$1"
      if [ -n "$2" ]; then
        pastel color "$2"
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
          pastel format "$toformat" "$2" | tr -d '\n' | wl-copy
        else
          pastel format "$toformat" "$2" | tr -d '\n' | xclip -i -selection clipboard >/dev/null
        fi
      else
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
          local res=$(echo -en "$(wl-paste)" | pastel color 2>/dev/null)
          if [ -n "$res" ]; then
            echo -en "$(wl-paste)" | pastel color 2>/dev/null
            echo -en "$(wl-paste)" | pastel format "$toformat" | tr -d '\n' | wl-copy
          fi
        else
          local res=$(echo -en "$(xclip -o -selection clipboard)" | pastel color 2>/dev/null)
          if [ -n "$res" ]; then
            echo -en "$(xclip -o -selection clipboard)" | pastel color 2>/dev/null
            echo -en "$(xclip -o -selection clipboard)" | pastel format "$toformat" | tr -d '\n' | xclip -i -selection clipboard >/dev/null
          fi
        fi
      fi
    else
      pastel color "$1"
      if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        pastel format "$toformat" "$1" | tr -d '\n' | wl-copy
      else
        pastel format "$toformat" "$1" | tr -d '\n' | xclip -i -selection clipboard >/dev/null
      fi
    fi
  else
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
      local res=$(echo -en "$(wl-paste)" | pastel color 2>/dev/null)
      if [ -n "$res" ]; then
        echo -en "$(wl-paste)" | pastel color 2>/dev/null
        echo -en "$(wl-paste)" | pastel format "$toformat" | tr -d '\n' | wl-copy
      fi
    else
      local res=$(echo -en "$(xclip -o -selection clipboard)" | pastel color 2>/dev/null)
      if [ -n "$res" ]; then
        echo -en "$(xclip -o -selection clipboard)" | pastel color 2>/dev/null
        echo -en "$(xclip -o -selection clipboard)" | pastel format "$toformat" | tr -d '\n' | xclip -i -selection clipboard >/dev/null
      fi
    fi
  fi
}
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
