export interface Vertex {
  id: string;
  x: number;
  y: number;
  z: number;
}

export interface Edge {
  from: string;
  to: string;
  relation?: string;
}

export interface FigureState {
  vertices: Vertex[];
  edges: Edge[];
  relations: string[];
  actions_log: string[];
}

export interface ProofStep {
  step_id: number;
  claim: string;
  justification_id?: string;
  comment?: string;
}

export interface PolyhedronType {
  id: number;
  name: string;
  display_order: number;
}

export interface Task {
  id: string;
  title: string;
  condition_text: string;
  initial_figure_state: FigureState;
  reference_figure_state?: FigureState;
  reference_proof?: ProofStep[];
  difficulty_level: string;
  polyhedron_types?: PolyhedronType[];
}

export interface PaginatedTasks {
  items: Task[];
  total: number;
  page: number;
  page_size: number;
  total_pages: number;
}

export interface TaskFilters {
  search?: string;
  polyhedron_type_ids?: string;
  difficulty_level?: string;
  sort_by: string;
  sort_order: string;
  page: number;
  page_size: number;
}

export interface ValidationRequest {
  task_id: string;
  task_condition: string;
  figure_state: FigureState;
  proof_history: ProofStep[];
  current_step: ProofStep;
}

export interface ValidationResponse {
  status: 'ok' | 'warning' | 'error';
  geometry_valid: boolean;
  logic_valid: boolean;
  reason: string;
  hint: string;
  referenced_theorem?: string;
  next_allowed_actions: string[];
}
