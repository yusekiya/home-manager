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

ここで，`$(whoami)@$(hostname -s)` が `flake.nix` の `homeConfigurations` に事前に追加されている必要がある．

### 2回目以降

```bash
home-manager switch --flake ~/Develop/home-manager#"$(whoami)@$(hostname -s)"
```

