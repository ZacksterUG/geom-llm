import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { MantineProvider } from '@mantine/core';
import { Notifications } from '@mantine/notifications';
import '@mantine/core/styles.css';
import '@mantine/notifications/styles.css';
import TaskList from './pages/TaskList';
import TaskView from './pages/TaskView';

export default function App() {
  return (
    <MantineProvider>
      <Notifications />
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<TaskList />} />
          <Route path="/task/:id" element={<TaskView />} />
        </Routes>
      </BrowserRouter>
    </MantineProvider>
  );
}
