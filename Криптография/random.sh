#!/bin/bash

# Скрипт генерации рандомного пароля случайной длины от 12 до 32 символов)
# Автор: https://github.com/patsuckow/
# 2017 - 2023г.
#
# Мифы о /dev/urandom - https://habr.com/company/mailru/blog/273147/

# 1.Вариант (генерируем пароль строго длинной 18 символов)
PASSWORD=$(cat /dev/urandom | tr -dc "a-zA-Z0-9@#$%^~=[]?!" | dd  bs=18 count=1 2>/dev/null)
echo $PASSWORD

# 2.Вариант (генерируем пароль строго длинной 18 символов)
# https://www.shellhacks.com/ru/generate-random-passwords-linux-command-line/
# Проверяем количество переданных аргументов и задаём значение LEN равное первому переданному аргументу. 
# Если ни один аргумент не передается, то значение LEN будет равно 18.
if [ "$#" -gt 0 ]
then
 LEN=$1
else # если аргумент не передан, то длина пароля будет больше 18 символов
 LEN=18
fi

PASSWORD=$(tr -dc "a-zA-Z0-9@#$%^~=[]?!" < /dev/urandom | head -c "$LEN" | xargs)
echo $PASSWORD

# Остальные варианты будут генерировать длинну пароля случайно, от 12 до 32 символов
# 3. Вариант
MIN_LENGTH=11
MAX_LENGTH=32
LENGTH=$(($MIN_LENGTH + ($RANDOM % ($MAX_LENGTH - $MIN_LENGTH + 1))))
# Генерация и вывод пароля
PASSWORD=$(LC_ALL=C tr -dc "a-zA-Z0-9@#$%^~=[]?!" < /dev/urandom | fold -w $LENGTH | head -n 1)
echo $PASSWORD

# 4. Вариант (Используем openssl для генерации случайных символов, генерирует случайную длину пароля от 11 до 32 символов с использованием shuf)
# Генерация случайной длины пароля
LENGTH=$(shuf -i 11-32 -n 1)
# Генерация случайного пароля ( /dev/random и base64:)
PASSWORD=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9@#$%^~=[]?!' | head -c $LENGTH)
echo $PASSWORD

# 5. Вариант (Используем dd для чтения нужного количества случайных байтов из /dev/urandom. Результат фильтруем с помощью tr, 
# чтобы оставить только допустимые символы для пароля.
PASSWORD=$(tr -dc 'a-zA-Z0-9@#$%^~=[]?!' < /dev/urandom | head -c $(shuf -i 11-32 -n 1))
echo $PASSWORD

# 6. Вариант
PASSWORD=$(cat /dev/random | tr -dc 'a-zA-Z0-9@#$%^~=[]?!' | head -c $(shuf -i 11-32 -n 1))
echo $PASSWORD

# 7. Вариант
PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9@#$%^~=[]?!' | head -c $(shuf -i 11-32 -n 1))
echo $PASSWORD

# 8. Вариант
PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9@#$%^~=[]?!' | fold -w "$(shuf -i 11-32 -n 1)" | head -n 1)
echo $PASSWORD

# 9. Вариант (Используем shuf для перемешивания символов)
PASSWORD=$(echo "a-zA-Z0-9@#$%^~=[]?!" | fold -w1 | shuf | tr -d '\n' | head -c $(shuf -i 11-32 -n 1))
echo $PASSWORD

# 10. Вариант (head -c для ограничения длины пароля)
PASSWORD=$(tr -dc 'a-zA-Z0-9@#$%^~=[]?!' < /dev/urandom | head -c $(shuf -i 11-32 -n 1))
echo $PASSWORD

