#!/bin/bash

# Обновление системы
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl wget gpg software-properties-common apt-transport-https

# 1. GIT, C++, PIP, MAVEN, GRADLE
sudo apt install -y git build-essential python3-pip maven gradle

# 2. DOCKER
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# 3. PYTHON (использование deadsnakes для свежих версий)
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install -y python3.12 python3.12-venv

# 4. JDK 
sudo apt install -y openjdk-25-jdk openjdk-25-source

# 5. POSTGRES
sudo apt install -y postgresql postgresql-contrib
# 16. NODE.JS (LTS версия)
# Устанавливаем официальный скрипт настройки репозитория NodeSource
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# 17. PGADMIN 4 (Desktop версия)
# Добавляем публичный ключ репозитория
curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg
# Добавляем сам репозиторий
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'
sudo apt update
# Устанавливаем версию для рабочего стола (desktop mode)
sudo apt install -y pgadmin4-desktop

# 6. NEOVIM & NEOVIDE
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install -y neovim
# Neovide (через cargo, если есть, или скачивание бинарника)
wget https://github.com/neovide/neovide/releases/latest/download/neovide-linux-x86_64.tar.gz
tar -xvf neovide-linux-x86_64.tar.gz
sudo mv neovide /usr/local/bin/
rm neovide-linux-x86_64.tar.gz

# 7. ZED EDITOR
curl -f https://zed.dev/install.sh | sh


# 9. OBSIDIAN (AppImage или Deb)
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/obsidian_1.5.3_amd64.deb
sudo apt install -y ./obsidian_1.5.3_amd64.deb
rm obsidian_1.5.3_amd64.deb

# 10. WIRESHARK
sudo apt install -y wireshark
# Настройка прав для непривилегированного пользователя
sudo dpkg-reconfigure wireshark-common 

# 11. TeXStudio
sudo add-apt-repository ppa:sunderme/texstudio -y
sudo apt update
sudo apt install -y texstudio

# 12. OLLAMA
curl -fsSL https://ollama.com/install.sh | sh


# 14. Hugging Face CLI & OpenCode
pip install -U "huggingface_hub[cli]"
# Для opencode обычно используется специфичный скрипт или pip, если это клиент

curl -fsSL https://opencode.ai/install | bash

#qwen code
curl -fsSL https://qwen-code-assets.oss-cn-hangzhou.aliyuncs.com/installation/install-qwen.sh | bash

#mistral vibe
curl -LsSf https://mistral.ai/vibe/install.sh | bash

# OpenBLAS
sudo apt update
sudo apt install libopenblas-dev libopenblas0

#Rust Cargo
sudo apt update
sudo apt install -y build-essential curl pkg-config libssl-dev

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $HOME/.cargo/env

rustup update

#llmfit
git clone https://github.com/AlexsJones/llmfit.git
cd llmfit
cargo build --release
# binary is at target/release/llmfit


#models
git clone https://github.com/arimxyer/models
cd models
cargo build --release
./target/release/models

#Pi agent
npm install -g @mariozechner/pi-coding-agent

#Goose
curl -fsSL https://github.com/block/goose/releases/download/stable/download_cli.sh | bash

#Cline
npm install -g cline

#also install Lm Studio via Browser https://lmstudio.ai/

#btop https://github.com/aristocratos/btop

#tree
sudo apt install tree


#superfile
bash -c "$(curl -sLo- https://superfile.dev/install.sh)"

#ripgrep
 sudo apt-get install ripgrep
 
 #fd
 sudo apt install fd-find
 
 #GH
 (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
	
#pass	
 sudo apt-get install pass
 
 
 
 
#jq or go to github page and check for latest
mkdir -p ~/bin
wget https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-amd64 -O ~/bin/jq
chmod +x ~/bin/jq
~/bin/jq --version
# Ожидаемый вывод: jq-1.8.1
# Проверьте, есть ли ~/bin уже в PATH
echo $PATH | grep -o "$HOME/bin"

# Если нет — добавьте в ~/.bashrc или ~/.zshrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc

# Примените изменения
source ~/.bashrc


#fzf
sudo apt install fzf

#tldr
pipx install tldr
