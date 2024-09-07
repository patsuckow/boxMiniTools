// Кликер для тапалки Dogiators (от 07.09.2024) Powered by patsuckow (https://github.com/patsuckow/)
//
// Использование:
// 1. Запускаем десктопную версию телеграм на пк
// 2. Запускаем бот тапалки и право кнопко - "Иследовать", находим в теле страницы тег <iframe class="zA1w1IOq" src="https://hamsterkombatgame.io/clicker/#tgWebAppData=query_id%****************&amp;tgWebAppVersion=7.8&amp;tgWebAppPlatform=weba&amp;tgWebAppThemeParams=%7B%22bg_color%22%3A%22%23212121%22%2C%22text_color%22%3A%22%23ffffff%22%2C%22hint_color%22%3A%22%23aaaaaa%22%2C%22link_color%22%3A%22%238774e1%22%2C%22button_color%22%3A%22%238774e1%22%2C%22button_text_color%22%3A%22%23ffffff%22%2C%22secondary_bg_color%22%3A%22%230f0f0f%22%2C%22header_bg_color%22%3A%22%23212121%22%2C%22accent_text_color%22%3A%22%238774e1%22%2C%22section_bg_color%22%3A%22%23212121%22%2C%22section_header_text_color%22%3A%22%23aaaaaa%22%2C%22subtitle_text_color%22%3A%22%23aaaaaa%22%2C%22destructive_text_color%22%3A%22%23e53935%22%7D" title="Hamster Kombat Web App" sandbox="allow-scripts allow-same-origin allow-popups allow-forms allow-modals allow-storage-access-by-user-activation" allow="camera; microphone; geolocation;"></iframe>
// 3. И в параметре tgWebAppPlatform=weba заменяем параметр на tgWebAppPlatform=android
// 4. Копируем изменый адрес ресурса (src) со всеми параметрами и без скобок, получаем строку которую вставлем в браузер, что-то типа:
// https://hamsterkombatgame.io/clicker/#tgWebAppData=query_id%****************&amp;tgWebAppVersion=7.8&amp;tgWebAppPlatform=android&amp;tgWebAppThemeParams=%7B%22bg_color%22%3A%22%23212121%22%2C%22text_color%22%3A%22%23ffffff%22%2C%22hint_color%22%3A%22%23aaaaaa%22%2C%22link_color%22%3A%22%238774e1%22%2C%22button_color%22%3A%22%238774e1%22%2C%22button_text_color%22%3A%22%23ffffff%22%2C%22secondary_bg_color%22%3A%22%230f0f0f%22%2C%22header_bg_color%22%3A%22%23212121%22%2C%22accent_text_color%22%3A%22%238774e1%22%2C%22section_bg_color%22%3A%22%23212121%22%2C%22section_header_text_color%22%3A%22%23aaaaaa%22%2C%22subtitle_text_color%22%3A%22%23aaaaaa%22%2C%22destructive_text_color%22%3A%22%23e53935%22%7D
// 5. В адресно строке должна повится строка типа: https://tte.dogiators.com/earn и игра должна запуститс в окне браузера
// 6. В консоль браузера вставлем содержимое данного скрипта и жмём Enter.
// 
// Логика работы скрипта:
// 1. При недостаточном уровне энергии скрипт будет проверять уровень через заданное время.
// 2. При достижении максимума энергии, скрипт будет скликивать до достижения нуля, затем ожидать её восстановления и повторять процесс.

const button = document.querySelector("#dogContainer canvas");

function getRandomPoint(element) {
    const rect = element.getBoundingClientRect();
    const x = Math.random() * rect.width;
    const y = Math.random() * rect.height;
    return { x, y };
}

function simulateClick(element) {
    if (element) {
        const rect = element.getBoundingClientRect();
        const { x, y } = getRandomPoint(element);

        const eventInit = {
            bubbles: true,
            cancelable: true,
            clientX: rect.left + x,
            clientY: rect.top + y
        };

        // Симуляция 'pointerdown'
        const downEvent = new PointerEvent('pointerdown', eventInit);
        element.dispatchEvent(downEvent);

        // Симуляция 'pointerup'
        const upEvent = new PointerEvent('pointerup', eventInit);
        element.dispatchEvent(upEvent);

        // Симуляция 'click'
        const clickEvent = new MouseEvent('click', {
            bubbles: true,
            cancelable: true,
            clientX: rect.left + x,
            clientY: rect.top + y
        });
        element.dispatchEvent(clickEvent);
    } else {
        console.log('Button element not found.');
    }
}

function getValuesEnergy() {
    const energyElement = document.querySelector(".EnergyModule .StrokedText");
    if (energyElement) {
        const energyText = energyElement.getAttribute('data-text');
        if (energyText) {
            const [currEnergy, maxEnergy] = energyText.split("/").map(Number);
            console.log('Energy Element:', energyElement);
            console.log('Current Energy:', currEnergy);
            console.log('Max Energy:', maxEnergy);
            return { currEnergy, maxEnergy };
        }
    }
    return null;
}

function getEnergyOneTap(callback) {
    simulateClick(button);
    setTimeout(() => {
        const newValuesEnergy = getValuesEnergy();
        if (newValuesEnergy) {
            const { currEnergy, maxEnergy } = newValuesEnergy;
            const energyOneTap = maxEnergy - currEnergy;
            console.log('Energy One Tap:', energyOneTap);
            callback(energyOneTap);
        } else {
            callback(null);
        }
    }, 100); // Небольшая задержка для обновления DOM
}

function getRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}

function clickMultipleTimes(button, numClicks) {
    for (let i = 0; i < numClicks; i++) {
        setTimeout(() => {
            simulateClick(button);
        }, getRandomNumber(50, 100));
    }
}

function handleFullEnergy(maxEnergy, callback) {
    getEnergyOneTap((energyOneTap) => {
        if (energyOneTap !== null) {
            const numClicks = Math.ceil(maxEnergy / energyOneTap);
            console.log('Number of Clicks Required:', numClicks);
            clickMultipleTimes(button, numClicks);
            callback();
        } else {
            console.log('Energy One Tap could not be determined.');
            callback();
        }
    });
}

function clickDogiators() {
    try {
        const valuesEnergy = getValuesEnergy();
        if (valuesEnergy && button) {
            const { currEnergy, maxEnergy } = valuesEnergy;
            console.log('Current Energy:', currEnergy);
            console.log('Max Energy:', maxEnergy);

            if (currEnergy === maxEnergy) {
                handleFullEnergy(maxEnergy, () => {
                    // После скликивания, повторно запускаем цикл
                    setTimeout(() => {
                        clickDogiators(); // Повторяем цикл
                    }, 1000); // Задержка перед началом следующего цикла
                });
            } else {
                // Если энергия не полная, повторяем проверку
                setTimeout(() => {
                    clickDogiators(); // Повторяем цикл
                }, 1000);
            }
        }
    } catch (e) {
        console.log(e);
        setTimeout(() => {
            clickDogiators(); // Повторяем цикл в случае ошибки
        }, 1000);
    }
}

// Запускаем основной цикл
clickDogiators();
