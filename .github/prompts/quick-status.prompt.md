# Prompt: 快速狀態檢視

> **用途**：快速了解當前各產品線狀況（輕量級口頭報告）  
> **觸發**：需要快速掌握現況，但不需要產生完整報告  
> **類型**：即時查詢

---

## 執行內容

### 1. 讀取 portfolio 核心文件

快速讀取：
- `0_portfolio/product_matrix.md` → 各產品線狀態
- `0_portfolio/cross_project_conflicts.md` → 當前衝突

### 2. 產出口頭摘要

以簡潔格式回報（不產生新文件）：

```markdown
## 📊 Portfolio 快速狀態 (YYYY-MM-DD)

### 整體概況
[一句話總結整體狀態]

### 各產品線
🟢 **MI2.0** — [階段] — [本週重點] — [阻礙: 有/無]
🟡 **VMS** — [階段] — [本週重點] — [阻礙: 有/無]
🟢 **SmartSignage** — [階段] — [本週重點] — [阻礙: 有/無]

### 需要關注的議題
- ⚠️ [異常 1]（如果有）
- ⚠️ [異常 2]（如果有）

### 跨專案議題
- 🔗 依賴關係：[簡述]（如果有）
- ⚡ 資源衝突：[簡述]（如果有）
- 🔄 共同需求：[簡述]（如果有）

### 建議
[如果有需要立即處理的事項，提供建議]
```

---

## 輸出確認

- ✅ 提供簡潔的口頭摘要
- ✅ 突出需要關注的異常
- ✅ 不產生新的 markdown 文件
- ✅ 不修改現有文件

---

## 使用方式

### 口語化指令（推薦）
```
現在各產品線狀況如何？
各專案進度怎麼樣？
快速看一下 portfolio 狀態
有什麼需要關注的嗎？
```

### 明確指令
```
@workspace 參考 .github/prompts/quick-status.prompt.md，快速檢視 portfolio 狀態
```

---

## 與其他工具的差異

| 工具 | 用途 | 產出 | 時機 |
|------|------|------|------|
| **quick-status** (此 prompt) | 快速口頭報告 | 口頭摘要 | 隨時 |
| **sync-portfolio** (prompt) | 同步最新狀態 | 更新 portfolio 文件 | 週度 |
| **portfolio-report** (skill) | 產生完整報告 | 週報/月報 markdown | 週度/月度 |

---

## 注意事項

1. **只讀不寫**：此 prompt 不修改任何文件
2. **基於現有資料**：僅讀取 portfolio 文件，不重新掃描子 PM
3. **如果資料過時**：建議先執行 `sync-portfolio` 再檢視

---

## 後續動作建議

如果發現：
- **portfolio 資料已過時** → 先執行 `sync-portfolio`
- **需要完整週報** → 使用 `portfolio-report` skill
- **發現資源衝突** → 使用 `priority-arbitrate` skill
- **需要策略分析** → 使用 `cross-project-strategy` skill
