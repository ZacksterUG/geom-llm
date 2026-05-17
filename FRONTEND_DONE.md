# Фронтенд реализован

## Структура фронтенда
```
frontend/
├── src/
│   ├── components/
│   │   └── GeometryCanvas.tsx  # 3D сцена (JSXGraph)
│   ├── pages/
│   │   ├── TaskList.tsx        # Список задач
│   │   └── TaskView.tsx        # Страница задачи (2 колонки)
│   ├── types.ts                # TypeScript интерфейсы
│   ├── App.tsx                 # Роутинг
│   └── main.tsx
├── Dockerfile
├── nginx.conf
└── vite.config.ts              # Прокси /api -> backend
```

## Функционал
- **Список задач** (`/`) — загружает задачи с `/api/tasks`
- **Страница задачи** (`/task/:id`) — две колонки:
  - Слева: условие, текст доказательства, кнопка "Проверить"
  - Справа: интерактивная 3D сцена (JSXGraph, аксонометрия)
- **Валидация** — отправка POST `/api/validate` с текстом и JSON чертежа

## Запуск
```bash
cd frontend
npm run dev
```

## Бэкенд
Создан упрощённый `main.py` с моковыми данными для тестирования фронтенда.
