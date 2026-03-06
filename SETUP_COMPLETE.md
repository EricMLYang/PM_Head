# Portfolio 管理系統 — 完整設置摘要

> 設置日期：2026-03-06  
> 狀態：✅ 已完成

---

## 📦 已建立的內容

### 1️⃣ 資料夾結構

```
PM_Head/
├── 0_portfolio/                    # 產品組合總覽（6 個文件）
│   ├── strategy_roadmap.md        # 整體策略與路線圖
│   ├── product_matrix.md          # 產品線狀態矩陣
│   ├── resource_allocation.md     # 資源分配現況
│   ├── common_components.md       # 共用組件清單
│   ├── cross_project_conflicts.md # 跨專案衝突記錄
│   └── stakeholder_map.md         # 利害關係人地圖
│
├── 5_management/                   # PM 工作產出
│   ├── weekly/                    # 週報（含範例）
│   ├── monthly/                   # 月報（含範例）
│   ├── quarterly/                 # 季報（含範例）
│   ├── stakeholder_briefs/        # 利害關係人簡報
│   ├── decision_records/          # 決策記錄（含範本）
│   └── templates/                 # 報告範本與指引
│
└── .github/prompts/               # 單次操作 Prompts（3 個）
    ├── init-portfolio.prompt.md
    ├── sync-portfolio.prompt.md
    └── quick-status.prompt.md
```

### 2️⃣ 3 個新增的 Prompts

| Prompt | 用途 | 觸發時機 |
|--------|------|---------|
| **init-portfolio** | 建立 portfolio 結構 | 首次設置或重置（一次性） |
| **sync-portfolio** | 同步子 PM 最新狀態 | 週度或按需 |
| **quick-status** | 快速口頭報告 | 即時查詢 |

### 3️⃣ 更新的文件

- ✅ **AGENTS.md** — 新增「自動觸發機制」章節
- ✅ **目錄快查** — 加入 `0_portfolio/` 和 `5_management/`
- ✅ **工作規範** — 加入 portfolio 管理流程

---

## 🎯 技能與 Prompts 的覆蓋分析

| 工作流程 | 對應工具 | 狀態 |
|---------|---------|------|
| 週度彙整 | `portfolio-report` skill | ✅ 已覆蓋 |
| 資源仲裁 | `priority-arbitrate` skill | ✅ 已覆蓋 |
| 共用組件識別 | `cross-project-strategy` skill | ✅ 已覆蓋 |
| Portfolio 初始化 | `init-portfolio` prompt | ✅ 新增 |
| 同步最新狀態 | `sync-portfolio` prompt | ✅ 新增 |
| 快速檢視狀況 | `quick-status` prompt | ✅ 新增 |
| 產生月報/季報 | `portfolio-report` skill | ✅ 已覆蓋 |

---

## 🔄 自動觸發機制

### 定期觸發（建議設定提醒）

| 時機 | 指令 | 工具 |
|------|------|------|
| **每週一早上** | 「同步 portfolio 狀態」 | `sync-portfolio` |
| **每週五下午** | 「寫本週週報」 | `portfolio-report` |
| **每月底** | 「做本月月報」 | `portfolio-report` |
| **每季末** | 「做季報」 + 「分析跨專案策略」 | `portfolio-report` + `cross-project-strategy` |

### 事件觸發

- 子 PM 提出資源衝突 → `priority-arbitrate`
- 發現重複需求 → `cross-project-strategy`
- AGENTS.md 修改 → `copilot-sync`
- 各子 PM git 更新 → `repo-git-sync`

### 口語化觸發

| 你說 | AI 會 |
|------|------|
| 「現在各產品線狀況如何？」 | 執行 `quick-status` |
| 「同步 portfolio」 | 執行 `sync-portfolio` |
| 「寫週報」 | 執行 `portfolio-report` |
| 「MI 和 VMS 搶資源」 | 執行 `priority-arbitrate` |
| 「掃描共用需求」 | 執行 `cross-project-strategy` |

---

## 🚀 快速上手

### 第一次使用（如果尚未執行 init）

1. **檢查現有結構**：
   ```
   是否已有 0_portfolio/ 和 5_management/ 資料夾？
   ```

2. **如果沒有，執行初始化**：
   ```
   初始化 portfolio 管理結構
   ```

### 日常工作流程

#### 每週一（同步狀態）
```
同步各產品線最新狀態到 portfolio
```

#### 每週五（產生週報）
```
寫本週週報
```

#### 隨時（快速檢視）
```
現在各產品線狀況如何？
```

#### 需要時（資源仲裁）
```
MI2.0 和 VMS 同時需要工程資源，幫我仲裁優先順序
```

#### 需要時（策略分析）
```
掃描各產品線有哪些可以抽成共用組件
```

---

## 📋 檢查清單

### Portfolio 結構
- [ ] `0_portfolio/` 包含 6 個核心文件
- [ ] `5_management/` 包含完整資料夾結構
- [ ] 各 portfolio 文件已填入初始狀態

### Prompts 可用性
- [ ] `.github/prompts/` 包含 3 個 prompt 文件
- [ ] AGENTS.md 已更新觸發機制
- [ ] 測試口語化指令是否正確觸發

### 定期流程
- [ ] 設定每週一提醒：「同步 portfolio」
- [ ] 設定每週五提醒：「寫週報」
- [ ] 設定每月底提醒：「做月報」

---

## 📚 參考文件

- [AGENTS.md](AGENTS.md) — 核心指令源與觸發機制
- [README_STRUCTURE.md](README_STRUCTURE.md) — 資料夾結構完整說明
- [SKILLS_GAP_ANALYSIS.md](SKILLS_GAP_ANALYSIS.md) — 技能覆蓋分析
- `.github/skills/_index.yaml` — 所有 skills 定義
- `.github/prompts/*.prompt.md` — 各 prompt 詳細說明

---

## 🎓 進階使用

### 自訂報告範本
修改 `5_management/templates/` 中的範本來調整報告格式

### 調整觸發條件
修改 `.github/skills/_index.yaml` 來新增或調整技能觸發關鍵字

### 新增 Portfolio 文件
如果需要追蹤新的跨專案資訊，在 `0_portfolio/` 新增文件，並更新 AGENTS.md 的目錄快查

---

## 更新記錄

- 2026-03-06：完成 portfolio 管理系統設置
  - 建立 0_portfolio/ 和 5_management/ 結構
  - 新增 3 個 prompts（init, sync, quick-status）
  - 更新 AGENTS.md 自動觸發機制
