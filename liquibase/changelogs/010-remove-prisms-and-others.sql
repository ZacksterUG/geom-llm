--liquibase formatted sql

--changeset ahmedyanov:14

-- Удаление связей задач с типами призм, треугольной пирамиды и октаэдра
DELETE FROM task_polyhedron_types
WHERE polyhedron_type_id IN (
    SELECT id FROM polyhedron_types
    WHERE name IN (
        'Треугольная призма',
        'Четырёхугольная призма',
        'Шестиугольная призма',
        'Правильная призма',
        'Наклонная призма',
        'Треугольная пирамида',
        'Октаэдр'
    )
);

-- Удаление задач, связанных с призмами (по ключевым словам в названии или условии)
DELETE FROM tasks
WHERE id IN (
    SELECT id FROM tasks
    WHERE title ILIKE '%призм%'
       OR condition_text ILIKE '%призм%'
);

-- Удаление задач с треугольной пирамидой
DELETE FROM tasks
WHERE id IN (
    SELECT id FROM tasks
    WHERE title ILIKE '%треугольная пирамида%'
       OR condition_text ILIKE '%треугольная пирамида%'
);

-- Удаление задач с октаэдром
DELETE FROM tasks
WHERE id IN (
    SELECT id FROM tasks
    WHERE title ILIKE '%октаэдр%'
       OR condition_text ILIKE '%октаэдр%'
);

-- Удаление типов многогранников: призмы, треугольная пирамида, октаэдр
DELETE FROM polyhedron_types
WHERE name IN (
    'Треугольная призма',
    'Четырёхугольная призма',
    'Шестиугольная призма',
    'Правильная призма',
    'Наклонная призма',
    'Треугольная пирамида',
    'Октаэдр'
);

-- Обновление порядка отображения оставшихся типов
UPDATE polyhedron_types SET display_order = 1 WHERE name = 'Куб';
UPDATE polyhedron_types SET display_order = 2 WHERE name = 'Прямоугольный параллелепипед';
UPDATE polyhedron_types SET display_order = 3 WHERE name = 'Параллелепипед';
UPDATE polyhedron_types SET display_order = 4 WHERE name = 'Тетраэдр';
UPDATE polyhedron_types SET display_order = 5 WHERE name = 'Четырёхугольная пирамида';
UPDATE polyhedron_types SET display_order = 6 WHERE name = 'Правильная пирамида';
