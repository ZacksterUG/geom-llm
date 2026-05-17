import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Title, Card, Text, Button, Stack, Group, Loader } from '@mantine/core';
import type { Task } from '../types';

export default function TaskList() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    fetch('http://localhost:8000/api/tasks')
      .then(res => res.json())
      .then(data => {
        setTasks(data);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  if (loading) return <Loader />;

  return (
    <Stack p="md" maw={800} mx="auto">
      <Title order={1}>Задачи по стереометрии</Title>
      <Stack gap="sm">
        {tasks.map(task => (
          <Card key={task.id} shadow="sm" p="md" radius="md" withBorder>
            <Group justify="space-between">
              <div>
                <Text fw={500} size="lg">{task.title}</Text>
                <Text c="dimmed" lineClamp={2}>{task.condition_text}</Text>
                <Text size="sm" c="blue">{task.difficulty_level}</Text>
              </div>
              <Button onClick={() => navigate(`/task/${task.id}`)}>
                Открыть
              </Button>
            </Group>
          </Card>
        ))}
      </Stack>
    </Stack>
  );
}
