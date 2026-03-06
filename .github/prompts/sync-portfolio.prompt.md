# Prompt: Portfolio 同步更新

> **用途**：定期同步各子 PM 的最新狀態到 portfolio 文件  
> **觸發**：週度或需要更新 portfolio 現況時  
> **類型**：定期執行（建議每週一）

---

## 執行內容

### 1. 讀取各子 PM 最新狀態

依序掃描三個子 PM Repo：

**從 MI_PM 讀取**：
- `15_management/` 最新週報 → 本週進展、阻礙
- `05_product/03_backlog/` → Backlog 狀態（是否有新需求）
- `.ai/memory/decisions.md` → 近期關鍵決策
- `01_inbox/` 最新檔案 → 新信號

**從 VMS_PM 讀取**：同上結構

**從 SmartSignagePM 讀取**：同上結構

### 2. 更新 product_matrix.md

更新 `0_portfolio/product_matrix.md`：

- **整體儀表板**：健康度、本週進展、阻礙
- **各產品線區塊**：當前階段、關鍵指標、資源需求
- **跨專案議題**：資源衝突、依賴關係、共同需求

### 3. 識別共同需求

掃描各子 PM 的 backlog，識別：
- 重複的功能需求
- 類似的技術需求（特別是 Databricks 相關）
- 跨專案的依賴關係

更新 `0_portfolio/common_components.md`：
- 新增識別到的共同需求
- 更新現有共用組件的使用狀態

### 4. 檢查跨專案衝突

分析是否有：
- 資源搶用（同一時間多個產品線需要同樣的人力）
- 功能依賴阻礙（A 產品線需要 B 產品線先完成某功能）
- 優先順序衝突（多個高優先級需求同時出現）

更新 `0_portfolio/cross_project_conflicts.md`：
- 記錄新發現的衝突
- 更新進行中衝突的狀態
- 將已解決的衝突移至「已解決」區塊

### 5. 產出同步報告

以簡潔格式回報：

```markdown
## Portfolio 同步完成 (YYYY-MM-DD)

### 更新摘要
- ✅ 已同步 3 個產品線最新狀態
- 🟢 MI2.0: [一句話進展]
- 🟡 VMS: [一句話進展]
- 🟢 SmartSignage: [一句話進展]

### 需要關注
- ⚠️ [異常 1]
- ⚠️ [異常 2]

### 新識別的共同需求
- [需求 1]
- [需求 2]

### 下一步建議
- [建議動作]
```

---

## 輸出確認

完成後應有：
- ✅ `0_portfolio/product_matrix.md` 已更新
- ✅ `0_portfolio/common_components.md` 已更新（如有新共同需求）
- ✅ `0_portfolio/cross_project_conflicts.md` 已更新（如有衝突）
- ✅ 回報同步摘要給使用者

---

## 使用方式

### 方式 1：直接指令
```
同步各產品線最新狀態到 portfolio
```

### 方式 2：明確指令
```
@workspace 參考 .github/prompts/sync-portfolio.prompt.md，更新 portfolio 狀態
```

### 方式 3：定期提醒（建議）
設定每週一早上的提醒：「該同步 portfolio 了」

---

## 注意事項

1. **輕量級更新**：只更新有變化的部分，不重寫整份文件
2. **突出異常**：如果發現健康度下降或出現新衝突，明確指出
3. **建議行動**：如果識別到需要仲裁或策略分析的議題，建議使用對應的 skill

---

## 後續動作

同步完成後，視需要：
- 如果發現資源衝突 → 使用 `priority-arbitrate` skill
- 如果識別到共同需求 → 使用 `cross-project-strategy` skill
- 如果週五 → 使用 `portfolio-report` skill 產生週報
