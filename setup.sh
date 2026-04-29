#!/bin/sh

set -e

DOTFILES="$HOME/git/dotfiles"

echo "Setting up your Mac..."

# Homebrewが未インストールなら導入
if ! command -v brew >/dev/null 2>&1; then
  echo "📥 Homebrewをインストール中..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon環境向けにPATHを通す
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrewはインストール済み"
fi

# Brewfileの内容をインストール
echo "📦 Brewfileのパッケージをインストール中..."
brew bundle --file="$DOTFILES/Brewfile"

# Claude Code CLIの導入（公式ネイティブインストーラ・自動更新対応）
if ! command -v claude >/dev/null 2>&1; then
  echo "🤖 Claude Code CLIをインストール中..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "✅ Claude Code CLIはインストール済み"
fi

# シンボリックリンクを作成（既存ファイルがあれば上書き）
link_file() {
  src="$1"
  dest="$2"
  dest_dir=$(dirname "$dest")
  mkdir -p "$dest_dir"
  ln -sf "$src" "$dest"
  echo "Linked $src -> $dest"
}

link_file "$DOTFILES/.zshenv" "$HOME/.zshenv"
link_file "$DOTFILES/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES/.pryrc" "$HOME/.pryrc"
link_file "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"
link_file "$DOTFILES/zed/keymap.json" "$HOME/.config/zed/keymap.json"
link_file "$DOTFILES/zed/settings.json" "$HOME/.config/zed/settings.json"
link_file "$DOTFILES/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
link_file "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
link_file "$DOTFILES/claude/statusline.sh" "$HOME/.claude/statusline.sh"

# SSH config（鍵は1Password、ホスト固有設定は ~/.ssh/config.d/ に配置）
mkdir -p "$HOME/.ssh/config.d"
link_file "$DOTFILES/ssh/config" "$HOME/.ssh/config"

# zsh環境のセットアップ
echo "zsh環境をセットアップ中..."
if [ -f "$DOTFILES/zsh-setup.sh" ]; then
    bash "$DOTFILES/zsh-setup.sh"
else
    echo "⚠️ zsh-setup.sh が見つかりません。手動でzsh環境をセットアップしてください。"
fi

# Oh My Zsh等のインストーラーが ~/.zshrc を上書きするケースに備え、シンボリックリンクを再作成
link_file "$DOTFILES/.zshrc" "$HOME/.zshrc"

echo "Done. Reload your terminal."
