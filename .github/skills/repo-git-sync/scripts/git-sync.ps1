<#
.SYNOPSIS
    PM_Head — 子 Repo Git 狀態檢查與同步工具 (Windows PowerShell)

.DESCRIPTION
    掃描 projects/ 下所有 git repo，檢查狀態並進行同步。
    支援 HTTPS / SSH 遠端協定。

.PARAMETER Mode
    執行模式：
      status — 僅顯示狀態（預設）
      pull   — 自動 pull 所有 repo
      push   — 自動 push 所有 repo
      sync   — 自動 pull + push 所有 repo
      (無)   — 互動模式，逐步確認

.EXAMPLE
    .\tools\git-sync.ps1
    .\tools\git-sync.ps1 --status
    .\tools\git-sync.ps1 --pull
    .\tools\git-sync.ps1 --sync
#>

param(
    [switch]$status,
    [switch]$pull,
    [switch]$push,
    [switch]$sync,
    [switch]$help
)

# ── 設定 ──────────────────────────────────────────────
$ErrorActionPreference = "Continue"

# 尋找 repo root：從腳本位置往上找到含 AGENTS.md 的目錄
$RepoRoot = $PSScriptRoot
for ($i = 0; $i -lt 10; $i++) {
    if (Test-Path (Join-Path $RepoRoot "AGENTS.md")) { break }
    $RepoRoot = Split-Path $RepoRoot -Parent
}
$ProjectsDir = Join-Path $RepoRoot "projects"

if (-not (Test-Path $ProjectsDir)) {
    Write-Host "❌ 找不到 projects/ 目錄" -ForegroundColor Red
    Write-Host "   預期路徑: $ProjectsDir"
    exit 1
}

# ── 輔助函式 ──────────────────────────────────────────

function Get-GitProtocol {
    param([string]$Url)
    if ($Url -match "^https?://") { return "HTTPS" }
    if ($Url -match "^git@")      { return "SSH" }
    return "Unknown"
}

function Get-BranchStatus {
    param([string]$StatusBranch)
    $ahead  = 0
    $behind = 0
    if ($StatusBranch -match "\[ahead (\d+)") { $ahead = [int]$Matches[1] }
    if ($StatusBranch -match "behind (\d+)")  { $behind = [int]$Matches[1] }
    return @{ Ahead = $ahead; Behind = $behind }
}

function Format-StatusEmoji {
    param(
        [int]$Uncommitted,
        [int]$Ahead,
        [int]$Behind
    )
    $parts = @()
    if ($Uncommitted -gt 0) { $parts += "⚠️  $Uncommitted uncommitted" }
    if ($Ahead -gt 0)       { $parts += "⬆️  $Ahead ahead" }
    if ($Behind -gt 0)      { $parts += "⬇️  $Behind behind" }
    if ($parts.Count -eq 0) { return "✅ clean, up-to-date" }
    return ($parts -join " | ")
}

# ── Help ──────────────────────────────────────────────

if ($help) {
    Write-Host @"

  PM_Head Git Sync Tool
  =====================
  Usage: .\tools\git-sync.ps1 [--status] [--pull] [--push] [--sync]

  Options:
    --status   僅顯示各 repo 狀態
    --pull     自動 pull 所有 repo
    --push     自動 push 所有 repo
    --sync     自動 pull + push
    (無參數)    互動模式

"@
    exit 0
}

# ── 主流程 ────────────────────────────────────────────

# 掃描 repos
$repos = Get-ChildItem -Path $ProjectsDir -Directory | Where-Object {
    Test-Path (Join-Path $_.FullName ".git")
}

if ($repos.Count -eq 0) {
    Write-Host "⚠️  projects/ 下沒有找到任何 git repo" -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "🔍 掃描到 $($repos.Count) 個 repo：$($repos.Name -join ', ')" -ForegroundColor Cyan
Write-Host "   路徑: $ProjectsDir"
Write-Host ""

# ── Step 1: Fetch + 收集狀態 ──────────────────────────

$repoStatuses = @()

foreach ($repo in $repos) {
    $repoPath = $repo.FullName
    $repoName = $repo.Name

    Write-Host "📁 $repoName" -ForegroundColor White

    Push-Location $repoPath
    try {
        # 當前分支
        $branch = git branch --show-current 2>$null
        if (-not $branch) { $branch = "(detached)" }

        # 遠端 URL
        $remoteUrl = git remote get-url origin 2>$null
        if (-not $remoteUrl) { $remoteUrl = "(no remote)" }
        $protocol = Get-GitProtocol $remoteUrl

        # Fetch
        Write-Host "   Fetching..." -ForegroundColor DarkGray -NoNewline
        git fetch --all --quiet 2>$null
        Write-Host " done" -ForegroundColor DarkGray

        # 工作區狀態
        $porcelain = git status --porcelain 2>$null
        $uncommitted = if ($porcelain) { ($porcelain | Measure-Object).Count } else { 0 }

        # Ahead / Behind
        $statusBranch = git status -sb 2>$null | Select-Object -First 1
        $branchInfo = Get-BranchStatus $statusBranch

        # 格式化
        $statusText = Format-StatusEmoji -Uncommitted $uncommitted -Ahead $branchInfo.Ahead -Behind $branchInfo.Behind

        Write-Host "   分支: $branch" -ForegroundColor Gray
        Write-Host "   遠端: $remoteUrl ($protocol)" -ForegroundColor Gray
        Write-Host "   狀態: $statusText"
        Write-Host ""

        $repoStatuses += [PSCustomObject]@{
            Name        = $repoName
            Path        = $repoPath
            Branch      = $branch
            RemoteUrl   = $remoteUrl
            Protocol    = $protocol
            Uncommitted = $uncommitted
            Ahead       = $branchInfo.Ahead
            Behind      = $branchInfo.Behind
            StatusText  = $statusText
        }
    }
    finally {
        Pop-Location
    }
}

# ── Step 2: 若是 --status 模式，到此結束 ─────────────

if ($status) {
    Write-Host "── 狀態報告完成 ──" -ForegroundColor Green
    exit 0
}

# ── Step 3: 同步操作 ──────────────────────────────────

# 判斷模式
$doPull  = $pull -or $sync
$doPush  = $push -or $sync
$interactive = -not ($pull -or $push -or $sync)

# 找出需要操作的 repos
$needsPull  = $repoStatuses | Where-Object { $_.Behind -gt 0 }
$needsPush  = $repoStatuses | Where-Object { $_.Ahead -gt 0 -and $_.Uncommitted -eq 0 }
$hasChanges = $repoStatuses | Where-Object { $_.Uncommitted -gt 0 }
$diverged   = $repoStatuses | Where-Object { $_.Ahead -gt 0 -and $_.Behind -gt 0 }

# 報告需要操作的項目
if ($needsPull.Count -eq 0 -and $needsPush.Count -eq 0 -and $hasChanges.Count -eq 0) {
    Write-Host "✅ 所有 repo 都是最新狀態，無需同步" -ForegroundColor Green
    exit 0
}

Write-Host "── 同步計畫 ──" -ForegroundColor Cyan

if ($hasChanges.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  有未提交變更（建議先 commit 或 stash）:" -ForegroundColor Yellow
    foreach ($r in $hasChanges) {
        Write-Host "   - $($r.Name): $($r.Uncommitted) 個檔案" -ForegroundColor Yellow
    }
}

if ($diverged.Count -gt 0) {
    Write-Host ""
    Write-Host "⚠️  分支已分歧（可能有衝突）:" -ForegroundColor Yellow
    foreach ($r in $diverged) {
        Write-Host "   - $($r.Name): $($r.Ahead) ahead, $($r.Behind) behind" -ForegroundColor Yellow
    }
}

if ($needsPull.Count -gt 0) {
    Write-Host ""
    Write-Host "⬇️  需要 pull:" -ForegroundColor Cyan
    foreach ($r in $needsPull) {
        Write-Host "   - $($r.Name): $($r.Behind) commits behind"
    }
}

if ($needsPush.Count -gt 0) {
    Write-Host ""
    Write-Host "⬆️  需要 push:" -ForegroundColor Cyan
    foreach ($r in $needsPush) {
        Write-Host "   - $($r.Name): $($r.Ahead) commits ahead"
    }
}

# ── 互動模式確認 ──────────────────────────────────────

if ($interactive) {
    Write-Host ""
    Write-Host "選擇操作:" -ForegroundColor White
    Write-Host "  [A] 全部同步 (pull + push 可安全操作的 repo)"
    Write-Host "  [P] 僅 pull"
    Write-Host "  [U] 僅 push"
    Write-Host "  [S] 跳過"
    Write-Host ""
    $choice = Read-Host "請選擇 (A/P/U/S)"

    switch ($choice.ToUpper()) {
        "A" { $doPull = $true; $doPush = $true }
        "P" { $doPull = $true }
        "U" { $doPush = $true }
        "S" {
            Write-Host "⏭️  已跳過同步" -ForegroundColor Gray
            exit 0
        }
        default {
            Write-Host "❌ 無效選擇，已取消" -ForegroundColor Red
            exit 1
        }
    }
}

# ── 執行同步 ──────────────────────────────────────────

$results = @()

if ($doPull) {
    foreach ($r in $needsPull) {
        # 跳過有未提交變更的 repo（除非無分歧）
        if ($r.Uncommitted -gt 0) {
            Write-Host "⏭️  $($r.Name): 跳過 pull（有未提交變更）" -ForegroundColor Yellow
            $results += [PSCustomObject]@{ Repo = $r.Name; Op = "pull"; Result = "⏭️ 跳過（有未提交變更）" }
            continue
        }

        Write-Host "⬇️  $($r.Name): pulling..." -ForegroundColor Cyan -NoNewline
        Push-Location $r.Path
        try {
            $pullOutput = git pull --rebase origin $r.Branch 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host " ✅" -ForegroundColor Green
                $results += [PSCustomObject]@{ Repo = $r.Name; Op = "pull --rebase"; Result = "✅ 成功" }
            } else {
                Write-Host " ❌" -ForegroundColor Red
                Write-Host "   $pullOutput" -ForegroundColor Red
                $results += [PSCustomObject]@{ Repo = $r.Name; Op = "pull --rebase"; Result = "❌ 失敗: $pullOutput" }
            }
        }
        finally { Pop-Location }
    }
}

if ($doPush) {
    foreach ($r in $needsPush) {
        Write-Host "⬆️  $($r.Name): pushing..." -ForegroundColor Cyan -NoNewline
        Push-Location $r.Path
        try {
            $pushOutput = git push origin $r.Branch 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host " ✅" -ForegroundColor Green
                $results += [PSCustomObject]@{ Repo = $r.Name; Op = "push"; Result = "✅ 成功" }
            } else {
                Write-Host " ❌" -ForegroundColor Red
                Write-Host "   $pushOutput" -ForegroundColor Red
                $results += [PSCustomObject]@{ Repo = $r.Name; Op = "push"; Result = "❌ 失敗: $pushOutput" }
            }
        }
        finally { Pop-Location }
    }
}

# ── 同步報告 ──────────────────────────────────────────

Write-Host ""
Write-Host "══ Git Sync Report — $(Get-Date -Format 'yyyy-MM-dd HH:mm') ══" -ForegroundColor Green
Write-Host ""

if ($results.Count -gt 0) {
    $results | Format-Table -Property Repo, Op, Result -AutoSize
} else {
    Write-Host "  無需執行任何同步操作" -ForegroundColor Gray
}

Write-Host "── 完成 ──" -ForegroundColor Green
