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

echo "Done. Reload your terminal."
