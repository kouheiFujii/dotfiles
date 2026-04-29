#!/bin/bash
# Claude Code statusline
# stdin から JSON を受け取り、1行で表示する
#   🤖 モデル  🌿 ブランチ  #PR  🧠 使用トークン/上限 (n%)  💰 $cost

set -u

input=$(cat)
get() { jq -r "$1 // empty" <<< "$input" 2>/dev/null; }

MODEL=$(get '.model.display_name')
CWD=$(get '.workspace.current_dir')
USED_TOKENS=$(get '.context_window.total_input_tokens')
CTX_SIZE=$(get '.context_window.context_window_size')
USED_PCT=$(get '.context_window.used_percentage')
COST=$(get '.cost.total_cost_usd')

# Git ブランチ
BRANCH=""
if [[ -n "${CWD:-}" ]]; then
  BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null || true)
fi

# PR 番号 — gh は遅いのでファイルキャッシュ + バックグラウンド更新
PR=""
if [[ -n "$BRANCH" ]] && command -v gh >/dev/null 2>&1; then
  CACHE_DIR="${TMPDIR:-/tmp}/claude-statusline"
  mkdir -p "$CACHE_DIR"
  REPO_KEY=$(echo "$CWD" | tr '/' '_')
  CACHE_FILE="$CACHE_DIR/pr_${REPO_KEY}_${BRANCH}"

  if [[ -f "$CACHE_FILE" ]]; then
    PR=$(<"$CACHE_FILE")
    AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || echo 0) ))
    if (( AGE > 300 )); then
      ( cd "$CWD" && gh pr view --json number -q .number 2>/dev/null > "$CACHE_FILE.tmp" \
          && mv "$CACHE_FILE.tmp" "$CACHE_FILE" ) &
      disown 2>/dev/null || true
    fi
  else
    ( cd "$CWD" && gh pr view --json number -q .number 2>/dev/null > "$CACHE_FILE" ) &
    disown 2>/dev/null || true
  fi
fi

# トークン数を 45k / 1.2k 形式に整形
fmt_tokens() {
  local n="${1:-0}"
  [[ -z "$n" || "$n" == "null" ]] && n=0
  if (( n >= 1000 )); then
    awk -v n="$n" 'BEGIN { if (n >= 100000) printf "%.0fk", n/1000; else printf "%.1fk", n/1000 }'
  else
    echo "$n"
  fi
}

USED_FMT=$(fmt_tokens "${USED_TOKENS:-0}")
SIZE_FMT=$(fmt_tokens "${CTX_SIZE:-0}")
PCT_INT=$(printf '%.0f' "${USED_PCT:-0}" 2>/dev/null || echo 0)
COST_FMT=$(printf '%.2f' "${COST:-0}" 2>/dev/null || echo "0.00")

# コンテキスト使用率に応じて色付け
if   (( PCT_INT >= 80 )); then CTX_COLOR=$'\033[31m'   # red
elif (( PCT_INT >= 60 )); then CTX_COLOR=$'\033[33m'   # yellow
else                            CTX_COLOR=$'\033[32m'  # green
fi
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

LINE="${BOLD}🤖 ${MODEL:-?}${RESET}"
[[ -n "$BRANCH" ]] && LINE="${LINE}  🌿 ${BRANCH}"
[[ -n "$PR"     ]] && LINE="${LINE}  ${DIM}#${PR}${RESET}"
LINE="${LINE}  🧠 ${CTX_COLOR}${USED_FMT}/${SIZE_FMT} (${PCT_INT}%)${RESET}  💰 \$${COST_FMT}"

printf '%s' "$LINE"
