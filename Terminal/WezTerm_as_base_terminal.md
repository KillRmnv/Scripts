Вот чёткий и проверенный алгоритм, чтобы сделать **WezTerm** терминалом по умолчанию в Ubuntu/GNOME.

### 📋 Алгоритм действий

#### Шаг 1. Узнаём точный путь к WezTerm
Откройте терминал и введите:
```bash
which wezterm
```
*Запомните вывод (обычно это `/usr/bin/wezterm`).*

---

#### Шаг 2. Настраиваем GNOME (Самое важное)
Эти команды заставят систему вызывать WezTerm вместо GNOME Terminal при нажатии `Ctrl+Alt+T` и в меню.

```bash
# 1. Указываем путь к терминалу
gsettings set org.gnome.desktop.default-applications.terminal exec '/usr/bin/wezterm'

# 2. Указываем аргумент запуска (обязательно для WezTerm)
gsettings set org.gnome.desktop.default-applications.terminal exec-arg 'start'
```

---

#### Шаг 3. Исправляем ассоциации приложений
Чтобы файлы и ссылки открывались корректно, нужно обновить файл `mimeapps.list`.

1.  Откройте файл:
    ```bash
    nano ~/.config/mimeapps.list
    ```
2.  Найдите секцию `[Default Applications]` и добавьте (или измените) строку:
    ```ini
    [Default Applications]
    terminal=wezterm.desktop
    ```
3.  Сохраните (`Ctrl+O`, `Enter`) и выйдите (`Ctrl+X`).

---

#### Шаг 4. Проверяем файл запуска (.desktop)
Убедитесь, что у WezTerm есть корректный ярлык для системы.

1.  Проверьте наличие файла:
    ```bash
    ls /usr/share/applications/wezterm.desktop
    ```
2.  Если файла нет или он пустой, создайте/исправьте его:
    ```bash
    sudo nvim /usr/share/applications/wezterm.desktop
    ```
3.  Убедитесь, что внутри есть строка `Exec=wezterm start`:
    ```ini
    [Desktop Entry]
    Name=WezTerm
    Exec=wezterm start
    Icon=wezterm
    Terminal=false
    Type=Application
    Categories=System;TerminalEmulator;
    ```

---

#### Шаг 5. Применяем изменения
Настройки GNOME часто кэшируются. Чтобы они вступили в силу:

1.  **Перезагрузите компьютер** (самый надёжный способ).
2.  *Или* перезапустите оболочку GNOME: нажмите `Alt+F2`, введите `r`, нажмите `Enter` (работает только на X11).
3.  *Или* убейте процесс файлового менеджера: `killall nautilus`.

---

### ✅ Проверка результата

После перезагрузки выполните проверки:

```bash
# 1. Проверка настроек GNOME
gsettings get org.gnome.desktop.default-applications.terminal exec
# ✅ Должно вывести: '/usr/bin/wezterm'

# 2. Тестовый запуск команды
x-terminal-emulator -e bash
# ✅ Должен открыться WezTerm

# 3. Горячие клавиши
# Нажмите Ctrl+Alt+T
# ✅ Должен открыться WezTerm
```

---

### 🔄 Как вернуть всё обратно (GNOME Terminal)

Если что-то пойдёт не так, выполните эти команды для отката:

```bash
gsettings set org.gnome.desktop.default-applications.terminal exec 'gnome-terminal'
gsettings set org.gnome.desktop.default-applications.terminal exec-arg '--'
```
