#!/bin/sh

echo "Setting up your Mac..."

# シンボリックリンクを作成（既存ファイルがあれば上書き）
link_file() {
  src="$1"
  dest="$2"
  dest_dir=$(dirname "$dest")
  mkdir -p "$dest_dir"
  ln -sf "$src" "$dest"
  echo "Linked $src -> $dest"
}

link_file ~/git/dotfiles/.zshrc ~/.zshrc
link_file ~/git/dotfiles/ghostty/config ~/.config/ghostty/config
link_file ~/git/dotfiles/zed/keymap.json ~/.config/zed/keymap.json

# iTerm2とzshプラグインのセットアップ
echo "iTerm2とzshプラグインをセットアップ中..."
if [ -f ~/git/dotfiles/iterm2-setup.sh ]; then
    bash ~/git/dotfiles/iterm2-setup.sh
else
    echo "⚠️ iterm2-setup.sh が見つかりません。手動でiTerm2をセットアップしてください。"
fi

echo "Done. Reload your terminal."
