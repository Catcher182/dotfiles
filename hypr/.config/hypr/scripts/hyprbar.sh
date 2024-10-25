#!/bin/bash

# 执行命令并将结果保存到变量result中
# result=$(hyprpm list | grep -A 1 hyprbars | grep true)
result=$(hyprctl plugin list)

# 检查结果中是否包含字符串"true"
if [[ "$result" == *"hyprbars"* ]]; then
  hyprctl plugin unload /usr/lib/hyprland-plugins/hyprbars.so
else
  hyprctl plugin load /usr/lib/hyprland-plugins/hyprbars.so
fi
