# Local 1C Bridge Agent

Локальный агент для безопасной работы с 1С. Первая версия работает только в режиме readonly.

## Что делает сейчас

- проверяет наличие 1cv8.exe;
- проверяет TCP-доступ к серверу 1С;
- читает только локальный конфиг;
- может сохранить JSON-отчёт о среде.

Агент не удаляет данные, не выполняет произвольный SQL и не принимает команды из Интернета.

## Запуск

Из корня репозитория:

powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\agent\1C-Bridge.ps1 -Action status

Для отчёта:

powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\agent\1C-Bridge.ps1 -Action collect

Следующий этап — добавить read-only внешнюю обработку 1С для инвентаризации документов до 2025 года.
