# Install / Upgrade Atlassian CLI (acli)

Source: https://developer.atlassian.com/cloud/acli/guides/install-acli/

## macOS

### Homebrew install

```bash
brew tap atlassian/homebrew-acli
brew install acli
acli --version
```

### Binary install (curl)

Intel:

```bash
curl -LO "https://acli.atlassian.com/darwin/latest/acli_darwin_amd64/acli"
chmod +x ./acli
sudo mv ./acli /usr/local/bin/acli
sudo chown root: /usr/local/bin/acli
acli --help
```

Apple Silicon:

```bash
curl -LO "https://acli.atlassian.com/darwin/latest/acli_darwin_arm64/acli"
chmod +x ./acli
sudo mv ./acli /usr/local/bin/acli
sudo chown root: /usr/local/bin/acli
acli --help
```

### Homebrew upgrade

```bash
brew update
brew upgrade acli
acli --version
```

## Linux

### Debian/Ubuntu (APT)

```bash
sudo apt-get install -y wget gnupg2
sudo mkdir -p -m 755 /etc/apt/keyrings
wget -nv -O- https://acli.atlassian.com/gpg/public-key.asc | sudo gpg --dearmor -o /etc/apt/keyrings/acli-archive-keyring.gpg
sudo chmod go+r /etc/apt/keyrings/acli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/acli-archive-keyring.gpg] https://acli.atlassian.com/linux/deb stable main" | sudo tee /etc/apt/sources.list.d/acli.list > /dev/null

sudo apt update
sudo apt install -y acli
acli --version
```

Upgrade:

```bash
sudo apt update
sudo apt upgrade -y acli
acli --version
```

### RHEL/CentOS (YUM)

```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://acli.atlassian.com/linux/rpm/acli.repo
sudo yum install -y acli
acli --version
```

Upgrade:

```bash
sudo yum check-update
sudo yum update -y acli
acli --version
```

### Binary install (curl)

ARM64:

```bash
curl -LO "https://acli.atlassian.com/linux/latest/acli_linux_arm64/acli"
chmod +x ./acli
sudo install -o root -g root -m 0755 acli /usr/local/bin/acli
acli --help
```

x86-64:

```bash
curl -LO "https://acli.atlassian.com/linux/latest/acli_linux_amd64/acli"
chmod +x ./acli
sudo install -o root -g root -m 0755 acli /usr/local/bin/acli
acli --help
```

No root:

```bash
mkdir -p ~/.local/bin
mv ./acli ~/.local/bin/acli
# ensure ~/.local/bin is on PATH
acli --help
```

## Windows

PowerShell (download binary):

x86-64:

```powershell
Invoke-WebRequest -Uri https://acli.atlassian.com/windows/latest/acli_windows_amd64/acli.exe -OutFile acli.exe
.\acli.exe --help
```

ARM64:

```powershell
Invoke-WebRequest -Uri https://acli.atlassian.com/windows/latest/acli_windows_arm64/acli.exe -OutFile acli.exe
.\acli.exe --help
```

Upgrade: re-download and replace the existing `acli.exe`.
