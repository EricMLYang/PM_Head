---
name: portfolio-report
description: Generate cross-product-line periodic status reports. Use when user says "彙整各專案狀態", "做定期報告", "各產品線進度如何", or "幫我整理一份給老闆的進度報告".
---

# Skill: portfolio-report — 定期報告彙整

## 用途（Purpose）

當需要彙整多產品線的定期狀態報告時，讀取各子 PM 的關鍵資訊，產出跨產品線彙整報告。

- **輸入**：各子 PM Repo 的狀態資訊（Inbox、OPP、Backlog、決策記錄）
- **輸出**：跨產品線彙整報告（markdown 或 pptx），含策略觀點

## 何時使用（When to Use）

符合以下任一情境即啟動本技能：
- 「彙整各專案狀態」
- 「做定期報告」
- 「各產品線進度如何」
- 「幫我整理一份給老闆的進度報告」

---

## 前置條件（Prerequisites）

- 各子 PM Repo 已有可讀取的狀態資訊
- 已載入 `.ai/principles.md` 的決策框架（報告需含策略觀點）

---

## 流程（Process）

### Step 1: 掃描各子 PM 狀態 [autonomous]

依序讀取每個子 PM Repo：

1. **projects/MI_PM/**：
   - `00_context/01_north_star.md` — 產品方向
   - `01_inbox/` — 信號池現況
   - `05_product/` — Outcome / OPP / Backlog 進度
   - `.ai/memory/decisions.md` — 近期關鍵決策

2. **projects/VMS_PM/**：同上結構

3. **projects/SmartSignagePM/**：同上結構

產出：各子 PM 的狀態摘要（標準化格式）。

### Step 2: 識別跨專案模式 [autonomous]

基於各子 PM 狀態，分析：

1. **進度對比** — 各專案在 Discovery 流程中的位置
2. **風險熱點** — 有沒有 block 或延遲的項目
3. **協同機會** — 專案間是否有共用需求或可抽離的組件
4. **資源競爭** — 是否有多個專案同時需要相同資源

### Step 3: 撰寫策略觀點 [hybrid]

每份報告至少一個策略觀點，回答以下至少一題：

- 「目前最值得投資的全局槓桿是什麼？」
- 「哪個專案的進度會影響其他專案？」
- 「有沒有可以抽離為共同組件的機會？」
- 「團隊長期精進方向是否需要調整？」

輸出策略觀點草稿，等待使用者確認。

### Step 4: 組裝報告 [autonomous]

將以上內容組裝為完整報告：

1. **Executive Summary** — 一段話總結全局狀態
2. **各產品線狀態** — 標準化格式，一目了然
3. **跨專案觀點** — Step 3 的策略分析
4. **建議行動** — 具體的下一步建議
5. **風險與關注** — 需要上層關注的事項

若需要 pptx 格式，啟動 `util-pptx` 技能。

---

## 品質標準（Quality Gates）

- 報告涵蓋所有子 PM 的關鍵狀態（無遺漏）
- 至少包含一個跨專案策略觀點（不只是狀態搬運）
- 建議行動具體可執行（不是空泛的「持續關注」）
- 報告格式一致，利害關係人不需追問即可理解

---

## 已知限制（Limitations）

- 各子 PM 的資訊更新頻率不同，報告反映的是「讀取時的快照」
- 策略觀點基於已知資訊推論，重大決策仍需使用者確認
- 若子 PM 的狀態資訊不完整，報告會標記資訊缺口
