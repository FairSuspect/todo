# todo

Todo-приложение для летней школы Яндекса 2022

## Ссылка на скачивание apk
https://disk.yandex.ru/d/PgOHvZ3P0HiAbg

## Алгоритм сборки 
 + Создать файл .env
```
BASE_URL=https://beta.mrdekk.ru/todobackend
TOKEN=API_KEY
```
 + `flutter pub get`
 + `flutter gen-l10n`
 + `flutter pub run build_runner --delete-conflicting-outputs`
 + `flutter run`

## Реализованные фичи
 + Создание задачи из экрана создания задачи
 + Создание задачи из конца списка задач
 + CRUD с бекендом
 + CRUD с локальным хранилищем с помощью hive
 + Синхронизация локальных данных и данных бекенда при запуске приложения
 + Удаление задачи по свайпу 
 + Отметка задаки как "выполнено" по свайпу
 + Подключён firebase crashnalytics
 + Подключён firebase remote config с возможностью переключения цвета важности
 + Есть фильтр по невыполненным/всем задачам
 + Как менеджер состояний используется Provider
 + Интернационализация с помощью intl
 + Добавлено логгирование
 
## Изменения к фазе 2
 + Стейт менеджер заменен на riverpod
 + DI реализован с помощью riverpod
 + Добавлена аналитика firebase
 + Настроен CI с публикацией Firebase App Distribution
 + Навигатор переписан на Navigator 2.0
 + Поддерживаются deep links с доменом https://yandex-school.com/ (Например:  https://yandex-school.com/todo/cf7b9833-c7a9-403b-a25d-0128a6808fa8 для открытия задачи. (Если пропустить id, откроется окно создания))
 + Окно с редакутированием открывается из состояения terminated
 + Доработана тёмная тема (В приложении используется системная)
 + Лендскейп отображается нормально
 + Крупные экраны отображатся нормально

 ## Доработки после дедлайна (не успел)
 + Покрытие тестами
 + Флейворы dev\release

 

 ## Скриншоты из первой фазы

 ![alt text](https://user-images.githubusercontent.com/49846058/183310389-c90e3b35-33bf-42b5-b6c1-3cd0249e7ad1.jpeg)
 ![alt text](https://user-images.githubusercontent.com/49846058/183310391-e2dacb98-7b75-48bb-b984-38b0d8922260.jpeg)
 ![alt text](https://user-images.githubusercontent.com/49846058/183310392-da27873e-20e7-45e3-b12e-f4f3b5016adc.jpeg)


