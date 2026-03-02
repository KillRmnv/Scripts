#!/bin/bash

###############################################################################
# find_large_dirs.sh - Поиск директорий больше указанного размера
# Использование: ./find_large_dirs.sh <размер> [путь] [количество]
###############################################################################

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция помощи
show_help() {
    echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ${GREEN}find_large_dirs.sh${NC} - Поиск больших директорий           ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Использование:${NC}"
    echo "  $0 <размер> [путь] [количество]"
    echo ""
    echo -e "${YELLOW}Параметры:${NC}"
    echo "  <размер>      - Минимальный размер (например: 100M, 1G, 500K)"
    echo "  [путь]        - Путь для поиска (по умолчанию: /home)"
    echo "  [количество]  - Сколько результатов показать (по умолчанию: 20)"
    echo ""
    echo -e "${YELLOW}Примеры:${NC}"
    echo "  $0 500M                    # Искать в /home директории >500MB"
    echo "  $0 1G /var 50              # Искать в /var директории >1GB (топ-50)"
    echo "  $0 100M / 100              # Искать по всему диску (требует sudo)"
    echo ""
    echo -e "${YELLOW}Форматы размера:${NC}"
    echo "  K - килобайты, M - мегабайты, G - гигабайты"
    echo ""
    exit 0
}

# Проверка аргументов
if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    show_help
fi

if [ -z "$1" ]; then
    echo -e "${RED} Ошибка: Не указан размер!${NC}"
    echo ""
    show_help
fi

# Параметры
SIZE_THRESHOLD="$1"
SEARCH_PATH="${2:-/home}"
RESULT_COUNT="${3:-20}"

# Проверка существования пути
if [ ! -d "$SEARCH_PATH" ]; then
    echo -e "${RED} Ошибка: Путь '$SEARCH_PATH' не существует!${NC}"
    exit 1
fi

# Проверка прав доступа
if [ "$SEARCH_PATH" == "/" ] && [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}  Внимание: Для поиска по всему диску нужны права root${NC}"
    echo -e "${YELLOW}   Запустите с: sudo $0 $SIZE_THRESHOLD $SEARCH_PATH $RESULT_COUNT${NC}"
    echo ""
fi

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${NC}  ${GREEN}🔍 Поиск больших директорий${NC}                              ${BLUE}║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW} Путь поиска:${NC} $SEARCH_PATH"
echo -e "${YELLOW} Минимальный размер:${NC} $SIZE_THRESHOLD"
echo -e "${YELLOW} Количество результатов:${NC} $RESULT_COUNT"
echo ""
echo -e "${BLUE}──────────────────────────────────────────────────────────────${NC}"
echo ""

# Поиск и сортировка директорий
echo -e "${GREEN}⏳ Сканирование...${NC} (это может занять время)"
echo ""

# Создаём временный файл для результатов
TEMP_FILE=$(mktemp)

# Функция для конвертации размера в байты
convert_to_bytes() {
    local size="$1"
    local number=$(echo "$size" | sed 's/[KMGkmg]$//')
    local unit=$(echo "$size" | grep -o '[KMGkmg]$')
    
    case "$unit" in
        [Kk]) echo $((number * 1024)) ;;
        [Mm]) echo $((number * 1024 * 1024)) ;;
        [Gg]) echo $((number * 1024 * 1024 * 1024)) ;;
        *) echo "$number" ;;
    esac
}

# Получаем размер в байтах для du
SIZE_BYTES=$(convert_to_bytes "$SIZE_THRESHOLD")

# Поиск директорий с размером больше порога
find "$SEARCH_PATH" -type d -exec du -sb {} \; 2>/dev/null | \
    awk -v threshold="$SIZE_BYTES" '$1 >= threshold' | \
    sort -rn | \
    head -n "$RESULT_COUNT" > "$TEMP_FILE"

# Форматированный вывод результатов
echo -e "${GREEN} Найдено директорий:${NC}"
echo ""
printf "${YELLOW}%-10s %-12s %s${NC}\n" "РАЗМЕР" "ЧЕЛОВЕК" "ПУТЬ"
echo -e "${BLUE}──────────────────────────────────────────────────────────────${NC}"

while IFS=$'\t' read -r size path; do
    # Конвертация размера в человекочитаемый формат
    if [ $size -ge 1073741824 ]; then
        human_size=$(echo "scale=2; $size/1073741824" | bc)"G"
    elif [ $size -ge 1048576 ]; then
        human_size=$(echo "scale=2; $size/1048576" | bc)"M"
    elif [ $size -ge 1024 ]; then
        human_size=$(echo "scale=2; $size/1024" | bc)"K"
    else
        human_size="${size}B"
    fi
    
    printf "${GREEN}%-10s %-12s %s${NC}\n" "$human_size" "$human_size" "$path"
done < "$TEMP_FILE"

echo -e "${BLUE}──────────────────────────────────────────────────────────────${NC}"
echo ""

# Статистика
TOTAL_DIRS=$(wc -l < "$TEMP_FILE")
if [ "$TOTAL_DIRS" -gt 0 ]; then
    LARGEST=$(head -1 "$TEMP_FILE" | awk '{print $1}')
    LARGEST_HUMAN=$(echo "scale=2; $LARGEST/1073741824" | bc)"G"
    echo -e "${YELLOW} Статистика:${NC}"
    echo "   Всего найдено: $TOTAL_DIRS директорий"
    echo "   Largest: $LARGEST_HUMAN"
fi

# Очистка
rm -f "$TEMP_FILE"

echo ""
echo -e "${GREEN} Готово!${NC}"
