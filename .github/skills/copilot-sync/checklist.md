# Checklist — copilot-sync 驗收清單

> 執行完 copilot-sync Skill 後，用本清單確認橋接同步品質。

---

## 同步完整性

- [ ] 已讀取 `_index.yaml` 作為技能表的最終來源（不是直接從 AGENTS.md 取技能資訊）
- [ ] 同步差異報告涵蓋所有 5 個必要資訊區塊（角色識別、技能表、工作規範、目錄快查、AGENTS.md 連結）
- [ ] 若有 ⚠️ 項目，已展示「現況 → 建議內容」對比並取得使用者確認

## 內容品質

- [ ] copilot-instructions.md 的技能表與 `_index.yaml` 一致（alias、trigger、mode 三欄）
- [ ] 角色識別（one_liner、perspective）與 `identity.yaml` / `AGENTS.md` 一致
- [ ] 橋接檔未引入詳細原則、跨 Repo 規則或 Agent 特定說明等「只在 AGENTS.md」的內容

## 必要元素

- [ ] 「完整版請參閱 AGENTS.md」連結存在，且未被移除
- [ ] 更新後檔案長度 ≤ 60 行（若超過，需說明原因）

## 流程記錄

- [ ] 若使用者選擇部分更新，已記錄跳過項目的決策原因
