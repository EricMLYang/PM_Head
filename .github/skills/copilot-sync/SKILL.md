---
name: copilot-sync
description: Sync AGENTS.md changes to copilot-instructions.md. Use when user says "AGENTS.md 有修改,幫我確認 copilot-instructions.md", "確認橋接同步狀態", or after role-bootstrap.
---

# Skill: copilot-sync — Copilot 橋接同步

## 用途（Purpose）

當 `AGENTS.md` 有變更後，比對並更新 `copilot-instructions.md`（橋接檔），確保 Copilot 取得正確的角色識別與技能資訊。

- **輸入**：已更新的 `AGENTS.md` 或使用者指示「確認同步狀態」
- **輸出**：已驗證或已更新的 `copilot-instructions.md`，附同步差異報告

## 何時使用（When to Use）

觸發條件符合以下任一項即啟動本技能：

- 「AGENTS.md 有修改，幫我確認 copilot-instructions.md 是否需要更新」
- 「確認橋接同步狀態」
- 「copilot-instructions.md 可能過時了」
- 完成 `role-bootstrap` 或修改核心身份檔案後的例行確認

---

## 前置條件（Prerequisites）

- `AGENTS.md` 已存在且內容為最新
- `.github/copilot-instructions.md` 已存在（橋接檔）
- `.github/skills/_index.yaml` 已存在（技能表的最終來源）

---

## 必要資訊清單（Sync Scope）

| 區塊 | copilot-instructions.md 的範圍 | 同步規則 |
|------|-------------------------------|---------|
| 角色識別 | name、alias、one_liner、perspective（一句話）、owns（摘要）、defers_to（摘要）| 必須同步 |
| 核心技能表 | 從 `_index.yaml` 讀取：alias、trigger、mode | 必須同步（以 _index.yaml 為準）|
| 工作規範 | 最多 4 條核心規則，不展開細節 | 有結構性大改時同步 |
| 目錄快查 | 最多 10 條，格式簡化 | 有新增/移除目錄時同步 |
| 連結 | 「完整版請參閱 AGENTS.md」 | 永遠保留，不可刪除 |

**不需要同步**（只在 AGENTS.md）：詳細決策原則、跨 Repo 協作規則、Agent 特定補充段落、框架層細節。

---

## 流程（Process）

### Step 1: 比對差異 [autonomous]

讀取以下三個來源，對照「必要資訊清單」：

1. `AGENTS.md` — 取得角色識別、工作規範、目錄結構的現況
2. `.github/skills/_index.yaml` — 取得技能表的最終來源（alias、trigger、mode）
3. `.github/copilot-instructions.md` — 取得橋接檔的現況

比對每個必要資訊區塊，輸出「同步差異報告」：

```
## 同步差異報告

### 角色識別
狀態：✅ 已同步 / ⚠️ 需更新 / ℹ️ 無需同步
（若需更新，列出具體差異）

### 核心技能表
狀態：✅ 已同步 / ⚠️ 需更新 / ℹ️ 無需同步
（若需更新，列出 _index.yaml 中有但橋接檔缺少或過時的技能）

### 工作規範
狀態：✅ 已同步 / ⚠️ 需更新 / ℹ️ 無需同步
（若需更新，說明結構性變更的內容）

### 目錄快查
狀態：✅ 已同步 / ⚠️ 需更新 / ℹ️ 無需同步
（若需更新，列出新增或移除的目錄條目）

### 「完整版請參閱 AGENTS.md」連結
狀態：✅ 存在 / ❌ 缺失（需立即補充）
```

### Step 2: 確認更新範圍 [interactive]

若 Step 1 報告有任何 ⚠️ 或 ❌ 項目：

1. 展示每個需更新項目的「現況 → 建議內容」對比
2. 詢問使用者：「以上項目全部更新，或選擇部分更新？」
3. 若使用者選擇部分更新，記錄跳過項目的決策原因（供未來參考）

若所有項目皆為 ✅，告知使用者橋接檔已是最新狀態，流程結束。

### Step 3: 更新橋接內容 [autonomous]

按使用者確認的範圍，更新 `.github/copilot-instructions.md`：

- **只更新有變動的區塊**，保留其他不需更新的段落
- **必須保留**「完整版請參閱 AGENTS.md」連結（無論如何不可刪除）
- **不引入**任何「只在 AGENTS.md」的詳細內容（詳細原則、跨 Repo 規則等）
- **確認長度**：更新後 copilot-instructions.md 應在合理範圍（建議 ≤ 60 行）

更新完成後，輸出：
- 已更新的區塊清單
- 最終檔案行數
- 若有跳過的項目，附上記錄的決策原因

---

## 品質標準（Quality Gates）

- 技能表與 `_index.yaml` 完全一致（alias、trigger、mode 三欄）
- 角色識別（one_liner、perspective）與 `identity.yaml` 或 `AGENTS.md` 一致
- 「完整版請參閱 AGENTS.md」連結存在
- 橋接檔未引入「只在 AGENTS.md」的詳細內容
- 更新後檔案長度 ≤ 60 行

---

## 已知限制（Limitations）

- 本技能不會自動偵測 AGENTS.md 的變更，需使用者主動觸發
- 「工作規範」是否有「結構性大改」由使用者判斷，Agent 只提供比對結果
- 無法保證 copilot-instructions.md 對所有 Copilot 版本都有效；只保證內容同步
