---
name: util-pptx
description: Handle .pptx tasks end-to-end. Use when the task needs to read, analyze, edit, merge, split, or create PowerPoint presentations.
---

# Skill: util-pptx — PPTX 簡報流程

## 用途（Purpose）

處理所有與 `.pptx` 有關的任務，包含讀取、編修、重組與新建簡報。

- **輸入**：簡報檔案、內容大綱、模板、品牌視覺或版面需求
- **輸出**：可開啟的 `.pptx` 產物、QA 驗證結果、可追溯的修改紀錄

## 何時使用（When to Use）

符合以下任一情境即啟動本技能：

- 「幫我做一份簡報 / deck / slides」
- 「幫我讀這個 `.pptx` 並整理重點」
- 「請修改既有簡報內容、樣式或版面」
- 「把多份簡報合併、拆分或轉成新版本」

---

## 前置條件（Prerequisites）

- 可存取至少一份輸入內容（既有 `.pptx` 或文字大綱）
- 明確定義輸出目標（讀取分析、編修模板、或從零建立）
- 需要執行命令時，建議具備下列工具（依路徑選用）：
  - `python -m markitdown`（內容抽取）
  - `Pillow`（thumbnail）
  - `LibreOffice` + `pdftoppm`（視覺 QA 轉圖）
  - `pptxgenjs`（程式化建檔）

---

## 流程（Process）

### Step 1: 判定作業路徑 [autonomous]

先將任務分類為下列其中一種：
1. 讀取/分析既有簡報
2. 編修既有模板（沿用風格）
3. 從零建立新簡報（無可用模板）

### Step 2: 建立內容基線 [autonomous]

對輸入 `.pptx` 建立文字與版面基線，至少完成一項：

```bash
python -m markitdown input.pptx
python scripts/thumbnail.py input.pptx
```

若當前專案沒有 `scripts/thumbnail.py`，改用 `soffice --headless --convert-to pdf` + `pdftoppm` 產出逐頁圖片。
若任務為模板編修，先定位可復用頁面與需要替換的 placeholder。

### Step 3: 執行主要產製 [autonomous]

- **模板編修路徑**：依 [`editing.md`](editing.md) 執行 unpack -> 結構調整 -> 內容替換 -> clean -> pack。
- **新建路徑**：依 [`pptxgenjs.md`](pptxgenjs.md) 使用 PptxGenJS 建立版面與內容。
- **純分析路徑**：輸出結構化摘要（章節、重點、風險、缺漏）。

### Step 4: 執行內容與視覺 QA [autonomous]

至少做一次「修正 -> 重驗」循環：

1. 文字 QA：確認無遺漏、錯字、殘留 placeholder
2. 視覺 QA：轉圖後檢查重疊、截斷、對齊、對比與間距
3. 修正後重新驗證受影響頁面

### Step 5: 交付結果與下一步 [hybrid]

交付時需包含：
- 產物路徑（`.pptx`）
- 驗證摘要（已檢查項目與結果）
- 若有未解決問題，列出限制與建議下一步

---

## 品質標準（Quality Gates）

- 流程路徑已明確標示（分析 / 編修 / 新建）
- 輸出 `.pptx` 可正常開啟，且頁面順序符合需求
- 內容 QA 已執行，且無已知 placeholder 殘留
- 視覺 QA 至少完成 1 次修正後重驗
- 最終交付包含檔案路徑與可追溯驗證摘要

---

## 已知限制（Limitations）

- 若缺少品牌規範或設計素材，視覺品質上限受限
- 模板品質不佳時，重用成本可能高於從零建立
- 進階圖表與動畫效果仍需人工審校，不保證一次到位
