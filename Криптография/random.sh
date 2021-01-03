#!/bin/bash

# Скрипт генерации рандомного пароля
# Автор: https://github.com/patsuckow/
# 2017г.

# Если кол-во переданных аргументов больше 0, то
if [ $# > 0 ]
then
 MIN=$1
else # если аргумент не передан, то длинна пароля будет больше 8 символов
 MIN=8
fi

DEL=`expr $RANDOM % 5`
LEN=`expr $MIN + $DEL`
cat /dev/urandom | tr -dc "a-zA-Z0-9@#$%^~=[]?!" | dd  bs=$LEN count=1 2>/dev/null
echo

# Мифы о /dev/urandom - https://habr.com/company/mailru/blog/273147/

# Ещё способ генерации:
# tr -dc "a-zA-Z0-9@#$%^~=[]?!" < /dev/urandom | head -c 30 | xargs
# https://www.shellhacks.com/ru/generate-random-passwords-linux-command-line/
