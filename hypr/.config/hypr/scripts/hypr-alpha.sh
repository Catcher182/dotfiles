#!/bin/bash

current_value=1.0

# 定义变量保存文件路径
temp_file="/tmp/hypr-alpha-temp.txt"

# 如果临时文件不存在，创建一个初始值为1的临时文件
if [ ! -f "$temp_file" ]; then
	echo "1" >"$temp_file"
fi

# 读取临时文件中的值
current_value=$(cat "$temp_file")

result=$(echo "$current_value + $1" | bc)

result=$(awk -v var="$result" 'BEGIN { if (var < 0.1) { print 0.1 } else if (var > 1.0) { print 1.0 } else { print var } }')

pidnum=$(hyprctl -j activewindow | jq '.pid')
hyprctl setprop pid:$pidnum alpha $result lock

# 将结果保存回临时文件
echo $result >"$temp_file"
