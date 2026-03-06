# Checklist — skill-expand 驗收清單

> 執行完 skill-expand Skill 後，用本清單確認產出品質。

---

## 核心檔案

- [ ] `SKILL.md` 存在，包含完整 6 段落格式（Purpose / When to Use / Prerequisites / Process / Quality Gates / Limitations）
- [ ] `checklist.md` 存在，每個 Quality Gate 對應至少一個可勾選項目
- [ ] `changelog.md` 存在，記錄 v1.0 版本與建立日期
- [ ] `examples/` 目錄存在（即使是空的，或只有 README.md）

## 內容品質

- [ ] 技能 alias 為 `動詞-名詞` 格式（kebab-case），例如 `arch-review`
- [ ] 觸發條件（trigger）一句話說清楚，不超過 25 字
- [ ] 流程步驟數量在 3-6 個之間
- [ ] 每個步驟都有執行模式標記：`[interactive]`、`[autonomous]` 或 `[hybrid]`
- [ ] SKILL.md 使用當前角色的語言風格（不是通用模板語言）

## 整合確認

- [ ] `.github/skills/_index.yaml` 已新增此技能的記錄
- [ ] _index.yaml 中的 alias 與 SKILL.md 目錄名稱一致
- [ ] _index.yaml 中的 path 指向正確位置
- [ ] 無與既有技能重複的 alias
