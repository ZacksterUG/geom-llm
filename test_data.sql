INSERT INTO tasks (title, condition_text, initial_figure_state, difficulty_level)
VALUES (
    'Пересечение плоскостей',
    'Даны две плоскости α и β. Точка A лежит в плоскости α, точка B лежит в плоскости β. Докажите, что прямая AB пересекает линию пересечения плоскостей.',
    '{"vertices": [{"id": "A", "x": 2, "y": 3, "z": 1}, {"id": "B", "x": 5, "y": 4, "z": 2}], "edges": [], "relations": [], "actions_log": []}',
    '10-11 класс'
) ON CONFLICT DO NOTHING;
