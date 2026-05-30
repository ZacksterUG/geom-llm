--liquibase formatted sql

--changeset ahmedyanov:32
-- Исправление удаления треугольной пирамиды (баг в 010: ILIKE '%треугольная пирамида%' не совпадает с 'треугольной пирамиде')
-- Сначала удаляем оставшиеся связи
DELETE FROM task_polyhedron_types
WHERE task_id IN (
    SELECT id FROM tasks
    WHERE title ILIKE '%треугольн%пирамид%'
);

-- Затем удаляем сами задачи
DELETE FROM tasks
WHERE title ILIKE '%треугольн%пирамид%';

--changeset ahmedyanov:33 splitStatements:false
-- Исправление координат: в Three.js ось Y направлена вверх, а Z — глубина.
-- Меняем Y и Z местами для всех вершин в задачах на пирамиды и тетраэдры,
-- чтобы основание было параллельно земле (XZ-плоскость).
DO $body$
DECLARE
    task_record RECORD;
    v_initial JSONB;
    v_reference JSONB;
    v_idx INT;
    v_y NUMERIC;
    v_z NUMERIC;
BEGIN
    FOR task_record IN
        SELECT id, title, initial_figure_state, reference_figure_state
        FROM tasks
        WHERE title IN (
            'Параллельность прямой и плоскости в тетраэдре',
            'Параллельность плоскостей в тетраэдре',
            'Скрещивающиеся прямые в тетраэдре',
            'Параллельность средней линии и основания пирамиды',
            'Скрещивающиеся прямые в пирамиде',
            'Параллельность прямой и плоскости в пирамиде'
        )
    LOOP
        -- Обновление initial_figure_state
        v_initial := task_record.initial_figure_state;
        FOR v_idx IN 0..jsonb_array_length(v_initial->'vertices') - 1 LOOP
            v_y := (v_initial->'vertices'->v_idx->>'y')::NUMERIC;
            v_z := (v_initial->'vertices'->v_idx->>'z')::NUMERIC;
            v_initial := jsonb_set(v_initial, ARRAY['vertices', v_idx::TEXT, 'y'], to_jsonb(v_z));
            v_initial := jsonb_set(v_initial, ARRAY['vertices', v_idx::TEXT, 'z'], to_jsonb(v_y));
        END LOOP;

        UPDATE tasks SET initial_figure_state = v_initial WHERE id = task_record.id;

        -- Обновление reference_figure_state
        IF task_record.reference_figure_state IS NOT NULL THEN
            v_reference := task_record.reference_figure_state;
            FOR v_idx IN 0..jsonb_array_length(v_reference->'vertices') - 1 LOOP
                v_y := (v_reference->'vertices'->v_idx->>'y')::NUMERIC;
                v_z := (v_reference->'vertices'->v_idx->>'z')::NUMERIC;
                v_reference := jsonb_set(v_reference, ARRAY['vertices', v_idx::TEXT, 'y'], to_jsonb(v_z));
                v_reference := jsonb_set(v_reference, ARRAY['vertices', v_idx::TEXT, 'z'], to_jsonb(v_y));
            END LOOP;

            UPDATE tasks SET reference_figure_state = v_reference WHERE id = task_record.id;
        END IF;
    END LOOP;
END $body$;
