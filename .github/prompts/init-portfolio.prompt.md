# Prompt: Portfolio 初始化

> **用途**：首次設置或重置 PM_Head 的 portfolio 管理結構  
> **觸發**：新建 PM_Head repo，或需要重置 portfolio 結構時  
> **類型**：一次性操作

---

## 執行內容

### 1. 建立 portfolio 核心文件

在 `0_portfolio/` 建立以下文件：

1. **strategy_roadmap.md**
   - 整體策略方向與北極星
   - 三條產品線定位
   - 季度路線圖
   - 當前策略賭注

2. **product_matrix.md**
   - 三條產品線狀態矩陣（健康度、進度、阻礙）
   - 關鍵指標
   - 跨專案議題

3. **resource_allocation.md**
   - 人力資源分配
   - 預算分配
   - 資源配置原則

4. **common_components.md**
   - 已識別的共用需求
   - 共用組件清單
   - 效益追蹤

5. **cross_project_conflicts.md**
   - 進行中的衝突
   - 已解決的衝突
   - 跨專案依賴關係

6. **stakeholder_map.md**
   - 利害關係人分類
   - 溝通策略與節奏
   - 關鍵訊息

### 2. 建立 management 資料夾結構

在 `5_management/` 建立：
- `weekly/` — 週報
- `monthly/` — 月報
- `quarterly/` — 季報
- `stakeholder_briefs/` — 利害關係人簡報
- `decision_records/` — 決策記錄
- `templates/` — 報告範本

### 3. 同步初始狀態

從各子 PM Repo 讀取初始狀態：

**從 MI_PM 讀取**：
- `00_context/01_north_star.md` → 產品定位
- `15_management/` 最新週報 → 當前進度
- `05_product/03_backlog/` → 需求清單

**從 VMS_PM 讀取**：同上結構

**從 SmartSignagePM 讀取**：同上結構

將狀態填入 `0_portfolio/product_matrix.md`

### 4. 建立範本文件

在 `5_management/templates/` 建立：
- `README.md` — 範本使用指引
- 週報/月報/季報範例檔案

### 5. 建立說明文件

在根目錄建立 `README_STRUCTURE.md`：
- 資料夾結構說明
- 工作流程指引
- 快速上手指南

---

## 輸出確認

完成後應有：
- ✅ `0_portfolio/` 包含 6 個核心文件
- ✅ `5_management/` 包含完整資料夾結構與範例
- ✅ 各 portfolio 文件已填入從子 PM 同步的初始狀態
- ✅ 根目錄有 README_STRUCTURE.md

---

## 使用方式

在 PM_Head repo 根目錄執行：
```
@workspace 參考 .github/prompts/init-portfolio.prompt.md，初始化 portfolio 結構
```

或直接說：
```
初始化 portfolio 管理結構
```

---

## 注意事項

1. **不覆蓋現有文件**：如果 `0_portfolio/` 或 `5_management/` 已存在，先詢問是否要覆蓋
2. **子 PM 狀態同步**：如果子 PM Repo 尚無狀態資訊，填入 "TBD" 佔位
3. **參考現有結構**：參考已建立的範例內容（如果有的話）

---

## 後續動作

初始化完成後，建議：
1. 使用 `sync-portfolio` prompt 定期同步狀態
2. 使用 `portfolio-report` skill 產生第一份週報
3. 在 AGENTS.md 記錄初始化完成日期
