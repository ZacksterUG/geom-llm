--liquibase formatted sql

--changeset ahmedyanov:2
DELETE FROM tasks;

--changeset ahmedyanov:3
INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
VALUES (
    'Скрещивающиеся диагонали граней куба',
    'В кубе ABCDA1B1C1D1 докажите, что диагональ A1C1 верхней грани и диагональ AD1 боковой грани являются скрещивающимися прямыми.',
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
        "relations": ["ABCD - нижнее основание куба", "A1B1C1D1 - верхняя грань куба"],
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
            {"from": "A1", "to": "C1"}, {"from": "A", "to": "D1"}
        ],
        "relations": ["A1C1 - диагональ верхней грани", "AD1 - диагональ боковой грани"],
        "actions_log": []
    }'::jsonb,
    '[
        {"step_id": 1, "claim": "Прямая A1C1 лежит в плоскости A1B1C1D1 (верхняя грань куба).", "justification_id": "definition", "comment": "A1 и C1 - вершины верхней грани"},
        {"step_id": 2, "claim": "Прямая AD1 пересекает плоскость A1B1C1D1 в точке D1.", "justification_id": "property", "comment": "D1 принадлежит и грани AA1D1D, и верхней грани"},
        {"step_id": 3, "claim": "Точка D1 не лежит на прямой A1C1, так как A1, C1, D1 - три различные вершины квадрата, а A1C1 соединяет две из них.", "justification_id": "property", "comment": "В квадрате диагональ соединяет противоположные вершины"},
        {"step_id": 4, "claim": "Следовательно, прямые A1C1 и AD1 скрещиваются по признаку скрещивающихся прямых.", "justification_id": "theorem", "comment": "Признак: одна прямая лежит в плоскости, другая пересекает плоскость в точке, не лежащей на первой прямой"}
    ]'::jsonb,
    '10-11 класс'
);

INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
VALUES (
    'Теорема о диагонали прямоугольного параллелепипеда',
    'В прямоугольном параллелепипеде ABCDA1B1C1D1 докажите, что квадрат диагонали равен сумме квадратов трех его измерений: AC1^2 = AB^2 + AD^2 + AA1^2.',
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
        "relations": ["ABCD - основание (прямоугольник)", "A1B1C1D1 - верхняя грань", "AB = 4, AD = 3, AA1 = 2"],
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
            {"from": "A", "to": "C"}, {"from": "A", "to": "C1"}
        ],
        "relations": ["ABCD - основание (прямоугольник)", "AC - диагональ основания", "AC1 - диагональ параллелепипеда"],
        "actions_log": []
    }'::jsonb,
    '[
        {"step_id": 1, "claim": "Построим диагональ AC в основании ABCD.", "justification_id": "construction", "comment": "AC лежит в плоскости основания"},
        {"step_id": 2, "claim": "Построим диагональ AC1 параллелепипеда.", "justification_id": "construction", "comment": "AC1 проходит через внутреннее пространство"},
        {"step_id": 3, "claim": "В прямоугольном треугольнике ACC1: AC1^2 = AC^2 + CC1^2 по теореме Пифагора, так как CC1 перпендикулярно плоскости основания.", "justification_id": "theorem_pythagorean", "comment": "CC1 - боковое ребро, перпендикулярное основанию"},
        {"step_id": 4, "claim": "В прямоугольном треугольнике ABC: AC^2 = AB^2 + BC^2 по теореме Пифагора.", "justification_id": "theorem_pythagorean", "comment": "ABCD - прямоугольник, угол B - прямой"},
        {"step_id": 5, "claim": "Учитывая, что BC = AD и CC1 = AA1, получаем AC1^2 = AB^2 + AD^2 + AA1^2.", "justification_id": "arithmetic", "comment": "Подстановка и равенство противоположных ребер"}
    ]'::jsonb,
    '10-11 класс'
);

INSERT INTO tasks (title, condition_text, initial_figure_state, reference_figure_state, reference_proof, difficulty_level)
VALUES (
    'Перпендикулярность диагонали куба и плоскости',
    'В кубе ABCDA1B1C1D1 докажите, что диагональ A1C перпендикулярна плоскости AB1D1.',
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
        "relations": ["ABCD - нижнее основание куба", "A1B1C1D1 - верхняя грань куба"],
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
            {"from": "A1", "to": "C"}, {"from": "A", "to": "B1"}, {"from": "A", "to": "D1"}, {"from": "B1", "to": "D1"}
        ],
        "relations": ["A1C - диагональ куба", "AB1D1 - плоскость сечения"],
        "actions_log": []
    }'::jsonb,
    '[
        {"step_id": 1, "claim": "Построим диагональ A1C куба.", "justification_id": "construction", "comment": "A1C - пространственная диагональ"},
        {"step_id": 2, "claim": "Построим отрезки AB1, AD1, B1D1 - они образуют плоскость AB1D1.", "justification_id": "construction", "comment": "Три точки определяют плоскость"},
        {"step_id": 3, "claim": "Проекция A1C на плоскость AA1D1D - прямая A1D. AD1 перпендикулярна A1D (диагонали квадрата). По теореме о трех перпендикулярах A1C перпендикулярна AD1.", "justification_id": "theorem_three_perps", "comment": "C проецируется в D на плоскость AA1D1D"},
        {"step_id": 4, "claim": "Проекция A1C на плоскость AA1B1B - прямая A1B. AB1 перпендикулярна A1B (диагонали квадрата). По теореме о трех перпендикулярах A1C перпендикулярна AB1.", "justification_id": "theorem_three_perps", "comment": "C проецируется в B на плоскость AA1B1B"},
        {"step_id": 5, "claim": "Прямая A1C перпендикулярна двум пересекающимся прямым AB1 и AD1 плоскости AB1D1, следовательно A1C перпендикулярна плоскости AB1D1.", "justification_id": "definition", "comment": "Признак перпендикулярности прямой и плоскости"}
    ]'::jsonb,
    '10-11 класс'
);
