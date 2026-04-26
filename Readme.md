# dotfiles

個人 macOS 環境のセットアップを再現するための dotfiles。

## セットアップ

新しい Mac で以下を実行するだけで基本環境が再現される。

```bash
mkdir -p ~/git
cd ~/git
git clone https://github.com/Kotahiyo/dotfiles
~/git/dotfiles/setup.sh
source ~/.zshrc
```

`setup.sh` がやること:

1. Homebrew のインストール（未導入時）
2. `brew bundle` で Brewfile に書いたパッケージを一括導入
3. 設定ファイルのシンボリックリンク作成
4. `zsh-setup.sh` の実行（Oh My Zsh / Powerlevel10k / プラグイン導入）

## ディレクトリ構成

```
.
├── .zshenv, .zshrc, .pryrc   # シェル / Pry 設定
├── Brewfile                  # Homebrew で管理するパッケージ一覧
├── setup.sh                  # メインのセットアップスクリプト
├── zsh-setup.sh              # Oh My Zsh / p10k / zshプラグインの導入
├── ghostty/                  # Ghostty ターミナル設定
├── ssh/                      # SSH config（1Password Agent 前提）
├── zed/                      # Zed エディタ設定
└── zsh/                      # zsh エイリアス・関数
```

## 移行時の手動作業チェックリスト

`setup.sh` で再現できない部分は以下を手動対応する。

### 1Password / SSH
- [ ] 1Password にログインし、Settings → Developer → 「Use the SSH agent」を ON
- [ ] CLI 連携も ON にしておく（`op` コマンド利用時）
- [ ] クライアント案件等の機密ホスト定義を `~/.ssh/config.d/` 配下に配置（dotfiles では管理しない）

### Google Cloud SDK
- [ ] `gcloud init` または `gcloud auth login` で再認証
- [ ] 必要なら `gcloud config set project <PROJECT_ID>`

### ターミナル / フォント
- [ ] iTerm2 / Ghostty でフォントを `MesloLGS NF` に設定
- [ ] 必要に応じて `p10k configure` でプロンプトをカスタマイズ

### asdf
- [ ] `~/.tool-versions` を新PCに配置（または `asdf install` で各言語を入れ直し）
- [ ] 必要言語のプラグインを `asdf plugin add ...` で追加

### その他
- [ ] iCloud / GitHub / 各種 SaaS のサインイン
- [ ] DBeaver / Raycast 等の Cask アプリの初回設定

## パッケージ追加

新しく入れた Homebrew パッケージは Brewfile に追記する。

```bash
brew bundle dump --file=~/git/dotfiles/Brewfile --force
```

ただし dump は実環境を全コピーするので、不要なものが混じらないよう差分を確認してから commit する。
