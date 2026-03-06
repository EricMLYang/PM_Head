---
name: repo-git-sync
description: Check and sync git status across all sub-PM repos. Use when user says "同步 git", "檢查各 repo 狀態", "pull 最新", "推送更新", "git sync", or "各專案 git 狀態".
---

# Skill: repo-git-sync — 子 Repo Git 同步

## 1️⃣ 元數據（Metadata）

| 欄位 | 值 |
|------|---|
| **名稱** | repo-git-sync |
| **用途** | 一次檢查 `projects/` 下所有子 PM Repo 的 git 狀態，並進行 pull / push 同步 |
| **模式** | hybrid（腳本自動執行 + 異常時 Agent 介入） |
| **觸發詞** | 「同步 git」「git sync」「檢查各 repo 狀態」「pull 最新」「推送更新」「各專案 git 狀態」 |

### 何時使用（When to Use）

- 任何涉及多 repo git 批量操作的請求
- 做報告前想確保資料是最新的
- 開始工作前的例行同步

### 前置條件（Prerequisites）

- `projects/` 目錄下有至少一個 git repo
- git CLI 已安裝且可存取
- 遠端認證已設定（Windows: HTTPS credential manager / Mac: SSH key）

---

## 2️⃣ 參數定義（Input Schema）

Agent 根據使用者意圖，決定傳遞給腳本的參數：

| 參數 | 型別 | 說明 | 預設 |
|------|------|------|------|
| `mode` | enum | 執行模式 | `status` |

**mode 選項對照表**：

| 使用者意圖 | mode 值 | 腳本參數 | 說明 |
|-----------|---------|---------|------|
| 「看一下狀態」「各 repo 狀態」 | `status` | `--status` | 僅顯示，不操作 |
| 「幫我 pull 最新」 | `pull` | `--pull` | 自動 pull 所有 repo |
| 「推送更新」 | `push` | `--push` | 自動 push 所有 repo |
| 「全部同步」「git sync」 | `sync` | `--sync` | pull + push |
| 不確定 / 模糊 | `status` | `--status` | 先看再說 |

---

## 3️⃣ 執行邏輯（Execution）

### 腳本位置

腳本封裝在本 Skill 目錄內，`tools/` 下為薄包裝入口：

```
.github/skills/repo-git-sync/
  scripts/
    git-sync.ps1    ← 本體（Windows PowerShell）
    git-sync.sh     ← 本體（macOS / Linux Bash）

tools/
  git-sync.ps1      ← 薄包裝，轉發至 ↑
  git-sync.sh       ← 薄包裝，轉發至 ↑
```

### ⚡ 核心原則：腳本執行，Agent 解讀

> **所有 git 操作一律透過腳本執行，Agent 不要逐一跑 git 指令。**
> Agent 的職責是：選參數 → 跑腳本 → 讀輸出 → 摘要回報 → 處理例外。

### 執行流程

#### Step 1: 跑腳本 [autonomous]

Agent 在終端執行一行指令：

```powershell
# Windows
.\tools\git-sync.ps1 --{mode}

# macOS / Linux
./tools/git-sync.sh --{mode}
```

> 也可直接呼叫 Skill 本體：
> `.\.github\skills\repo-git-sync\scripts\git-sync.ps1 --{mode}`

#### Step 2: 解讀輸出 [autonomous]

腳本輸出結構化結果，Agent 只需**讀取並摘要**：

| 輸出標記 | 含義 | Agent 動作 |
|---------|------|-----------|
| ✅ clean, up-to-date | 無需動作 | 回報「已是最新」 |
| ⬇️ N behind | 有遠端更新 | 回報待拉取數量（若 --pull/--sync 已自動處理） |
| ⬆️ N ahead | 有本地 commit | 回報待推送數量（若 --push/--sync 已自動處理） |
| ⚠️ N uncommitted | 有未提交變更 | 提醒使用者先 commit 或 stash |
| ❌ 失敗 | 操作失敗 | 進入 Step 3 異常處理 |

#### Step 3: 異常處理 [interactive]

**只有異常時**才需要 Agent 介入：

| 異常 | Agent 行為 |
|------|-----------|
| 認證失敗（HTTPS token 過期）| 提示重新登入 Git Credential Manager |
| 認證失敗（SSH key）| 提示 `ssh-add -l` 或 SSH agent |
| 分支分歧（diverged）| 詢問是否 `pull --rebase`，提醒可能有衝突 |
| merge conflict | 說明衝突位置，建議手動解決 |
| 腳本找不到 / 執行失敗 | 檢查路徑、git 是否安裝 |

**無異常時直接回報結果，不需額外確認。**

---

## 跨平台注意事項

腳本已內建跨平台處理，Agent 通常不需手動處理：

- **Windows**：預設 HTTPS + Git Credential Manager
- **macOS/Linux**：預設 SSH key（`~/.ssh/id_ed25519` 或 `~/.ssh/id_rsa`）
- 腳本會自動偵測每個 repo 的遠端協定（HTTPS/SSH）並標注在輸出中
