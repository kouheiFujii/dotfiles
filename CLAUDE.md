# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## セットアップコマンド

このdotfilesリポジトリは個人のmacOS環境設定ファイルを管理しています。

### 初期セットアップ
```bash
# リポジトリのクローン
mkdir ~/git
cd ~/git
git clone https://github.com/Kotahiyo/dotfiles

# セットアップスクリプトの実行
~/git/dotfiles/setup.sh

# ターミナル再起動後、設定を確認
source ~/.zshrc
```

### パッケージ管理
```bash
# Homebrewパッケージのインストール
brew bundle --file=~/git/dotfiles/Brewfile

# 新しいパッケージをBrewfileに追加
brew bundle dump --file=~/git/dotfiles/Brewfile --force
```

## アーキテクチャ

### ディレクトリ構造
- `.zshrc` - メインのzsh設定ファイル、環境変数とモジュール読み込み
- `setup.sh` - シンボリックリンク作成スクリプト  
- `Brewfile` - Homebrewパッケージ定義
- `zsh/` - zsh設定の分割ファイル
  - `aliases.zsh` - エイリアス定義（Git、Docker、ナビゲーション）
  - `functions.zsh` - カスタム関数（Docker、Git管理）

### 設定ファイルの依存関係
1. `.zshrc`がメインエントリーポイント
2. asdf、Homebrew、Google Cloud SDKの初期化
3. `zsh/aliases.zsh`と`zsh/functions.zsh`を動的読み込み
4. `$DOTFILES`環境変数で設定ディレクトリを参照

### 重要な機能
- **git-cleanup関数** - マージ済み/未マージブランチの削除管理
- **Docker関数群** - `dcup()`, `dcrun()`, `dbash()`でDocker Compose操作を簡素化
- **Git エイリアス** - 頻繁に使うGitコマンドの短縮形
- **Claude Code統合** - `claude`エイリアスでBashシェル環境を指定

### 環境変数
- `DOTFILES=$HOME/git/dotfiles` - 設定ファイルへのパス
- `PATH`にHomebrew、asdf、Ruby等を追加
- Google Cloud SDK設定の条件付き読み込み