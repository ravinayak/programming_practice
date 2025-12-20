# Edmonds-Karp Algorithm for Maximum Flow

## Overview

The **Edmonds-Karp algorithm** is an implementation of the Ford-Fulkerson method for computing the maximum flow in a flow network. It uses **BFS (Breadth-First Search)** to find augmenting paths, which guarantees that the algorithm terminates in polynomial time.

**Key Properties:**

- **Time Complexity**: O(V × E²) where V is the number of vertices and E is the number of edges
- **Space Complexity**: O(V + E) for the graph representation
- Uses BFS to find the shortest augmenting path (in terms of number of edges)
- Guarantees termination (unlike DFS-based Ford-Fulkerson which can be exponential)

---

## Algorithm Steps

1. **Initialize**: Set all flows to 0
2. **While augmenting path exists**:
   - Use BFS to find a path from source to sink with available capacity
   - Find the minimum residual capacity along the path (bottleneck)
   - Update the flow along the path by adding the bottleneck value
   - Update residual capacities (forward edges decrease, backward edges increase)
3. **Return**: The maximum flow value

---

## Python Implementation

```python
from collections import deque, defaultdict
from typing import Dict, List, Tuple, Optional


def edmonds_karp(graph: Dict[int, Dict[int, int]], source: int, sink: int) -> int:
    """
    Find the maximum flow from source to sink using Edmonds-Karp algorithm.

    Args:
        graph: Adjacency list representation of the flow network.
               graph[u][v] = capacity of edge from u to v
        source: Source vertex
        sink: Sink (target) vertex

    Returns:
        Maximum flow value from source to sink

    Example:
        graph = {
            0: {1: 10, 2: 10},
            1: {2: 2, 3: 4, 4: 8},
            2: {4: 9},
            3: {5: 10},
            4: {3: 6, 5: 10},
            5: {}
        }
        max_flow = edmonds_karp(graph, 0, 5)  # Returns 19
    """
    # Create residual graph (initially same as original graph)
    residual = defaultdict(dict)
    for u in graph:
        for v, capacity in graph[u].items():
            residual[u][v] = capacity
            # Initialize reverse edge with 0 capacity
            if v not in residual:
                residual[v] = {}
            residual[v][u] = residual[v].get(u, 0)

    max_flow = 0

    # Keep finding augmenting paths using BFS
    while True:
        # BFS to find augmenting path
        parent = {}
        queue = deque([source])
        parent[source] = None
        found_path = False

        while queue:
            u = queue.popleft()

            # Explore all neighbors with available capacity
            for v in residual[u]:
                # Check if edge has capacity and vertex not visited
                if v not in parent and residual[u][v] > 0:
                    parent[v] = u
                    queue.append(v)

                    # If we reached sink, we found an augmenting path
                    if v == sink:
                        found_path = True
                        break

            if found_path:
                break

        # If no augmenting path found, we're done
        if not found_path:
            break

        # Find the bottleneck (minimum residual capacity along path)
        path_flow = float('inf')
        v = sink

        # Trace back from sink to source to find minimum capacity
        while v != source:
            u = parent[v]
            path_flow = min(path_flow, residual[u][v])
            v = u

        # Update residual capacities along the path
        v = sink
        while v != source:
            u = parent[v]
            # Decrease forward edge capacity
            residual[u][v] -= path_flow
            # Increase backward edge capacity (for reverse flow)
            residual[v][u] += path_flow
            v = u

        # Add path flow to total flow
        max_flow += path_flow

    return max_flow


def edmonds_karp_with_paths(
    graph: Dict[int, Dict[int, int]],
    source: int,
    sink: int
) -> Tuple[int, List[List[int]]]:
    """
    Find maximum flow and return the augmenting paths used.

    Returns:
        Tuple of (max_flow, list of paths with their flows)
    """
    residual = defaultdict(dict)
    for u in graph:
        for v, capacity in graph[u].items():
            residual[u][v] = capacity
            if v not in residual:
                residual[v] = {}
            residual[v][u] = residual[v].get(u, 0)

    max_flow = 0
    paths = []

    while True:
        parent = {}
        queue = deque([source])
        parent[source] = None
        found_path = False

        while queue:
            u = queue.popleft()

            for v in residual[u]:
                if v not in parent and residual[u][v] > 0:
                    parent[v] = u
                    queue.append(v)

                    if v == sink:
                        found_path = True
                        break

            if found_path:
                break

        if not found_path:
            break

        # Find path and bottleneck
        path_flow = float('inf')
        path = []
        v = sink

        while v != source:
            u = parent[v]
            path_flow = min(path_flow, residual[u][v])
            path.append(v)
            v = u

        path.append(source)
        path.reverse()

        # Update residual graph
        v = sink
        while v != source:
            u = parent[v]
            residual[u][v] -= path_flow
            residual[v][u] += path_flow
            v = u

        max_flow += path_flow
        paths.append((path, path_flow))

    return max_flow, paths


def build_graph_from_edges(edges: List[Tuple[int, int, int]]) -> Dict[int, Dict[int, int]]:
    """
    Build a graph from a list of edges.

    Args:
        edges: List of (from, to, capacity) tuples

    Returns:
        Graph as adjacency list
    """
    graph = defaultdict(dict)
    for u, v, capacity in edges:
        graph[u][v] = capacity
    return graph


# Example usage and test cases
if __name__ == "__main__":
    # Example 1: Simple network
    print("Example 1: Simple Network")
    graph1 = {
        0: {1: 10, 2: 10},
        1: {2: 2, 3: 4, 4: 8},
        2: {4: 9},
        3: {5: 10},
        4: {3: 6, 5: 10},
        5: {}
    }

    max_flow1 = edmonds_karp(graph1, 0, 5)
    print(f"Maximum flow: {max_flow1}")
    print()

    # Example 2: Get paths
    print("Example 2: With Paths")
    max_flow2, paths = edmonds_karp_with_paths(graph1, 0, 5)
    print(f"Maximum flow: {max_flow2}")
    print("Augmenting paths:")
    for path, flow in paths:
        print(f"  Path: {' -> '.join(map(str, path))}, Flow: {flow}")
    print()

    # Example 3: Classic example
    print("Example 3: Classic Flow Network")
    edges = [
        (0, 1, 16),  # s -> v1
        (0, 2, 13),  # s -> v2
        (1, 2, 10),  # v1 -> v2
        (1, 3, 12),  # v1 -> v3
        (2, 1, 4),   # v2 -> v1
        (2, 4, 14),  # v2 -> v4
        (3, 2, 9),   # v3 -> v2
        (3, 5, 20),  # v3 -> t
        (4, 3, 7),   # v4 -> v3
        (4, 5, 4),   # v4 -> t
    ]
    graph3 = build_graph_from_edges(edges)
    max_flow3 = edmonds_karp(graph3, 0, 5)
    print(f"Maximum flow: {max_flow3}")
    print()

    # Example 4: Bipartite matching (can be solved as max flow)
    print("Example 4: Bipartite Matching as Max Flow")
    # Add source connected to left partition
    # Add sink connected to right partition
    # All edges have capacity 1
    bipartite_edges = [
        (0, 1, 1), (0, 2, 1), (0, 3, 1),  # source to left
        (1, 4, 1), (1, 5, 1),             # left to right
        (2, 4, 1), (2, 6, 1),
        (3, 5, 1), (3, 6, 1),
        (4, 7, 1), (5, 7, 1), (6, 7, 1),  # right to sink
    ]
    graph4 = build_graph_from_edges(bipartite_edges)
    max_flow4 = edmonds_karp(graph4, 0, 7)
    print(f"Maximum matching size: {max_flow4}")
```

---

## Detailed Dry Run: Example 1

Let's trace through the algorithm step-by-step for `graph1`:

### Input Graph

```
Source: 0, Sink: 5

Graph Structure:
    0 --10--> 1 --2--> 2
    |         |         |
    10        4         9
    |         |         |
    2 --9--> 4 <--6--- 3 --10--> 5
    |         |                  |
    10        8                  10
    |         |                  |
    4 --10--> 5 <---------------+
```

**Adjacency List:**

```
0: {1: 10, 2: 10}
1: {2: 2, 3: 4, 4: 8}
2: {4: 9}
3: {5: 10}
4: {3: 6, 5: 10}
5: {}
```

### Initial State

**Residual Graph (initially same as original):**

```
residual[0][1] = 10, residual[1][0] = 0
residual[0][2] = 10, residual[2][0] = 0
residual[1][2] = 2,  residual[2][1] = 0
residual[1][3] = 4,  residual[3][1] = 0
residual[1][4] = 8,  residual[4][1] = 0
residual[2][4] = 9,  residual[4][2] = 0
residual[3][5] = 10, residual[5][3] = 0
residual[4][3] = 6,  residual[3][4] = 0
residual[4][5] = 10, residual[5][4] = 0
```

**Max Flow:** 0

---

### Iteration 1: Finding First Augmenting Path

**BFS from source (0):**

```
Queue: [0]
parent = {0: None}

Step 1: Process 0
  - Check neighbors: 1, 2
  - residual[0][1] = 10 > 0 → Discover 1
    parent[1] = 0
    Queue: [1]
  - residual[0][2] = 10 > 0 → Discover 2
    parent[2] = 0
    Queue: [1, 2]
  parent = {0: None, 1: 0, 2: 0}

Step 2: Process 1
  - Check neighbors: 0, 2, 3, 4
  - 0 in parent → skip
  - residual[1][2] = 2 > 0 → Discover 2 (already discovered, skip)
  - residual[1][3] = 4 > 0 → Discover 3
    parent[3] = 1
    Queue: [2, 3]
  - residual[1][4] = 8 > 0 → Discover 4
    parent[4] = 1
    Queue: [2, 3, 4]
  parent = {0: None, 1: 0, 2: 0, 3: 1, 4: 1}

Step 3: Process 2
  - Check neighbors: 0, 1, 4
  - 0, 1 in parent → skip
  - residual[2][4] = 9 > 0 → Discover 4 (already discovered, skip)
  Queue: [3, 4]

Step 4: Process 3
  - Check neighbors: 1, 4, 5
  - 1, 4 in parent → skip
  - residual[3][5] = 10 > 0 → Discover 5 (SINK FOUND!)
    parent[5] = 3
    found_path = True
```

**Path Found:** 0 → 1 → 3 → 5

**Reconstruct path and find bottleneck:**

```
v = 5
path_flow = ∞

v = 5, u = parent[5] = 3
  residual[3][5] = 10
  path_flow = min(∞, 10) = 10
  v = 3

v = 3, u = parent[3] = 1
  residual[1][3] = 4
  path_flow = min(10, 4) = 4
  v = 1

v = 1, u = parent[1] = 0
  residual[0][1] = 10
  path_flow = min(4, 10) = 4
  v = 0 (source reached)
```

**Bottleneck:** 4

**Update Residual Graph:**

```
Forward edges (decrease capacity):
  residual[0][1] = 10 - 4 = 6
  residual[1][3] = 4 - 4 = 0
  residual[3][5] = 10 - 4 = 6

Backward edges (increase capacity):
  residual[1][0] = 0 + 4 = 4
  residual[3][1] = 0 + 4 = 4
  residual[5][3] = 0 + 4 = 4
```

**Max Flow:** 0 + 4 = 4

---

### Iteration 2: Finding Second Augmenting Path

**BFS from source (0):**

```
Queue: [0]
parent = {0: None}

Step 1: Process 0
  - residual[0][1] = 6 > 0 → Discover 1
    parent[1] = 0
  - residual[0][2] = 10 > 0 → Discover 2
    parent[2] = 0
  Queue: [1, 2]
  parent = {0: None, 1: 0, 2: 0}

Step 2: Process 1
  - residual[1][2] = 2 > 0 → Discover 2 (already discovered, skip)
  - residual[1][3] = 0 → Skip (no capacity)
  - residual[1][4] = 8 > 0 → Discover 4
    parent[4] = 1
    Queue: [2, 4]
  parent = {0: None, 1: 0, 2: 0, 4: 1}

Step 3: Process 2
  - residual[2][4] = 9 > 0 → Discover 4 (already discovered, skip)
  Queue: [4]

Step 4: Process 4
  - Check neighbors: 1, 2, 3, 5
  - 1, 2 in parent → skip
  - residual[4][3] = 6 > 0 → Discover 3
    parent[3] = 4
    Queue: [3]
  - residual[4][5] = 10 > 0 → Discover 5 (SINK FOUND!)
    parent[5] = 4
    found_path = True
```

**Path Found:** 0 → 1 → 4 → 5

**Find bottleneck:**

```
v = 5, u = 4: residual[4][5] = 10 → path_flow = 10
v = 4, u = 1: residual[1][4] = 8  → path_flow = min(10, 8) = 8
v = 1, u = 0: residual[0][1] = 6  → path_flow = min(8, 6) = 6
```

**Bottleneck:** 6

**Update Residual Graph:**

```
Forward edges:
  residual[0][1] = 6 - 6 = 0
  residual[1][4] = 8 - 6 = 2
  residual[4][5] = 10 - 6 = 4

Backward edges:
  residual[1][0] = 4 + 6 = 10
  residual[4][1] = 0 + 6 = 6
  residual[5][4] = 0 + 6 = 6
```

**Max Flow:** 4 + 6 = 10

---

### Iteration 3: Finding Third Augmenting Path

**BFS from source (0):**

```
Queue: [0]
parent = {0: None}

Step 1: Process 0
  - residual[0][1] = 0 → Skip (no capacity)
  - residual[0][2] = 10 > 0 → Discover 2
    parent[2] = 0
    Queue: [2]
  parent = {0: None, 2: 0}

Step 2: Process 2
  - Check neighbors: 0, 1, 4
  - 0 in parent → skip
  - residual[2][1] = 0 → Skip (backward edge, but no flow yet)
  - residual[2][4] = 9 > 0 → Discover 4
    parent[4] = 2
    Queue: [4]
  parent = {0: None, 2: 0, 4: 2}

Step 3: Process 4
  - Check neighbors: 1, 2, 3, 5
  - 2 in parent → skip
  - residual[4][1] = 6 > 0 → Discover 1 (backward edge!)
    parent[1] = 4
    Queue: [1]
  - residual[4][3] = 6 > 0 → Discover 3
    parent[3] = 4
    Queue: [1, 3]
  - residual[4][5] = 4 > 0 → Discover 5 (SINK FOUND!)
    parent[5] = 4
    found_path = True
```

**Path Found:** 0 → 2 → 4 → 5

**Find bottleneck:**

```
v = 5, u = 4: residual[4][5] = 4  → path_flow = 4
v = 4, u = 2: residual[2][4] = 9  → path_flow = min(4, 9) = 4
v = 2, u = 0: residual[0][2] = 10 → path_flow = min(4, 10) = 4
```

**Bottleneck:** 4

**Update Residual Graph:**

```
Forward edges:
  residual[0][2] = 10 - 4 = 6
  residual[2][4] = 9 - 4 = 5
  residual[4][5] = 4 - 4 = 0

Backward edges:
  residual[2][0] = 0 + 4 = 4
  residual[4][2] = 0 + 4 = 4
  residual[5][4] = 6 + 4 = 10
```

**Max Flow:** 10 + 4 = 14

---

### Iteration 4: Finding Fourth Augmenting Path

**BFS from source (0):**

```
Queue: [0]
parent = {0: None}

Step 1: Process 0
  - residual[0][1] = 0 → Skip
  - residual[0][2] = 6 > 0 → Discover 2
    parent[2] = 0
    Queue: [2]
  parent = {0: None, 2: 0}

Step 2: Process 2
  - residual[2][4] = 5 > 0 → Discover 4
    parent[4] = 2
    Queue: [4]
  parent = {0: None, 2: 0, 4: 2}

Step 3: Process 4
  - residual[4][1] = 6 > 0 → Discover 1
    parent[1] = 4
    Queue: [1]
  - residual[4][3] = 6 > 0 → Discover 3
    parent[3] = 4
    Queue: [1, 3]
  - residual[4][5] = 0 → Skip
  parent = {0: None, 2: 0, 4: 2, 1: 4, 3: 4}

Step 4: Process 1
  - Check neighbors: 0, 2, 3, 4
  - 0, 2, 4 in parent → skip
  - residual[1][3] = 0 → Skip
  Queue: [3]

Step 5: Process 3
  - Check neighbors: 1, 4, 5
  - 1, 4 in parent → skip
  - residual[3][5] = 6 > 0 → Discover 5 (SINK FOUND!)
    parent[5] = 3
    found_path = True
```

**Path Found:** 0 → 2 → 4 → 3 → 5

**Find bottleneck:**

```
v = 5, u = 3: residual[3][5] = 6  → path_flow = 6
v = 3, u = 4: residual[4][3] = 6  → path_flow = min(6, 6) = 6
v = 4, u = 2: residual[2][4] = 5  → path_flow = min(6, 5) = 5
v = 2, u = 0: residual[0][2] = 6  → path_flow = min(5, 6) = 5
```

**Bottleneck:** 5

**Update Residual Graph:**

```
Forward edges:
  residual[0][2] = 6 - 5 = 1
  residual[2][4] = 5 - 5 = 0
  residual[4][3] = 6 - 5 = 1
  residual[3][5] = 6 - 5 = 1

Backward edges:
  residual[2][0] = 4 + 5 = 9
  residual[4][2] = 4 + 5 = 9
  residual[3][4] = 0 + 5 = 5
  residual[5][3] = 4 + 5 = 9
```

**Max Flow:** 14 + 5 = 19

---

### Iteration 5: No More Augmenting Paths

**BFS from source (0):**

```
Queue: [0]
parent = {0: None}

Step 1: Process 0
  - residual[0][1] = 0 → Skip
  - residual[0][2] = 1 > 0 → Discover 2
    parent[2] = 0
    Queue: [2]
  parent = {0: None, 2: 0}

Step 2: Process 2
  - Check neighbors: 0, 1, 4
  - 0 in parent → skip
  - residual[2][1] = 0 → Skip
  - residual[2][4] = 0 → Skip
  Queue: [] (empty)

No path to sink found!
```

**No augmenting path exists** → Algorithm terminates.

---

### Final Result

**Maximum Flow:** 19

**Summary of Augmenting Paths:**

1. Path: 0 → 1 → 3 → 5, Flow: 4
2. Path: 0 → 1 → 4 → 5, Flow: 6
3. Path: 0 → 2 → 4 → 5, Flow: 4
4. Path: 0 → 2 → 4 → 3 → 5, Flow: 5

**Total:** 4 + 6 + 4 + 5 = 19

**Final Residual Graph (showing only edges with capacity > 0):**

```
Forward edges:
  residual[0][2] = 1
  residual[1][2] = 2
  residual[1][4] = 2
  residual[3][5] = 1
  residual[4][3] = 1

Backward edges (showing flow):
  residual[1][0] = 10  (flow: 10 from 0→1)
  residual[2][0] = 9   (flow: 9 from 0→2)
  residual[3][1] = 4   (flow: 4 from 1→3)
  residual[4][1] = 6   (flow: 6 from 1→4)
  residual[4][2] = 9   (flow: 9 from 2→4)
  residual[3][4] = 5   (flow: 5 from 4→3)
  residual[5][3] = 9   (flow: 9 from 3→5)
  residual[5][4] = 10  (flow: 10 from 4→5)
```

**Key Observations:**

- The algorithm found 4 augmenting paths
- Path 3 used a backward edge (4→1) to redirect flow
- Path 4 used backward edge (4→3) to find an alternative route
- The final flow of 19 is the maximum possible flow from source 0 to sink 5

---

## How It Works

### Key Concepts

1. **Residual Graph**:

   - Forward edges: Remaining capacity (original capacity - current flow)
   - Backward edges: Current flow (allows "undoing" flow)

2. **Augmenting Path**:

   - A path from source to sink with available capacity
   - Found using BFS (shortest path in terms of edges)

3. **Bottleneck**:

   - Minimum capacity along the augmenting path
   - This is the amount of flow we can push through the path

4. **Residual Capacity Update**:
   - Forward edge: `residual[u][v] -= flow`
   - Backward edge: `residual[v][u] += flow`

### The Parent Hash Concept

The `parent` dictionary serves **three critical purposes** in the algorithm:

#### 1. **Visited Tracking**

```python
if v not in parent and residual[u][v] > 0:
    parent[v] = u
```

- Acts as a **visited set**: If a vertex is in `parent`, it has been discovered
- Prevents revisiting vertices during BFS
- More efficient than maintaining a separate `visited` set

#### 2. **Path Reconstruction**

```python
# Trace back from sink to source
while v != source:
    u = parent[v]  # Get the vertex that discovered v
    path_flow = min(path_flow, residual[u][v])
    v = u  # Move to parent
```

- Stores the **predecessor** of each vertex in the BFS tree
- Allows us to **trace back** from sink to source
- Reconstructs the entire augmenting path without storing it explicitly

#### 3. **BFS Tree Structure**

- `parent[source] = None` marks the root
- Each vertex points to its parent in the BFS tree
- Creates a tree structure from source to all reachable vertices

#### Visual Example

Consider finding a path from source (0) to sink (5):

```
Graph:
    0 --10--> 1 --8--> 5
    |         |
    10        4
    |         |
    2 --9--> 3
```

**BFS Exploration:**

```
Queue: [0]
parent = {0: None}

Step 1: Process 0
  - Discover 1: parent[1] = 0
  - Discover 2: parent[2] = 0
  Queue: [1, 2]
  parent = {0: None, 1: 0, 2: 0}

Step 2: Process 1
  - Discover 5: parent[5] = 1  ← Found sink!
  Queue: [2, 5]
  parent = {0: None, 1: 0, 2: 0, 5: 1}
```

**Path Reconstruction:**

```python
v = 5  # Start at sink
path = []

while v != 0:  # Until we reach source
    u = parent[v]  # Get parent
    # u = parent[5] = 1
    # u = parent[1] = 0
    v = u

# Path: 0 -> 1 -> 5
```

**Final parent state:**

```
parent = {
    0: None,  # Source (root)
    1: 0,     # Discovered from 0
    2: 0,     # Discovered from 0
    5: 1      # Discovered from 1
}
```

#### Why Not Store the Full Path?

1. **Memory Efficiency**: Only store one value per vertex (O(V)) instead of full paths
2. **Simplicity**: Easy to reconstruct path when needed
3. **Standard BFS Pattern**: This is the standard way to track paths in BFS

#### Code Flow with Parent

```python
# 1. Initialize parent for source
parent = {source: None}

# 2. During BFS: Mark vertices as visited and record parent
for v in residual[u]:
    if v not in parent:  # Not visited yet
        parent[v] = u    # Record who discovered v
        queue.append(v)

# 3. After finding sink: Reconstruct path backwards
v = sink
while v != source:
    u = parent[v]        # Get parent
    # Process edge (u, v)
    v = u                # Move to parent
```

### Why BFS?

- **Guarantees shortest path**: BFS finds the path with minimum number of edges
- **Polynomial time**: O(V × E²) worst case
- **Termination**: Unlike DFS, BFS ensures the algorithm always terminates

### Example Walkthrough

Consider this simple network:

```
    s --10--> v1 --8--> t
    |          |
    10         4
    |          |
    v2 --9--> v3
```

**Step 1**: Find path `s -> v1 -> t` with flow 8

- Residual: `s->v1: 2, v1->t: 0, v1->t (backward): 8`

**Step 2**: Find path `s -> v2 -> v3 -> t` with flow 4

- Residual: `s->v2: 6, v2->v3: 5, v3->t: 0, v3->t (backward): 4`

**Step 3**: Find path `s -> v2 -> v3 -> v1 -> t` with flow 4

- Uses backward edge `v3->v1` (capacity 4 from previous flow)
- Flow: 4

**Total Flow**: 8 + 4 + 4 = 16

---

## Applications

1. **Network Flow Problems**

   - Maximum data transfer in networks
   - Water distribution systems
   - Traffic flow optimization

2. **Bipartite Matching**

   - Job assignment
   - Dating/matching problems
   - Resource allocation

3. **Image Segmentation**

   - Graph cut algorithms use max flow

4. **Project Selection**
   - Some optimization problems can be reduced to max flow

---

## Example: Why Backward Edges Are Essential

This example demonstrates how **backward edges** (residual edges) allow the algorithm to redirect flow and find the optimal solution. Without backward edges, we'd be stuck with a suboptimal flow.

### The Problem Setup

**Graph:**

```python
graph = {
    0: {1: 10, 2: 10},  # s -> v1, s -> v2
    1: {2: 5, 3: 5},    # v1 -> v2 (capacity 5), v1 -> t (capacity 5)
    2: {3: 10},         # v2 -> t
    3: {}                # t
}
```

**Visual Representation:**

```
       10             5
   s ------> v1 ---------> t
    \         |            ^
     \        | 5          |
      \       v            |
       \     v2 ----------+
        \    |
         \   | 10
          \  |
           vv
           t
```

**Source:** 0, **Sink:** 3

**Optimal Flow:** 15

The maximum flow can be achieved as:

- Path 1: s → v1 → t (flow: 5)
- Path 2: s → v1 → v2 → t (flow: 5)
- Path 3: s → v2 → t (flow: 5)

OR simply:

- Path 1: s → v1 → t (flow: 5)
- Path 2: s → v2 → t (flow: 10)

---

### Step-by-Step Execution with Backward Edges

#### Iteration 1: First Greedy Path

**BFS finds:** 0 → 1 → 3 (s → v1 → t)

**Bottleneck calculation:**

```
Path: 0 → 1 → 3
residual[0][1] = 10
residual[1][3] = 5
Bottleneck = min(10, 5) = 5
```

**Flow:** 5

**Update Residual Graph:**

```
Forward edges (decrease capacity):
  residual[0][1] = 10 - 5 = 5
  residual[1][3] = 5 - 5 = 0
  residual[0][2] = 10 (unchanged)
  residual[1][2] = 5 (unchanged)
  residual[2][3] = 10 (unchanged)

Backward edges (increase capacity - KEY FEATURE!):
  residual[1][0] = 0 + 5 = 5   ← Can "undo" 5 units from v1 to s
  residual[3][1] = 0 + 5 = 5   ← Can "undo" 5 units from t to v1
```

**Current Flow:** 5

**Residual Graph State:**

```
Forward:
  0→1: 5,  1→3: 0,  0→2: 10,  1→2: 5,  2→3: 10

Backward (NEW - allows flow redirection):
  1→0: 5,  3→1: 5
```

---

#### Iteration 2: Second Path (Using v1→v2→t)

**BFS from source (0):**

```
Queue: [0]
parent = {0: None}

Step 1: Process 0
  - residual[0][1] = 5 > 0 → Discover 1
    parent[1] = 0
    Queue: [1]
  - residual[0][2] = 10 > 0 → Discover 2
    parent[2] = 0
    Queue: [1, 2]
  parent = {0: None, 1: 0, 2: 0}

Step 2: Process 1
  - Check neighbors: 0, 2, 3
  - 0 in parent → skip
  - residual[1][2] = 5 > 0 → Discover 2 (already discovered, skip)
  - residual[1][3] = 0 → Skip (no capacity)
  Queue: [2]

Step 3: Process 2
  - Check neighbors: 0, 1, 3
  - 0, 1 in parent → skip
  - residual[2][3] = 10 > 0 → Discover 3 (SINK FOUND!)
    parent[3] = 2
    found_path = True
```

**Path Found:** 0 → 2 → 3 (BFS finds shortest path first)

**Bottleneck calculation:**

```
Path: 0 → 2 → 3
residual[0][2] = 10
residual[2][3] = 10
Bottleneck = min(10, 10) = 10
```

**Flow:** 10

**Update Residual Graph:**

```
Forward edges:
  residual[0][2] = 10 - 10 = 0
  residual[2][3] = 10 - 10 = 0

Backward edges:
  residual[2][0] = 0 + 10 = 10
  residual[3][2] = 0 + 10 = 10
```

**Total Flow:** 5 + 10 = 15 ✅

**Note:** In this run, BFS found the optimal solution directly without needing backward edges. However, backward edges are still essential for the algorithm's correctness. Let's see a scenario where they're actually used:

---

### Alternative Scenario: Backward Edges in Action

If BFS had explored vertices in a different order, we might get:

**Iteration 1:** Path 0 → 1 → 2 → 3 (s → v1 → v2 → t)

- Flow: 5 (bottleneck: min(10, 5, 10) = 5)
- Residual: 0→1: 5, 1→2: 0, 2→3: 5
- Backward: 1→0: 5, 2→1: 5, 3→2: 5
- **Total Flow:** 5

**Iteration 2:** Path 0 → 1 → 3 (s → v1 → t)

- Flow: 5 (bottleneck: min(5, 5) = 5)
- Residual: 0→1: 0, 1→3: 0, 0→2: 10, 2→3: 5
- Backward: 1→0: 10, 3→1: 5
- **Total Flow:** 10

**Iteration 3:** To get more flow, we'd need to use the backward edge 2→1, but in this case, v1→t is already saturated, so we can't complete the path. However, this demonstrates why backward edges exist - they allow flow redirection when needed.

**Important Note:** In this specific example, BFS found the optimal solution (15) directly. However, **backward edges are fundamental** to the algorithm because:

1. They guarantee the algorithm can always find the optimal solution
2. In more complex graphs, they're essential for redirecting flow
3. They're what makes the residual graph representation work correctly

---

### Key Insight

**Backward edges enable flow redirection:**

1. They represent **"undoing"** previous flow assignments
2. They allow the algorithm to **find better paths** by redirecting flow
3. They're essential for finding the **optimal solution**

**The residual graph with backward edges:**

- Forward edge capacity = Original capacity - Current flow
- Backward edge capacity = Current flow (can be "undone")

This dual representation allows the algorithm to explore all possible flow configurations and find the maximum flow!

---

## Complexity Analysis

- **Time Complexity**: O(V × E²)

  - BFS: O(V + E) per iteration
  - At most O(V × E) augmenting paths (each path increases flow by at least 1)
  - Each edge can be part of at most O(V) paths

- **Space Complexity**: O(V + E)
  - Residual graph storage
  - BFS queue and parent tracking

---

## Comparison with Other Algorithms

| Algorithm                | Time Complexity | Notes                       |
| ------------------------ | --------------- | --------------------------- |
| **Edmonds-Karp**         | O(V × E²)       | Uses BFS, always terminates |
| **Ford-Fulkerson (DFS)** | O(E × max_flow) | Can be exponential          |
| **Dinic's Algorithm**    | O(V² × E)       | Faster, uses BFS + DFS      |
| **Push-Relabel**         | O(V² × E)       | Different approach          |

---

## Edge Cases to Consider

1. **No path exists**: Algorithm returns 0
2. **Disconnected graph**: Returns 0
3. **Self-loops**: Should be handled (can add capacity)
4. **Multiple edges**: Sum capacities
5. **Zero capacity edges**: Treated as no edge

---

## Testing

The implementation includes several test cases:

- Simple network flow
- Classic flow network example
- Bipartite matching reduction
- Path tracking for debugging

Run the file to see the examples in action!
