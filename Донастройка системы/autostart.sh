#!/bin/bash

# Путь к исполняемому файлу вашей утилиты
APP_EXECUTABLE="/opt/Obsidian/obsidian %U"

# Название и описание вашей утилиты
APP_NAME="Obsidian"
APP_DESCRIPTION="Заметки Obsidian"

# Создаем .desktop файл в директории автозапуска
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/obsidian.desktop"

mkdir -p "$AUTOSTART_DIR"
touch "$DESKTOP_FILE"

# Заполняем .desktop файл
echo "[Desktop Entry]" > "$DESKTOP_FILE"
echo "Type=Application" >> "$DESKTOP_FILE"
echo "Exec=$APP_EXECUTABLE" >> "$DESKTOP_FILE"
echo "Hidden=false" >> "$DESKTOP_FILE"
echo "NoDisplay=false" >> "$DESKTOP_FILE"
echo "X-GNOME-Autostart-enabled=true" >> "$DESKTOP_FILE"
echo "Name=$APP_NAME" >> "$DESKTOP_FILE"
echo "Comment=$APP_DESCRIPTION" >> "$DESKTOP_FILE"

chmod +x "$DESKTOP_FILE"
