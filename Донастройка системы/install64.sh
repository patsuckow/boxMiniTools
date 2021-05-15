# Актуальность: май 2021г.
# Пример для OS Linux Mint 20, Cinnamon (64-bit).
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
#!/bin/bash

# 1. Удаляем предустановленные и ненужные утилиты с их настройками из системы:
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
sudo apt purge -y redshift pix hexchat gnote thunderbird warpinator rhythmbox webapp-manager

# 2. Обновим систему:
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

# 3. Решаем проблемы и недочёты (донастраиваем) Linux Mint 20.*:
#
# "Warning: No support for locale: ru_RU.utf8":
sudo locale-gen --purge --no-archive
# Добавляем две локали в систему, которые ИНОГДА по умолчанию не устанавливаются:
sudo locale-gen ru_RU.CP1251 ru_RU.KOI8-R
# Установим показ русскоязычной документации (манов) по команде man <пакет> (если они есть на русском) 
echo 'export MANOPT="-L ru"' >> ~/.bashrc

# 4. Установим необходимый софт, используя списки репозиториев системы:
#
# Установим 32 битные библиотеки для разрешения неразрешённых зависимостей в 64 битной системе, это позволит,
# при возникновении необходимости, устанавливать и запускать 32 битные и gt приложения на 64 битной системе:
sudo apt install -y ia32-libs libc6:i386
# Установим Microsoft True Type(ttf) шрифты: Andale Mono, Arial, Arial Black, Comic Sans MS, Courier New, Georgia, Impact, Times New Roman, Trebuchet, 
# Verdana, Webdings
sudo apt install -y ttf-mscorefonts-installer
#
# vim - редактор
# mc - Midnight Commander - консольный файловый менеджер
# dropbox - Dropbox-клиент
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
# zeal -  an offline documentation browser for software developers zealdocs.org
# obs-studio - захват видео скринкастов с экрана Linux, позволяет записывать видео с нескольких источников, в том числе с наложением картинки / возможна 
#              трансляция на все популярные платформы: YouTube, Twitch и другие
# whatsapp-desktop - Unofficial whatsapp web desktop client for OSX, Linux and Windows. Build with Electron.
sudo apt install -y filezilla mc dropbox xneur gxneur kcolorchooser kruler  inkscape gparted libimage-exiftool-perl whois tree htop brasero
sudo apt install -y python3-pip python3-venv clamav clamav-daemon clamtk ark pwgen ffmpeg cheese kdenlive vnstat zeal obs-studio whatsapp-desktop

# 5. Установим необходимый софт, используя ppa-репозитории:
###########################################################
# Cryptomator - кроссплатформенное средство резервного копирования с шифрованием для вашего облачного хранилища (Dropbox, Google Drive, OneDrive и любым 
# другим облачным сервисом хранения данных, синхронизирующимся с локальной папкой). Сайт - https://cryptomator.org
sudo add-apt-repository ppa:sebastian-stenzel/cryptomator -y && sudo apt update && sudo apt install cryptomator -y
# KeePassXC - кросплатформенный менеджер паролей (https://keepassxc.org/) ("живой" форк разработки от "мёртвой и не обновляющейся" KeePassX 
#             https://www.keepassx.org/)
sudo add-apt-repository -y ppa:phoerious/keepassxc && sudo apt update && sudo apt  install -y keepassxc
# Консольный git:
sudo apt add-repository ppa:git-core/ppa -y && sudo apt update && sudo apt install -y git
# Grub Customizer - утилита для настройки загрузчика системы
sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y && sudo apt update && sudo apt install -y grub-customizer
# Sqlitebrowser (для работы с SQLite3) - GUI версия
sudo add-apt-repository -y ppa:linuxgndu/sqlitebrowser && sudo apt update && sudo apt install -y sqlitebrowser
# Boot-Repair - утилита для восстановления доступа к вашей операционной системе
# https://sourceforge.net/p/boot-repair/home/ru/
# https://help.ubuntu.com/community/Boot-Repair
# https://github.com/yannmrn/boot-repair
sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt update && sudo apt install -y && boot-repair
# Typora - A minimal Markdown reading & writing app / https://typora.io
wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
sudo add-apt-repository -y 'deb https://typora.io/linux ./'
sudo apt update
sudo apt install -y typora

# 6. Установка утилит, для обновления которых требуется наличие в системе крипто-ключей для их репозиториев:
#############################################################################################################
# Создадим скрытую папку в домашней директории пользователя (но с доступом только суперпользователя), где будем хранить скачанные ключи для репозиториев:
sudo mkdir ~/.crypto-keys

# Скачаем и добавим в наш репозиторий ключ для VS Code
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# Обновим списки репозиториев(пакетов в системе) и скачаем и установим VS Code
sudo apt update && sudo apt install -y code

# 7. Скачаем .deb-пакеты и установим утилиты:
#############################################
# Создадим каталог uploads во временной папке системы:
sudo mkdir /tmp/uploads
# Скачаем .deb-пакеты:
######################
# TeamViewer - Пакет программного обеспечения для удалённого контроля компьютеров совместного использования,
#              обмена файлами между управляющей и управляемой машинами, видеосвязи и веб-конференций.
# Skype - для видеозвонков
sudo wget -P /tmp/uploads https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
sudo wget -P /tmp/uploads https://go.skype.com/skypeforlinux-64.deb
# На всякий случай проверим и устраним сломавшиеся зависимости:
sudo apt-get install -f
# Установим все скачанные .deb-пакеты:
sudo dpkg -i /tmp/uploads/*.deb 
# Удаляем каталог uploads из временной папки со всем содержимым:
sudo rm -rf /tmp/uploads
 
# Yandex.Disk - онлайн хранилище
# Вся документация: https://yandex.ru/support/disk-desktop-linux/start.html
# Если вами понадобится, раскоментируете сами:
# sudo wget -O YANDEX-DISK-KEY.GPG http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG
# sudo apt-key add YANDEX-DISK-KEY.GPG
# sudo echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" >> /etc/apt/sources.list.d/yandex-disk.list
# sudo apt-get update
# sudo apt-get install yandex-disk
# echo 'Запускаем ручную настройку клиента Yandex.Disk:';
# yandex-disk setup
# Установим СТОРОННИЙ GUI индикатор yd-tools для Yandex.Disk (добавим ppa-репозиторий, обновим список пакетов и установим) - делать нужно только после установки 
# и настройки самого клиента Yandex.Disk
# sudo apt add-repository ppa:slytomcat/ppa -y && sudo apt update && sudo apt install -y yd-tools
# Запускаем индикатор Yandex.Disk (автозагрузка включена по умолчанию)
# yandex-disk-indicator

# 8. После всех установок/обновлений/удалений:
###########################################
# Обновим списки пакетов, содержащихся в репозиториях:
# Обновим пакеты, установленные в системе (и их зависимости), для которых в репозиториях доступны новые версии;
# Удаляем пакеты (зависимости), которые более ненужны:
# Обновим пакеты, которые требуют разрешения зависимостей (установки дополнительных/удаления конфликтующих пакетов):
# Устраним сбои (если такие есть) в базе пакетов, вызванные нарушениями зависимостей:
# Удалим оставшиеся конфиги от удалённых пакетов
# Удалим архивные файлы .deb пакетов из локального репозитория
# Удалим архивные файлы .deb пакетов из каталога /var/cache/apt/archives
sudo apt update && sudo apt full-upgrade -y && sudo apt dist-upgrade -y && sudo apt-get install -f -y && sudo aptitude -y purge ~c && sudo apt clean -y && sudo apt autoclean -y

# Перезагрузим систему, через 1 минуту:
shutdown -r +1

exit 0
