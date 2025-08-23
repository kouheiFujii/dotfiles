#!/bin/bash

# iTerm2セットアップスクリプト
# このスクリプトはiTerm2をインストールし、Oh My Zsh、Powerlevel10k、プラグインでzshを設定します

set -e

echo "🚀 iTerm2のセットアップを開始します..."

# Homebrewがインストールされているかチェック
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrewが必要ですがインストールされていません。まずHomebrewをインストールしてください。"
    exit 1
fi

# iTerm2がインストールされていない場合はインストール
if ! brew list --cask iterm2 &> /dev/null; then
    echo "📥 iTerm2をインストール中..."
    brew install --cask iterm2
else
    echo "✅ iTerm2は既にインストールされています"
fi

# フォントがインストールされていない場合はインストール
if ! brew list --cask font-meslo-lg-nerd-font &> /dev/null; then
    echo "📥 Meslo LG Nerd Fontをインストール中..."
    brew install --cask font-meslo-lg-nerd-font
else
    echo "✅ Meslo LG Nerd Fontは既にインストールされています"
fi

# Oh My Zshがインストールされていない場合はインストール
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Oh My Zshをインストール中..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zshは既にインストールされています"
fi

# Powerlevel10kテーマをインストール
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "📥 Powerlevel10kテーマをインストール中..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
else
    echo "✅ Powerlevel10kテーマは既にインストールされています"
fi

# zsh-syntax-highlightingプラグインをインストール
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "📥 zsh-syntax-highlightingプラグインをインストール中..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
    echo "✅ zsh-syntax-highlightingプラグインは既にインストールされています"
fi

# zsh-autosuggestionsプラグインをインストール
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "📥 zsh-autosuggestionsプラグインをインストール中..."
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
    echo "✅ zsh-autosuggestionsプラグインは既にインストールされています"
fi

echo ""
echo "🎉 iTerm2のセットアップが完了しました！"
echo ""
echo "次の手順："
echo "1. iTerm2を開く"
echo "2. 環境設定 > プロファイル > テキスト > フォントに移動"
echo "3. アイコンを正しく表示するためにフォントを'MesloLGS NF'に設定"
echo "4. ターミナルを再起動するか、次のコマンドを実行: source ~/.zshrc"
echo "5. 'p10k configure'を実行してPowerlevel10kテーマをカスタマイズ"