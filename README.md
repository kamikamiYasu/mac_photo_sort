# mac-photo-sorter

📸 macOS向けの画像整理スクリプト。JPEGやARWファイルを撮影日ごとにフォルダ分けして整理します。

## ✅ 特徴

- 撮影日で `output/yyyy-mm-dd/` に自動分類
- JPEGはファイル名ごとにサブフォルダを作成＋添え字付きで保存
- 撮影日が取得できない場合は `unknown/` に振り分け
- `.jpeg`, `.jpg`, `.arw` 拡張子対応（大文字小文字問わず）
- インラインモードと対話モードをサポート

## 📦 インストール

```bash
brew install exiftool
```

## 🚀 使い方
対話モード

```bash
bash move_images_by_date.sh
```

インラインモード
```bash
bash move_images_by_date.sh -i /path/to/input -o /path/to/output
```

## 📝 ライセンス
このプロジェクトは MIT License で公開されています。

```text
MIT License

Copyright (c) 2025 kamia-y

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```