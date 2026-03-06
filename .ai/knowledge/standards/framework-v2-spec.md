# Framework v2 規範精要

> 供 Skill 執行時快速確認合規性。完整文件見 RoleFoundry `context/framework/agent-role-repo-framework-v2.md`。

---

## 必要檔案清單

以下檔案在任何 Framework v2 Repo 中都必須存在：

| 檔案 | 用途 |
|------|------|
| `AGENTS.md` | 核心指令源，< 32KB |
| `CLAUDE.md` | Claude Code 橋接 |
| `GEMINI.md` | Gemini CLI 橋接（內容：`@./AGENTS.md`）|
| `.github/copilot-instructions.md` | Copilot 橋接（摘要版）|
| `.github/skills/_index.yaml` | 技能目錄 |
| `.ai/identity.yaml` | 角色身份卡 |
| `.ai/principles.md` | 決策原則 |
| `.ai/interfaces/exports.yaml` | 對外能力介面 |
| `.ai/interfaces/imports.yaml` | 外部依賴聲明 |
| `.ai/memory/decisions.md` | 設計決策記錄 |

---

## identity.yaml 必要欄位

```yaml
schema_version: "1.0"      # 必要
type: expert | project      # 必要
role:
  name:                     # 必要
  alias:                    # 必要（kebab-case）
  icon:                     # 建議
  one_liner:                # 必要（≤ 20 字）
identity:
  perspective:              # 必要（描述視角，非職責）
  tone:                     # 必要（具體風格，非「專業」）
capabilities:
  primary: []               # 必要
boundaries:
  owns: []                  # 必要
  advises: []               # 必要
  defers_to: []             # 必要（至少 1 條，含 on 欄位）
quality_criteria: []        # 必要（至少 3 條）
anti_patterns: []           # 必要（至少 3 條）
```

---

## Skill 目錄必要結構

每個 Skill 目錄必須包含：

```
.github/skills/<skill-alias>/
├── SKILL.md        # 必要
├── checklist.md    # 必要
├── changelog.md    # 必要
└── examples/       # 必要（目錄存在即可，內容可為空）
```

SKILL.md 必要段落：
1. 用途（Purpose）— 含輸入/輸出說明
2. 何時使用（When to Use）— 至少 2 個觸發句
3. 流程（Process）— 每步驟標記 `[interactive/autonomous/hybrid]`
4. 品質標準（Quality Gates）— 可客觀判斷
5. 已知限制（Limitations）

---

## _index.yaml 必要欄位

```yaml
skills:
  - name:              # 必要（中文）
    alias:             # 必要（kebab-case）
    trigger:           # 必要（一句話，≤ 25 字）
    description:       # 必要
    mode:              # 必要（interactive/autonomous/hybrid）
    phase:             # 建議
    path:              # 建議
```

---

## 橋接檔規範

| 橋接檔 | 內容要求 |
|--------|---------|
| `CLAUDE.md` | 至少包含「請閱讀 AGENTS.md」的明確重導向語句 |
| `GEMINI.md` | 必須包含 `@./AGENTS.md` |
| `copilot-instructions.md` | 摘要版（不能只是「請見 AGENTS.md」）；必須包含技能清單 |

---

## Expert vs Project Repo 區分

| 判斷點 | Expert | Project |
|--------|--------|---------|
| identity.type | `expert` | `project` |
| 知識複用範圍 | 跨多個專案 | 單一專案 |
| Skills 深度 | 深且廣，持續迭代 | 精簡，專案特有 |
| Memory 焦點 | 跨專案經驗 | 專案決策 |
