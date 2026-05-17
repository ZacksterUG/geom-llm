# Stereometry Proof Checker

MVP веб‑приложения для пошаговой проверки геометрических доказательств (стереометрия) с интерактивной 2D‑визуализацией и валидацией через локальную LLM (Qwen 2.5 7B).

## Архитектура

- **Frontend**: React + TypeScript + Mantine + JSXGraph (2D аксонометрия)
- **Backend**: FastAPI + SQLAlchemy + Pydantic
- **База данных**: PostgreSQL + Liquibase (миграции)
- **AI‑валидация**: Ollama с моделью Qwen 2.5 7B
- **Инфраструктура**: Docker Compose

## Быстрый старт

### 1. Клонирование и настройка окружения
```bash
git clone <repository>
cd ahmedyanov
cp .env.example .env
# При необходимости отредактируйте .env
```

### 2. Запуск инфраструктуры
```bash
docker-compose up -d
```

Сервисы:
- **PostgreSQL** – порт 5432 (`geom-db`)
- **PgAdmin** – порт 5050 (`geom-pgadmin`)
- **Ollama** – порт 11434 (`geom-ollama`)
- **Liquibase** – миграции БД (`geom-liquibase`, запускается однократно)

### 3. Загрузка модели LLM (однократно)
```bash
docker-compose --profile pull-model up geom-ollama-pull
```
Модель Qwen 2.5 7B (~4.5 GB) загрузится в volume `geom-ollama-models`.

### 4. Проверка работоспособности
```bash
docker-compose ps
curl http://localhost:11434/api/tags
```
Откройте PgAdmin: http://localhost:5050 (логин/пароль из `.env`).

## Структура проекта

```
├── backend/                 # FastAPI приложение
│   ├── app/
│   │   ├── core/config.py  # Настройки
│   │   ├── db/session.py   # SQLAlchemy сессии
│   │   └── models/         # Модели БД и Pydantic‑схемы
│   └── requirements.txt    # Зависимости Python
├── liquibase/              # Миграции БД
│   ├── changelog-master.xml
│   └── changelogs/001-init-tasks.sql
├── frontend/               # React приложение (будет добавлено)
├── docker-compose.yml      # Оркестрация сервисов
├── .env.example            # Шаблон переменных окружения
├── docker-setup.md         # Подробная инструкция по Docker
├── analyze.md              # Анализ проекта
└── db-design.md            # Проектирование БД
```

## API (планируется)

- `GET /api/tasks` – список задач
- `POST /api/validate` – валидация шага доказательства
- `GET /api/tasks/{id}` – детали задачи с начальным состоянием фигуры

## Переменные окружения (.env)

| Переменная | Описание | Пример |
|------------|----------|--------|
| `POSTGRES_DB` | Имя базы данных | `stereometry_db` |
| `POSTGRES_USER` | Пользователь БД | `geom_user` |
| `POSTGRES_PASSWORD` | Пароль БД | `geom_password123` |
| `PGADMIN_DEFAULT_EMAIL` | Адрес для входа в PgAdmin | `admin@geom.local` |
| `PGADMIN_DEFAULT_PASSWORD` | Пароль PgAdmin | `admin123` |
| `OLLAMA_MODEL` | Модель Ollama | `qwen2.5:7b` |
| `OLLAMA_PORT` | Порт Ollama | `11434` |
| `LIQUIBASE_URL` | JDBC‑URL для миграций | `jdbc:postgresql://geom-db:5432/stereometry_db` |

## Разработка

### Backend
```bash
cd backend
python -m venv venv
source venv/bin/activate  # или venv\Scripts\activate на Windows
pip install -r requirements.txt
# Запуск в режиме разработки (после реализации)
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend
*(будет добавлен)*

## Документация

- [Анализ проекта](analyze.md) – архитектура, стек, риски
- [Проектирование БД](db-design.md) – ER‑диаграмма, SQL‑схема
- [Docker‑инфраструктура](docker-setup.md) – детальное описание сервисов

## Контакты

Проект разрабатывается в рамках учебного задания. Вопросы и предложения – через Issues.