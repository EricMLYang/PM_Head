# Checklist — repo-git-sync 驗收清單

- [ ] 是否掃描了 `projects/` 下所有含 `.git/` 的子目錄？
- [ ] 是否正確偵測每個 repo 的當前分支？
- [ ] 是否執行了 `git fetch` 以取得遠端最新狀態？
- [ ] 是否正確判斷 ahead / behind / diverged / clean 狀態？
- [ ] 是否標示了遠端協定（HTTPS / SSH）？
- [ ] 有未提交變更的 repo 是否有警告提示？
- [ ] 同步操作是否等待使用者確認後才執行？
- [ ] 同步結果是否以報告格式呈現？
