import { useEffect, useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Title, Card, Text, Button, Stack, Group, Loader,
  TextInput, Select, MultiSelect, Pagination, Flex, Badge, ActionIcon
} from '@mantine/core';
import { useDebouncedValue } from '@mantine/hooks';
import type { Task, PaginatedTasks, PolyhedronType } from '../types';
import MathText from '../components/MathText';

const PAGE_SIZE = 10;

export default function TaskList() {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [loading, setLoading] = useState(true);
  const [total, setTotal] = useState(0);
  const [totalPages, setTotalPages] = useState(1);
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState('');
  const [debouncedSearch] = useDebouncedValue(search, 400);
  const [polyhedronTypes, setPolyhedronTypes] = useState<PolyhedronType[]>([]);
  const [selectedTypes, setSelectedTypes] = useState<string[]>([]);
  const [sortBy, setSortBy] = useState<string>('created_at');
  const [sortOrder, setSortOrder] = useState<string>('desc');
  const navigate = useNavigate();

  const filtersRef = useRef({ debouncedSearch: '', selectedTypes: '', sortBy: 'created_at', sortOrder: 'desc' });

  useEffect(() => {
    const filterKey = `${debouncedSearch}|${selectedTypes.join(',')}|${sortBy}|${sortOrder}`;
    const prevKey = `${filtersRef.current.debouncedSearch}|${filtersRef.current.selectedTypes}|${filtersRef.current.sortBy}|${filtersRef.current.sortOrder}`;
    filtersRef.current = { debouncedSearch, selectedTypes: selectedTypes.join(','), sortBy, sortOrder };
    if (filterKey !== prevKey) {
      setPage(1);
    }
  }, [debouncedSearch, selectedTypes, sortBy, sortOrder]);

  useEffect(() => {
    setLoading(true);
    const params = new URLSearchParams();
    params.set('page', String(page));
    params.set('page_size', String(PAGE_SIZE));
    params.set('sort_by', sortBy);
    params.set('sort_order', sortOrder);
    if (debouncedSearch) params.set('search', debouncedSearch);
    if (selectedTypes.length > 0) params.set('polyhedron_type_ids', selectedTypes.join(','));

    fetch(`http://localhost:8000/api/tasks?${params}`)
      .then(res => res.json())
      .then((data: PaginatedTasks) => {
        setTasks(data.items);
        setTotal(data.total);
        setTotalPages(data.total_pages);
        setLoading(false);
      })
      .catch(() => {
        setTasks([]);
        setLoading(false);
      });
  }, [page, debouncedSearch, selectedTypes, sortBy, sortOrder]);

  useEffect(() => {
    fetch('http://localhost:8000/api/polyhedron-types')
      .then(res => res.json())
      .then((data: PolyhedronType[]) => setPolyhedronTypes(data))
      .catch(() => {});
  }, []);

  const toggleSortOrder = () => {
    setSortOrder(prev => prev === 'asc' ? 'desc' : 'asc');
  };

  return (
    <Stack p="md" maw={900} mx="auto">
      <Title order={1}>Задачи по стереометрии</Title>

      <Card shadow="sm" p="md" radius="md" withBorder>
        <Stack gap="sm">
          <TextInput
            placeholder="Поиск по тексту задачи..."
            value={search}
            onChange={e => setSearch(e.currentTarget.value)}
          />
          <Group grow>
            <MultiSelect
              placeholder="Тип многогранника"
              data={polyhedronTypes.map(pt => ({ value: String(pt.id), label: pt.name }))}
              value={selectedTypes}
              onChange={setSelectedTypes}
              clearable
            />
          </Group>
          <Group justify="space-between">
            <Group gap="xs">
              <Text size="sm" c="dimmed">Сортировать:</Text>
              <Select
                size="sm"
                data={[
                  { value: 'created_at', label: 'По дате создания' },
                  { value: 'title', label: 'По названию' },
                ]}
                value={sortBy}
                onChange={v => v && setSortBy(v)}
                w={180}
              />
              <ActionIcon variant="subtle" onClick={toggleSortOrder} size="lg">
                {sortOrder === 'asc' ? '↑' : '↓'}
              </ActionIcon>
            </Group>
            <Text size="sm" c="dimmed">Найдено: {total}</Text>
          </Group>
        </Stack>
      </Card>

      {loading ? (
        <Flex justify="center" py="xl"><Loader /></Flex>
      ) : tasks.length === 0 ? (
        <Text ta="center" py="xl" c="dimmed">Задачи не найдены</Text>
      ) : (
        <>
          <Stack gap="sm">
            {tasks.map(task => (
              <Card key={task.id} shadow="sm" p="md" radius="md" withBorder>
                <Group justify="space-between" align="flex-start">
                  <div style={{ flex: 1 }}>
                    <Text fw={500} size="lg"><MathText>{task.title}</MathText></Text>
                    <Text c="dimmed" lineClamp={2}><MathText>{task.condition_text}</MathText></Text>
                    <Group gap="xs" mt="xs">
                      {task.polyhedron_types?.map(pt => (
                        <Badge key={pt.id} color="teal" variant="light" size="sm">{pt.name}</Badge>
                      ))}
                    </Group>
                  </div>
                  <Button onClick={() => navigate(`/task/${task.id}`)} ml="md">
                    Открыть
                  </Button>
                </Group>
              </Card>
            ))}
          </Stack>

          {totalPages > 1 && (
            <Flex justify="center" mt="md">
              <Pagination total={totalPages} value={page} onChange={setPage} />
            </Flex>
          )}
        </>
      )}
    </Stack>
  );
}
