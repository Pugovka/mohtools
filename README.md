# MOH Tools

## Описание
MOH Tools - скрипт для GTA SAMP, разработанный специально для игроков Министерства Здравоохранения на проекте Evolve-RP. Скрипт автоматизирует ежедневные задачи сотрудников Министерства Здравоохранения и предоставляет множество полезных функций.

# ⚙️ УСТАНОВКА И ЗАПУСК ⚙️

## 📋 Требования
- **GTA San Andreas** с установленным **SAMP 0.3.7 R1** или выше
- **[Moonloader](https://blast.hk/moonloader)** версии 0.26 или выше
- **[SAMPFUNCS](https://blast.hk/sampfuncs)**
- **[ImGui](https://blast.hk/imgui)**

## 🔧 Пошаговая установка
1. Установите **Moonloader** по [инструкции с официального сайта](https://blast.hk/moonloader)
2. Убедитесь, что у вас также установлен **SAMPFUNCS**
3. Скачайте файл `MOH-Tools.luac` из репозитория
4. Поместите файл в папку: `%ПУТЬ_К_GTA_SA%\moonloader\`
5. Запустите игру
6. В игре введите `/mt` для открытия интерфейса скрипта или используйте клавишу `F10`

## 🔄 Обновление
Скрипт имеет встроенную систему автоматического обновления. Для ручного обновления:
1. Скачайте новую версию файла `MOH-Tools.luac`
2. Замените существующий файл в папке moonloader
3. В игре нажмите сочетание клавиш `Ctrl + R`

## ⚠️ Устранение проблем
- Если скрипт не запускается, проверьте наличие всех необходимых библиотек
- Скрипт автоматически скачает недостающие библиотеки при первом запуске

---

## Основные функции

### Быстрое меню
- Отыгровки лечения пациентов
- Отыгровки лечения от наркозависимости
- Выдача медицинских карт
- Помощь на призыве
- Отыгровки сложных медицинских процедур
- Различные отыгровки для медосмотров

### Операции
- Отыгровки различных типов операций:
  - Открытый перелом руки
  - Закрытый перелом руки
  - Пулевое ранение
  - Ножевое ранение
  - Кровотечение
  - Удаление аппендицита

### Медосмотр
- Отыгровки для разных типов медосмотра:
  - Кардиолог
  - Нарколог
  - Психолог
  - Терапевт
  - Хирург
  - Окулист

### Первая медицинская помощь
- Отыгровки оказания первой помощи:
  - При венозном кровотечении
  - При капиллярном кровотечении
  - При артериальном кровотечении
  - При открытом переломе руки/ноги
  - При закрытых/открытых переломах
  - При ушибах/растяжениях

### Функции для собеседований
- Проведение собеседований для новых сотрудников
- Отыгровки для принятия или отказа кандидатам
- Автоматическая отправка доклада в рацию
- Несколько шаблонов проведения собеседований
- Система вопросов-ответов с задержкой для более реалистичной отыгровки

### Государственные оповещения
- Шаблоны для различных объявлений:
  - Собеседование
  - Акция "Почётный донор"
  - Наборы наркологов
  - Другие объявления
- Таймер для автоматической отправки объявлений в назначенное время
- Настраиваемые задержки между сообщениями

### Команды
- `/mt` - открытие основного меню скрипта
- `/cheal` - быстрое лечение ближайшего игрока
- `/mb` - отображение списка членов организации
- `/mkv` - установка метки по квадрату карты
- `/blg` - благодарность другой фракции
- `/monitor` - проверка состояния складов
- `/mmask` - быстрое надевание маски
- `/medosm` - проведение медосмотра
- `/ffixcar` - спавн организационного транспорта
- `/cc` - очистка чата
- `/warn` - выдача выговора сотруднику
- `/shp` - отображение информации о шапке/служебной форме
- `/smslog` - лог СМС
- `/rlog` - лог рации
- `/dlog` - лог департамента
- `/r [текст]` - отправка сообщения в рацию с тегом
- `/rt [текст]` - отправка сообщения в рацию без тега
- `/invite [id]` - принятие игрока в организацию с отыгровкой
- `/uninvite [id] [причина]` - увольнение игрока с отыгровкой
- `/invn [id]` - принятие на должность нарколога
- `/giverank [id] [ранг] [+/-]` - повышение/понижение игрока с отыгровкой
- `/changelog` - просмотр истории изменений скрипта
- `/amnyam` - включение/выключение сообщения "ам ням"

### Информационный HUD
- Отображение статистики игрока
- Информация о пинге и FPS
- Отображение текущей локации
- Отображение статистики здоровья
- Информация о времени дня
- Настраиваемый интерфейс
- Настройка прозрачности и скругления углов
- Возможность перемещения HUD на экране
- Отображение статуса маски и починки транспорта

### Система статистики
- Отслеживание времени онлайн
- Еженедельная статистика активности
- Учет количества принятых вызовов
- Учет количества проведенных лечений
- Статистика повышений/понижений сотрудников
- Учет заработанных денег
- Автоматический сброс статистики в начале новой недели
- Подсчет AFK времени отдельно от активного времени

### Система лекций
- Создание и сохранение текстов лекций
- Настройка задержки между сообщениями
- Возможность прервать лекцию в любой момент
- Уведомление о возможности прерывания отыгровки

### Дополнительные функции
- Калькулятор в чате
- Система логирования (СМС, рация, департамент)
- Автоматическое обновление скрипта
- Возможность настройки горячих клавиш
- Отображение списка старшего состава
- Система уведомлений
- Автоматическое надевание маски
- Автоматический доклад при разгрузке склада
- Создание скриншотов через тег {screen}
- Помощник ввода в чате
- Автоматическое добавление тега в рацию

## Система стилей
- Возможность выбора одного из готовых стилей оформления
- Поддержка светлых и темных тем

## Горячие клавиши
- F10 (по умолчанию) - открыть главное меню
- Z (по умолчанию) + ПКМ - открыть меню взаимодействия с игроком
- Y (по умолчанию) - отправка доклада в рацию
- N (по умолчанию) - продолжние отыгровки
- Y (по умолчанию) - клавиша для принятия вызова при включенной функции автоматического SendCall
- Возможность настройки всех горячих клавиш через раздел "Клавиши"

## История изменений
Скрипт постоянно обновляется и дополняется новыми функциями. Полный список изменений можно посмотреть в разделе "О скрипте" в меню скрипта.

## Примечание
Скрипт работает только на проекте Evolve-RP и предназначен исключительно для сотрудников Министерства Здравоохранения. 

## Техническая информация
- Скрипт автоматически загружает необходимые библиотеки, если они отсутствуют
- Имеет систему обработки ошибок и отправки их в Sentry
- Сохраняет все настройки в конфигурационных файлах в папке MOH-Tools
- Автоматически создает необходимые папки при первом запуске 

### Система тегов
Скрипт поддерживает множество тегов для автоматической подстановки информации:
- `{my_name}` - ваше имя и фамилия (например, "Иван Иванов")
- `{rank}` - ваша должность в организации (например, "Доктор", "Хирург" и т.д.)
- `{tag}` - настраиваемый тег для рации, указанный в настройках
- `{sex:текст_муж|текст_жен}` - текст в зависимости от выбранного пола
- `{select_id}` - ID выбранного игрока (с которым взаимодействуете)
- `{select_name}` - имя выбранного игрока
- `{closest_id}` - ID ближайшего игрока
- `{closest_name}` - имя ближайшего игрока
- `{hello}` - случайное приветствие ("Здравствуйте", "Доброго времени суток" и т.д.)
- `{screen}` - автоматическое создание скриншота в этот момент отыгровки
- `{pause}` - пауза в отыгровке до нажатия клавиши ENTER
- `{kv}` - координаты текущего квадрата на карте 
- `{noenter}` или `{noe}` - предотвращает автоматический ввод сообщения
- `{nick}` - ваш никнейм в формате Имя_Фамилия
- `{time}` - текущее игровое время
- `{date}` - текущая игровая дата
