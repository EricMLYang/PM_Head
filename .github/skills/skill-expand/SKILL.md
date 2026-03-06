---
name: skill-expand
description: Convert a recurring task into a usable skill. Use when user says "幫我把 [某工作流程] 固化成一個技能", "我發現每次做 [某任務] 步驟都一樣", "這個 Repo 缺少 [某類型] 的技能", or "我想讓這個 Agent 學會 [某能力]".
---

# Skill: skill-expand — 技能擴充

## 用途（Purpose）

當角色 Agent 發現某個重複性任務沒有對應技能時，引導完成從「模糊感知」到「可用技能」的端到端流程。

- **輸入**：一個重複出現的任務場景描述（可以很粗略）
- **輸出**：完整的 Skill 目錄（SKILL.md + checklist.md + changelog.md + examples/）

## 何時使用（When to Use）

觸發條件符合以下任一項即啟動本技能：

- 「幫我把 [某工作流程] 固化成一個技能」
- 「我發現每次做 [某任務] 步驟都一樣，幫我做成 Skill」
- 「這個 Repo 缺少 [某類型] 的技能，幫我新增」
- 「我想讓這個 Agent 學會 [某能力]」

---

## 前置條件（Prerequisites）

- 使用者能描述這個技能「大概在做什麼」（不需要精確）
- 當前 Repo 有 `.github/skills/_index.yaml`（若無，先建立空檔案）
- 本 Skill 完全自包含，不依賴 RoleFoundry 路徑，複製到任意 Repo 後即可使用

---

## 流程（Process）

### Step 1: 識別任務模式 [hybrid]

詢問使用者（或基於上下文自主判斷）：

1. **觸發情境**：「什麼情況下你會需要做這件事？」（一句話觸發條件）
2. **主要產出**：「完成後，你拿到的是什麼？」（具體產出物）
3. **執行模式**：這個技能需要使用者互動嗎？
   - `interactive`：需要使用者提供資訊才能開始
   - `autonomous`：有明確輸入就能自主完成
   - `hybrid`：部分步驟需要確認

輸出：一段「技能識別摘要」，等待使用者確認或修正。

### Step 2: 設計 Skill 結構 [autonomous]

基於識別摘要，設計：

- **alias**：`動詞-名詞` 格式（kebab-case），例如 `arch-review`、`prd-write`
- **步驟清單**：3-6 個步驟，每步驟附執行模式標記
- **品質標準**：2-4 條可驗證的 Quality Gates
- **已知限制**：1-3 條誠實的限制說明

輸出：結構設計草稿，等待使用者確認。

### Step 3: 撰寫 SKILL.md [autonomous]

**必須遵循 Agent Skills 開放標準格式**，包含 YAML Frontmatter + Markdown Body：

```markdown
---
name: <alias>
description: <功能描述與觸發條件，1-2 句話說明用途和何時使用，最多 1024 字元>
---

# Skill: <alias> — <中文名稱>

## 用途（Purpose）
<1-2 句話說明解決什麼問題，明確說明輸入和輸出>

## 何時使用（When to Use）
<至少 2 個具體觸發句，使用者真實說的話>

## 前置條件（Prerequisites）
<執行前需要什麼才能開始>

## 流程（Process）

### Step 1: <步驟名> [interactive/autonomous/hybrid]
<步驟詳細說明>

### Step 2: <步驟名> [interactive/autonomous/hybrid]
<步驟詳細說明>

...

## 品質標準（Quality Gates）
<可客觀判斷的通過條件>

## 已知限制（Limitations）
<誠實說明這個技能做不到什麼>
```

**YAML Frontmatter 規範**：
- **name** (必填)：長度 1-64 字元，僅限小寫英文、數字與連字號，必須與資料夾名稱完全相同
- **description** (必填)：最多 1024 字元，必須包含「技能用途」和「觸發條件」，Agent 完全依賴此欄位判斷是否啟動技能

**Markdown Body 注意事項**：
- 每個步驟的觸發條件描述不超過 25 字
- 使用角色自身的語言和風格（不是 RoleFoundry 的語言）
- 步驟間的依賴關係要明確
- 流程步驟不超過 7 個（超過考慮拆分為兩個 Skill）
- 每個步驟的標題用動詞開頭（「收集需求」而非「需求」）

### Step 4: 建立支援檔案 [autonomous]

在技能目錄下建立：

1. **checklist.md**：每個 Quality Gate 對應一個 `[ ]` 項目，附簡短說明
2. **changelog.md**：記錄 `v1.0 (日期)` — 初始版本，列出主要特點
3. **examples/README.md**：說明「第一個真實使用案例」應記錄哪些內容

### Step 5: 更新 _index.yaml [autonomous]

在 `.github/skills/_index.yaml` 中新增：

```yaml
- alias: "<alias>"
  name: "<中文名稱>"
  trigger: "<一句話觸發條件>"
  mode: <interactive|autonomous|hybrid>
  path: ".github/skills/<alias>/SKILL.md"
```

確認：alias 無重複、trigger 不超過 25 字、path 路徑正確。

---

## 品質標準（Quality Gates）

- SKILL.md 頂部必須有 YAML Frontmatter（`---` 包圍的 name 和 description）
- name 欄位與資料夾名稱完全一致
- description 包含觸發條件關鍵字，不超過 1024 字元
- SKILL.md 包含完整 6 段落格式（用途、何時使用、前置條件、流程、品質標準、已知限制）
- 觸發條件（trigger）一句話說清楚，不超過 25 字
- 步驟數量在 3-7 個之間
- 每個步驟有明確的執行模式標記（interactive/autonomous/hybrid）
- _index.yaml 已更新，新技能可被正確觸發

---

## 已知限制（Limitations）

- 新技能的 SKILL.md 是「框架合規」的起點，內容品質需在真實使用後迭代
- examples/ 在初始版本中為空（只有 README.md），需要在第一次使用後補充
- 無法自動判斷新技能是否與現有技能重疊，需使用者確認
