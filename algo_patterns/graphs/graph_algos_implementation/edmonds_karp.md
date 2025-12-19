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

| Algorithm | Time Complexity | Notes |
|-----------|----------------|-------|
| **Edmonds-Karp** | O(V × E²) | Uses BFS, always terminates |
| **Ford-Fulkerson (DFS)** | O(E × max_flow) | Can be exponential |
| **Dinic's Algorithm** | O(V² × E) | Faster, uses BFS + DFS |
| **Push-Relabel** | O(V² × E) | Different approach |

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

