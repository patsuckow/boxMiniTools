:: Универсальный скрипт для разных Windows систем для проверки, что bat-файл запущен с правами администратора. 
:: Если нет, использует несколько вариантов для перезапуска самого себя с повышенными привилегиями в системе.
:: 
:: Преимущества перед любыми другими вариантами:
:: - Скрипт полностью независим от состояния службы "Сервер" и команды NET FILE.
::   Вместо неё используется попытка создать временный файл в системной директории (%SystemRoot%\System32).
:: - Работает на системах где есть PowerShell, если его нет, то использует VBScript как резервный вариант повышения привилегий в системе.
:: - Совместим с большинством конфигураций Windows.
:: - Обеспечивает повышение привилегий даже в ограниченных средах.

:: Перемещаем текущую рабочую директорию в ту же, где находится этот .bat-файл.
cd /d %~dp0

@echo off
:: Отключаем вывод команд
setlocal EnableExtensions EnableDelayedExpansion

:: Очищаем экран консоли
cls

:: Проверка прав администратора с помощью попытки создать временный файл в системной директории (%SystemRoot%\System32)
set "adminTestFile=%SystemRoot%\System32\adminTest.tmp"

:: Проверяем, был ли уже передан флаг "ELEV", который указывает, что мы уже перезапускались с правами администратора
if "%1"=="ELEV" (
    echo Administrator rights confirmed. Continuing with the main script logic...
    goto gotPrivileges
)

:: Если флага нет, пробуем создать временный файл в системной директории для проверки прав
> "%adminTestFile%" echo Test >nul 2>&1
if exist "%adminTestFile%" (
    del "%adminTestFile%" >nul 2>&1
    echo Administrator rights confirmed. Continuing with the main script logic...
    goto gotPrivileges
) else (
    :: Если PowerShell доступен, используем его для запуска скрипта с повышенными привилегиями (через Start-Process с флагом -Verb RunAs).
    powershell -command "exit 0" >nul 2>&1
    if '%errorlevel%' == '0' (
        echo PowerShell is available, let's use it to request administrator rights.
        powershell -command "Start-Process '%~f0' -ArgumentList 'ELEV' -Verb RunAs"
        exit /b
    ) else (
        :: Если PowerShell недоступен, создаём временный VBScript для запроса прав администратора через UAC.
        echo PowerShell is not available, create a temporary VBScript to elevate privileges.
        set "vbsGetPrivileges=%temp%\getPrivileges.vbs"
        echo Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
        echo UAC.ShellExecute "%~s0", "ELEV", "", "runas", 1 >> "%vbsGetPrivileges%"
        "%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%"
        echo Delete the VBScript file
        del "%vbsGetPrivileges%"
        exit /b
    )
)

:gotPrivileges
:: Удаление временных файлов, если параметр "ELEV" передан
if "%1"=="ELEV" shift /1

:: Далее идёт основная логика вашего скрипта, которому нужны были права администратора в системе Windows
:: Важно!: Запускать команды (без открытия нового окна терминала) нужно будет через префикс-команду: start /b cmd /c "ваша команда"
:: Например:

:: Остановка службы, если она запущена (без открытия нового окна терминала, но оборачивать в префикс-команду НЕ нужно!)
sc query libusb0 | find "RUNNING" >nul && sc stop libusb0 >nul 2>&1

:: Удаление dll библиотек драйверов
start /b cmd /c "del /F /Q C:\Windows\SysWOW64\libusbK.dll"
start /b cmd /c "del /F /Q C:\Windows\SysWOW64\libusb0.dll"
start /b cmd /c "del /F /Q C:\Windows\System32\libusbK.dll"
start /b cmd /c "del /F /Q C:\Windows\System32\libusb0.dll"
start /b cmd /c "del /F /Q C:\Windows\System32\libusbK_x86.dll"
start /b cmd /c "del /F /Q C:\Windows\System32\libusb0_x86.dll"

:: Изменение прав доступа и удаление sys-файла драйвера
start /b cmd /c "takeown /f C:\Windows\System32\drivers\libusb0.sys"
start /b cmd /c "icacls C:\Windows\System32\drivers\libusb0.sys /grant %username%:F"
start /b cmd /c "del /F /Q C:\Windows\System32\drivers\libusb0.sys"

:: Запуск certmgr.msc и regedit (здесь достаточно префикс команды: start /b )
start /b certmgr.msc
start /b regedit

::pause
exit
