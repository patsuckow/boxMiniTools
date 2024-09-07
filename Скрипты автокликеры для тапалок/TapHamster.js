// Кликер для тапалки Hamster Combat (от 28.07.2024) Powered by patsuckow (https://github.com/patsuckow/)
//
// Использование:
// 1. Запускаем десктопную версию телеграм на пк
// 2. Запускаем бот тапалки и право кнопко - "Иследовать", находим в теле страницы тег:
//  <iframe class="zA1w1IOq" src="https://hamsterkombatgame.io/clicker/#tgWebAppData=query_id%****************&amp;tgWebAppVersion=7.8&amp;tgWebAppPlatform=weba&amp;tgWebAppThemeParams=%7B%22bg_color%22%3A%22%23212121%22%2C%22text_color%22%3A%22%23ffffff%22%2C%22hint_color%22%3A%22%23aaaaaa%22%2C%22link_color%22%3A%22%238774e1%22%2C%22button_color%22%3A%22%238774e1%22%2C%22button_text_color%22%3A%22%23ffffff%22%2C%22secondary_bg_color%22%3A%22%230f0f0f%22%2C%22header_bg_color%22%3A%22%23212121%22%2C%22accent_text_color%22%3A%22%238774e1%22%2C%22section_bg_color%22%3A%22%23212121%22%2C%22section_header_text_color%22%3A%22%23aaaaaa%22%2C%22subtitle_text_color%22%3A%22%23aaaaaa%22%2C%22destructive_text_color%22%3A%22%23e53935%22%7D" title="Hamster Kombat Web App" sandbox="allow-scripts allow-same-origin allow-popups allow-forms allow-modals allow-storage-access-by-user-activation" allow="camera; microphone; geolocation;"></iframe>
// 3. И в параметре tgWebAppPlatform=weba заменяем параметр на tgWebAppPlatform=android
// 4. Копируем изменый адрес ресурса (src) со всеми параметрами и без скобок, получаем строку которую вставлем в браузер, что-то типа:
// https://hamsterkombatgame.io/clicker/#tgWebAppData=query_id%****************&amp;tgWebAppVersion=7.8&amp;tgWebAppPlatform=android&amp;tgWebAppThemeParams=%7B%22bg_color%22%3A%22%23212121%22%2C%22text_color%22%3A%22%23ffffff%22%2C%22hint_color%22%3A%22%23aaaaaa%22%2C%22link_color%22%3A%22%238774e1%22%2C%22button_color%22%3A%22%238774e1%22%2C%22button_text_color%22%3A%22%23ffffff%22%2C%22secondary_bg_color%22%3A%22%230f0f0f%22%2C%22header_bg_color%22%3A%22%23212121%22%2C%22accent_text_color%22%3A%22%238774e1%22%2C%22section_bg_color%22%3A%22%23212121%22%2C%22section_header_text_color%22%3A%22%23aaaaaa%22%2C%22subtitle_text_color%22%3A%22%23aaaaaa%22%2C%22destructive_text_color%22%3A%22%23e53935%22%7D
// 5. В адресно строке должна повится строка типа: https://hamsterkombatgame.io/ru/clicker и игра должна запустится в окне браузера
// 6. В консоль браузера вставлем содержимое данного скрипта и жмём Enter.
// 
// Логика работы скрипта:
// 1. При недостаточном уровне энергии скрипт будет проверять уровень через заданное время.
// 2. При достижении максимума энергии, скрипт будет скликивать до достижения нуля, затем ожидать её восстановления и повторять процесс.

// if (location.hostname === "hamsterkombatgame.io") {
//     const original_indexOf = Array.prototype.indexOf;
//     Array.prototype.indexOf = function(...args) {
//         if (JSON.stringify(this) === JSON.stringify(["android", "android_x", "ios"])) {
//             setTimeout(() => {
//                 Array.prototype.indexOf = original_indexOf;
//             });
//             return 0;
//         }
//         return original_indexOf.apply(this, args);
//     };
// }

const button = document.querySelector(".user-tap-button.button");

function getRandomPoint(element) {
    const rect = element.getBoundingClientRect();
    const x = Math.random() * rect.width;
    const y = Math.random() * rect.height;
    return { x, y };
}

function triggerPointerEvent(element, eventType = "pointerup") {
    const { x, y } = getRandomPoint(element);
    const eventInit = {
        bubbles: true,
        cancelable: true,
        clientX: x,
        clientY: y,
    };
    const event = new PointerEvent(eventType, eventInit);
    element.dispatchEvent(event);
}

function getRandomNumber(min, max) {
    return Math.floor(Math.random() * (max - min) + min);
}

function getValuesEnergy() {
    const energyElement = document.querySelector(".user-tap-energy > p");
    if (energyElement) {
        const [currEnergy, maxEnergy] = energyElement.innerText.split("/").map(Number);
        return { currEnergy, maxEnergy };
    }
    return null;
}

function getEnergyOneTap(maxEnergy, callback) {
    triggerPointerEvent(button);
    setTimeout(() => {
        const newValuesEnergy = getValuesEnergy();
        if (newValuesEnergy) {
            const { currEnergy } = newValuesEnergy;
            const energyOneTap = maxEnergy - currEnergy;
            callback(energyOneTap);
        } else {
            callback(null);
        }
    }, 100); // Небольшая задержка для обновления DOM
}

function clickMultipleTimes(button, numClicks) {
    for (let i = 0; i < numClicks; i++) {
        setTimeout(() => {
            triggerPointerEvent(button);
        }, getRandomNumber(50, 100));
    }
}

function handleFullEnergy(maxEnergy, callback) {
    getEnergyOneTap(maxEnergy, (energyOneTap) => {
        if (energyOneTap) {
            const numClicks = Math.ceil(maxEnergy / energyOneTap);
            clickMultipleTimes(button, numClicks);
            callback();
        }
    });
}

function clickHamster() {
    try {
        const valuesEnergy = getValuesEnergy();
        if (valuesEnergy && button) {
            const { currEnergy, maxEnergy } = valuesEnergy;
            if (currEnergy === maxEnergy) {
                handleFullEnergy(maxEnergy, () => {});
            }
        }
    } catch (e) {
        console.log(e);
    }

    setTimeout(() => {
        requestAnimationFrame(clickHamster);
    }, 1000); // Задержка между итерациями 1000 мс, чтобы избежать перегрузки
}

clickHamster();
