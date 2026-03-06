# Examples — repo-git-sync

## 使用情境

### 情境 1: 每日開始工作前
```
使用者：幫我檢查各專案 git 狀態
→ 觸發 repo-git-sync，顯示所有 repo 狀態
→ 使用者選擇「全部同步」
```

### 情境 2: 彙整報告前確認資料最新
```
使用者：先 pull 最新再幫我做報告
→ 觸發 repo-git-sync --pull
→ 完成後自動接續 portfolio-report
```

### 情境 3: 只想看狀態不同步
```
使用者：各 repo 有沒有還沒 push 的東西？
→ 觸發 repo-git-sync --status
→ 僅顯示狀態報告
```
