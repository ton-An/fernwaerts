'use client';

import logos from '@iconify-json/logos/icons.json';
import {
  Handle,
  MarkerType,
  Position,
  ReactFlow,
  type NodeProps,
  type Edge,
  type Node,
} from '@xyflow/react';
import type { CSSProperties, ReactNode } from 'react';

type LogoName = 'flutter' | 'postgresql' | 'supabase-icon';

function Logo({ name }: { name: LogoName }) {
  const icon = logos.icons[name];
  const width = 'width' in icon ? icon.width : logos.width;

  return (
    <svg
      aria-hidden="true"
      className="stack-node__logo"
      viewBox={`0 0 ${width} ${icon.height ?? logos.height}`}
      dangerouslySetInnerHTML={{ __html: icon.body }}
    />
  );
}

function ServiceLabel({
  icon,
  name,
  detail,
}: {
  icon?: ReactNode;
  name: string;
  detail: string;
}) {
  return (
    <div className="stack-node">
      {icon}
      <div>
        <strong>{name}</strong>
        <span>{detail}</span>
      </div>
    </div>
  );
}

type ServiceNodeData = {
  detail: string;
  icon?: ReactNode;
  name: string;
};

function ServiceNode({ data }: NodeProps<Node<ServiceNodeData>>) {
  return (
    <>
      <Handle id="write-out" type="source" position={Position.Right} style={{ top: '25%' }} />
      <Handle id="auth-out" type="source" position={Position.Right} style={{ top: '75%' }} />
      <Handle id="read-in" type="target" position={Position.Bottom} style={{ left: '50%' }} />
      <Handle id="write-in" type="target" position={Position.Left} style={{ top: '25%' }} />
      <Handle id="auth-in" type="target" position={Position.Left} style={{ top: '75%' }} />
      <Handle id="down-out" type="source" position={Position.Bottom} />
      <Handle id="up-in" type="target" position={Position.Top} />
      <Handle id="left-out" type="source" position={Position.Left} />
      <ServiceLabel icon={data.icon} name={data.name} detail={data.detail} />
    </>
  );
}

const serverStyle = {
  width: 258,
  height: 368,
} satisfies CSSProperties;

const serviceStyle = {
  width: 210,
  height: 64,
} satisfies CSSProperties;

const nodes: Node[] = [
  {
    id: 'app',
    type: 'service',
    position: { x: 10, y: 104 },
    style: { width: 210, height: 72 },
    className: 'stack-node-card stack-node-card--app',
    data: {
      icon: (
        <img
          alt=""
          className="stack-node__logo"
          src="/images/app_icon_transparent_bg.png"
        />
      ),
      name: 'Fernwaerts app',
      detail: 'Records and processes your location history',
    },
  },
  {
    id: 'server',
    type: 'group',
    position: { x: 276, y: 10 },
    style: serverStyle,
    className: 'stack-server-group',
    data: { label: 'Your self-hosted server' },
  },
  {
    id: 'supabase',
    type: 'service',
    parentId: 'server',
    extent: 'parent',
    position: { x: 24, y: 50 },
    style: serviceStyle,
    className: 'stack-node-card stack-node-card--service',
    data: {
      icon: <Logo name="supabase-icon" />,
      name: 'Supabase',
      detail: 'Receives writes and handles authentication',
    },
  },
  {
    id: 'postgres',
    type: 'service',
    parentId: 'server',
    extent: 'parent',
    position: { x: 24, y: 162 },
    style: serviceStyle,
    className: 'stack-node-card stack-node-card--database',
    data: {
      icon: <Logo name="postgresql" />,
      name: 'PostgreSQL',
      detail: 'Stores the durable server copy',
    },
  },
  {
    id: 'powersync',
    type: 'service',
    parentId: 'server',
    extent: 'parent',
    position: { x: 24, y: 274 },
    style: serviceStyle,
    className: 'stack-node-card stack-node-card--service',
    data: {
      icon: (
        <img
          alt=""
          className="stack-node__logo"
          src="/images/powersync-icon.svg"
        />
      ),
      name: 'PowerSync',
      detail: "Syncs server data into the app's local copy",
    },
  },
];

const edgeDefaults = {
  type: 'smoothstep',
  animated: true,
  className: 'stack-data-edge',
  markerEnd: { type: MarkerType.ArrowClosed },
  style: { strokeWidth: 1.5 },
} as const;

const edges: Edge[] = [
  {
    id: 'app-write',
    source: 'app',
    sourceHandle: 'write-out',
    target: 'supabase',
    targetHandle: 'write-in',
    label: 'write',
    ...edgeDefaults,
    type: 'straight',
  },
  {
    id: 'app-auth',
    source: 'app',
    sourceHandle: 'auth-out',
    target: 'supabase',
    targetHandle: 'auth-in',
    label: 'auth',
    type: 'straight',
    markerStart: { type: MarkerType.ArrowClosed },
    markerEnd: { type: MarkerType.ArrowClosed },
    style: { strokeWidth: 1.25, strokeDasharray: '3 4' },
    className: 'stack-auth-edge',
  },
  {
    id: 'supabase-postgres',
    source: 'supabase',
    sourceHandle: 'down-out',
    target: 'postgres',
    targetHandle: 'up-in',
    label: 'store',
    ...edgeDefaults,
    className: 'stack-data-edge stack-internal-edge',
    labelBgPadding: [3, 2],
  },
  {
    id: 'postgres-powersync',
    source: 'postgres',
    sourceHandle: 'down-out',
    target: 'powersync',
    targetHandle: 'up-in',
    label: 'replicate',
    ...edgeDefaults,
    className: 'stack-data-edge stack-internal-edge',
    labelBgPadding: [3, 2],
  },
  {
    id: 'powersync-app',
    source: 'powersync',
    sourceHandle: 'left-out',
    target: 'app',
    targetHandle: 'read-in',
    label: 'sync',
    ...edgeDefaults,
  },
];

const nodeTypes = { service: ServiceNode };

export function StackDiagram() {
  return (
    <figure className="stack-diagram" aria-labelledby="stack-diagram-caption">
      <div className="stack-diagram__canvas">
        <ReactFlow
          aria-label="Fernwaerts architecture diagram"
          nodes={nodes}
          edges={edges}
          nodeTypes={nodeTypes}
          fitView
          fitViewOptions={{ padding: 0.08 }}
          minZoom={0.5}
          maxZoom={1.2}
          nodesDraggable={false}
          nodesConnectable={false}
          elementsSelectable={false}
          panOnDrag={false}
          zoomOnScroll={false}
          zoomOnPinch={false}
          zoomOnDoubleClick={false}
          preventScrolling={false}
          proOptions={{ hideAttribution: true }}
        />
      </div>

      <figcaption id="stack-diagram-caption" className="stack-diagram__caption">
        Writes travel from the app through Supabase to PostgreSQL. PowerSync
        syncs the stored data back into the app's local copy. Authentication is
        handled directly between the app and Supabase.
      </figcaption>
    </figure>
  );
}
