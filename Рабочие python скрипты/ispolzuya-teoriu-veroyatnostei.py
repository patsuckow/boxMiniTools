# @uthor Пацуков А.А. (https://vk.com/patsuckow)
# Код к моей статье: Используя "Теорию вероятностей", подсчитаем какова
# вероятность выиграть в любую лотерею
# https://vk.com/@patsuckow-ispolzuya-teoriu-veroyatnostei
# Будем считать что 25% выигрыша - это уже хорошая лотерея
# (только это проценты не те, о которых вам могут сказать, а те, которые
# подсчитает данная программа использующая для этого Теорию вероятностей)


def calculate_jackpot_chance(a, b):
    if not (isinstance(a, int) and isinstance(b, int)) or a <= 0 or b <= a:
        return 'Введены неверные параметры'

    list_res = []
    res_tag = 'Ваш шанс на "джекпот" составляет: '
    not_miracle = 'К сожалению чуда не произошло.'
    miracle = 'O чудо! Вы нашли лотерею где у вас есть шанс!'

    for _ in range(a):
        # Если лотерея вообще "жестоко-лохотронная", к примеру "8 из 12",
        # там даже минусовые результаты появятся, типа: -0.1428571428571
        # Можно конечно считать дальше, но смысла нет, результат уже ясен,
        # ведь дальше вероятности ножно перемножить и ниже по коду, в цикле
        # перемножения полученных значений (for i in list_res), если хотя
        # бы один из сомножителей равен нулю, то и произведение равно нулю
        list_res.append((b - a) / b)
        b -= 1

    res = 1
    for i in list_res:
        res *= i

    result = (res / a) * 100

    outcome = miracle if result > 25 else not_miracle
    # Выводим значение шанса на "джекпот" в процентах с точностью до трех знаков
    # после запятой
    return f"{outcome}\n{res_tag}{result:.3f}%"

a = int(input("Введите общее количество исходов: "))
b = int(input("Введите количество желаемых исходов: "))
print(calculate_jackpot_chance(a, b))
