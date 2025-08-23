#!/bin/sh

echo "Setting up your Mac..."

# シンボリックリンクを作成
ln -sf ~/git/dotfiles/.zshrc ~/.zshrc

# iTerm2とzshプラグインのセットアップ
echo "iTerm2とzshプラグインをセットアップ中..."
if [ -f ~/git/dotfiles/iterm2-setup.sh ]; then
    bash ~/git/dotfiles/iterm2-setup.sh
else
    echo "⚠️ iterm2-setup.sh が見つかりません。手動でiTerm2をセットアップしてください。"
fi

echo "Done. Reload your terminal."
