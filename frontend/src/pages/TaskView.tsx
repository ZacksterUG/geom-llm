import { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { Title, Text, Textarea, Button, Stack, Grid, Card, Loader, Alert, Group } from '@mantine/core';
import { notifications } from '@mantine/notifications';
import type { Task, ProofStep, ValidationRequest, ValidationResponse, FigureState } from '../types';
import GeometryCanvas from '../components/GeometryCanvas';
import MathText from '../components/MathText';

export default function TaskView() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [task, setTask] = useState<Task | null>(null);
  const [proof, setProof] = useState('');
  const [loading, setLoading] = useState(true);
  const [validating, setValidating] = useState(false);
  const [figureState, setFigureState] = useState<FigureState | null>(null);
  const [validationResult, setValidationResult] = useState<ValidationResponse | null>(null);

  useEffect(() => {
    fetch(`http://localhost:8000/api/tasks/${id}`)
      .then(res => res.json())
      .then(data => {
        setTask(data);
        setFigureState(data.initial_figure_state);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, [id]);

  const handleValidate = async () => {
    if (!task || !figureState) return;

    setValidating(true);
    const steps: ProofStep[] = proof.split('\n').filter(Boolean).map((line, i) => ({
      step_id: i + 1,
      claim: line,
    }));

    const request: ValidationRequest = {
      task_id: task.id,
      task_condition: task.condition_text,
      figure_state: figureState,
      proof_history: steps,
      current_step: steps[steps.length - 1] || { step_id: 1, claim: '' },
    };

    try {
      const res = await fetch('http://localhost:8000/api/validate', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(request),
      });
      const result: ValidationResponse = await res.json();
      setValidationResult(result);
      notifications.show({
        title: result.status === 'ok' ? 'Верно' : 'Ошибка',
        message: result.reason,
        color: result.status === 'ok' ? 'green' : 'red',
      });
    } catch {
      notifications.show({ title: 'Ошибка', message: 'Не удалось связаться с сервером', color: 'red' });
    }
    setValidating(false);
  };

  if (loading) return <Loader />;
  if (!task) return <Text>Задача не найдена</Text>;

  return (
    <Grid p="md" h="100vh">
      <Grid.Col span={4}>
        <Stack h="100%">
          <Group>
            <Button variant="subtle" onClick={() => navigate('/')} size="sm">
              ← Назад к списку
            </Button>
          </Group>
          <Title order={2}><MathText>{task.title}</MathText></Title>
          <Card withBorder p="md">
            <Text><MathText>{task.condition_text}</MathText></Text>
          </Card>
          <Textarea
            label="Доказательство"
            placeholder="Введите шаги доказательства..."
            value={proof}
            onChange={e => setProof(e.currentTarget.value)}
            autosize
            minRows={10}
            style={{ flex: 1 }}
          />
          <Button onClick={handleValidate} loading={validating} fullWidth>
            Проверить
          </Button>
          {validationResult && (
            <Alert color={validationResult.status === 'ok' ? 'green' : 'red'}>
              <Text fw={500}>{validationResult.reason}</Text>
              {validationResult.hint && <Text mt="xs">Подсказка: {validationResult.hint}</Text>}
            </Alert>
          )}
        </Stack>
      </Grid.Col>
      <Grid.Col span={8}>
        <GeometryCanvas
          initialFigure={task.initial_figure_state}
          onFigureChange={setFigureState}
        />
      </Grid.Col>
    </Grid>
  );
}
