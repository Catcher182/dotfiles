#!/bin/bash

# 检查参数是否传入
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <file1> <file2> ... <folder1> <folder2> ..."
  exit 1
fi

# 创建输出目录
OUTPUT_DIR="convert"
mkdir -p "$OUTPUT_DIR"
# 遍历输入的所数
for INPUT in "$@"; do
  if [ -e "$INPUT" ]; then
    if [ -d "$INPUT" ]; then
      # 如果是目录，递归调用当前脚本（保持目录结构）
      find "$INPUT" -type f | while read -r FILE; do
        OUTPUT_FILE="$OUTPUT_DIR/${FILE#"$INPUT"/}" # 保持文件夹结构
        OUTPUT_DIR_PATH=$(dirname "$OUTPUT_FILE")
        mkdir -p "$OUTPUT_DIR_PATH"
        # 检查音频编码并转换
        AUDIO_CODEC=$(ffmpeg -i "$FILE" 2>&1 | grep 'Stream #' | grep 'Audio' | awk -F', ' '{for(i=1;i<=NF;i++){if($i ~ /Audio/)print $i}}' | grep -oP 'Audio: \K\w+')

        # 判断是否是AAC编码
        if [[ "$AUDIO_CODEC" == "aac" ]]; then
          echo "Converting '$FILE' to opus..."
          ffmpeg -i "$FILE" -c:v copy -c:a libopus "$OUTPUT_FILE"
        fi
      done
    elif [ -f "$INPUT" ]; then
      # 如果是文件，直接处理
      OUTPUT_FILE="$OUTPUT_DIR/$(basename "$INPUT")" # 输出文件
      OUTPUT_DIR_PATH="$OUTPUT_DIR"
      AUDIO_CODEC=$(ffmpeg -i "$INPUT" 2>&1 | grep 'Stream #' | grep 'Audio' | awk -F', ' '{for(i=1;i<=NF;i++){if($i ~ /Audio/)print $i}}' | grep -oP 'Audio: \K\w+')

      # 判断是否是AAC编码
      if [[ "$AUDIO_CODEC" == "aac" ]]; then
        echo "Converting '$INPUT' to opus..."
        ffmpeg -i "$INPUT" -c:v copy -c:a libopus "$OUTPUT_FILE"
      fi
    else
      echo "'$INPUT' is not a valid file or directory."
    fi
  else
    echo "'$INPUT' does not exist."
  fi
done

echo "Conversion completed."
