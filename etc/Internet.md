Есть два способа — через `sysctl` (меняет дефолтный TTL ядра) или через `iptables` (модифицирует TTL в пакетах на лету). Для обхода оператора подходят оба. [the](https://the.hosting/ru/help/menjaem-ttl-v-linux)

### Способ 1: sysctl (рекомендуется)

Применить сразу без перезагрузки:

```bash
sudo sysctl -w net.ipv4.ip_default_ttl=65
```

Чтобы сохранилось после перезагрузки, добавь в `/etc/sysctl.d/99-ttl.conf`:

```bash
echo "net.ipv4.ip_default_ttl=65" | sudo tee /etc/sysctl.d/99-ttl.conf
sudo sysctl --system
```

На Arch лучше использовать файл в `/etc/sysctl.d/`, а не напрямую `/etc/sysctl.conf` — это более правильный подход для systemd-систем. [the](https://the.hosting/ru/help/menjaem-ttl-v-linux)

### Способ 2: iptables (альтернатива)

```bash
sudo iptables -t mangle -A POSTROUTING -j TTL --ttl-set 65
```

Чтобы правило сохранялось после перезагрузки на Arch, установи `iptables-nft` и сохрани правила:

```bash
sudo iptables-save | sudo tee /etc/iptables/iptables.rules
sudo systemctl enable iptables
```

### Почему именно 65

Телефон на Android/iOS использует TTL = 64 по умолчанию. Когда пакет проходит через телефон как хоп, он уменьшает TTL на 1. Если твоя машина отправляет TTL=65, оператор получает пакеты с TTL=64 — как будто устройство одно. [4te](https://4te.me/post/android-ttl-fix/)

Проверить результат можно командой:

```bash
ping -c 1 google.com | grep ttl
```

или:

```bash
sysctl net.ipv4.ip_default_ttl
```