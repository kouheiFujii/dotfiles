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
├── ssh/                      # SSH config（公開可な共通設定のみ）
├── zed/                      # Zed エディタ設定
└── zsh/                      # zsh エイリアス・関数
```

## 移行時の手動作業チェックリスト

`setup.sh` で再現できない部分は以下を手動対応する。

### SSH 鍵 / config
鍵本体は Google Drive 経由で旧PC→新PCへ移動する運用。dotfiles には鍵を含めない。
セキュリティリスクを抑えるため、**Drive 上には移行のタイミングだけ置き、復元後に完全削除**する。

#### 旧PC側（バックアップ作成）
```bash
# 1. アーカイブ作成
tar czf /tmp/ssh-backup.tar.gz \
  -C ~ \
  .ssh/id_rsa \
  .ssh/id_rsa.pub \
  .ssh/aws_rsa_key \
  .ssh/aws_rsa_key.pub \
  .ssh/client \
  .ssh/config.d

# 2. Google Drive にアップロード
open https://drive.google.com   # ブラウザで /tmp/ssh-backup.tar.gz を手動アップロード

# 3. ローカルの一時ファイルを削除
rm /tmp/ssh-backup.tar.gz
```

#### 新PC側（復元）
```bash
# 1. Google Drive から ssh-backup.tar.gz を ~/Downloads に DL

# 2. 展開
mkdir -p ~/.ssh
tar xzf ~/Downloads/ssh-backup.tar.gz -C ~

# 3. パーミッション設定
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa ~/.ssh/aws_rsa_key
find ~/.ssh/client -type f ! -name "*.pub" -exec chmod 600 {} \;

# 4. 一時ファイル削除
rm ~/Downloads/ssh-backup.tar.gz
```

#### 動作確認後、Drive 側のクリーンアップ
- [ ] Google Drive 上の `ssh-backup.tar.gz` を削除
- [ ] **ゴミ箱からも完全削除**（30日後の自動削除を待たず即削除）

### 1Password
- [ ] 1Password にログイン（パスワード管理用）

### Google Cloud SDK
- [ ] `gcloud init` または `gcloud auth login` で再認証
- [ ] 必要なら `gcloud config set project <PROJECT_ID>`

### ターミナル / フォント
- [ ] 必要に応じて `p10k configure` でプロンプトをカスタマイズ
  - フォント (`MesloLGS NF`) は `ghostty/config` で自動設定済み

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
