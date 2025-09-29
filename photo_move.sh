#!/bin/bash

# 初期設定
INLINE_MODE=false
INPUT_DIR=""
OUTPUT_DIR=""

# 引数処理
while getopts ":i:o:" opt; do
  case $opt in
    i) INPUT_DIR="$OPTARG"; INLINE_MODE=true ;;
    o) OUTPUT_DIR="$OPTARG"; INLINE_MODE=true ;;
    \?) echo "無効なオプション: -$OPTARG" >&2; exit 1 ;;
    :) echo "オプション -$OPTARG には引数が必要です" >&2; exit 1 ;;
  esac
done

# デフォルト設定（未指定ならカレントディレクトリ直下の input/output）
if [ -z "$INPUT_DIR" ]; then
  INPUT_DIR="./input"
fi
if [ -z "$OUTPUT_DIR" ]; then
  OUTPUT_DIR="./output"
fi

# exiftoolチェック
if ! command -v exiftool &> /dev/null; then
  echo "エラー: exiftool がインストールされていません。brew install exiftool を実行してください。"
  exit 1
fi

# 入力ディレクトリ確認（なければ作成して警告）
if [ ! -d "$INPUT_DIR" ]; then
  echo "入力ディレクトリが存在しないため作成しました: $INPUT_DIR"
  mkdir -p "$INPUT_DIR"
fi

# 出力ディレクトリ作成
mkdir -p "$OUTPUT_DIR"

# 対象ファイルをループ
find "$INPUT_DIR" -type f \( -iname "*.jpeg" -o -iname "*.jpg" -o -iname "*.arw" \) | while read -r FILE; do
  EXT="${FILE##*.}"
  EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
  BASENAME=$(basename "$FILE")

  # 撮影日を取得（なければ "unknown"）
  DATE=$(exiftool -d "%Y-%m-%d" -DateTimeOriginal -s3 "$FILE")
  if [ -z "$DATE" ]; then
    DATE="unknown"
  fi

  # 撮影日ディレクトリ
  TARGET_DIR="$OUTPUT_DIR/$DATE"
  if [ ! -d "$TARGET_DIR" ]; then
    mkdir "$TARGET_DIR"
  fi

  # JPEG系は prefix フォルダに添え字付きで移動
  if [[ "$EXT_LOWER" == "jpeg" || "$EXT_LOWER" == "jpg" ]]; then
    PREFIX="${BASENAME%.*}"
    SUBFOLDER="$TARGET_DIR/$PREFIX"

    if [ ! -d "$SUBFOLDER" ]; then
      mkdir "$SUBFOLDER"
    fi

    COUNT=$(find "$SUBFOLDER" -type f -name "${PREFIX}_*.${EXT_LOWER}" | wc -l)
    COUNT=$((COUNT + 1))
    NEW_FILENAME="${PREFIX}_${COUNT}.${EXT_LOWER}"
    DEST="$SUBFOLDER/$NEW_FILENAME"

  else
    # ARWなどはそのまま日付ディレクトリに移動（重複時リネーム）
    DEST="$TARGET_DIR/$BASENAME"
    if [ -e "$DEST" ]; then
      NAME="${BASENAME%.*}"
      COUNT=1
      while [ -e "$TARGET_DIR/${NAME}_$COUNT.$EXT_LOWER" ]; do
        COUNT=$((COUNT + 1))
      done
      DEST="$TARGET_DIR/${NAME}_$COUNT.$EXT_LOWER"
    fi
  fi

  mv "$FILE" "$DEST"
  echo "Moved: $FILE → $DEST"
done

echo "✅ すべてのファイルを整理しました。"
