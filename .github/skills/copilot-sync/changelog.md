# Changelog — copilot-sync

## v1.0 (2026-03-02)

**初始版本**

- 3 步驟流程：比對差異 → 確認更新範圍 → 更新橋接內容
- hybrid 執行模式（Step 1 自主比對，Step 2 互動確認，Step 3 自主更新）
- 明確定義「必要資訊清單」同步範圍，防止 AGENTS.md 詳細內容污染橋接檔
- 以 `_index.yaml` 為技能表的最終來源，確保技能資訊一致性
- 作為 RoleFoundry 預設技能，每個新鍛造的角色 Repo 自動內建
