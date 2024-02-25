#!/bin/bash
#
# Актуальность: февраль 2024г.
# Пример для OS Linux Mint 21.3 Virginia Xfce Edition (64-bit).
# lsb_release -a
#
# Сделать данный файл install64.sh исполняемым и запустить сразу после установки Linux Mint, 
# для установки нужных репозиториев, пакетов и удаления ненужных.
# 
# Заметка:
# В зависимости от скорости скачивания и количества установок/обновлений пакетов,
# время выполнения может затянутся и пароль суперпользователя снова может понадобится ввести,
# так как он действителен в течении 15 минутного сеанса.
# Команды записаны специально отдельно, чтобы было легко редактировать или удалить ненужное.
# Вообще это скелет, который можно модифицировать как вам угодно добавляя нужные утилиты,
# удаляя ненужные и т.п., тоесть автоматически донастраивать свежеустановленную систему так,
# как вам нужно, не делая это всё в ручную.
#
# 1. Удаляем предустановленные и ненужные (по усмотрению) утилиты с их настройками из системы:
##############################################################################################
# Поскольку нет необходимости больше пользоваться нижеследующими утилитами в будущем, то незачем оставлять
# в системе файлы их настроек, поэтому для удаления используем sudo apt purge вместо sudo apt remove
#
# vino - утилиту удалённого доступа к НАШЕМУ рабочему столу
# Redshift - утилита для автоматической смены цветовой температуры монитора, в зависимости от времени суток
# pix - доп. программа просмотра изображений (Хватит и простой Xviewer)
# pidgin - утилиту мгновенных сообщений Pidgin
# HexChat - встроенный чатик
# GNote - заметки
# Thunderbird - почтовый клиент
# Warpinator - отправка и получение файлов по локальной сети
# rhythmbox - аудиоплеер
# webapp-manager - создавать десктопные приложения из страниц сайтов - хр*нь, короче!
# HexChat - IRC client based on XChat
# onboard - экранная клавиатура
# Timeshift - программа востановления системы из бэкапа (снимка)
# firefox - этот браузер иногда сильно подвешивает систему и у некоторых спецов по безопасности есть ряд вопрос к разработчикам..
sudo apt purge -y redshift pix thunderbird warpinator rhythmbox webapp-manager hexchat onboard timeshift firefox

# удалить extensions(расширения), cache и данные Firefox
rm -rf ~/.mozilla

# 2. Обновим систему:
#####################
# Обновим системные списки ссылок на пакеты, содержащихся в репозиториях:
sudo apt update
# Обновим установленные пакеты (и их зависимости), для которых в репозиториях доступны новые версии и
# удаляем пакеты (зависимости), которые более ненужны:
sudo apt full-upgrade -y
# Устраним сбои (если такие есть) в базе пакетов, вызванные нарушениями зависимостей:
sudo apt install -f -y 
# Удалим оставшиеся конфиги от удалённых пакетов:
sudo aptitude -y purge ~c 
# Удалим архивные файлы .deb пакетов из локального репозитория:
sudo apt clean -y
# Удалим архивные файлы .deb пакетов из каталога /var/cache/apt/archives
sudo apt autoclean -y

# 3. Решаем проблемы и недочёты (донастраиваем) Linux Mint:
###########################################################
# "Warning: No support for locale: ru_RU.utf8":
sudo locale-gen --purge --no-archive
# Добавляем две локали в систему, которые ИНОГДА по умолчанию не устанавливаются:
sudo locale-gen ru_RU.CP1251 ru_RU.KOI8-R
# Установим показ русскоязычной документации (манов) по команде man <пакет> (если они есть на русском) 
echo 'export MANOPT="-L ru"' >> ~/.bashrc

# 4. Установим необходимый софт, используя списки репозиториев системы:
#######################################################################
# Установим 32 битные библиотеки для разрешения неразрешённых зависимостей в 64 битной системе, это позволит,
# при возникновении необходимости, устанавливать и запускать 32 битные и gt приложения на 64 битной системе:
sudo apt install -y ia32-libs libc6:i386
# Установим Microsoft True Type(ttf) шрифты: Andale Mono, Arial, Arial Black, Comic Sans MS, Courier New, Georgia, Impact, Times New Roman, Trebuchet, 
# Verdana, Webdings
sudo apt install -y ttf-mscorefonts-installer
#
# vim - редактор
# mc - Midnight Commander - консольный файловый менеджер
# kcolorchooser - пипетка выбора цветов и выбора цвета на экране (нажимать на каплю)
# kruler - экранная линейка
# inkscape - редактор векторной графики
# gparted - редактор разделов HDD
# filezilla - FileZilla Client (да, в репозитории не самая последняя версия, но ведь перед добавлением в репозиторий она протестированна и работает стабильно)
# libimage-exiftool-perl - утилита для удаление EXIF информации из изображений и фото
# whois - утилита получения сведений об IP или URL адресе ресурса (Пример: $ whois patsuckow.ru | less )
# tree - выводит дерево файлов и папок, а потом подсчитывает их количество по отдельности. Кроме того, утилита имеет множество опций и настроек.
# htop — консольный монитор системных ресурсов в реальном времени: посмотреть сколько оперативной памяти занято, процент использования процессора, какие процессы 
#        используют больше всего ресурсов системы, можно менять приоритеты процессов завершать их, выполнять поиск, фильтровать процессы по определенным 
#        параметрам, сортировать, а также смотреть потоки каждого процесса.
# brasero - запись CD/DVD-R/RW (обычных, загрузочных с iso), музыкальных дисков, клонирование дисков www.gnome.org/projects/brasero
# freecad - бесплатная система 2D и 3D моделирования (куча роликов, документации и поддержкой python - https://www.freecad.org/?lang=ru )
# pip - пакетный менеджер для python3
# python3-venv - уилита для работы с виртуальным окружением в python3
# clamav - антивирусный сканер и его демона + clamtk - графическая оболочка к нему.
# ark - графическая утилита-архиватор: tar, tar.bz2, tar.lz4, tar.lz, tar.lzma, tar.xz, tar.zst, tar.Z, zip и т.д.
# pwgen - консольный генератор паролей. Использование (рандомный, 18 символьный пароль, без символов O/0 и 1/I): pwgen -sB 18
# ffmpeg - A complete, cross-platform solution to record, convert and stream audio and video. https://ffmpeg.org/
# Cheese - утилита для получения снимков и видео с вашей вебкамеры
# kdenlive - видео редактор для Linux, для решения полупрофессиональных задач, с открытым исходным кодом, ориентированный на работу в окружении рабочего 
#            стола KDE. Для работы с видео используются другие проекты, такие как ffmpeg и mlt 
# vnstat - Учет трафика сетевого интерфейса https://electrichp.blogspot.com/2013/05/linux-vnstat.html
# obs-studio - захват видео скринкастов с экрана Linux, позволяет записывать видео с нескольких источников, в том числе с наложением картинки / возможна 
#              трансляция на все популярные платформы: YouTube, Twitch и другие
# whatsapp-desktop - Unofficial whatsapp web desktop client for OSX, Linux and Windows. Build with Electron.
# speedtest-cli - измерение скорости интернета (загрузка/выгрузка/задержка и потеря пакетов, настройка сбора статистики и использование в своих утилитах) - https://www.speedtest.net/apps/cli
# fuse3 - нужен для работы Cryptomator на Linux Mint
sudo apt install -y filezilla mc xneur gxneur kcolorchooser kruler inkscape gparted libimage-exiftool-perl whois tree htop brasero freecad
sudo apt install -y python3-pip python3-venv clamav clamav-daemon clamtk ark pwgen ffmpeg cheese kdenlive vnstat obs-studio 
sudo apt install -y speedtest-cli fuse3
# mmex - менеджер личных финансов
# obsidian - — это инструмент для локальной работы с набором файлов Markdown
# wipe - утилита для безвозвратного удаления файлов? путём перезаписи содержимого файла и каталога случайными данными или нулями.
# libssl-dev - OpenSSL lib
# sudo apt install -y mmex wipe obsidian whatsapp-desktop ibssl-dev

# 5. Установим необходимый софт, используя ppa-репозитории:
###########################################################
# Cryptomator - кроссплатформенное средство резервного копирования с шифрованием для вашего облачного хранилища (Dropbox, Google Drive, OneDrive и любым 
# другим облачным сервисом хранения данных, синхронизирующимся с локальной папкой). Сайт - https://cryptomator.org
sudo add-apt-repository ppa:sebastian-stenzel/cryptomator -y && sudo apt update && sudo apt install cryptomator -y
# KeePassXC - кросплатформенный менеджер паролей (https://keepassxc.org/) ("живой" форк разработки от "мёртвой и не обновляющейся" KeePassX 
#             https://www.keepassx.org/)
sudo add-apt-repository -y ppa:phoerious/keepassxc && sudo apt update && sudo apt install -y keepassxc
# Консольный git:
sudo apt add-repository ppa:git-core/ppa -y && sudo apt update && sudo apt install -y git
# Grub Customizer - утилита для настройки загрузчика системы
# sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y && sudo apt update && sudo apt install -y grub-customizer
# DB Browser for SQLite (sqlitebrowser) для работы с БД SQLite3  (GUI версия)
sudo add-apt-repository -y ppa:linuxgndu/sqlitebrowser && sudo apt update && sudo apt install -y sqlitebrowser
# Boot-Repair - утилита для восстановления доступа к вашей операционной системе
# https://sourceforge.net/p/boot-repair/home/ru/
# https://help.ubuntu.com/community/Boot-Repair
# https://github.com/yannmrn/boot-repair
sudo add-apt-repository -y ppa:yannubuntu/boot-repair && sudo apt update && sudo apt install -y && boot-repair
# Typora - A minimal Markdown reading & writing app / https://typora.io
#wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
#sudo add-apt-repository -y 'deb https://typora.io/linux ./'
#sudo apt update & sudo apt install -y typora
# Etcher (balena-etcher-electron) - утилита записи загрузочных ISO-образов на флешку
curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' | sudo -E bash
sudo apt update & sudo apt install -y balena-etcher-electron

# 6. Установка утилит, для обновления которых требуется наличие в системе крипто-ключей для их репозиториев:
#############################################################################################################
# Создадим скрытую папку в домашней директории пользователя (но с доступом только суперпользователя), где будем хранить скачанные ключи для репозиториев:
sudo mkdir ~/.crypto-keys

# Скачаем GPG ключ для VSCodium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
# Бобавим GPG ключ в наш локальный репозиторий 
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
# Обновим списки репозиториев(пакетов в системе), скачаем и установим VSCodium
sudo apt update && sudo apt install -y codium

# 7. Скачаем и установим deb пакеты:
####################################
# Создадим каталог uploads во временной папке системы:
sudo mkdir /tmp/uploads
# Скачаем пакеты:
#################
# TeamViewer - Пакет программного обеспечения для удалённого контроля компьютеров совместного использования,
#              обмена файлами между управляющей и управляемой машинами, видеосвязи и веб-конференций.
#sudo wget -P /tmp/uploads https://download.teamviewer.com/download/linux/teamviewer_amd64.deb

# Skype - для видеозвонков
# sudo wget -P /tmp/uploads https://go.skype.com/skypeforlinux-64.deb

# yt-dlp - форк youtube-dl с активной разработкой и поддержкой. Он также предлагает широкий набор 
#          функций и возможностей для загрузки видео с YouTube и других платформ.
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

# Yandex.Disk - онлайн хранилище. Есть одно НО - он при загрузке графической оболочки может сильно тормозить систему 2-3 минуты! Так что автозагрузку - лучше отключить!
# Вся документация: https://yandex.ru/support/disk-desktop-linux/start.html
#sudo echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | sudo tee -a /etc/apt/sources.list.d/yandex-disk.list > /dev/null
#sudo wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | sudo apt-key add - 
#sudo apt-get update
#sudo apt-get install -y yandex-disk
# echo 'Запускаем ручную настройку клиента Yandex.Disk:';
#yandex-disk setup
# Установим СТОРОННИЙ GUI индикатор yd-tools для Yandex.Disk (добавим ppa-репозиторий, обновим список пакетов и установим) - делать нужно только после установки 
# и настройки самого клиента Yandex.Disk
#sudo apt add-repository ppa:slytomcat/ppa -y && sudo apt update && sudo apt install -y yd-tools
# Запускаем индикатор Yandex.Disk (автозагрузка включена по умолчанию)
#yandex-disk-indicator

# На всякий случай проверим и устраним сломавшиеся зависимости:
sudo apt-get install -f
# Установим все скачанные .deb-пакеты:
sudo dpkg -i /tmp/uploads/*.deb
# Удовлетворяем требуемые зависимости
sudo apt --fix-broken -y install
# Удаляем каталог uploads из временной папки со всем содержимым:
sudo rm -rf /tmp/uploads

# 8. Установка с сайтов, через установочные ssh
###############################################
# Vivaldi браузер
sudo wget -P https://downloads.vivaldi.com/snapshot/install-vivaldi.sh
sh install-vivaldi.sh
#
# Установим pyenv - утилиту для управления несколькими версиями Python на одной системе.
curl https://pyenv.run | bash
# Теперь обновим настройки оболочки
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
source ~/.bashrc
# Установим несколько последних версий Python с помощью pyenv
pyenv install -v 3.10.13
pyenv install -v 3.11.7
pyenv install -v 3.12.0
# Установим версию Python 3.12.0 как глобальную в сисеме
pyenv global 3.12.0

# PIP - пакетный менеджер для python
####################################
# Обновляем его
pip install --upgrade pip
# 
# pip install 

# 9. После всех установок/обновлений/удалений:
##############################################
# Обновим списки пакетов, содержащихся в репозиториях
# Обновим пакеты, установленные в системе (и их зависимости), для которых в репозиториях доступны новые версии
sudo apt update && sudo apt full-upgrade -y
# Удаляем пакеты (зависимости), которые более ненужны
sudo apt-get install -f -y
# Обновим пакеты, которые требуют разрешения зависимостей (установки дополнительных/удаления конфликтующих пакетов)
sudo apt dist-upgrade -y 
# Устраним сбои (если такие есть) в базе пакетов, вызванные нарушениями зависимостей
sudo apt install -f -y 
# Удалим оставшиеся конфиги от удалённых пакетов
sudo aptitude -y purge ~c 
# Удалим архивные файлы .deb пакетов из локального репозитория
sudo apt clean -y
# Удалим архивные файлы .deb пакетов из каталога /var/cache/apt/archives
sudo apt autoclean -y

# 10. Установить тему значков рабочего стола:
gsettings set org.gnome.desktop.interface icon-theme 'Mint-Y-Dark-Blue'

# 11. Установим правильную смену раскладки клавиатуры
echo "setxkbmap -layout us,ru -option grp:alt_shift_toggle" >> ~/.bashrc

# Перезагрузим систему, через 1 минуту:
shutdown -r +1

exit 0
