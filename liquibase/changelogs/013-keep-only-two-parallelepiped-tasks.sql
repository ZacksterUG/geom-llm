--liquibase formatted sql

--changeset ahmedyanov:35
-- Удаление лишних задач на прямоугольный параллелепипед, оставляем только 2 лучшие:
--   1. «Теорема о диагонали прямоугольного параллелепипеда»
--   2. «Параллельность плоскостей в параллелепипеде»
-- CASCADE автоматически удаляет связи из task_polyhedron_types.
DELETE FROM tasks
WHERE id IN (
    SELECT t.id FROM tasks t
    JOIN task_polyhedron_types tpt ON t.id = tpt.task_id
    JOIN polyhedron_types pt ON tpt.polyhedron_type_id = pt.id
    WHERE pt.name = 'Прямоугольный параллелепипед'
)
AND title NOT IN (
    'Теорема о диагонали прямоугольного параллелепипеда',
    'Параллельность плоскостей в параллелепипеде'
);

--changeset ahmedyanov:36
-- Удаление задачи «Параллельность отрезков в параллелепипеде» (тип 'Параллелепипед'),
-- так как отрезки A1N и D1M не являются параллельными ни в каком параллелепипеде
-- (геометрически некорректная задача).
DELETE FROM tasks
WHERE title = 'Параллельность отрезков в параллелепипеде';

--changeset ahmedyanov:37
-- Удаление типа «Параллелепипед», так как в нём больше нет задач.
DELETE FROM polyhedron_types
WHERE name = 'Параллелепипед';

