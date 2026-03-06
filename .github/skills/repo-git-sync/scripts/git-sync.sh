#!/usr/bin/env bash
# ──────────────────────────────────────────────────────
# PM_Head — 子 Repo Git 狀態檢查與同步工具 (macOS / Linux)
#
# Usage:
#   ./tools/git-sync.sh              # 互動模式
#   ./tools/git-sync.sh --status     # 僅顯示狀態
#   ./tools/git-sync.sh --pull       # 自動 pull
#   ./tools/git-sync.sh --push       # 自動 push
#   ./tools/git-sync.sh --sync       # 自動 pull + push
# ──────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 尋找 repo root：從腳本位置往上找到含 AGENTS.md 的目錄
REPO_ROOT="$SCRIPT_DIR"
for _ in $(seq 1 10); do
    [ -f "$REPO_ROOT/AGENTS.md" ] && break
    REPO_ROOT="$(dirname "$REPO_ROOT")"
done
PROJECTS_DIR="$REPO_ROOT/projects"

if [ ! -d "$PROJECTS_DIR" ]; then
    echo "❌ 找不到 projects/ 目錄"
    echo "   預期路徑: $PROJECTS_DIR"
    exit 1
fi

# ── 參數解析 ──────────────────────────────────────────

MODE="interactive"
case "${1:-}" in
    --status) MODE="status" ;;
    --pull)   MODE="pull" ;;
    --push)   MODE="push" ;;
    --sync)   MODE="sync" ;;
    --help|-h)
        cat <<EOF

  PM_Head Git Sync Tool
  =====================
  Usage: ./tools/git-sync.sh [--status] [--pull] [--push] [--sync]

  Options:
    --status   僅顯示各 repo 狀態
    --pull     自動 pull 所有 repo
    --push     自動 push 所有 repo
    --sync     自動 pull + push
    (無參數)    互動模式

EOF
        exit 0
        ;;
esac

# ── 輔助函式 ──────────────────────────────────────────

get_protocol() {
    local url="$1"
    if [[ "$url" == https://* ]]; then echo "HTTPS"
    elif [[ "$url" == git@* ]];   then echo "SSH"
    else echo "Unknown"
    fi
}

# ── 掃描 repos ────────────────────────────────────────

repos=()
for dir in "$PROJECTS_DIR"/*/; do
    if [ -d "$dir/.git" ]; then
        repos+=("$dir")
    fi
done

if [ ${#repos[@]} -eq 0 ]; then
    echo "⚠️  projects/ 下沒有找到任何 git repo"
    exit 0
fi

repo_names=()
for r in "${repos[@]}"; do
    repo_names+=("$(basename "$r")")
done

echo ""
echo "🔍 掃描到 ${#repos[@]} 個 repo：${repo_names[*]}"
echo "   路徑: $PROJECTS_DIR"
echo ""

# ── 狀態收集 ──────────────────────────────────────────

# 平行陣列存狀態
declare -a st_names st_branches st_urls st_protocols st_uncommitted st_ahead st_behind st_texts

idx=0
for repo_path in "${repos[@]}"; do
    repo_name="$(basename "$repo_path")"
    echo "📁 $repo_name"

    cd "$repo_path"

    # 當前分支
    branch=$(git branch --show-current 2>/dev/null || echo "(detached)")

    # 遠端 URL
    remote_url=$(git remote get-url origin 2>/dev/null || echo "(no remote)")
    protocol=$(get_protocol "$remote_url")

    # Fetch
    printf "   Fetching..."
    git fetch --all --quiet 2>/dev/null || true
    echo " done"

    # 工作區狀態
    porcelain=$(git status --porcelain 2>/dev/null || true)
    uncommitted=0
    if [ -n "$porcelain" ]; then
        uncommitted=$(echo "$porcelain" | wc -l | tr -d ' ')
    fi

    # Ahead / Behind
    status_branch=$(git status -sb 2>/dev/null | head -1)
    ahead=0
    behind=0
    if [[ "$status_branch" =~ \[ahead\ ([0-9]+) ]]; then
        ahead="${BASH_REMATCH[1]}"
    fi
    if [[ "$status_branch" =~ behind\ ([0-9]+) ]]; then
        behind="${BASH_REMATCH[1]}"
    fi

    # 格式化狀態
    parts=()
    [ "$uncommitted" -gt 0 ] && parts+=("⚠️  ${uncommitted} uncommitted")
    [ "$ahead" -gt 0 ]       && parts+=("⬆️  ${ahead} ahead")
    [ "$behind" -gt 0 ]      && parts+=("⬇️  ${behind} behind")
    if [ ${#parts[@]} -eq 0 ]; then
        status_text="✅ clean, up-to-date"
    else
        status_text=$(IFS=" | "; echo "${parts[*]}")
    fi

    echo "   分支: $branch"
    echo "   遠端: $remote_url ($protocol)"
    echo "   狀態: $status_text"
    echo ""

    st_names[$idx]="$repo_name"
    st_branches[$idx]="$branch"
    st_urls[$idx]="$remote_url"
    st_protocols[$idx]="$protocol"
    st_uncommitted[$idx]="$uncommitted"
    st_ahead[$idx]="$ahead"
    st_behind[$idx]="$behind"
    st_texts[$idx]="$status_text"

    idx=$((idx + 1))
done

cd "$SCRIPT_DIR/.."

# ── 僅狀態模式 ────────────────────────────────────────

if [ "$MODE" = "status" ]; then
    echo "── 狀態報告完成 ──"
    exit 0
fi

# ── 同步計畫 ──────────────────────────────────────────

needs_action=false
for i in $(seq 0 $((idx - 1))); do
    if [ "${st_behind[$i]}" -gt 0 ] || [ "${st_ahead[$i]}" -gt 0 ] || [ "${st_uncommitted[$i]}" -gt 0 ]; then
        needs_action=true
        break
    fi
done

if [ "$needs_action" = false ]; then
    echo "✅ 所有 repo 都是最新狀態，無需同步"
    exit 0
fi

echo "── 同步計畫 ──"

# 顯示警告
for i in $(seq 0 $((idx - 1))); do
    if [ "${st_uncommitted[$i]}" -gt 0 ]; then
        echo "⚠️  ${st_names[$i]}: ${st_uncommitted[$i]} 個未提交的檔案"
    fi
done

for i in $(seq 0 $((idx - 1))); do
    if [ "${st_ahead[$i]}" -gt 0 ] && [ "${st_behind[$i]}" -gt 0 ]; then
        echo "⚠️  ${st_names[$i]}: 分支已分歧 (${st_ahead[$i]} ahead, ${st_behind[$i]} behind)"
    fi
done

for i in $(seq 0 $((idx - 1))); do
    if [ "${st_behind[$i]}" -gt 0 ]; then
        echo "⬇️  ${st_names[$i]}: ${st_behind[$i]} commits behind → 需要 pull"
    fi
done

for i in $(seq 0 $((idx - 1))); do
    if [ "${st_ahead[$i]}" -gt 0 ] && [ "${st_uncommitted[$i]}" -eq 0 ]; then
        echo "⬆️  ${st_names[$i]}: ${st_ahead[$i]} commits ahead → 需要 push"
    fi
done

# ── 互動確認 ──────────────────────────────────────────

do_pull=false
do_push=false

case "$MODE" in
    pull) do_pull=true ;;
    push) do_push=true ;;
    sync) do_pull=true; do_push=true ;;
    interactive)
        echo ""
        echo "選擇操作:"
        echo "  [A] 全部同步 (pull + push)"
        echo "  [P] 僅 pull"
        echo "  [U] 僅 push"
        echo "  [S] 跳過"
        echo ""
        read -r -p "請選擇 (A/P/U/S): " choice
        case "${choice^^}" in
            A) do_pull=true; do_push=true ;;
            P) do_pull=true ;;
            U) do_push=true ;;
            S) echo "⏭️  已跳過同步"; exit 0 ;;
            *) echo "❌ 無效選擇，已取消"; exit 1 ;;
        esac
        ;;
esac

# ── 執行同步 ──────────────────────────────────────────

declare -a res_repo res_op res_result
res_idx=0

if [ "$do_pull" = true ]; then
    for i in $(seq 0 $((idx - 1))); do
        if [ "${st_behind[$i]}" -gt 0 ]; then
            if [ "${st_uncommitted[$i]}" -gt 0 ]; then
                echo "⏭️  ${st_names[$i]}: 跳過 pull（有未提交變更）"
                res_repo[$res_idx]="${st_names[$i]}"
                res_op[$res_idx]="pull"
                res_result[$res_idx]="⏭️ 跳過"
                res_idx=$((res_idx + 1))
                continue
            fi

            printf "⬇️  %s: pulling..." "${st_names[$i]}"
            cd "${repos[$i]}"
            if git pull --rebase origin "${st_branches[$i]}" 2>&1; then
                echo " ✅"
                res_result[$res_idx]="✅ 成功"
            else
                echo " ❌"
                res_result[$res_idx]="❌ 失敗"
            fi
            res_repo[$res_idx]="${st_names[$i]}"
            res_op[$res_idx]="pull --rebase"
            res_idx=$((res_idx + 1))
            cd "$SCRIPT_DIR/.."
        fi
    done
fi

if [ "$do_push" = true ]; then
    for i in $(seq 0 $((idx - 1))); do
        if [ "${st_ahead[$i]}" -gt 0 ] && [ "${st_uncommitted[$i]}" -eq 0 ]; then
            printf "⬆️  %s: pushing..." "${st_names[$i]}"
            cd "${repos[$i]}"
            if git push origin "${st_branches[$i]}" 2>&1; then
                echo " ✅"
                res_result[$res_idx]="✅ 成功"
            else
                echo " ❌"
                res_result[$res_idx]="❌ 失敗"
            fi
            res_repo[$res_idx]="${st_names[$i]}"
            res_op[$res_idx]="push"
            res_idx=$((res_idx + 1))
            cd "$SCRIPT_DIR/.."
        fi
    done
fi

# ── 同步報告 ──────────────────────────────────────────

echo ""
echo "══ Git Sync Report — $(date '+%Y-%m-%d %H:%M') ══"
echo ""

if [ "$res_idx" -gt 0 ]; then
    printf "%-20s %-15s %s\n" "Repo" "Op" "Result"
    printf "%-20s %-15s %s\n" "----" "--" "------"
    for i in $(seq 0 $((res_idx - 1))); do
        printf "%-20s %-15s %s\n" "${res_repo[$i]}" "${res_op[$i]}" "${res_result[$i]}"
    done
else
    echo "  無需執行任何同步操作"
fi

echo ""
echo "── 完成 ──"
