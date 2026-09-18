# Home managerによるセットアップ

## Nix インストール（**要root権限**）

### macOS

[Determinate Nix](https://docs.determinate.systems/) をインストールする．
公式ページからインストーラをダウンロードするか，以下のコマンドを実行する．

```bash
curl -fsSL -o /tmp/determinate-nix.pkg \
  https://install.determinate.systems/determinate-pkg/stable/Universal
sudo installer -pkg /tmp/determinate-nix.pkg -target /
```

Flake方式でstandaloneのhome-managerをインストール．

```bash
nix run home-manager/release-<version> -- init --switch ~/.config/home-manager
```

### Linux

[公式ページ](https://nixos.org/download/#nix-install-linux)に従ってインストール．

```bash
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
```

Flakeを有効化．

```bash
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## 適用

リポジトリをcloneする．

```bash
git clone https://github.com/yusekiya/home-manager.git ~/Develop/home-manager
```

### 初回

`home-manager` コマンドがないので，`nix run` から実行する．

```bash
nix run home-manager/master -- switch --flake ~/Develop/home-manager#$(whoami)@$(hostname -s)
```

ここで，セットアップ対象の項目を `flake.nix` の `homeConfigurations` に（もしなければ）事前に追加しておく．
項目の識別子は次のコマンドの出力と一致させる必要がある．

```bash
echo "$(whoami)@$(hostname -s)"
```

### 2回目以降

```bash
home-manager switch --flake ~/Develop/home-manager#"$(whoami)@$(hostname -s)"
```

## Lockファイル更新

nixpkgs と home-manager の更新

```bash
nix flake update
```

nixpkgsのみの場合

```bash
nix flake update nixpkgs
```

更新後のテスト

```bash
git diff flake.lock # 変更点の確認
nix build .#homeConfigurations."<user>@<hostname>".activationPackage --no-link # ビルド
```

問題がなければ `flake.lock` をコミットする．その後，変更を適用．
