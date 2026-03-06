# PM_Head 資料夾結構說明

> 更新日期：2026-03-06

---

## 📁 根目錄結構

```
PM_Head/
├── 0_portfolio/          # 產品組合總覽與策略
├── 5_management/         # PM 工作產出區
├── .ai/                  # AI Agent 配置
├── .github/              # GitHub 配置與技能定義
├── projects/             # 三個子 PM Repo
└── tools/                # 輔助工具腳本
```

---

## 🎯 0_portfolio/ — 「看全局」

放置跨產品線的**現況快照**和**策略資產**

### 文件說明
- `strategy_roadmap.md` — 整體策略、北極星、路線圖
- `product_matrix.md` — 三條產品線健康度與狀態矩陣
- `resource_allocation.md` — 資源（人力/預算）分配現況
- `common_components.md` — 跨專案共用組件清單
- `cross_project_conflicts.md` — 跨專案衝突記錄與仲裁
- `stakeholder_map.md` — 利害關係人地圖與溝通策略

### 更新頻率
- **週度**：`product_matrix.md`, `cross_project_conflicts.md`
- **月度**：`resource_allocation.md`, `common_components.md`
- **季度**：`strategy_roadmap.md`

---

## 📝 5_management/ — 「做產出」

放置所有 PM 的**工作產出**：報告、決策、簡報

### 資料夾結構
```
5_management/
├── weekly/                # 週報
├── monthly/               # 月報
├── quarterly/             # 季報
├── stakeholder_briefs/    # 利害關係人簡報（.pptx）
├── decision_records/      # 決策記錄
└── templates/             # 報告範本
```

### 命名規範
- **報告**：`YYYY-MM-DD_[標題].md`
- **決策**：`YYYY-MM-DD_[議題簡述].md`
- **簡報**：`YYYY-MM-DD_[受眾]_[主題].pptx`

---

## 🔗 其他資料夾

### .ai/
AI Agent 的核心配置
- `identity.yaml` — 角色定義
- `principles.md` — 決策原則
- `knowledge/` — 術語表、規範
- `interfaces/` — 跨 Repo 介面定義
- `memory/` — 決策與模式記錄

### .github/
GitHub 設定與技能定義
- `copilot-instructions.md` — Copilot 指令
- `skills/` — 技能定義與範例

### projects/
三個子 PM 的獨立 Repo
- `MI_PM/` — MI2.0 影像平台
- `VMS_PM/` — VMS 影像管理系統
- `SmartSignagePM/` — 智慧電子看板

### tools/
輔助工具腳本
- `git-sync.ps1/.sh` — Git 同步腳本

---

## 🔄 工作流程

### 1️⃣ 週度彙整
```
讀取 → projects/*/15_management/週報
分析 → 更新 0_portfolio/*.md
輸出 → 5_management/weekly/
```

### 2️⃣ 資源仲裁
```
觸發 → 子 PM 提出衝突
評估 → 參考 0_portfolio/resource_allocation.md
決策 → 記錄於 5_management/decision_records/
同步 → 更新 0_portfolio/product_matrix.md
```

### 3️⃣ 共用組件識別
```
掃描 → projects/*/05_product/03_backlog/
分析 → 更新 0_portfolio/common_components.md
決策 → 記錄於 5_management/decision_records/
```

---

## 📊 快速上手

### 新手第一步
1. 讀 `0_portfolio/strategy_roadmap.md` — 了解整體策略
2. 讀 `0_portfolio/product_matrix.md` — 了解當前狀態
3. 看 `5_management/weekly/` 最新週報 — 了解最新進展

### 寫第一份週報
1. 複製 `5_management/templates/README.md` 的週報範本
2. 從各子 PM 的 `15_management/` 收集進度
3. 更新 `0_portfolio/product_matrix.md`
4. 產出 `5_management/weekly/YYYY-MM-DD_週報.md`

### 做第一個決策
1. 使用 `5_management/decision_records/0_template_決策記錄範本.md`
2. 參考 `.ai/principles.md` 的決策框架
3. 記錄於 `5_management/decision_records/`
4. 同步更新相關的 `0_portfolio/*.md`

---

## 更新記錄

- 2026-03-06：初始化資料夾結構
