#!/bin/bash

# 执行命令并将结果保存到变量result中
result=$(hyprctl activewindow | grep workspace | grep -)

# 检查结果是否为空
if [ -n "$result" ]; then
	hyprctl dispatch movetoworkspace +0
else
	hyprctl dispatch movetoworkspacesilent special
fi
