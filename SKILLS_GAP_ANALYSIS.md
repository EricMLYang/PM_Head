# PM_Head Skills & Prompts 覆蓋分析

> 分析日期：2026-03-06  
> 用途：確認新建立的工作流程是否都有對應的 skills 或 prompts

---

## 📊 現有 Skills 與新流程的對應關係

| 新建立的流程 | 對應的 Skill | 覆蓋狀況 | 建議 |
|------------|-------------|---------|------|
| **週度彙整流程** | `portfolio-report` | ✅ 完全覆蓋 | 無需新增 |
| **資源仲裁流程** | `priority-arbitrate` | ✅ 完全覆蓋 | 無需新增 |
| **共用組件識別** | `cross-project-strategy` | ✅ 完全覆蓋 | 無需新增 |
| **初始化 portfolio 文件** | ❌ 無對應 | 🟡 缺少 | 建議：新增 prompt |
| **同步子 PM 最新狀態** | `portfolio-report` 部分涵蓋 | 🟡 部分覆蓋 | 建議：新增 prompt |
| **產生月報/季報** | `portfolio-report` | ✅ 已涵蓋 | 可加強觸發說明 |
| **更新 portfolio 文件** | ❌ 無對應 | 🟡 缺少 | 建議：新增 prompt |

---

## 🎯 需要新增的 Prompts

### 1. Portfolio 初始化 ⭐ 高優先級

**觸發時機**：新建 PM_Head repo，或重置 portfolio 結構時（一次性）

**檔案位置**：`.github/prompts/init-portfolio.prompt.md`

**功能**：
- 建立 `0_portfolio/` 全部 6 個文件
- 建立 `5_management/` 資料夾結構
- 從各子 PM 同步初始狀態到 `product_matrix.md`
- 建立範本文件

**在 AGENTS.md 的說明**：
```markdown
### 初始化（一次性）
首次設置或重置時，使用 prompt：
`@workspace /github/prompts/init-portfolio.prompt.md`
```

---

### 2. Portfolio 同步更新 ⭐ 高優先級

**觸發時機**：定期（週度）或需要更新 portfolio 現況時

**檔案位置**：`.github/prompts/sync-portfolio.prompt.md`

**功能**：
- 從各子 PM 讀取最新狀態
- 更新 `0_portfolio/product_matrix.md`
- 更新 `0_portfolio/common_components.md`
- 更新 `0_portfolio/cross_project_conflicts.md`
- 識別需要關注的異常

**在 AGENTS.md 的說明**：
```markdown
### 定期同步
週一同步各產品線狀態時，使用：
`同步各產品線最新狀態到 portfolio` → 觸發此 prompt
```

---

### 3. 快速狀態檢視 ⭐ 中優先級

**觸發時機**：需要快速了解當前狀況（輕量級）

**檔案位置**：`.github/prompts/quick-status.prompt.md`

**功能**：
- 快速讀取 `0_portfolio/product_matrix.md`
- 列出本週各產品線狀態
- 突出需要關注的議題
- 不產生新文件，只提供口頭摘要

**在 AGENTS.md 的說明**：
```markdown
### 快速檢視
`現在各產品線狀況如何？` → 觸發此 prompt
```

---

## 🔄 現有 Skills 需要補充的觸發說明

### portfolio-report
**現有觸發**：「彙整各專案狀態」、「做定期報告」

**建議補充**：
- 「寫週報」
- 「產生本週報告」
- 「做月報」
- 「做季報」

### cross-project-strategy
**現有觸發**：「分析跨專案策略」、「專案間有什麼衝突」

**建議補充**：
- 「有哪些可以共用的組件」
- 「掃描重複需求」
- 「評估抽離共用模組」

---

## 📝 AGENTS.md 需要新增的觸發機制

### 當前問題
AGENTS.md 有技能定義，但**沒有告訴 user 或 AI 何時自動觸發**

### 建議在 AGENTS.md 新增章節

```markdown
## 自動觸發機制

### 定期觸發（建議設定提醒）

| 時機 | 觸發動作 | 對應 Skill/Prompt |
|------|---------|------------------|
| 每週一早上 | 同步各產品線最新狀態 | `sync-portfolio` prompt |
| 每週五下午 | 產生週報 | `portfolio-report` skill |
| 每月底 | 產生月報 | `portfolio-report` skill |
| 每季末 | 產生季報 + 策略分析 | `portfolio-report` + `cross-project-strategy` |

### 事件觸發（即時響應）

| 事件 | 觸發動作 | 對應 Skill/Prompt |
|------|---------|------------------|
| 子 PM 提出資源需求衝突 | 優先順序仲裁 | `priority-arbitrate` skill |
| 發現重複需求 | 共用組件評估 | `cross-project-strategy` skill |
| AGENTS.md 修改 | 同步 Copilot 指令 | `copilot-sync` skill |
| 新增子 PM Repo | Portfolio 重新初始化 | `init-portfolio` prompt |

### 人類觸發（口語化指令）

- 「現在各產品線狀況如何？」→ `quick-status` prompt
- 「寫週報」→ `portfolio-report` skill
- 「MI 和 VMS 搶資源怎麼辦」→ `priority-arbitrate` skill
- 「掃描有哪些可以共用」→ `cross-project-strategy` skill
```

---

## ✅ 行動建議

### 立即執行
1. ✅ 建立 `init-portfolio.prompt.md`
2. ✅ 建立 `sync-portfolio.prompt.md`
3. ✅ 建立 `quick-status.prompt.md`
4. ✅ 更新 AGENTS.md 新增「自動觸發機制」章節

### 後續優化
5. 在 `_index.yaml` 補充各 skill 的口語化觸發範例
6. 考慮建立 `.github/workflows/` 自動化（如：每週一自動執行 sync-portfolio）

---

## 更新記錄

- 2026-03-06：初次分析，識別 3 個缺少的 prompts
