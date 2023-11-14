# Скрипт (на python) шифрования/расшифровки файла или каталога с файлами (аналог AES256crypt.sh),
# но всё так же для Linux, с ипользование утилиты tar
#
# Автор: https://github.com/patsuckow/
# 2023г.
#
# Замечание:
# В силу неумения утилитой tar обрабатывать директории с пробелами в именах - пути к
# файлам/директориям которые нужно зашифровать - не должны содержать пробелы!
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


def check_success(return_code, success_message, error_message):
    """
    Проверяет успешность выполнения операции на основе кода возврата.
    Если операция прошла успешно, выводит success_message.
    В противном случае, выводит error_message и завершает выполнение программы.
    """
    if os.WIFEXITED(return_code) and os.WEXITSTATUS(return_code) == 0:
        print(success_message)
    else:
        print(error_message)
        sys.exit(1)


def file_encrypt(base_name):
    """
    Функция для шифрования файла.

    Args:
        base_name (str): Имя файла для шифрования.

    Returns:
        str: Имя зашифрованного файла.
    """
    if not os.path.exists(base_name):
        print(f"Файл не существует: {base_name}")
        sys.exit(1)

    # Зашифруем файл, используя openssl и алгоритм AES-256-CBC с ключом 256 бит и "солью"
    new_name = f"{base_name}.enc"
    return_code = os.system(
        f"openssl enc -aes-256-cbc -salt -in {base_name} -out {new_name}"
    )
    # Проверка успешности шифрования
    check_success(
        return_code,
        f"\nШифрование прошло успешно.\nПолучен зашифрованный файл: {new_name}",
        "При шифровании произошла ошибка",
    )

    return new_name  # TODO: пока не используется


def file_decrypt(encrypted_file, new_name):
    """
    Функция для расшифровки файла.

    Args:
        encrypted_file (str): Имя зашифрованного файла.
        new_name (str): Имя расшифрованного файла.

    Returns:
        str: Имя расшифрованного файла.
    """
    if not os.path.exists(encrypted_file):
        print(f"Зашифрованный файл не существует: {encrypted_file}")
        sys.exit(1)

    # Расшифруем файл с помощью openssl
    return_code = os.system(
        f"openssl enc -aes-256-cbc -d -in {encrypted_file} -out {new_name}"
    )
    # Проверка успешности расшифровки
    check_success(
        return_code,
        f"\nРасшифровка прошла успешно.\nПолучен файл: {new_name}",
        "При расшифровке произошла ошибка",
    )

    return new_name


def tar_rf(base_name):
    """
    Функция для архивации каталога с файлами.

    Args:
        base_name (str): Имя каталога для архивации.

    Returns:
        str: Имя полученного файла-архива.
    """
    print("Запаковываем каталог в архив...")
    archive_name = base_name + ".tar"
    return_code = subprocess.run(["tar", "-rf", archive_name, base_name])
    # Проверка успешности архивации
    check_success(
        return_code.returncode,
        f"Архивация прошла успешно.\nПолучен файл: {archive_name}",
        "При архивации произошла ошибка",
    )

    return archive_name


def tar_xf(archive):
    """
    Функция для разархивации каталога с файлами.

    Args:
        archive (str): Имя архива для разархивации.

    Returns:
        str: Имя распакованного каталога
    """
    print("Распаковка архива...")
    return_code = subprocess.run(["tar", "-xf", archive])
    # Получаем имя распакованного каталога
    name_dir = os.path.basename(archive).replace(".tar", "")
    # Проверка успешности разархивации
    check_success(
        return_code.returncode,
        f"Распаковка прошла успешно.\nПолучен каталог: {name_dir}",
        "При разархивации произошла ошибка",
    )

    return name_dir  # TODO: пока не используется


def del_source(name):
    """
    Функция для удаления исходного файла/каталога.

    Args:
        name (str): Имя файла/каталога для удаления.

    Returns:
        str: Имя удалённого файла/каталога
    """
    os.system("rm -rf {}".format(name))

    return print(f"Удалён: {name}")


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Передано неправильное кол-во аргументов!")
        sys.exit(1)

    # Сохраняем второй переданный аргумент
    operation = sys.argv[1]
    # Сохраняем переданный путь в переменную
    file_path = sys.argv[2]

    # Переходим из каталога где запущен скрипт, в каталог с файлом/папкой c файлами которые
    # нужно зашифровать
    dirname_command = 'dirname "{}"'.format(file_path)
    dirname = os.popen(dirname_command).read().strip()
    os.chdir(dirname)

    # Если нужно зашифровать
    if operation == "enc":
        # Получаем имя файла или каталога из переданного пути
        base_name = os.path.basename(os.path.normpath(file_path))

        # Eсли указанный путь - это директория с файлами, то архивируем каталог с файлами
        if os.path.isdir(file_path):
            # Архивируем каталог с файлами, получая tar-архив
            base_name = tar_rf(base_name)

        # Шифруем файл/архив
        file_encrypt(base_name)
        # Так как шифрование прошло успешно, то удалим незашифрованный файл/каталог
        del_source(file_path)
        # Если есть файл архива с именем "base_name.tar", удаляем его
        if os.path.exists(base_name):
            del_source(base_name)
    # Если нужно расшифровать
    elif operation == "dec":
        # убираем расширение .enc
        new_name = file_path.replace(".enc", "")
        # Расшифровываем
        new_name = file_decrypt(file_path, new_name)
        # Так как расшифровка прошла успешно, то удалим зашифрованный файл/каталог
        del_source(file_path)
        # Если после расшифровки перед нами tar архив, то распакуем его
        if new_name.endswith(".tar"):
            tar_xf(new_name)
            # удаляем файл архива
            del_source(new_name)
    else:
        print(
            'Неверный параметр. Используйте "enc" для шифрования или "dec" для расшифровки.'
        )
        sys.exit(1)
