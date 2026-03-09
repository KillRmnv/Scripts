# ═══════════════════════════════════════════════════════════
# Fish Config — чистый и рабочий вариант
# ═══════════════════════════════════════════════════════════

# 🎨 Catppuccin тема
set -g catppuccin_flavor mocha
set -g catppuccin_prompt_icons true

# ───────────────────────────────────────────────────────────
# 📜 История
# ───────────────────────────────────────────────────────────
set -g fish_history_limit 1000

# ───────────────────────────────────────────────────────────
# 🎨 Цветные алиасы
# ───────────────────────────────────────────────────────────
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# ───────────────────────────────────────────────────────────
# 📦 Кастомные алиасы
# ───────────────────────────────────────────────────────────
alias oencode='~/.opencode/bin/opencode'
alias qwen='~/.npm-global/bin/qwen'
alias vibe='~/.local/bin/vibe'
alias zed='~/.local/bin/zed'


# ───────────────────────────────────────────────────────────
# 🔧 Функция alert
# ───────────────────────────────────────────────────────────
function alert
    notify-send --urgency=low -i (test $status = 0; and echo terminal; or echo error) \
        (history --max=1 | string replace -r '^\s*\d+\s*' '')
end

# ───────────────────────────────────────────────────────────
# 🌍 Переменные окружения
# ───────────────────────────────────────────────────────────

# 🔹 Cargo (Rust) — без source bash-файла
set -gx CARGO_HOME "$HOME/.cargo"
fish_add_path -g $CARGO_HOME/bin

# 🔹 NVM — через bash (временное решение)
if test -f "$HOME/.nvm/nvm.sh"
    bash -c 'source $HOME/.nvm/nvm.sh && nvm use --silent default' > /dev/null ^> /dev/null
end

# 🔹 Maven
set -gx MAVEN_HOME ~/apache-maven-3.9.9-bin/apache-maven-3.9.9

# 🔹 JAVA_HOME
set -gx JAVA_HOME /usr/lib/jvm/java-21-openjdk-amd64


# 🔹 Opencode / LM Studio
fish_add_path -g ~/.opencode/bin ~/.lmstudio/bin

# 🔹 JetBrains VM Options — ИСПРАВЛЕНО
if test -f "$HOME/.jetbrains.vmoptions.sh"
    source "$HOME/.jetbrains.vmoptions.sh"
end

# 🔹 Kiro terminal
if test "$TERM_PROGRAM" = "kiro"
    kiro --locate-shell-integration-path fish | source
end

# 🔹 Linuxbrew
if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# 🔹 Централизованный PATH
fish_add_path -g $HOME/bin $HOME/.local/bin

# ───────────────────────────────────────────────────────────
# ⭐ Starship (раскомментируйте, если используете его)
# ───────────────────────────────────────────────────────────
starship init fish | source

# ───────────────────────────────────────────────────────────
# 🎨 Цвета подсветки (Catppuccin Mocha)
# ───────────────────────────────────────────────────────────
set -g fish_color_autosuggestion '#6c7086'
set -g fish_color_command '#89b4fa'
set -g fish_color_param '#cba6f7'
set -g fish_color_string '#a6e3a1'
set -g fish_color_error '#f38ba8'
set -g fish_color_cwd '#94e2d5'

# ───────────────────────────────────────────────────────────
# ⚡ Git-аббревиатуры
# ───────────────────────────────────────────────────────────
abbr -a g git
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gl 'git pull'

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/killrmnv/.lmstudio/bin
# End of LM Studio CLI section

