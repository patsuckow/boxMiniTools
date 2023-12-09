#!/bin/bash

# Путь к исполняемому файлу вашей утилиты
APP_Obsidian="/opt/Obsidian/obsidian"
APP_EXECUTABLE="$APP_Obsidian %U"

# Название и описание вашей утилиты
APP_NAME="Obsidian"
APP_DESCRIPTION="Заметки Obsidian"

# Создаем .desktop файл в директории автозапуска
AUTOSTART_DIR="$HOME/.config/autostart"
DESKTOP_FILE="$HOME/.config/autostart/obsidian.desktop"

# Убедимся, что директория автозапуска существует
mkdir -p "$AUTOSTART_DIR"

# Добавляем задержку перед запуском утилиты на 20 секунд
# Создадим файл "/opt/Obsidian/obsidian-delayed" с правами администратора и установим атрибуты исполнения
suffix="-delayed"
sudo bash -c "echo -e '#!/bin/bash\nsleep 20\n$APP_EXECUTABLE' > \"$APP_Obsidian$suffix\""
sudo chmod +x "$APP_Obsidian$suffix"

# Заполняем .desktop файл
cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Type=Application
Exec=$APP_Obsidian$suffix
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=$APP_NAME
Comment=$APP_DESCRIPTION
EOL

chmod +x "$DESKTOP_FILE"
