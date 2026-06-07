#!/bin/bash
# Claude Code statusline (2 行表示)
#   1 行目: 📦 リポジトリ  🌿 ブランチ  #PR
#   2 行目: 🧠 コンテキスト(バー)  ⏱ セッション(5h)  📅 週間(7d)

set -u

input=$(cat)
get() { jq -r "$1 // empty" <<< "$input" 2>/dev/null; }

CWD=$(get '.workspace.current_dir')
CTX_SIZE=$(get '.context_window.context_window_size')

# /clear でリセットされるよう、累積値ではなく直近 API 呼び出しの current_usage から算出
CU_INPUT=$(get '.context_window.current_usage.input_tokens')
CU_CACHE_READ=$(get '.context_window.current_usage.cache_read_input_tokens')
CU_CACHE_CREATE=$(get '.context_window.current_usage.cache_creation_input_tokens')
USED_TOKENS=$(( ${CU_INPUT:-0} + ${CU_CACHE_READ:-0} + ${CU_CACHE_CREATE:-0} ))

# レート制限（Pro/Max のみ。無ければ非表示）
RL5=$(get '.rate_limits.five_hour.used_percentage')
RL5_RESET=$(get '.rate_limits.five_hour.resets_at')
RL7=$(get '.rate_limits.seven_day.used_percentage')

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

# ---- ヘルパ ----
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
RED=$'\033[31m'

# 使用率に応じた色（緑 〜49% / 黄 50〜79% / 赤 80%〜）
pct_color() {
  local p=${1%.*}; p=${p:-0}
  if   (( p >= 80 )); then printf '%s' "$RED"
  elif (( p >= 50 )); then printf '%s' "$YELLOW"
  else                     printf '%s' "$GREEN"; fi
}

# 10 マスのバー [████░░░░░░]
bar10() {
  local p=${1%.*}; p=${p:-0}
  local filled=$(( (p + 5) / 10 )); (( filled > 10 )) && filled=10; (( filled < 0 )) && filled=0
  local b="" i=0
  while (( i < 10 )); do
    if (( i < filled )); then b+="█"; else b+="░"; fi
    i=$((i+1))
  done
  printf '%s' "$b"
}

# epoch → HH:MM（BSD/macOS と GNU/Linux の両対応）
epoch_to_hm() {
  local e="$1"
  [[ -z "$e" || "$e" == "null" ]] && return
  date -r "$e" +%H:%M 2>/dev/null || date -d "@$e" +%H:%M 2>/dev/null
}

# ===== 1 行目 =====
LINE1=""
[[ -n "$REPO"   ]] && LINE1="${LINE1}${BOLD}📦 ${REPO}${RESET}  "
[[ -n "$BRANCH" ]] && LINE1="${LINE1}🌿 ${BRANCH}  "
[[ -n "$PR"     ]] && LINE1="${LINE1}${DIM}#${PR}${RESET}  "
LINE1="${LINE1%"${LINE1##*[![:space:]]}"}"

# ===== 2 行目 =====
# コンテキスト使用率（バー）
if (( ${CTX_SIZE:-0} > 0 )); then
  CTX_PCT=$(awk -v u="$USED_TOKENS" -v s="$CTX_SIZE" 'BEGIN { printf "%.0f", u*100/s }')
else
  CTX_PCT=0
fi
CTX_C=$(pct_color "$CTX_PCT")
LINE2="🧠 ${CTX_C}[$(bar10 "$CTX_PCT")] ${CTX_PCT}%${RESET}"

# セッション（5h）
if [[ -n "$RL5" ]]; then
  RL5_INT=${RL5%.*}
  RESET_STR=""
  HM=$(epoch_to_hm "$RL5_RESET")
  [[ -n "$HM" ]] && RESET_STR=" ${DIM}(↻${HM})${RESET}"
  LINE2="${LINE2}   ⏱ セッション $(pct_color "$RL5_INT")${RL5_INT}%${RESET}${RESET_STR}"
fi

# 週間（7d）
if [[ -n "$RL7" ]]; then
  RL7_INT=${RL7%.*}
  LINE2="${LINE2}   📅 週間 $(pct_color "$RL7_INT")${RL7_INT}%${RESET}"
fi

printf '%s\n%s' "$LINE1" "$LINE2"
