--liquibase formatted sql

--changeset ahmedyanov:9
CREATE TABLE IF NOT EXISTS polyhedron_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    display_order INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS task_polyhedron_types (
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    polyhedron_type_id INTEGER NOT NULL REFERENCES polyhedron_types(id) ON DELETE CASCADE,
    PRIMARY KEY (task_id, polyhedron_type_id)
);

CREATE INDEX IF NOT EXISTS idx_tpt_task ON task_polyhedron_types(task_id);
CREATE INDEX IF NOT EXISTS idx_tpt_type ON task_polyhedron_types(polyhedron_type_id);

--changeset ahmedyanov:10
INSERT INTO polyhedron_types (name, display_order) VALUES
    ('Куб', 1),
    ('Прямоугольный параллелепипед', 2),
    ('Параллелепипед', 3),
    ('Треугольная призма', 4),
    ('Четырёхугольная призма', 5),
    ('Шестиугольная призма', 6),
    ('Правильная призма', 7),
    ('Тетраэдр', 8),
    ('Треугольная пирамида', 9),
    ('Четырёхугольная пирамида', 10),
    ('Правильная пирамида', 11),
    ('Октаэдр', 12),
    ('Наклонная призма', 13);
