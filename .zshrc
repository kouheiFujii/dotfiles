# Powerlevel10k instant prompt（起動高速化機能）
# これはファイルの最上部に配置する必要がある
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# パフォーマンス最適化設定
ZSH_DISABLE_COMPFIX=true    # 補完システムのセキュリティチェックをスキップ（起動高速化）
DISABLE_AUTO_UPDATE=true    # Oh My Zshの自動更新チェックを無効化
DISABLE_UPDATE_PROMPT=true  # 更新プロンプトを表示しない

# Oh My Zsh設定
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"  # テーマ設定

# zsh機能設定
ENABLE_CORRECTION="true"           # コマンド自動修正を有効化
COMPLETION_WAITING_DOTS="true"     # 補完待機中にドットを表示

# プラグイン設定
# git: Git関連のエイリアスと機能
# zsh-syntax-highlighting: コマンドのシンタックスハイライト
# zsh-autosuggestions: コマンド履歴からの自動補完提案
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Oh My Zshを読み込み
source $ZSH/oh-my-zsh.sh

# ユーザー環境変数設定（DOTFILESは.zshenvで定義済み）
export PATH="/opt/homebrew/bin:$PATH"                     # Homebrewのパス

# asdf（バージョン管理ツール、0.16+ Go版は asdf.sh ではなく shim ディレクトリを PATH に追加）
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# asdf読み込み後にローカルバイナリを最優先に（claude code用）
export PATH="$HOME/.local/bin:$PATH"

# カスタムエイリアスと関数を読み込み
[[ -f $DOTFILES/zsh/aliases.zsh ]] && source $DOTFILES/zsh/aliases.zsh
[[ -f $DOTFILES/zsh/functions.zsh ]] && source $DOTFILES/zsh/functions.zsh

# Google Cloud SDK設定（Homebrew Caskで管理）
if command -v brew >/dev/null 2>&1; then
  GCLOUD_SDK="$(brew --prefix)/share/google-cloud-sdk"
  [[ -f "$GCLOUD_SDK/path.zsh.inc" ]] && source "$GCLOUD_SDK/path.zsh.inc"
  [[ -f "$GCLOUD_SDK/completion.zsh.inc" ]] && source "$GCLOUD_SDK/completion.zsh.inc"
fi

# Powerlevel10k設定を読み込み
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
