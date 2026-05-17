--liquibase formatted sql

--changeset ahmedyanov:1
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    condition_text TEXT NOT NULL,
    initial_figure_state JSONB NOT NULL,
    reference_figure_state JSONB,
    reference_proof JSONB,
    difficulty_level VARCHAR(50) DEFAULT '10-11 класс',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_tasks_difficulty ON tasks(difficulty_level);
