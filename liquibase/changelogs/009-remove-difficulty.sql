--liquibase formatted sql

--changeset ahmedyanov:9

-- Удаление индекса по сложности
DROP INDEX IF EXISTS idx_tasks_difficulty;

-- Удаление столбца difficulty_level из таблицы tasks
ALTER TABLE tasks DROP COLUMN IF EXISTS difficulty_level;
