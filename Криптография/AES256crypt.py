# Скрипт (на python) шифрования/расшифровки файла или каталога с файлами (аналог AES256crypt.sh), 
# но всё так же для Linux, с ипользование утилиты tar
#
# Автор: https://github.com/patsuckow/
# 2023г.
#
# Замечание:
# В силу неумения утилитой tar обрабатывать директории с пробелами в именах - пути к файлам/директориям которые нужно зашифровать - не должны содержать пробелы!
# Т.е. путь типа нижеследующих - будут некорректны! : 
# '/home/alex/Рабочий стол/1.txt'
# или
# '/home/alex/My Folder'
# "Корректный" путь, без пробелов:
# /home/alex/My_Folder
#
# Пример использования:
# Зашифровать каталог с файлами
# $ python3 AES256crypt.py enc ~/My_Folder
#
# Расшифровать архив-каталог
# $ python3 AES256crypt.py dec ~/My_Folder.tar.dec
#
# Зашифровать файл
# $ python3 AES256crypt.py enc ~/My_File
#
# Расшифровать файл
# $ python3 AES256crypt.py dec ~/My_File.dec

import os
import sys
import subprocess


# Функция для шифрования файла
def file_encrypt(base_name):
    if not os.path.exists(base_name):
        print(f"Файл не существует: {base_name}")
        sys.exit(1)
        
    # Зашифруем файл, используя openssl и алгоритм AES-256-CBC с ключом 256 бит и "солью"
    return_code = os.system(f"openssl enc -aes-256-cbc -salt -in {base_name} -out {base_name}.enc")
    # Проверяем успешно ли прошло шифрование
    if os.WIFEXITED(return_code) and os.WEXITSTATUS(return_code) == 0:
        print(f"\nШифрование прошло успешно, получен зашифрованный файл: {base_name}.enc")
    else:
        print("При шифровании произошла ошибка")
        sys.exit(1)


# Функция для расшифровки файла
def file_decrypt(encrypted_file, new_file_name):
    if not os.path.exists(encrypted_file):
        print(f"Зашифрованный файл не существует: {encrypted_file}")
        sys.exit(1)
    
    # Расшифруем файл с помощью openssl
    return_code = os.system(f"openssl enc -aes-256-cbc -d -in {encrypted_file} -out {new_file_name}")
    # Проверяем успешно ли прошла расшифровка
    if os.WIFEXITED(return_code) and os.WEXITSTATUS(return_code) == 0:
        print(f"\nРасшифровка прошла успешно, получен файл: {new_file_name}")
    else:
        print("При расшифровке произошла ошибка")
        sys.exit(1)
    
    return new_file_name

# Функция архивации каталога с файлами
def tar_rf(base_name):
    archive_name = base_name + ".tar"
    return_code = subprocess.run(["tar", "-rf", archive_name, base_name])
    # Проверяем успешно ли прошла архивация
    if os.WIFEXITED(return_code.returncode) and os.WEXITSTATUS(return_code.returncode) == 0:
        print(f"\nАрхивация прошла успешна, получен файл: {archive_name}")
    else:
        print("При архивации произошла ошибка")
        sys.exit(1)

# Функция разархивации каталога с файлами
def tar_xf(base_name):
    print('Распаковка архива...')
    return_code = subprocess.run(["tar", "-xf", base_name])
    # Проверяем успешно ли прошла разархивация
    if os.WIFEXITED(return_code.returncode) and os.WEXITSTATUS(return_code.returncode) == 0:
        print(f"\nРазахивация прошла успешно")
    else:
        print("При разархивации произошла ошибка")
        sys.exit(1)

# Функция удаления исходного файла/каталога
def deleting_source(name):
    os.system('rm -rf {}'.format(name))
    print(name, "удалён")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print('Передано неправильное кол-во аргументов!')
        sys.exit(1)

    # Сохраняем второй переданный аргумент
    operation = sys.argv[1]
    # Сохраняем переданный путь в переменную
    file_path = sys.argv[2]

    # Переходим из каталога где запущен скрипт, в каталог с файлом/папкой c файлами которые нужно зашифровать
    dirname_command = 'dirname "{}"'.format(file_path)
    dirname = os.popen(dirname_command).read().strip()
    os.chdir(dirname)

    # Если нужно зашифровать
    if operation == 'enc':
        # Получаем имя файла или каталога из абсолютного пути
        base_name = os.path.basename(os.path.normpath(file_path))

        # Eсли указанный путь - это директория с файлами, то архивируем каталог с файлами, если это файл - пропускаем архивацию
        isdir = os.path.isdir(file_path)
        if isdir:
            # Архивируем каталог с файлами, получая файл-архив
            tar_rf(base_name)
            # добавляем расширение для архива каталога
            base_name = base_name + ".tar"

        # Шифруем
        file_encrypt(base_name)
        # Так как шифрование прошло успешно, то удалим незашифрованный файл/каталог
        deleting_source(file_path)
        # Если есть файл архива с именем "base_name.tar", удаляем его
        if os.path.exists(base_name):
            deleting_source(base_name)

    # Если нужно расшифровать
    elif operation == 'dec':
        # убираем расширение .enc
        new_file_name = file_path.replace('.enc', '')
        # Расшифровываем
        new_file_name = file_decrypt(file_path, new_file_name)
        # Так как расшифровка прошла успешно, то удалим зашифрованный файл/каталог
        deleting_source(file_path)
        # Если после расшифровки перед нами tar архив, то распакуем его
        if new_file_name.endswith('.tar'):
            tar_xf(new_file_name)
            # удалим файл архива
            deleting_source(new_file_name)
            print("Получаем каталог: ", new_file_name.replace('.tar', ''))
    else:
        print('Неверный параметр. Используйте "enc" для шифрования или "dec" для расшифровки.')
        sys.exit(1)
