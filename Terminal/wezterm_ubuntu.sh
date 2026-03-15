sudo apt install -y curl wget gnupg2 software-properties-common apt-transport-https ca-certificates


mkdir -p ~/.local/share/fonts
cd /tmp
wget -O JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
unzip JetBrainsMono.zip -d ~/.local/share/fonts/
rm JetBrainsMono.zip
fc-cache -fv



# Добавляем в PATH (если ~/.local/bin нет в PATH)
if ! grep -q '.local/bin' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi





# Импорт GPG-ключа и добавление репозитория [[3]]
curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

sudo apt update
sudo apt install -y wezterm

# Базовый конфиг
mkdir -p ~/.config/wezterm
cat > ~/.config/wezterm/wezterm.lua << 'EOF'
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
config.font = wezterm.font('JetBrainsMono Nerd Font', {weight='Regular'})
config.font_size = 13.0
config.harfbuzz_features = {'calt', 'clig', 'liga'}
config.color_scheme = 'Catppuccin Mocha'
config.enable_tab_bar = true
config.scrollback_lines = 10000
config.keys = {
  {key="g", mods="CTRL", action=wezterm.action.SpawnCommandInNewTab{args={'lazygit'}}},
  {key="f", mods="CTRL", action=wezterm.action.SpawnCommandInNewPane{args={'fzf'}}},
}
return config
EOF
echo "✅ WezTerm установлен"
curl -sS https://starship.rs/install.sh | sh
