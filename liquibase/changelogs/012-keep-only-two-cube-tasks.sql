--liquibase formatted sql

--changeset ahmedyanov:34
-- Удаление лишних задач на куб, оставляем только 2 лучшие:
--   1. «Скрещивающиеся диагонали граней куба»
--   2. «Перпендикулярность диагонали куба и плоскости»
-- CASCADE автоматически удаляет связи из task_polyhedron_types.
DELETE FROM tasks
WHERE id IN (
    SELECT t.id FROM tasks t
    JOIN task_polyhedron_types tpt ON t.id = tpt.task_id
    JOIN polyhedron_types pt ON tpt.polyhedron_type_id = pt.id
    WHERE pt.name = 'Куб'
)
AND title NOT IN (
    'Скрещивающиеся диагонали граней куба',
    'Перпендикулярность диагонали куба и плоскости'
);
