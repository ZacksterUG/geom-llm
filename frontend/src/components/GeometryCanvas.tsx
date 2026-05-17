import { useState, useCallback, useEffect, useMemo, useRef } from 'react';
import { Canvas, useThree } from '@react-three/fiber';
import { OrbitControls, Html } from '@react-three/drei';
import * as THREE from 'three';
import type { FigureState, Vertex, Edge } from '../types';

interface Section {
  id: string;
  vertexIds: string[];
  color: string;
  visible: boolean;
}

interface HistorySnapshot {
  vertices: Vertex[];
  edges: Edge[];
  sections: Section[];
}

interface SceneContentProps {
  vertices: Vertex[];
  edges: Edge[];
  sections: Section[];
  mode: 'select' | 'point' | 'edge' | 'delete';
  selectedPoints: string[];
  setSelectedPoints: (s: string[]) => void;
  onStateChange: (vertices: Vertex[], edges: Edge[], sections: Section[]) => void;
  previewPoint: THREE.Vector3 | null;
  setPreviewPoint: (p: THREE.Vector3 | null) => void;
  hoveredEdge: string | null;
  setHoveredEdge: (e: string | null) => void;
  hoveredVertex: string | null;
  setHoveredVertex: (v: string | null) => void;
}

function buildSectionGeometry(points: THREE.Vector3[]) {
  if (points.length < 3) return null;

  const centroid = points.reduce(
    (acc, point) => acc.add(point),
    new THREE.Vector3()
  ).multiplyScalar(1 / points.length);

  let normal = new THREE.Vector3();
  for (let i = 0; i < points.length - 2; i += 1) {
    const a = new THREE.Vector3().subVectors(points[i + 1], points[i]);
    const b = new THREE.Vector3().subVectors(points[i + 2], points[i]);
    normal = new THREE.Vector3().crossVectors(a, b);
    if (normal.lengthSq() > 1e-8) break;
  }

  if (normal.lengthSq() <= 1e-8) {
    normal = new THREE.Vector3(0, 0, 1);
  } else {
    normal.normalize();
  }

  const helperAxis = Math.abs(normal.dot(new THREE.Vector3(0, 0, 1))) > 0.9
    ? new THREE.Vector3(0, 1, 0)
    : new THREE.Vector3(0, 0, 1);
  const u = new THREE.Vector3().crossVectors(helperAxis, normal).normalize();
  const v = new THREE.Vector3().crossVectors(normal, u).normalize();

  const shape = new THREE.Shape(
    points.map((point) => {
      const relative = new THREE.Vector3().subVectors(point, centroid);
      return new THREE.Vector2(relative.dot(u), relative.dot(v));
    })
  );

  const geometry = new THREE.ShapeGeometry(shape);
  const transform = new THREE.Matrix4().makeBasis(u, v, normal);
  transform.setPosition(centroid);
  geometry.applyMatrix4(transform);
  geometry.computeVertexNormals();

  return geometry;
}

function SectionMesh({ points, color }: { points: THREE.Vector3[]; color: string }) {
  const sectionGeometry = useMemo(() => buildSectionGeometry(points), [points]);

  useEffect(() => {
    return () => {
      sectionGeometry?.dispose();
    };
  }, [sectionGeometry]);

  if (!sectionGeometry) return null;

  return (
    <mesh geometry={sectionGeometry}>
      <meshBasicMaterial color={color} transparent opacity={0.3} side={THREE.DoubleSide} />
    </mesh>
  );
}

function SceneContent({
  vertices,
  edges,
  sections,
  mode,
  selectedPoints,
  setSelectedPoints,
  onStateChange,
  previewPoint,
  setPreviewPoint,
  hoveredEdge,
  setHoveredEdge,
  hoveredVertex,
  setHoveredVertex,
}: SceneContentProps) {
  const { camera, gl, scene } = useThree();
  const raycaster = useRef(new THREE.Raycaster());
  const mouse = useRef(new THREE.Vector2());
  const edgeLinesRef = useRef<THREE.Line[]>([]);

  useEffect(() => {
    edgeLinesRef.current.forEach((l) => scene.remove(l));
    edgeLinesRef.current = [];

    edges.forEach((e) => {
      const v1 = vertices.find((v) => v.id === e.from);
      const v2 = vertices.find((v) => v.id === e.to);
      if (!v1 || !v2) return;

      const geometry = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(v1.x, v1.y, v1.z),
        new THREE.Vector3(v2.x, v2.y, v2.z),
      ]);
      const material = new THREE.LineBasicMaterial({
        color: hoveredEdge === `${e.from}-${e.to}` || hoveredEdge === `${e.to}-${e.from}` ? 0xff3333 : 0xffffff,
        linewidth: hoveredEdge === `${e.from}-${e.to}` || hoveredEdge === `${e.to}-${e.from}` ? 4 : 2,
      });
      const line = new THREE.Line(geometry, material);
      line.userData = { edgeId: `${e.from}-${e.to}` };
      scene.add(line);
      edgeLinesRef.current.push(line);
    });

    return () => {
      edgeLinesRef.current.forEach((l) => scene.remove(l));
    };
  }, [edges, vertices, hoveredEdge, scene]);

  const findClosestPointOnEdge = useCallback(
    (mouseX: number, mouseY: number): { point: THREE.Vector3; edgeId: string } | null => {
      mouse.current.x = mouseX;
      mouse.current.y = mouseY;
      raycaster.current.setFromCamera(mouse.current, camera);

      const intersections = raycaster.current.intersectObjects(edgeLinesRef.current, false);
      if (intersections.length > 0) {
        const inter = intersections[0];
        const edgeId = inter.object.userData.edgeId;
        const edge = edges.find((e) => `${e.from}-${e.to}` === edgeId);
        if (!edge) return null;

        const v1 = vertices.find((v) => v.id === edge.from);
        const v2 = vertices.find((v) => v.id === edge.to);
        if (!v1 || !v2) return null;

        const A = new THREE.Vector3(v1.x, v1.y, v1.z);
        const B = new THREE.Vector3(v2.x, v2.y, v2.z);
        const P = new THREE.Vector3().copy(inter.point);

        const AB = new THREE.Vector3().subVectors(B, A);
        const AP = new THREE.Vector3().subVectors(P, A);
        const t = Math.max(0, Math.min(1, AP.dot(AB) / AB.lengthSq()));
        const closest = new THREE.Vector3().copy(A).addScaledVector(AB, t);

        return { point: closest, edgeId };
      }
      return null;
    },
    [camera, edges, vertices]
  );

  const handleSceneClick = (event: any) => {
    if (mode === 'point') {
      const rect = gl.domElement.getBoundingClientRect();
      const x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
      const y = -((event.clientY - rect.top) / rect.height) * 2 + 1;

      const result = findClosestPointOnEdge(x, y);
      if (result) {
        const { point } = result;
        const id = `V${vertices.length + 1}`;
        const newVertex: Vertex = { id, x: point.x, y: point.y, z: point.z };
        onStateChange([...vertices, newVertex], edges, sections);
        setPreviewPoint(null);
        setHoveredEdge(null);
      }
    }
  };

  const handleSceneDoubleClick = (event: any) => {
    if (mode === 'delete') {
      const rect = gl.domElement.getBoundingClientRect();
      const x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
      const y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
      mouse.current.x = x;
      mouse.current.y = y;
      raycaster.current.setFromCamera(mouse.current, camera);

      // Сначала проверяем пересечение с вершинами (sphere meshes)
      const vertexMeshes: THREE.Object3D[] = [];
      scene.traverse((obj) => {
        if (obj.userData?.isVertex) vertexMeshes.push(obj);
      });
      const vertexIntersections = raycaster.current.intersectObjects(vertexMeshes, false);
      if (vertexIntersections.length > 0) {
        const vertexId = vertexIntersections[0].object.userData.vertexId;
        const newVertices = vertices.filter((v) => v.id !== vertexId);
        const newEdges = edges.filter((e) => e.from !== vertexId && e.to !== vertexId);
        const newSections = sections.map((s) => ({
          ...s,
          vertexIds: s.vertexIds.filter((vid) => vid !== vertexId),
        }));
        onStateChange(newVertices, newEdges, newSections);
        setHoveredVertex(null);
        return;
      }

      // Если не попали в вершину — проверяем рёбра
      const edgeIntersections = raycaster.current.intersectObjects(edgeLinesRef.current, false);
      if (edgeIntersections.length > 0) {
        const edgeId = edgeIntersections[0].object.userData.edgeId;
        const newEdges = edges.filter((e) => `${e.from}-${e.to}` !== edgeId && `${e.to}-${e.from}` !== edgeId);
        onStateChange(vertices, newEdges, sections);
        setHoveredEdge(null);
      }
    }
  };

  const handleVertexClick = (id: string, event: any) => {
    event.stopPropagation();
    if (mode === 'edge') {
      if (selectedPoints.includes(id)) {
        setSelectedPoints(selectedPoints.filter((p) => p !== id));
      } else {
        setSelectedPoints([...selectedPoints, id]);
      }
    }
  };

  const handleVertexPointerOver = (id: string) => {
    if (mode === 'delete') {
      setHoveredVertex(id);
    }
  };

  const handleVertexPointerOut = () => {
    setHoveredVertex(null);
  };

  const getVertexColor = (id: string) => {
    if (selectedPoints.includes(id)) return 'orange';
    if (mode === 'delete' && hoveredVertex === id) return '#ff4444';
    return 'blue';
  };

  const handlePointerMove = useCallback(
    (event: any) => {
      if (mode !== 'point' && mode !== 'delete') return;

      const rect = gl.domElement.getBoundingClientRect();
      const x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
      const y = -((event.clientY - rect.top) / rect.height) * 2 + 1;

      const result = findClosestPointOnEdge(x, y);
      if (result) {
        if (mode === 'point') {
          setPreviewPoint(result.point);
        }
        setHoveredEdge(result.edgeId);
      } else {
        setPreviewPoint(null);
        setHoveredEdge(null);
      }
    },
    [mode, camera, edges, vertices, gl]
  );

  return (
    <>
      <ambientLight intensity={0.5} />
      <pointLight position={[10, 10, 10]} />
      <OrbitControls makeDefault enabled />

      <gridHelper args={[20, 20, '#444', '#222']} />

      {/* Render Sections (filled polygons) */}
      {sections
        .filter((s) => s.visible)
        .map((section) => {
          const points = section.vertexIds
            .map((id) => vertices.find((v) => v.id === id))
            .filter(Boolean)
            .map((v) => new THREE.Vector3(v!.x, v!.y, v!.z));

          if (points.length < 3) return null;

          return <SectionMesh key={section.id} points={points} color={section.color} />;
        })}

      {/* Render Edges (imperative lines are added to scene in useEffect) */}

      {/* Render Vertices */}
      {vertices.map((v) => (
        <mesh
          key={v.id}
          position={[v.x, v.y, v.z]}
          onClick={(e) => handleVertexClick(v.id, e)}
          onPointerOver={() => handleVertexPointerOver(v.id)}
          onPointerOut={handleVertexPointerOut}
          userData={{ isVertex: true, vertexId: v.id }}
        >
          <sphereGeometry args={[0.1, 16, 16]} />
          <meshStandardMaterial color={getVertexColor(v.id)} />
          <Html
            center
            distanceFactor={10}
            style={{
              pointerEvents: 'none',
              userSelect: 'none',
            }}
          >
            <span
              style={{
                color: 'white',
                fontSize: 12,
                fontWeight: 'bold',
                textShadow: '0 0 4px black, 0 0 4px black, 0 0 4px black',
                whiteSpace: 'nowrap',
              }}
            >
              {v.id}
            </span>
          </Html>
        </mesh>
      ))}

      {/* Preview point on edge hover */}
      {previewPoint && mode === 'point' && (
        <mesh position={[previewPoint.x, previewPoint.y, previewPoint.z]}>
          <sphereGeometry args={[0.12, 16, 16]} />
          <meshStandardMaterial color="yellow" transparent opacity={0.7} />
        </mesh>
      )}

      {/* Click handler plane */}
      <mesh
        onClick={handleSceneClick}
        onDoubleClick={handleSceneDoubleClick}
        onPointerMove={handlePointerMove}
        visible={false}
      >
        <planeGeometry args={[100, 100]} />
        <meshBasicMaterial side={THREE.DoubleSide} />
      </mesh>
    </>
  );
}

export default function GeometryCanvas({
  initialFigure,
  onFigureChange,
}: {
  initialFigure: FigureState;
  onFigureChange: (state: FigureState) => void;
}) {
  const [mode, setMode] = useState<'select' | 'point' | 'edge' | 'delete'>('select');
  const [selectedPoints, setSelectedPoints] = useState<string[]>([]);
  const [previewPoint, setPreviewPoint] = useState<THREE.Vector3 | null>(null);
  const [hoveredEdge, setHoveredEdge] = useState<string | null>(null);
  const [hoveredVertex, setHoveredVertex] = useState<string | null>(null);

  const initialSnapshot: HistorySnapshot = useMemo(
    () => ({
      vertices: initialFigure.vertices || [],
      edges: initialFigure.edges || [],
      sections: [],
    }),
    []
  );

  const [historyState, setHistoryState] = useState<{
    history: HistorySnapshot[];
    index: number;
  }>({
    history: [initialSnapshot],
    index: 0,
  });

  const current = historyState.history[historyState.index];
  const vertices = current.vertices;
  const edges = current.edges;
  const sections = current.sections;

  const onFigureChangeRef = useRef(onFigureChange);
  useEffect(() => {
    onFigureChangeRef.current = onFigureChange;
  }, [onFigureChange]);

  useEffect(() => {
    const cur = historyState.history[historyState.index];
    onFigureChangeRef.current({
      vertices: cur.vertices,
      edges: cur.edges,
      relations: [],
      actions_log: [],
    });
  }, [historyState.index]);

  useEffect(() => {
    const snapshot: HistorySnapshot = {
      vertices: initialFigure.vertices || [],
      edges: initialFigure.edges || [],
      sections: [],
    };
    setHistoryState({ history: [snapshot], index: 0 });
    setSelectedPoints([]);
    setPreviewPoint(null);
    setHoveredEdge(null);
    setHoveredVertex(null);
    setMode('select');
  }, [initialFigure]);

  const commitState = (newVertices: Vertex[], newEdges: Edge[], newSections: Section[]) => {
    setHistoryState((prev) => {
      const newHistory = prev.history.slice(0, prev.index + 1);
      newHistory.push({ vertices: newVertices, edges: newEdges, sections: newSections });
      return { history: newHistory, index: newHistory.length - 1 };
    });
  };

  const handleUndo = () => {
    setHistoryState((prev) => {
      if (prev.index > 0) {
        return { ...prev, index: prev.index - 1 };
      }
      return prev;
    });
    setSelectedPoints([]);
  };

  const handleRedo = () => {
    setHistoryState((prev) => {
      if (prev.index < prev.history.length - 1) {
        return { ...prev, index: prev.index + 1 };
      }
      return prev;
    });
    setSelectedPoints([]);
  };

  const handleReset = () => {
    commitState(initialFigure.vertices || [], initialFigure.edges || [], []);
  };

  const handleBuildEdge = () => {
    if (selectedPoints.length === 2) {
      const newEdge: Edge = { from: selectedPoints[0], to: selectedPoints[1] };
      commitState(vertices, [...edges, newEdge], sections);
      setSelectedPoints([]);
    }
  };

  const addSection = () => {
    const newSection: Section = {
      id: `S${sections.length + 1}`,
      vertexIds: [],
      color:
        ['#ff6b6b', '#4ecdc4', '#45b7d1', '#96ceb4', '#ffeaa7', '#fd79a8', '#a29bfe'][
          Math.floor(Math.random() * 7)
        ],
      visible: true,
    };
    commitState(vertices, edges, [...sections, newSection]);
  };

  const toggleSectionVisibility = (id: string) => {
    const newSections = sections.map((s) => (s.id === id ? { ...s, visible: !s.visible } : s));
    commitState(vertices, edges, newSections);
  };

  const removeSection = (id: string) => {
    commitState(vertices, edges, sections.filter((s) => s.id !== id));
  };

  const addPointToSection = (sectionId: string, pointId: string) => {
    const newSections = sections.map((s) => {
      if (s.id === sectionId) {
        if (s.vertexIds.includes(pointId)) {
          return { ...s, vertexIds: s.vertexIds.filter((id) => id !== pointId) };
        } else {
          return { ...s, vertexIds: [...s.vertexIds, pointId] };
        }
      }
      return s;
    });
    commitState(vertices, edges, newSections);
  };

  return (
    <div style={{ width: '100%', height: '100%', minHeight: 500, display: 'flex' }}>
      {/* 3D Scene */}
      <div style={{ flex: 1, position: 'relative' }}>
        {/* Toolbar */}
        <div
          style={{
            position: 'absolute',
            top: 10,
            left: 10,
            zIndex: 10,
            background: 'rgba(30,30,30,0.9)',
            padding: '8px',
            borderRadius: '8px',
            display: 'flex',
            gap: '8px',
            alignItems: 'center',
            boxShadow: '0 4px 12px rgba(0,0,0,0.5)',
            flexWrap: 'wrap',
          }}
        >
          <button
            onClick={() => {
              setMode('select');
              setSelectedPoints([]);
            }}
            style={{
              padding: '8px 12px',
              background: mode === 'select' ? '#228be6' : '#495057',
              color: 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: 'pointer',
              fontWeight: mode === 'select' ? 'bold' : 'normal',
            }}
          >
            Выделение
          </button>
          <button
            onClick={() => {
              setMode('point');
              setSelectedPoints([]);
            }}
            style={{
              padding: '8px 12px',
              background: mode === 'point' ? '#228be6' : '#495057',
              color: 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: 'pointer',
              fontWeight: mode === 'point' ? 'bold' : 'normal',
            }}
          >
            Точка на ребре
          </button>
          <button
            onClick={() => {
              setMode('edge');
              setSelectedPoints([]);
            }}
            style={{
              padding: '8px 12px',
              background: mode === 'edge' ? '#228be6' : '#495057',
              color: 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: 'pointer',
              fontWeight: mode === 'edge' ? 'bold' : 'normal',
            }}
          >
            Отрезок
          </button>
          <button
            onClick={() => {
              setMode('delete');
              setSelectedPoints([]);
            }}
            style={{
              padding: '8px 12px',
              background: mode === 'delete' ? '#dc3545' : '#495057',
              color: 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: 'pointer',
              fontWeight: mode === 'delete' ? 'bold' : 'normal',
            }}
          >
            Удаление
          </button>

          <div style={{ width: 1, height: 24, background: '#555', margin: '0 4px' }} />

          <button
            onClick={handleUndo}
            disabled={historyState.index === 0}
            title="Отменить"
            style={{
              padding: '8px 12px',
              background: historyState.index === 0 ? '#333' : '#495057',
              color: historyState.index === 0 ? '#888' : 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: historyState.index === 0 ? 'not-allowed' : 'pointer',
            }}
          >
            ↩ Отмена
          </button>
          <button
            onClick={handleRedo}
            disabled={historyState.index === historyState.history.length - 1}
            title="Повторить"
            style={{
              padding: '8px 12px',
              background: historyState.index === historyState.history.length - 1 ? '#333' : '#495057',
              color: historyState.index === historyState.history.length - 1 ? '#888' : 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: historyState.index === historyState.history.length - 1 ? 'not-allowed' : 'pointer',
            }}
          >
            ↪ Повтор
          </button>
          <button
            onClick={handleReset}
            title="Сбросить до начального состояния"
            style={{
              padding: '8px 12px',
              background: '#c92a2a',
              color: 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: 'pointer',
            }}
          >
            ⟲ Сброс
          </button>

          {mode === 'edge' && selectedPoints.length === 2 && (
            <button
              onClick={handleBuildEdge}
              style={{
                padding: '8px 12px',
                background: '#2f9e44',
                color: 'white',
                border: 'none',
                borderRadius: '4px',
                cursor: 'pointer',
                fontWeight: 'bold',
              }}
            >
              Построить отрезок
            </button>
          )}

          <div style={{ color: 'white', fontSize: 12, marginLeft: 8 }}>
            {mode === 'select' && 'Вращение камеры'}
            {mode === 'point' && 'Наведи на ребро и кликни для точки'}
            {mode === 'edge' && 'Кликни по двум точкам'}
            {mode === 'delete' && 'Двойной клик по точке или ребру'}
          </div>
        </div>

        <Canvas camera={{ position: [5, 5, 5], fov: 60 }} style={{ background: '#1a1a1a' }}>
          <SceneContent
            vertices={vertices}
            edges={edges}
            sections={sections}
            mode={mode}
            selectedPoints={selectedPoints}
            setSelectedPoints={setSelectedPoints}
            onStateChange={commitState}
            previewPoint={previewPoint}
            setPreviewPoint={setPreviewPoint}
            hoveredEdge={hoveredEdge}
            setHoveredEdge={setHoveredEdge}
            hoveredVertex={hoveredVertex}
            setHoveredVertex={setHoveredVertex}
          />
        </Canvas>
      </div>

      {/* Sections Panel */}
      <div
        style={{
          width: 250,
          background: 'rgba(30,30,30,0.95)',
          padding: '12px',
          overflowY: 'auto',
          borderLeft: '1px solid #444',
        }}
      >
        <div
          style={{
            display: 'flex',
            justifyContent: 'space-between',
            alignItems: 'center',
            marginBottom: 12,
          }}
        >
          <span style={{ color: 'white', fontWeight: 'bold' }}>Сечения</span>
          <button
            onClick={addSection}
            style={{
              padding: '6px 12px',
              background: '#228be6',
              color: 'white',
              border: 'none',
              borderRadius: '4px',
              cursor: 'pointer',
              fontSize: 12,
            }}
          >
            + Добавить
          </button>
        </div>

        {sections.map((section) => (
          <div
            key={section.id}
            style={{
              background: 'rgba(255,255,255,0.05)',
              padding: '8px',
              borderRadius: '6px',
              marginBottom: '8px',
            }}
          >
            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
              }}
            >
              <span style={{ color: section.color, fontWeight: 'bold', fontSize: 12 }}>
                {section.id}
              </span>
              <button
                onClick={() => removeSection(section.id)}
                style={{
                  background: 'transparent',
                  border: 'none',
                  color: '#ff6b6b',
                  cursor: 'pointer',
                  fontSize: 12,
                }}
              >
                ✕
              </button>
            </div>
            <label
              style={{
                color: 'white',
                fontSize: 12,
                display: 'flex',
                alignItems: 'center',
                marginTop: 4,
              }}
            >
              <input
                type="checkbox"
                checked={section.visible}
                onChange={() => toggleSectionVisibility(section.id)}
                style={{ marginRight: 6 }}
              />
              Показать заполнение
            </label>
            <div style={{ marginTop: 6 }}>
              <span style={{ color: '#aaa', fontSize: 11 }}>Точки: </span>
              {vertices.map((v) => (
                <button
                  key={v.id}
                  onClick={() => addPointToSection(section.id, v.id)}
                  style={{
                    padding: '2px 6px',
                    margin: '2px',
                    background: section.vertexIds.includes(v.id) ? section.color : '#555',
                    color: 'white',
                    border: 'none',
                    borderRadius: '3px',
                    cursor: 'pointer',
                    fontSize: 10,
                  }}
                >
                  {v.id}
                </button>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
