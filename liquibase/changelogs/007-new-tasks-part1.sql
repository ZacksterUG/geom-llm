--liquibase formatted sql

--changeset ahmedyanov:12
-- Task 5: Параллельность прямой и плоскости в кубе
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность прямой и плоскости в кубе',
        'В кубе $ABCDA_1B_1C_1D_1$ точка $M$ — середина ребра $A_1B_1$, точка $N$ — середина ребра $B_1C_1$. Докажите, что прямая $MN$ параллельна плоскости $AA_1C_1$.',
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
                {"id": "M", "x": 1.5, "y": 0, "z": 3},
                {"id": "N", "x": 3, "y": 1.5, "z": 3}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCD$ - нижнее основание куба", "$A_1B_1C_1D_1$ - верхняя грань", "$M$ - середина $A_1B_1$", "$N$ - середина $B_1C_1$"],
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
                {"id": "M", "x": 1.5, "y": 0, "z": 3},
                {"id": "N", "x": 3, "y": 1.5, "z": 3}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "M", "to": "N"}, {"from": "M", "to": "B1"}, {"from": "N", "to": "B1"}
            ],
            "relations": ["$MN$ - средняя линия треугольника $A_1B_1C_1$", "$MN \\parallel A_1C_1$", "$A_1C_1$ лежит в плоскости $AA_1C_1$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $A_1B_1C_1$ точки $M$ и $N$ — середины сторон $A_1B_1$ и $B_1C_1$ соответственно.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "Следовательно, $MN$ — средняя линия треугольника $A_1B_1C_1$, и $MN \\parallel A_1C_1$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 3, "claim": "Прямая $A_1C_1$ лежит в плоскости $AA_1C_1$.", "justification_id": "definition", "comment": "Точки $A_1$ и $C_1$ принадлежат плоскости $AA_1C_1$"},
            {"step_id": 4, "claim": "Так как $MN \\parallel A_1C_1$, а $A_1C_1$ лежит в плоскости $AA_1C_1$, то $MN \\parallel$ плоскости $AA_1C_1$.", "justification_id": "theorem", "comment": "Признак параллельности прямой и плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Куб';

--changeset ahmedyanov:13
-- Task 6: Скрещивающиеся прямые AB1 и CD1 в кубе
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Скрещивающиеся прямые $AB_1$ и $CD_1$ в кубе',
        'В кубе $ABCDA_1B_1C_1D_1$ докажите, что прямые $AB_1$ и $CD_1$ являются скрещивающимися.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 3, "y": 0, "z": 0},
                {"id": "C", "x": 3, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 3},
                {"id": "B1", "x": 3, "y": 0, "z": 3},
                {"id": "C1", "x": 3, "y": 3, "z": 3},
                {"id": "D1", "x": 0, "y": 3, "z": 3}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCD$ - нижнее основание куба", "$A_1B_1C_1D_1$ - верхняя грань куба"],
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
                {"id": "D1", "x": 0, "y": 3, "z": 3}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "A", "to": "B1"}, {"from": "C", "to": "D1"}
            ],
            "relations": ["$AB_1$ - диагональ боковой грани", "$CD_1$ - диагональ боковой грани"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Прямая $AB_1$ лежит в плоскости $AA_1B_1B$ (боковая грань куба).", "justification_id": "definition", "comment": "$A$, $B_1$ — вершины грани $AA_1B_1B$"},
            {"step_id": 2, "claim": "Прямая $CD_1$ пересекает плоскость $AA_1B_1B$ в точке $D_1$.", "justification_id": "property", "comment": "$D_1$ принадлежит и грани $AA_1D_1D$, и плоскости $AA_1B_1B$"},
            {"step_id": 3, "claim": "Точка $D_1$ не лежит на прямой $AB_1$, так как $AB_1$ соединяет вершины одной боковой грани, а $D_1$ — вершина противоположной грани.", "justification_id": "property", "comment": "$D_1 \\notin AB_1$ по расположению вершин куба"},
            {"step_id": 4, "claim": "Следовательно, прямые $AB_1$ и $CD_1$ скрещиваются по признаку скрещивающихся прямых.", "justification_id": "theorem", "comment": "Признак: одна прямая лежит в плоскости, другая пересекает плоскость в точке, не лежащей на первой прямой"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Куб';

--changeset ahmedyanov:14
-- Task 7: Параллельность плоскостей в кубе
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность плоскостей в кубе',
        'В кубе $ABCDA_1B_1C_1D_1$ докажите, что плоскость $A_1BD$ параллельна плоскости $CB_1D_1$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 3, "y": 0, "z": 0},
                {"id": "C", "x": 3, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 3},
                {"id": "B1", "x": 3, "y": 0, "z": 3},
                {"id": "C1", "x": 3, "y": 3, "z": 3},
                {"id": "D1", "x": 0, "y": 3, "z": 3}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCD$ - нижнее основание куба", "$A_1B_1C_1D_1$ - верхняя грань куба"],
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
                {"id": "D1", "x": 0, "y": 3, "z": 3}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "A1", "to": "B"}, {"from": "A1", "to": "D"}, {"from": "C", "to": "B1"}, {"from": "C", "to": "D1"}
            ],
            "relations": ["$A_1BD$ - плоскость", "$CB_1D_1$ - плоскость"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В плоскости $A_1BD$ возьмём две пересекающиеся прямые $A_1B$ и $A_1D$.", "justification_id": "definition", "comment": "Плоскость определяется двумя пересекающимися прямыми"},
            {"step_id": 2, "claim": "$A_1B \\parallel D_1C$, так как $A_1B$ и $D_1C$ — диагонали противоположных граней куба, лежащие в параллельных гранях.", "justification_id": "property", "comment": "Противоположные грани куба параллельны"},
            {"step_id": 3, "claim": "$A_1D \\parallel B_1C$, так как $A_1D$ и $B_1C$ — диагонали противоположных граней куба.", "justification_id": "property", "comment": "Противоположные грани куба параллельны"},
            {"step_id": 4, "claim": "Прямые $D_1C$ и $B_1C$ лежат в плоскости $CB_1D_1$ и пересекаются в точке $C$.", "justification_id": "definition", "comment": "$C$, $B_1$, $D_1$ определяют плоскость $CB_1D_1$"},
            {"step_id": 5, "claim": "Следовательно, плоскость $A_1BD$ параллельна плоскости $CB_1D_1$ по признаку параллельности плоскостей.", "justification_id": "theorem", "comment": "Признак: две пересекающиеся прямые одной плоскости параллельны двум пересекающимся прямым другой плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Куб';

--changeset ahmedyanov:15
-- Task 8: Сечение куба плоскостью
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Сечение куба плоскостью',
        'В кубе $ABCDA_1B_1C_1D_1$ точки $M$, $N$, $K$ — середины рёбер $AB$, $BC$ и $BB_1$ соответственно. Постройте сечение куба плоскостью $MNK$. Докажите, что треугольник $MNK$ — прямоугольный.',
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
                {"id": "M", "x": 1.5, "y": 0, "z": 0},
                {"id": "N", "x": 3, "y": 1.5, "z": 0},
                {"id": "K", "x": 3, "y": 0, "z": 1.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCD$ - нижнее основание куба", "$M$ - середина $AB$", "$N$ - середина $BC$", "$K$ - середина $BB_1$"],
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
                {"id": "M", "x": 1.5, "y": 0, "z": 0},
                {"id": "N", "x": 3, "y": 1.5, "z": 0},
                {"id": "K", "x": 3, "y": 0, "z": 1.5}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "M", "to": "N"}, {"from": "M", "to": "K"}, {"from": "N", "to": "K"}
            ],
            "relations": ["$MNK$ - сечение куба", "$MN$ - в плоскости основания", "$K$ - на боковом ребре"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Построим отрезки $MN$, $MK$ и $NK$ — они образуют сечение $MNK$.", "justification_id": "construction", "comment": "Соединяем заданные точки"},
            {"step_id": 2, "claim": "Рассмотрим треугольник $MNK$. $MN$ лежит в плоскости $ABC$ (основания), $MK$ лежит в плоскости $ABB_1$, $NK$ лежит в плоскости $BB_1C$.", "justification_id": "definition", "comment": "Точки определяют прямые в соответствующих гранях"},
            {"step_id": 3, "claim": "$AB \\perp BC$ как стороны квадрата, $M \\in AB$, $N \\in BC$, значит $MN$ не перпендикулярен ни одной из граней.", "justification_id": "property", "comment": "Стороны квадрата перпендикулярны"},
            {"step_id": 4, "claim": "Проверим угол $MKN$: $MK$ лежит в плоскости $BB_1C$, $NK$ лежит в плоскости $ABB_1$. Так как $BB_1 \\perp AB$ и $BB_1 \\perp BC$, то $BB_1 \\perp$ плоскости $ABC$. $K \\in BB_1$, поэтому $MK$ и $NK$ — наклонные.", "justification_id": "property", "comment": "Боковое ребро перпендикулярно основанию"},
            {"step_id": 5, "claim": "В треугольнике $MNK$: $MN^2 = MB^2 + BN^2 = (1.5)^2 + (1.5)^2 = 4.5$, $MK^2 = MB^2 + BK^2 = (1.5)^2 + (1.5)^2 = 4.5$, $NK^2 = BN^2 + BK^2 = (1.5)^2 + (1.5)^2 = 4.5$. Следовательно, треугольник равносторонний.", "justification_id": "arithmetic", "comment": "Вычисление длин отрезков по теореме Пифагора"},
            {"step_id": 6, "claim": "Треугольник $MNK$ — равносторонний, а значит и остроугольный. Сечение построено.", "justification_id": "definition", "comment": "Равносторонний треугольник — частный случай равнобедренного"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Куб';

--changeset ahmedyanov:16
-- Task 9: Параллельность плоскостей в прямоугольном параллелепипеде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность плоскостей в параллелепипеде',
        'В прямоугольном параллелепипеде $ABCDA_1B_1C_1D_1$ докажите, что плоскость $AB_1D_1$ параллельна плоскости $C_1BD$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 2},
                {"id": "B1", "x": 4, "y": 0, "z": 2},
                {"id": "C1", "x": 4, "y": 3, "z": 2},
                {"id": "D1", "x": 0, "y": 3, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCD$ - основание (прямоугольник)", "$A_1B_1C_1D_1$ - верхняя грань"],
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
                {"id": "D1", "x": 0, "y": 3, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "A", "to": "B1"}, {"from": "A", "to": "D1"}, {"from": "C1", "to": "B"}, {"from": "C1", "to": "D"}
            ],
            "relations": ["$AB_1D_1$ - плоскость", "$C_1BD$ - плоскость"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В плоскости $AB_1D_1$ возьмём пересекающиеся прямые $AB_1$ и $AD_1$.", "justification_id": "definition", "comment": "Две пересекающиеся прямые определяют плоскость"},
            {"step_id": 2, "claim": "$AB_1 \\parallel C_1D$, так как $AB_1$ и $C_1D$ — диагонали противоположных граней прямоугольного параллелепипеда.", "justification_id": "property", "comment": "Противоположные грани прямоугольного параллелепипеда параллельны"},
            {"step_id": 3, "claim": "$AD_1 \\parallel C_1B$, так как $AD_1$ и $C_1B$ — диагонали противоположных граней.", "justification_id": "property", "comment": "Противоположные грани прямоугольного параллелепипеда параллельны"},
            {"step_id": 4, "claim": "Прямые $C_1D$ и $C_1B$ лежат в плоскости $C_1BD$ и пересекаются в точке $C_1$.", "justification_id": "definition", "comment": "$C_1$, $B$, $D$ определяют плоскость $C_1BD$"},
            {"step_id": 5, "claim": "Следовательно, плоскость $AB_1D_1$ параллельна плоскости $C_1BD$ по признаку параллельности плоскостей.", "justification_id": "theorem", "comment": "Если две пересекающиеся прямые одной плоскости параллельны двум прямым другой плоскости, то плоскости параллельны"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Прямоугольный параллелепипед';

--changeset ahmedyanov:17
-- Task 10: Скрещивающиеся прямые в прямоугольном параллелепипеде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Скрещивающиеся прямые в параллелепипеде',
        'В прямоугольном параллелепипеде $ABCDA_1B_1C_1D_1$ докажите, что прямые $A_1B$ и $D_1C$ являются скрещивающимися.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 4, "y": 3, "z": 0},
                {"id": "D", "x": 0, "y": 3, "z": 0},
                {"id": "A1", "x": 0, "y": 0, "z": 2},
                {"id": "B1", "x": 4, "y": 0, "z": 2},
                {"id": "C1", "x": 4, "y": 3, "z": 2},
                {"id": "D1", "x": 0, "y": 3, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCD$ - основание (прямоугольник)", "$A_1B_1C_1D_1$ - верхняя грань"],
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
                {"id": "D1", "x": 0, "y": 3, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "A1", "to": "B"}, {"from": "D1", "to": "C"}
            ],
            "relations": ["$A_1B$ - диагональ боковой грани", "$D_1C$ - диагональ боковой грани"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Прямая $A_1B$ лежит в плоскости $AA_1B_1B$ (боковая грань).", "justification_id": "definition", "comment": "$A_1$ и $B$ — вершины грани $AA_1B_1B$"},
            {"step_id": 2, "claim": "Прямая $D_1C$ пересекает плоскость $AA_1B_1B$ в точке $D_1$.", "justification_id": "property", "comment": "Точка $D_1$ принадлежит плоскости $AA_1D_1D$, которая пересекается с $AA_1B_1B$ по $AA_1$"},
            {"step_id": 3, "claim": "Точка $D_1$ не лежит на прямой $A_1B$.", "justification_id": "property", "comment": "$D_1$ не принадлежит грани $AA_1B_1B$"},
            {"step_id": 4, "claim": "Следовательно, прямые $A_1B$ и $D_1C$ скрещиваются по признаку скрещивающихся прямых.", "justification_id": "theorem", "comment": "Одна прямая лежит в плоскости, другая пересекает её в точке, не лежащей на первой прямой"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Прямоугольный параллелепипед';

--changeset ahmedyanov:18
-- Task 11: Параллельность прямой и плоскости в параллелепипеде
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность прямой и плоскости в параллелепипеде',
        'В прямоугольном параллелепипеде $ABCDA_1B_1C_1D_1$ точки $M$ и $N$ — середины рёбер $A_1B_1$ и $B_1C_1$ соответственно. Докажите, что прямая $MN$ параллельна плоскости $A_1BC$.',
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
                {"id": "M", "x": 2, "y": 0, "z": 2},
                {"id": "N", "x": 4, "y": 1.5, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"}
            ],
            "relations": ["$ABCD$ - основание", "$M$ - середина $A_1B_1$", "$N$ - середина $B_1C_1$"],
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
                {"id": "M", "x": 2, "y": 0, "z": 2},
                {"id": "N", "x": 4, "y": 1.5, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "D"}, {"from": "D", "to": "A"},
                {"from": "A1", "to": "B1"}, {"from": "B1", "to": "C1"}, {"from": "C1", "to": "D1"}, {"from": "D1", "to": "A1"},
                {"from": "A", "to": "A1"}, {"from": "B", "to": "B1"}, {"from": "C", "to": "C1"}, {"from": "D", "to": "D1"},
                {"from": "M", "to": "N"}, {"from": "A1", "to": "C"}
            ],
            "relations": ["$MN$ - средняя линия $A_1B_1C_1$", "$MN \\parallel A_1C$", "$A_1C$ лежит в плоскости $A_1BC$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $A_1B_1C_1$ точки $M$ и $N$ — середины сторон $A_1B_1$ и $B_1C_1$.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "Следовательно, $MN$ — средняя линия треугольника $A_1B_1C_1$, и $MN \\parallel A_1C_1$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 3, "claim": "$A_1C_1 \\parallel AC$, так как $A_1C_1$ и $AC$ — диагонали параллельных граней.", "justification_id": "property", "comment": "Противоположные грани параллелепипеда параллельны"},
            {"step_id": 4, "claim": "Прямая $AC$ лежит в плоскости $A_1BC$, следовательно $MN \\parallel$ плоскости $A_1BC$.", "justification_id": "theorem", "comment": "Признак параллельности прямой и плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Прямоугольный параллелепипед';

--changeset ahmedyanov:19
-- Task 12: Параллельность прямой и плоскости в тетраэдре
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность прямой и плоскости в тетраэдре',
        'В тетраэдре $DABC$ точки $M$ и $N$ — середины рёбер $AD$ и $DB$ соответственно. Докажите, что прямая $MN$ параллельна плоскости $ABC$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "D", "x": 2, "y": 1, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "D"}, {"from": "B", "to": "D"}, {"from": "C", "to": "D"}
            ],
            "relations": ["$DABC$ - тетраэдр", "$M$ - середина $AD$", "$N$ - середина $DB$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "D", "x": 2, "y": 1, "z": 4},
                {"id": "M", "x": 1, "y": 0.5, "z": 2},
                {"id": "N", "x": 3, "y": 0.5, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "D"}, {"from": "B", "to": "D"}, {"from": "C", "to": "D"},
                {"from": "M", "to": "N"}
            ],
            "relations": ["$MN$ - средняя линия треугольника $ADB$", "$MN \\parallel AB$", "$AB$ лежит в плоскости $ABC$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $ADB$ точки $M$ и $N$ — середины сторон $AD$ и $DB$ соответственно.", "justification_id": "definition", "comment": "По условию задачи"},
            {"step_id": 2, "claim": "Следовательно, $MN$ — средняя линия треугольника $ADB$, и $MN \\parallel AB$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 3, "claim": "Прямая $AB$ лежит в плоскости $ABC$.", "justification_id": "definition", "comment": "$A$ и $B$ — вершины треугольника $ABC$"},
            {"step_id": 4, "claim": "Так как $MN \\parallel AB$, а $AB$ лежит в плоскости $ABC$, то $MN \\parallel$ плоскости $ABC$.", "justification_id": "theorem", "comment": "Признак параллельности прямой и плоскости"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Тетраэдр';

--changeset ahmedyanov:20
-- Task 13: Параллельность плоскостей в тетраэдре
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Параллельность плоскостей в тетраэдре',
        'В тетраэдре $DABC$ точки $M$, $N$, $K$ — середины рёбер $DA$, $DB$ и $DC$ соответственно. Докажите, что плоскость $MNK$ параллельна плоскости $ABC$.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "D", "x": 2, "y": 1, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "D"}, {"from": "B", "to": "D"}, {"from": "C", "to": "D"}
            ],
            "relations": ["$DABC$ - тетраэдр", "$M$ - середина $DA$", "$N$ - середина $DB$", "$K$ - середина $DC$"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "D", "x": 2, "y": 1, "z": 4},
                {"id": "M", "x": 1, "y": 0.5, "z": 2},
                {"id": "N", "x": 3, "y": 0.5, "z": 2},
                {"id": "K", "x": 2, "y": 2.25, "z": 2}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "D"}, {"from": "B", "to": "D"}, {"from": "C", "to": "D"},
                {"from": "M", "to": "N"}, {"from": "M", "to": "K"}, {"from": "N", "to": "K"}
            ],
            "relations": ["$MNK$ - плоскость", "$MN \\parallel AB$", "$NK \\parallel BC$"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "В треугольнике $ADB$ $MN$ — средняя линия, следовательно $MN \\parallel AB$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 2, "claim": "В треугольнике $BDC$ $NK$ — средняя линия, следовательно $NK \\parallel BC$.", "justification_id": "theorem", "comment": "Свойство средней линии треугольника"},
            {"step_id": 3, "claim": "Прямые $AB$ и $BC$ лежат в плоскости $ABC$ и пересекаются в точке $B$.", "justification_id": "definition", "comment": "Две пересекающиеся прямые определяют плоскость"},
            {"step_id": 4, "claim": "Прямые $MN$ и $NK$ лежат в плоскости $MNK$ и пересекаются в точке $N$.", "justification_id": "definition", "comment": "Две пересекающиеся прямые определяют плоскость"},
            {"step_id": 5, "claim": "Следовательно, плоскость $MNK$ параллельна плоскости $ABC$ по признаку параллельности плоскостей.", "justification_id": "theorem", "comment": "Если две пересекающиеся прямые одной плоскости параллельны двум прямым другой плоскости, то плоскости параллельны"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Тетраэдр';

--changeset ahmedyanov:21
-- Task 14: Скрещивающиеся прямые в тетраэдре
WITH t AS (
    INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
    VALUES (
        'Скрещивающиеся прямые в тетраэдре',
        'В тетраэдре $DABC$ докажите, что прямые $AB$ и $CD$ являются скрещивающимися.',
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "D", "x": 2, "y": 1, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "D"}, {"from": "B", "to": "D"}, {"from": "C", "to": "D"}
            ],
            "relations": ["$DABC$ - тетраэдр"],
            "actions_log": []
        }'::jsonb,
        '{
            "vertices": [
                {"id": "A", "x": 0, "y": 0, "z": 0},
                {"id": "B", "x": 4, "y": 0, "z": 0},
                {"id": "C", "x": 2, "y": 3.5, "z": 0},
                {"id": "D", "x": 2, "y": 1, "z": 4}
            ],
            "edges": [
                {"from": "A", "to": "B"}, {"from": "B", "to": "C"}, {"from": "C", "to": "A"},
                {"from": "A", "to": "D"}, {"from": "B", "to": "D"}, {"from": "C", "to": "D"}
            ],
            "relations": ["$AB$ - ребро основания", "$CD$ - боковое ребро"],
            "actions_log": []
        }'::jsonb,
        '[
            {"step_id": 1, "claim": "Прямая $AB$ лежит в плоскости $ABC$ (основание тетраэдра).", "justification_id": "definition", "comment": "$A$ и $B$ — вершины основания"},
            {"step_id": 2, "claim": "Прямая $CD$ пересекает плоскость $ABC$ в точке $C$.", "justification_id": "property", "comment": "Точка $C$ принадлежит как $CD$, так и плоскости $ABC$"},
            {"step_id": 3, "claim": "Точка $C$ не лежит на прямой $AB$, так как $A$, $B$, $C$ — вершины треугольника $ABC$ (не лежат на одной прямой).", "justification_id": "property", "comment": "Вершины треугольника не коллинеарны"},
            {"step_id": 4, "claim": "Следовательно, прямые $AB$ и $CD$ скрещиваются по признаку скрещивающихся прямых.", "justification_id": "theorem", "comment": "Одна прямая лежит в плоскости, другая пересекает плоскость в точке, не лежащей на первой прямой"}
        ]'::jsonb,
        '10-11 класс'
    ) RETURNING id
)
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id FROM t, polyhedron_types pt WHERE pt.name = 'Тетраэдр';
