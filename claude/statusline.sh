#!/bin/bash
# Claude Code statusline
# stdin から JSON を受け取り、1行で表示する
#   📦 リポジトリ  🌿 ブランチ  #PR  🤖 モデル  🧠 使用トークン/上限 (n%)  💰 $cost

set -u

input=$(cat)
get() { jq -r "$1 // empty" <<< "$input" 2>/dev/null; }

MODEL=$(get '.model.display_name')
CWD=$(get '.workspace.current_dir')
CTX_SIZE=$(get '.context_window.context_window_size')
COST=$(get '.cost.total_cost_usd')

# /clear でリセットされるよう、累積値ではなく直近 API 呼び出しの current_usage から算出
CU_INPUT=$(get '.context_window.current_usage.input_tokens')
CU_CACHE_READ=$(get '.context_window.current_usage.cache_read_input_tokens')
CU_CACHE_CREATE=$(get '.context_window.current_usage.cache_creation_input_tokens')
USED_TOKENS=$(( ${CU_INPUT:-0} + ${CU_CACHE_READ:-0} + ${CU_CACHE_CREATE:-0} ))

# Git リポジトリ名・ブランチ
REPO=""
BRANCH=""
if [[ -n "${CWD:-}" ]]; then
  REPO_ROOT=$(git -C "$CWD" rev-parse --show-toplevel 2>/dev/null || true)
  [[ -n "$REPO_ROOT" ]] && REPO=$(basename "$REPO_ROOT")
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
if (( ${CTX_SIZE:-0} > 0 )); then
  PCT_INT=$(awk -v u="$USED_TOKENS" -v s="$CTX_SIZE" 'BEGIN { printf "%.0f", u*100/s }')
else
  PCT_INT=0
fi
COST_FMT=$(printf '%.2f' "${COST:-0}" 2>/dev/null || echo "0.00")

# コンテキスト使用率に応じて色付け
if   (( PCT_INT >= 80 )); then CTX_COLOR=$'\033[31m'   # red
elif (( PCT_INT >= 60 )); then CTX_COLOR=$'\033[33m'   # yellow
else                            CTX_COLOR=$'\033[32m'  # green
fi
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

LINE=""
[[ -n "$REPO"   ]] && LINE="${LINE}${BOLD}📦 ${REPO}${RESET}  "
[[ -n "$BRANCH" ]] && LINE="${LINE}🌿 ${BRANCH}  "
[[ -n "$PR"     ]] && LINE="${LINE}${DIM}#${PR}${RESET}  "
LINE="${LINE}🤖 ${MODEL:-?}  🧠 ${CTX_COLOR}${USED_FMT}/${SIZE_FMT} (${PCT_INT}%)${RESET}  💰 \$${COST_FMT}"

printf '%s' "$LINE"
