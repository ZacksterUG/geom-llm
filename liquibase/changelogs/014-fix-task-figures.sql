--liquibase formatted sql

--changeset ahmedyanov:38
-- Task 12: Добавление точек M и N (середины AD и DB) в initial_figure_state
-- (координаты указаны после Y/Z swap из 011, Three.js: Y — вверх)
UPDATE tasks
SET initial_figure_state = jsonb_set(
    initial_figure_state,
    '{vertices}',
    initial_figure_state->'vertices' || '[
        {"id": "M", "x": 1, "y": 2, "z": 0.5},
        {"id": "N", "x": 3, "y": 2, "z": 0.5}
    ]'::jsonb
)
WHERE title = 'Параллельность прямой и плоскости в тетраэдре';

--changeset ahmedyanov:39
-- Task 13: Добавление точек M, N, K (середины DA, DB, DC) в initial_figure_state
UPDATE tasks
SET initial_figure_state = jsonb_set(
    initial_figure_state,
    '{vertices}',
    initial_figure_state->'vertices' || '[
        {"id": "M", "x": 1, "y": 2, "z": 0.5},
        {"id": "N", "x": 3, "y": 2, "z": 0.5},
        {"id": "K", "x": 2, "y": 2, "z": 2.25}
    ]'::jsonb
)
WHERE title = 'Параллельность плоскостей в тетраэдре';

--changeset ahmedyanov:40
-- Task 3: Добавление рёбер A1D и A1B (проекции диагонали A1C) в reference_figure_state
-- Эти рёбра используются в доказательстве (теорема о трёх перпендикулярах)
UPDATE tasks
SET reference_figure_state = jsonb_set(
    reference_figure_state,
    '{edges}',
    reference_figure_state->'edges' || '[
        {"from": "A1", "to": "D"},
        {"from": "A1", "to": "B"}
    ]'::jsonb
)
WHERE title = 'Перпендикулярность диагонали куба и плоскости';
