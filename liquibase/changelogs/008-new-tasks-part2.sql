--liquibase formatted sql

--changeset ahmedyanov:22
-- Task 15: Параллельность прямой и плоскости в треугольной призме
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность прямой и плоскости в призме',
        'В правильной треугольной призме $ABCA_1B_1C_1$ точки $M$ и $N$ — середины рёбер $A_1B_1$ и $A_1C_1$ соответственно. Докажите, что прямая $MN$ параллельна плоскости $ABC$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 4},
                {"id": "B1", "x": 4, "y": 0, "z": 4},
                {"id": "C1", "x": 2, "y": 3.5, "z": 4},
                {"id": "M", "x": 2, "y": 0, "z": 4},
                {"id": "N", "x": 1, "y": 1.75, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}
            ],
            "relations": ["$ABC$ - нижнее основание призмы", "$M$ - середина $A_1B_1$", "$N$ - середина $A_1C_1$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 4},
                {"id": "B1", "x": 4, "y": 0, "z": 4},
                {"id": "C1", "x": 2, "y": 3.5, "z": 4},
                {"id": "M", "x": 2, "y": 0, "z": 4},
                {"id": "N", "x": 1, "y": 1.75, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"},
                {"from": "M", "to": "N"}
            ],
            "relations": ["$MN$ - средняя линия треугольника $A_1B_1C_1$", "$MN \\parallel B_1C_1$", "$B_1C_1 \\parallel BC$", "$BC$ лежит в плоскости $ABC$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $A_1B_1C_1$ точки $M$ и $N$ — середины сторон $A_1B_1$ и $A_1C_1$.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "Следовательно, $MN$ — средняя линия треугольника $A_1B_1C_1$, и $MN \\parallel B_1C_1$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 3, "claim": "В призме $B_1C_1 \\parallel BC$, так как верхнее и нижнее основания параллельны.", "justification_id": "property", "comment": "Свойство параллельных плоскостей оснований"},
            {"step_id": 4, "claim": "Прямая $BC$ лежит в плоскости $ABC$.", "justification_id": "definition", "comment": "$B$ и $C$ — точки плоскости основания"},
            {"step_id": 5, "claim": "Следовательно, $MN \\parallel$ плоскости $ABC$ по признаку параллельности прямой и плоскости.", "justification_id": "theorem", "comment": "Если прямая параллельна прямой в плоскости, то она параллельна и самой плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name IN ('Треугольная призма', 'Правильная призма');

--changeset ahmedyanov:23
-- Task 16: Скрещивающиеся прямые в треугольной призме
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Скрещивающиеся прямые в треугольной призме',
        'В правильной треугольной призме $ABCA_1B_1C_1$ докажите, что прямые $AB_1$ и $BC_1$ являются скрещивающимися.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 4},
                {"id": "B1", "x": 4, "y": 0, "z": 4},
                {"id": "C1", "x": 2, "y": 3.5, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}
            ],
            "relations": ["$ABC$ - нижнее основание призмы", "$A_1B_1C_1$ - верхнее основание"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 4},
                {"id": "B1", "x": 4, "y": 0, "z": 4},
                {"id": "C1", "x": 2, "y": 3.5, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"},
                {"from": "A", "to": "B1"}, {"from": "B", "to": "C1"}
            ],
            "relations": ["$AB_1$ - диагональ боковой грани", "$BC_1$ - диагональ боковой грани"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Прямая $AB_1$ лежит в плоскости $ABB_1A_1$ (боковая грань призмы).", "justification_id": "definition", "comment": "$A$ и $B_1$ — вершины грани $ABB_1A_1$"},
            {"step_id": 2, "claim": "Прямая $BC_1$ пересекает плоскость $ABB_1A_1$ в точке $B$.", "justification_id": "property", "comment": "Точка $B$ — общая вершина обеих граней"},
            {"step_id": 3, "claim": "Точка $B$ не лежит на прямой $AB_1$ (только в случае вырождения).", "justification_id": "property", "comment": "$A$, $B$, $B_1$ — вершины прямоугольника $ABB_1A_1$, и $B$ не принадлежит диагонали $AB_1$"},
            {"step_id": 4, "claim": "Следовательно, прямые $AB_1$ и $BC_1$ скрещиваются по признаку скрещивающихся прямых.", "justification_id": "theorem", "comment": "Одна лежит в плоскости, другая пересекает её в точке, не лежащей на первой"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name IN ('Треугольная призма', 'Правильная призма');

--changeset ahmedyanov:24
-- Task 17: Параллельность прямой и плоскости в треугольной призме (2)
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность прямой и плоскости в призме',
        'В правильной треугольной призме $ABCA_1B_1C_1$ точки $M$ и $N$ — середины рёбер $A_1B_1$ и $B_1C_1$ соответственно. Докажите, что прямая $MN$ параллельна плоскости $ACC_1$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 4},
                {"id": "B1", "x": 4, "y": 0, "z": 4},
                {"id": "C1", "x": 2, "y": 3.5, "z": 4},
                {"id": "M", "x": 2, "y": 0, "z": 4},
                {"id": "N", "x": 3, "y": 1.75, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}
            ],
            "relations": ["$ABC$ - нижнее основание", "$M$ - середина $A_1B_1$", "$N$ - середина $B_1C_1$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 4},
                {"id": "B1", "x": 4, "y": 0, "z": 4},
                {"id": "C1", "x": 2, "y": 3.5, "z": 4},
                {"id": "M", "x": 2, "y": 0, "z": 4},
                {"id": "N", "x": 3, "y": 1.75, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"},
                {"from": "M", "to": "N"}
            ],
            "relations": ["$MN$ - средняя линия $A_1B_1C_1$", "$MN \\parallel A_1C_1$", "$A_1C_1 \\parallel AC$", "$AC$ лежит в плоскости $ACC_1$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $A_1B_1C_1$ $MN$ — средняя линия, следовательно $MN \\parallel A_1C_1$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 2, "claim": "В призме $A_1C_1 \\parallel AC$ как соответственные стороны параллельных оснований.", "justification_id": "property", "comment": "Основания призмы параллельны"},
            {"step_id": 3, "claim": "Прямая $AC$ лежит в плоскости $ACC_1$.", "justification_id": "definition", "comment": "$A$ и $C$ — точки плоскости $ACC_1$"},
            {"step_id": 4, "claim": "Следовательно, $MN \\parallel$ плоскости $ACC_1$ по признаку параллельности прямой и плоскости.", "justification_id": "theorem", "comment": "Если прямая параллельна прямой в плоскости, то она параллельна плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name IN ('Треугольная призма', 'Правильная призма');

--changeset ahmedyanov:25
-- Task 18: Параллельность прямой и плоскости в четырёхугольной пирамиде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность средней линии и основания пирамиды',
        'В правильной четырёхугольной пирамиде $SABCD$ с вершиной $S$ точки $M$ и $N$ — середины рёбер $SA$ и $SB$ соответственно. Докажите, что прямая $MN$ параллельна плоскости $ABCD$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 4, "z": 0},
                {"id": "D", "x": 0, "y": 4, "z": 0},
                {"id": "S", "x": 2, "y": 2, "z": 5},
                {"id": "M", "x": 1, "y": 1, "z": 2.5},
                {"id": "N", "x": 3, "y": 1, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}, {"from": "D", "to": "S"}
            ],
            "relations": ["$SABCD$ - правильная четырёхугольная пирамида", "$ABCD$ - основание (квадрат)", "$M$ - середина $SA$", "$N$ - середина $SB$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 4, "z": 0},
                {"id": "D", "x": 0, "y": 4, "z": 0},
                {"id": "S", "x": 2, "y": 2, "z": 5},
                {"id": "M", "x": 1, "y": 1, "z": 2.5},
                {"id": "N", "x": 3, "y": 1, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}, {"from": "D", "to": "S"},
                {"from": "M", "to": "N"}
            ],
            "relations": ["$MN$ - средняя линия треугольника $SAB$", "$MN \\parallel AB$", "$AB$ лежит в плоскости $ABCD$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $SAB$ точки $M$ и $N$ — середины сторон $SA$ и $SB$ соответственно.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "Следовательно, $MN$ — средняя линия треугольника $SAB$, и $MN \\parallel AB$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 3, "claim": "Прямая $AB$ лежит в плоскости $ABCD$ (основание пирамиды).", "justification_id": "definition", "comment": "$A$ и $B$ — вершины основания"},
            {"step_id": 4, "claim": "Так как $MN \\parallel AB$, а $AB$ лежит в плоскости $ABCD$, то $MN \\parallel$ плоскости $ABCD$.", "justification_id": "theorem", "comment": "Признак параллельности прямой и плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name IN ('Четырёхугольная пирамида', 'Правильная пирамида');

--changeset ahmedyanov:26
-- Task 19: Скрещивающиеся прямые в четырёхугольной пирамиде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Скрещивающиеся прямые в пирамиде',
        'В правильной четырёхугольной пирамиде $SABCD$ с вершиной $S$ докажите, что прямые $SA$ и $BC$ являются скрещивающимися.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 4, "z": 0},
                {"id": "D", "x": 0, "y": 4, "z": 0},
                {"id": "S", "x": 2, "y": 2, "z": 5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}, {"from": "D", "to": "S"}
            ],
            "relations": ["$SABCD$ - правильная четырёхугольная пирамида", "$ABCD$ - основание (квадрат)"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 4, "z": 0},
                {"id": "D", "x": 0, "y": 4, "z": 0},
                {"id": "S", "x": 2, "y": 2, "z": 5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}, {"from": "D", "to": "S"}
            ],
            "relations": ["$SA$ - боковое ребро", "$BC$ - сторона основания"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Прямая $BC$ лежит в плоскости $ABCD$ (основание пирамиды).", "justification_id": "definition", "comment": "$B$ и $C$ — вершины основания"},
            {"step_id": 2, "claim": "Прямая $SA$ пересекает плоскость $ABCD$ в точке $A$.", "justification_id": "property", "comment": "Точка $A$ — общая для $SA$ и плоскости основания"},
            {"step_id": 3, "claim": "Точка $A$ не лежит на прямой $BC$, так как $A$, $B$, $C$ — вершины квадрата, и $A$ не принадлежит стороне $BC$.", "justification_id": "property", "comment": "В квадрате смежные стороны $AB$ и $BC$"},
            {"step_id": 4, "claim": "Следовательно, прямые $SA$ и $BC$ скрещиваются по признаку скрещивающихся прямых.", "justification_id": "theorem", "comment": "Одна лежит в плоскости, другая пересекает плоскость в точке, не лежащей на первой прямой"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name IN ('Четырёхугольная пирамида', 'Правильная пирамида');

--changeset ahmedyanov:27
-- Task 20: Средняя линия в боковой грани пирамиды
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность прямой и плоскости в пирамиде',
        'В правильной четырёхугольной пирамиде $SABCD$ с вершиной $S$ точки $M$ и $N$ — середины рёбер $SA$ и $SD$ соответственно. Докажите, что прямая $MN$ параллельна прямой $AD$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 4, "z": 0},
                {"id": "D", "x": 0, "y": 4, "z": 0},
                {"id": "S", "x": 2, "y": 2, "z": 5},
                {"id": "M", "x": 1, "y": 1, "z": 2.5},
                {"id": "N", "x": 1, "y": 3, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}, {"from": "D", "to": "S"}
            ],
            "relations": ["$SABCD$ - правильная четырёхугольная пирамида", "$M$ - середина $SA$", "$N$ - середина $SD$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 4, "z": 0},
                {"id": "D", "x": 0, "y": 4, "z": 0},
                {"id": "S", "x": 2, "y": 2, "z": 5},
                {"id": "M", "x": 1, "y": 1, "z": 2.5},
                {"id": "N", "x": 1, "y": 3, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}, {"from": "D", "to": "S"},
                {"from": "M", "to": "N"}
            ],
            "relations": ["$MN$ - средняя линия треугольника $SAD$", "$MN \\parallel AD$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $SAD$ точки $M$ и $N$ — середины сторон $SA$ и $SD$ соответственно.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "Следовательно, $MN$ — средняя линия треугольника $SAD$, и $MN \\parallel AD$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name IN ('Четырёхугольная пирамида', 'Правильная пирамида');

--changeset ahmedyanov:28
-- Task 21: Параллельность прямой и плоскости в треугольной пирамиде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность прямой и плоскости в треугольной пирамиде',
        'В треугольной пирамиде $SABC$ с вершиной $S$ точки $M$ и $N$ — середины рёбер $SB$ и $SC$ соответственно. Докажите, что прямая $MN$ параллельна плоскости $ABC$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "S", "x": 2, "y": 1, "z": 5},
                {"id": "M", "x": 3, "y": 0.5, "z": 2.5},
                {"id": "N", "x": 3, "y": 2.25, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}
            ],
            "relations": ["$SABC$ - треугольная пирамида", "$M$ - середина $SB$", "$N$ - середина $SC$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "S", "x": 2, "y": 1, "z": 5},
                {"id": "M", "x": 3, "y": 0.5, "z": 2.5},
                {"id": "N", "x": 3, "y": 2.25, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"},
                {"from": "M", "to": "N"}
            ],
            "relations": ["$MN$ - средняя линия треугольника $SBC$", "$MN \\parallel BC$", "$BC$ лежит в плоскости $ABC$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $SBC$ точки $M$ и $N$ — середины сторон $SB$ и $SC$ соответственно.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "Следовательно, $MN$ — средняя линия треугольника $SBC$, и $MN \\parallel BC$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 3, "claim": "Прямая $BC$ лежит в плоскости $ABC$ (основание пирамиды).", "justification_id": "definition", "comment": "$B$ и $C$ — вершины основания"},
            {"step_id": 4, "claim": "Следовательно, $MN \\parallel$ плоскости $ABC$ по признаку параллельности прямой и плоскости.", "justification_id": "theorem", "comment": "Если прямая параллельна прямой в плоскости, то она параллельна плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name IN ('Треугольная пирамида');

--changeset ahmedyanov:29
-- Task 22: Скрещивающиеся прямые в треугольной пирамиде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Скрещивающиеся прямые в треугольной пирамиде',
        'В треугольной пирамиде $SABC$ с вершиной $S$ точки $M$ и $N$ — середины рёбер $SA$ и $SB$ соответственно. Докажите, что прямые $CN$ и $AM$ являются скрещивающимися.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "S", "x": 2, "y": 1, "z": 5},
                {"id": "M", "x": 1, "y": 0.5, "z": 2.5},
                {"id": "N", "x": 3, "y": 0.5, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"}
            ],
            "relations": ["$SABC$ - треугольная пирамида", "$M$ - середина $SA$", "$N$ - середина $SB$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "S", "x": 2, "y": 1, "z": 5},
                {"id": "M", "x": 1, "y": 0.5, "z": 2.5},
                {"id": "N", "x": 3, "y": 0.5, "z": 2.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "S"}, {"from": "B", "to": "S"}, {"from": "C", "to": "S"},
                {"from": "C", "to": "N"}, {"from": "A", "to": "M"}
            ],
            "relations": ["$CN$ - отрезок в грани $SBC$", "$AM$ - отрезок в грани $SAB$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Прямая $AM$ лежит в плоскости $SAB$ (боковая грань пирамиды).", "justification_id": "definition", "comment": "$A$ и $M \\in SA$, обе точки в $SAB$"},
            {"step_id": 2, "claim": "Прямая $CN$ пересекает плоскость $SAB$ в точке $N$.", "justification_id": "property", "comment": "$N \\in SB$, а $SB$ лежит в $SAB$"},
            {"step_id": 3, "claim": "Точка $N$ не лежит на прямой $AM$, так как $A$, $M$, $N$ — вершины треугольника $AMN$ (неколлинеарны).", "justification_id": "property", "comment": "$M$ и $N$ — середины разных сторон, $A$ — вершина"},
            {"step_id": 4, "claim": "Следовательно, прямые $CN$ и $AM$ скрещиваются по признаку скрещивающихся прямых.", "justification_id": "theorem", "comment": "Одна лежит в плоскости, другая пересекает плоскость в точке, не лежащей на первой прямой"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Треугольная пирамида';

--changeset ahmedyanov:30
-- Task 23: Параллельность отрезков в параллелепипеде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность отрезков в параллелепипеде',
        'В параллелепипеде $ABCDA_1B_1C_1D_1$ точки $M$ и $N$ — середины рёбер $AB$ и $CD$ соответственно. Докажите, что отрезки $A_1N$ и $D_1M$ параллельны.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 2},
                {"id": "B1", "x": 4, "y": 0, "z": 2},
                {"id": "C1", "x": 4, "y": 3, "z": 2},
                {"id": "D1", "x": 0, "y": 3, "z": 2},
                {"id": "M", "x": 2, "y": 0, "z": 0},
                {"id": "N", "x": 2, "y": 3, "z": 0}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCDA_1B_1C_1D_1$ - параллелепипед", "$M$ - середина $AB$", "$N$ - середина $CD$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 2},
                {"id": "B1", "x": 4, "y": 0, "z": 2},
                {"id": "C1", "x": 4, "y": 3, "z": 2},
                {"id": "D1", "x": 0, "y": 3, "z": 2},
                {"id": "M", "x": 2, "y": 0, "z": 0},
                {"id": "N", "x": 2, "y": 3, "z": 0}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "A1", "to": "N"}, {"from": "D1", "to": "M"}
            ],
            "relations": ["$A_1N$ - отрезок", "$D_1M$ - отрезок", "$M$ - середина $AB$", "$N$ - середина $CD$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Точки $M$ и $N$ — середины рёбер $AB$ и $CD$ соответственно.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "$AM = MB$ и $CN = ND$, причём $AB \\parallel CD$ как противоположные стороны основания.", "justification_id": "property", "comment": "Основание параллелепипеда — параллелограмм"},
            {"step_id": 3, "claim": "Рассмотрим четырёхугольник $A_1D_1NM$. $A_1D_1 \\parallel AD$ и $A_1D_1 = AD$ (противоположные ребра).", "justification_id": "property", "comment": "Свойство параллелепипеда"},
            {"step_id": 4, "claim": "$MN \\parallel AD$ и $MN = AD$, так как $M$ и $N$ — середины $AB$ и $CD$ в параллелограмме $ABCD$.", "justification_id": "property", "comment": "Средняя линия параллелограмма"},
            {"step_id": 5, "claim": "Следовательно, $A_1D_1 \\parallel MN$ и $A_1D_1 = MN$, значит $A_1D_1NM$ — параллелограмм.", "justification_id": "definition", "comment": "Признак параллелограмма: противоположные стороны параллельны и равны"},
            {"step_id": 6, "claim": "В параллелограмме $A_1D_1NM$ противоположные стороны $A_1N$ и $D_1M$ параллельны.", "justification_id": "property", "comment": "Свойство параллелограмма"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Параллелепипед';

--changeset ahmedyanov:31
-- Task 24: Параллелограмм в кубе
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллелограмм в кубе',
        'В кубе $ABCDA_1B_1C_1D_1$ точки $M$ и $N$ — середины рёбер $AA_1$ и $CC_1$ соответственно. Докажите, что четырёхугольник $MB_1ND_1$ является параллелограммом.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 3, "y": 0, "z": 0},
                {"id": "C", "x": 3, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 3},
                {"id": "B1", "x": 3, "y": 0, "z": 3},
                {"id": "C1", "x": 3, "y": 3, "z": 3},
                {"id": "D1", "x": 0, "y": 3, "z": 3},
                {"id": "M", "x": 0, "y": 0, "z": 1.5},
                {"id": "N", "x": 3, "y": 3, "z": 1.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCDA_1B_1C_1D_1$ - куб", "$M$ - середина $AA_1$", "$N$ - середина $CC_1$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 3, "y": 0, "z": 0},
                {"id": "C", "x": 3, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 3},
                {"id": "B1", "x": 3, "y": 0, "z": 3},
                {"id": "C1", "x": 3, "y": 3, "z": 3},
                {"id": "D1", "x": 0, "y": 3, "z": 3},
                {"id": "M", "x": 0, "y": 0, "z": 1.5},
                {"id": "N", "x": 3, "y": 3, "z": 1.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "M", "to": "B1"}, {"from": "B1", "to": "N"}, {"from": "N", "to": "D1"}, {"from": "D1", "to": "M"}
            ],
            "relations": ["$MB_1ND_1$ - четырёхугольник"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Построим отрезки $MB_1$, $B_1N$, $ND_1$, $D_1M$, образующие четырёхугольник $MB_1ND_1$.", "justification_id": "construction", "comment": "Соединяем заданные точки"},
            {"step_id": 2, "claim": "Вектор $\\overrightarrow{MB_1} = \\overrightarrow{MB} + \\overrightarrow{BB_1}$. $M$ — середина $AA_1$, поэтому $\\overrightarrow{AM} = \\frac{1}{2}\\overrightarrow{AA_1}$.", "justification_id": "property", "comment": "Разложение вектора"},
            {"step_id": 3, "claim": "Аналогично, $\\overrightarrow{ND_1} = \\overrightarrow{NC} + \\overrightarrow{CD} + \\overrightarrow{DD_1} = \\frac{1}{2}\\overrightarrow{CC_1} + \\overrightarrow{CD} + \\overrightarrow{DD_1}$.", "justification_id": "property", "comment": "Разложение вектора"},
            {"step_id": 4, "claim": "В кубе $\\overrightarrow{AA_1} = \\overrightarrow{BB_1} = \\overrightarrow{CC_1} = \\overrightarrow{DD_1}$ и $\\overrightarrow{AB} = \\overrightarrow{DC}$.", "justification_id": "property", "comment": "Равенство векторов в кубе"},
            {"step_id": 5, "claim": "Следовательно, $\\overrightarrow{MB_1} = \\overrightarrow{ND_1}$, значит $MB_1 \\parallel ND_1$ и $MB_1 = ND_1$.", "justification_id": "property", "comment": "Равенство векторов"},
            {"step_id": 6, "claim": "Аналогично доказывается, что $\\overrightarrow{D_1M} = \\overrightarrow{B_1N}$.", "justification_id": "property", "comment": "Противоположные стороны равны и параллельны"},
            {"step_id": 7, "claim": "Таким образом, четырёхугольник $MB_1ND_1$ — параллелограмм по определению.", "justification_id": "definition", "comment": "Противоположные стороны попарно параллельны"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Куб';
