#!/bin/bash

# zsh環境セットアップスクリプト
# Oh My Zsh、Powerlevel10kテーマ、zshプラグインを導入する。
# ターミナル本体（Ghostty）やフォントはBrewfileで管理しているためここでは扱わない。

set -e

echo "🚀 zsh環境のセットアップを開始します..."

# Oh My Zshがインストールされていない場合はインストール
# KEEP_ZSHRC=yes で既存の ~/.zshrc（dotfilesへのシンボリックリンク）を上書きさせない
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Oh My Zshをインストール中..."
    KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zshは既にインストールされています"
fi

# Powerlevel10kテーマをインストール
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "📥 Powerlevel10kテーマをインストール中..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "✅ Powerlevel10kテーマは既にインストールされています"
fi

# zsh-syntax-highlightingプラグインをインストール
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "📥 zsh-syntax-highlightingプラグインをインストール中..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "✅ zsh-syntax-highlightingプラグインは既にインストールされています"
fi

# zsh-autosuggestionsプラグインをインストール
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "📥 zsh-autosuggestionsプラグインをインストール中..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "✅ zsh-autosuggestionsプラグインは既にインストールされています"
fi

echo ""
echo "🎉 zsh環境のセットアップが完了しました！"
echo ""
echo "次の手順："
echo "1. ターミナルを再起動するか source ~/.zshrc を実行"
echo "2. 必要に応じて 'p10k configure' を実行してプロンプトを調整"
