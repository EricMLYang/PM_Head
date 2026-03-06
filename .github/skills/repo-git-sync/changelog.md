# Changelog — repo-git-sync

## v1.1 — 2026-03-06
- 腳本封裝至 Skill 目錄（`.github/skills/repo-git-sync/scripts/`）
- `tools/` 改為薄包裝，轉發至 Skill 腳本
- SKILL.md 重構為三段式結構（元數據 / 參數定義 / 執行邏輯）
- 腳本路徑解析改為從 repo root 向下尋找，不依賴相對父目錄

## v1.0 — 2026-03-06
- 初始版本
- 支援 `projects/` 下多 repo git 狀態檢查
- 支援 pull / push 互動同步
- 跨平台（Windows HTTPS / macOS SSH）
- 提供 PowerShell 與 Bash 輔助腳本
