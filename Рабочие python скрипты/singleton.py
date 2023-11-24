# Пример простого использования патерна Singleton
# @author Пацуков А.А.

class SingletonSetupStartTime:
    """ Th's Singleton need to set up start time one time. """
    st_tm = None

    def __init__(self):
        if SingletonSetupStartTime.st_tm is None:
            SingletonSetupStartTime.st_tm = time.time()


class SingletonToHideCursor:
    """ Th's Singleton need to hide console cursor one time.

    https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_codes
    hide console cursor: '\x1b[?25l'
    """
    hide = True

    def __init__(self):
        if SingletonToHideCursor.hide:
            print('\x1b[?25l')
            SingletonToHideCursor.hide = False


# Set up start time one time
st_tm = SingletonSetupStartTime().st_tm

# Hide console cursor one time
SingletonToHideCursor()
