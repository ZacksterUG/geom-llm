import httpx
import json
import re
import logging
from app.core.config import settings

logger = logging.getLogger(__name__)


def _extract_json(text: str) -> dict:
    """Извлекает JSON из ответа LLM, обрабатывая markdown-обертки."""
    text = text.strip()
    if not text:
        return {}

    # Попытка найти JSON внутри markdown-блоков
    md_patterns = [
        r'```json\s*(.*?)\s*```',
        r'```\s*(.*?)\s*```',
    ]
    for pattern in md_patterns:
        matches = re.findall(pattern, text, re.DOTALL)
        for match in matches:
            try:
                return json.loads(match)
            except json.JSONDecodeError:
                continue

    # Попытка найти первый объект {...}
    brace_match = re.search(r'(\{.*\})', text, re.DOTALL)
    if brace_match:
        try:
            return json.loads(brace_match.group(1))
        except json.JSONDecodeError:
            pass

    # Прямая попытка парсинга
    try:
        return json.loads(text)
    except json.JSONDecodeError:
        pass

    return {}


async def validate_with_ollama(
    task_condition: str,
    proof_history: list,
    current_step: dict,
    figure_state: dict,
) -> dict:
    """Отправляет шаг доказательства в Ollama для валидации."""

    system_prompt = (
        "Ты — терпеливый учитель геометрии (стереометрия 10-11 класс, учебник Атанасян). "
        "Твоя задача — проверять ПОШАГОВЫЕ доказательства учеников.\n\n"
        "КРИТИЧЕСКИ ВАЖНЫЕ ПРАВИЛА:\n"
        "1. ПРОВЕРЯЙ СООТВЕТСТВИЕ УСЛОВИЮ: каждый шаг ученика должен решать ИМЕННО ту задачу, "
        "которая дана в условии. Если ученик решает другую задачу или использует не те объекты — "
        "это ошибка.\n"
        "2. РАЗЛИЧАЙ ПОНЯТИЯ: диагонали ГРАНЕЙ (лежат на поверхности, соединяют вершины одной грани) "
        "отличаются от диагоналей ПАРАЛЛЕЛЕПИПЕДА (проходят через внутреннее пространство). "
        "Грань — это плоская поверхность, а не всё тело.\n"
        "3. ПРОВЕРЯЙ ОБОЗНАЧЕНИЯ: если ученик пишет 'параллелограмм ABC1D1', проверь, "
        "что эти 4 точки ДЕЙСТВИТЕЛЬНО лежат в одной плоскости и образуют параллелограмм. "
        "В параллелепипеде ABCDA1B1C1D1 точки A, B, C1, D1 НЕ образуют параллелограмм.\n"
         "4. СОКРАТИЧЕСКИЙ МЕТОД: НИКОГДА не давай готовое решение. Только указывай на ошибки "
         "и задавай наводящие вопросы.\n"
         "5. hint ВСЕГДА должен быть строкой (не null, не пустой объект). Если всё верно — напиши "
         "'Верно, продолжайте' или похвали ученика. Если ошибка — задай наводящий вопрос.\n\n"
        "ТОН ОБЩЕНИЯ (ОБЯЗАТЕЛЬНО):\n"
        "- Формулируй замечания спокойно и уважительно.\n"
        "- НЕ используй фразы: 'грубая ошибка', 'жестокая ошибка', 'совершил ошибки', 'ученик ошибся'.\n"
        "- Вместо этого используй конструкции: 'Обрати внимание, что...', 'В этом шаге стоит уточнить...', "
        "'Давай разберёмся: в условии речь идёт о..., а в шаге используется...'.\n"
        "- reason должен быть мягким, но конкретным.\n"
        "- hint должен быть наводящим вопросом, который помогает ученику самому найти правильный путь.\n\n"
        "ПРИМЕР ПРОВЕРКИ:\n"
        "Условие: Докажите, что диагонали граней, исходящие из одной вершины, пересекаются в одной точке.\n"
        "Шаг ученика: Рассмотрим диагонали параллелепипеда AC1 и BD1...\n"
        "Оценка: error. Причина: В условии требуется рассмотреть диагонали граней, выходящие из одной вершины, "
        "а в шаге используются диагонали всего параллелепипеда. Кроме того, точки A, B, C1, D1 не лежат в одной плоскости, "
        "поэтому фигура ABC1D1 не является параллелограммом. "
        "hint: Какие три диагонали граней можно провести из вершины A? На каких гранях они лежат?\n\n"
        "Ответь ТОЛЬКО в формате JSON:\n"
        '{"status": "ok|warning|error", "geometry_valid": true|false, '
        '"logic_valid": true|false, "reason": "конкретная ошибка или подтверждение", '
         '"hint": "наводящий вопрос (строка, не null; если всё верно — похвали)", '
        '"referenced_theorem": "название теоремы или null", '
        '"next_allowed_actions": ["список допустимых действий"]}'
    )

    user_prompt = (
        f"УСЛОВИЕ ЗАДАЧИ: {task_condition}\n\n"
        f"ИСТОРИЯ ШАГОВ: {proof_history}\n\n"
        f"ТЕКУЩИЙ ШАГ: {current_step}\n\n"
        f"СОСТОЯНИЕ ФИГУРЫ: {figure_state}\n\n"
        "Проверь:\n"
        "1. Соответствует ли текущий шаг условию задачи?\n"
        "2. Правильно ли использованы геометрические термины и обозначения?\n"
        "3. Верны ли утверждения о фигурах (параллелограммы, пересечения и т.д.)?\n"
        "4. Если есть ошибка — укажи конкретно, что неверно, и задай наводящий вопрос."
    )

    try:
        async with httpx.AsyncClient(timeout=120.0) as client:
            response = await client.post(
                settings.OLLAMA_URL,
                json={
                    "model": settings.OLLAMA_MODEL,
                    "messages": [
                        {"role": "system", "content": system_prompt},
                        {"role": "user", "content": user_prompt},
                    ],
                    "temperature": settings.OLLAMA_TEMPERATURE,
                    "seed": settings.OLLAMA_SEED,
                    "stream": False,
                },
            )
            response.raise_for_status()
            result = response.json()

            # Ollama иногда возвращает ошибку внутри JSON (например, model not found)
            if "error" in result:
                error_msg = result["error"]
                logger.error(f"Ollama returned error: {error_msg}")
                return {
                    "status": "error",
                    "geometry_valid": False,
                    "logic_valid": False,
                    "reason": f"Ошибка Ollama: {error_msg}",
                    "hint": "Проверьте, что модель загружена (ollama pull)",
                    "referenced_theorem": None,
                    "next_allowed_actions": [],
                }

            content = result.get("message", {}).get("content", "")
            if not content:
                logger.error("Ollama returned empty content")
                return {
                    "status": "error",
                    "geometry_valid": False,
                    "logic_valid": False,
                    "reason": "Ollama вернул пустой ответ",
                    "hint": "Попробуйте позже",
                    "referenced_theorem": None,
                    "next_allowed_actions": [],
                }

            parsed = _extract_json(content)
            logger.info(f"Ollama raw content: {content[:500]}...")
            logger.info(f"Parsed JSON keys: {list(parsed.keys())}")

            # Заполняем обязательные поля значениями по умолчанию
            defaults = {
                "status": "error",
                "geometry_valid": False,
                "logic_valid": False,
                "reason": "LLM вернул неструктурированный ответ",
                "hint": "Попробуйте переформулировать шаг",
                "referenced_theorem": None,
                "next_allowed_actions": [],
            }
            defaults.update(parsed)

            # Гарантируем корректные типы
            if not isinstance(defaults.get("next_allowed_actions"), list):
                defaults["next_allowed_actions"] = []
            if not isinstance(defaults.get("geometry_valid"), bool):
                defaults["geometry_valid"] = False
            if not isinstance(defaults.get("logic_valid"), bool):
                defaults["logic_valid"] = False
            if not isinstance(defaults.get("hint"), str):
                defaults["hint"] = "Попробуйте переформулировать шаг"
            if not isinstance(defaults.get("reason"), str):
                defaults["reason"] = "LLM вернул неструктурированный ответ"
            if not isinstance(defaults.get("status"), str):
                defaults["status"] = "error"

            return defaults

    except httpx.HTTPStatusError as e:
        logger.error(
            f"HTTP error from Ollama: {e.response.status_code} - {e.response.text}"
        )
        return {
            "status": "error",
            "geometry_valid": False,
            "logic_valid": False,
            "reason": f"HTTP ошибка {e.response.status_code} при обращении к LLM",
            "hint": "Проверьте доступность сервиса Ollama",
            "referenced_theorem": None,
            "next_allowed_actions": [],
        }
    except Exception as e:
        logger.error(f"Exception during Ollama validation: {str(e)}")
        return {
            "status": "error",
            "geometry_valid": False,
            "logic_valid": False,
            "reason": f"Ошибка при обращении к LLM: {str(e)}",
            "hint": "Попробуйте позже",
            "referenced_theorem": None,
            "next_allowed_actions": [],
        }
