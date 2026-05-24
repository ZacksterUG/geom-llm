--liquibase formatted sql

--changeset ahmedyanov:11
INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id
FROM tasks t, polyhedron_types pt
WHERE t.title = 'Скрещивающиеся диагонали граней куба' AND pt.name = 'Куб';

INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id
FROM tasks t, polyhedron_types pt
WHERE t.title = 'Теорема о диагонали прямоугольного параллелепипеда' AND pt.name = 'Прямоугольный параллелепипед';

INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id
FROM tasks t, polyhedron_types pt
WHERE t.title = 'Перпендикулярность диагонали куба и плоскости' AND pt.name = 'Куб';

INSERT INTO task_polyhedron_types (task_id, polyhedron_type_id)
SELECT t.id, pt.id
FROM tasks t, polyhedron_types pt
WHERE t.title = 'Параллельность прямой и плоскости в призме' AND pt.name IN ('Четырёхугольная призма', 'Правильная призма');
