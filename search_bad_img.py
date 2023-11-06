import os
import shutil
import random

# Обнаружить битые изображения:
# https://medium.com/joelthchao/programmatically-detect-corrupted-image-8c1b2006c3d3
# Используем:
# https://scikit-image.org/
# Установка:
# pip install scikit-image
from skimage import io


class SearchBadImg:
    """
    Поиск и перенос битых изображений в папку bad_img (или заданную пользов.).
    Будут перенесены и все другие файлы, не являющиеся изображениями.
    Переносимые файлы с одинаковым именем из разных папок будут переименованы.
    
    @author Пацуков А.А.
    """

    # Счётчик битых изображений
    count_bad_img = 0
    # Счётчик всех проверенных изображений
    count_img = 0

    def __init__(self, dir_name='bad_img'):
        self.dir_name = dir_name
        # Если папки для переноса в неё битых фото нет, то создадим её.
        # Если создать такую директорию не удалось, то вернём исключение.
        if self._mkdir(self._name_dir_bad_img()):
            # Если всё норм, начинаем рекурсивно проходить по каталогам
            self._recursive_folder_traversal()

    @staticmethod
    def _verify_image(img_file: bin):
        """Обнаружить битые изображения"""
        try:
            io.imread(img_file)
        except:
            return False
        return True

    @staticmethod
    def _gen_unique_str(len_output_str: int):
        """Генератор уникальной строки"""
        return ''.join([
            random.choice(list(
                '123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM'
            )) for _ in range(len_output_str)
        ])

    @staticmethod
    def _mkdir(directory: str):
        # Если такого каталога ещё нет, то создадим его:
        if not os.path.exists(directory):
            try:
                os.mkdir(directory)
            except OSError:
                print(f"Создать директорию {path} не удалось")
                return False
        return True

    def _name_dir_bad_img(self):
        """
        Вернём путь к требуемому каталогу.
        (Находится на уровень выше запущенного скрипта)
        """
        parent_dir = os.path.abspath(os.path.join(os.getcwd(), os.pardir))
        # os.sep добавить правильный разделитель каталогов, в зависимости от ОС
        return parent_dir + os.sep + self.dir_name + os.sep

    def _rename_file(self, fullname: str):
        path = os.path.dirname(fullname) + os.sep
        basename = os.path.basename(fullname)
        name = os.path.splitext(basename)[0]
        ext = os.path.splitext(basename)[1]
        # os.rename(src, dst, *, src_dir_fd=None, dst_dir_fd=None) -
        # переименовывает файл или директорию из src в dst.
        # Переименуем с добавлением _ и уникальной 7 значной строки
        new_file_name = f"{path}{name}_{self._gen_unique_str(7)}{ext}"
        os.rename(path + basename, new_file_name)
        return new_file_name

    def _move_file(self, fullname: str):
        """
        Перенесём битое изображение в нужную папку
        
        Примечание:
        Сначала я думал, что нужно:
        сохранить путь текущего каталога, в котором запущен скрипт
        my_dir = os.getcwd()
        сменить текущий каталог, на нужный
        os.chdir(self._name_dir_bad_img())
        Если файл fullname с таким именем уже существует в папке bad_img,
        то переименовать файл который в папке bad_img, добавив уникальную str
        и вернуться в исходный каталог
        os.chdir(my_dir)
        НО, это будет по времени дольше, чем просто сгенерировать новое имя
        файла, переименовать и перенести файл.
        """
        # Переименуем файл, перед тем, как переносить его в папку назначения
        fullname = self._rename_file(fullname)
        # Переносим
        shutil.move(fullname, self._name_dir_bad_img())

    def _recursive_folder_traversal(self):
        # os.walk(top, topdown=True, onerror=None, followlinks=False) -
        # генерация имён файлов в дереве каталогов. Для каждого каталога
        # функция walk возвращает кортеж (путь к каталогу, список каталогов,
        # список файлов).
        for patch, dirs, files in os.walk('.'):
            # Пропускаем папку для плохих изображений
            # if 'bad_img' in dirs:
            #     continue
            for filename in files:
                # Получаем полное имя-путь к файлу
                fullname = os.path.join(patch, filename)
                # Пропустим сам файл нашего запущенного скрипта:
                if fullname == './search_bad_img.py':
                    continue
                with open(fullname, 'rb') as f:
                    if not self._verify_image(f):
                        print(f"Изображение {fullname} повреждено")
                        # Перенесём битое изображение в нужную папку (на
                        # уровень выше)
                        self._move_file(fullname)
                        SearchBadImg.count_bad_img += 1
                    SearchBadImg.count_img += 1
        print(f"\n Итого:\n Проверенно изображений: {SearchBadImg.count_img} "
              f"\n Повреждённых изображений найдено: "
              f"{SearchBadImg.count_bad_img}")


if __name__ == "__main__":
    SearchBadImg()
