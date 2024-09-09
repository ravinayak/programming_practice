1. Breadth First Search (BFS)

```
BFS(graph, start_node):
    Create a queue and enqueue start_node
    Create a set to keep track of visited nodes

    while queue is not empty:
        node = dequeue from queue
        if node is not in visited:
            Mark node as visited
            Process node (print or store the result)
            Enqueue all unvisited neighbors of node
```

2. Depth-First Search (DFS) - Iterative

```
DFS(graph, start_node):
    Create a stack and push start_node
    Create a set to keep track of visited nodes

    while stack is not empty:
        node = pop from stack
        if node is not in visited:
            Mark node as visited
            Process node (print or store the result)
            Push all unvisited neighbors of node onto the stack
```

3. DFS - Recursive

```
DFS(graph, node, visited):
    if node is not in visited:
        Mark node as visited
        Process node (print or store the result)
        for each neighbor of node:
            if neighbor is not visited:
                Call DFS(graph, neighbor, visited)
```

4. Union-Find (Disjoint Set Union, DSU)

```
Initialize parent[] and rank[] arrays

Find(node):
    if parent[node] != node:
        parent[node] = Find(parent[node])  # Path compression
    return parent[node]

Union(node1, node2):
    root1 = Find(node1)
    root2 = Find(node2)

    if root1 != root2:
        if rank[root1] > rank[root2]:
            parent[root2] = root1
        else if rank[root1] < rank[root2]:
            parent[root1] = root2
        else:
            parent[root2] = root1
            rank[root1] += 1
```

5. Topological Sort (DFS-based)

```
TopologicalSort(graph):
    Create an empty stack
    Create a set to keep track of visited nodes

    for each node in graph:
        if node is not visited:
            Call DFSUtil(graph, node, visited, stack)

    return the reversed stack (stack[::-1])

DFSUtil(graph, node, visited, stack):
    Mark node as visited
    for each neighbor of node:
        if neighbor is not visited:
            Call DFSUtil(graph, neighbor, visited, stack)
    Push node to stack after all neighbors are visited
```

6. Dijkstra’s Algorithm

```
Dijkstra(graph, start_node):
    Initialize distance[] for all nodes to infinity
    Set distance[start_node] = 0
    Create a priority queue (min-heap) and insert start_node with distance 0

    while priority queue is not empty:
        node = dequeue the node with the smallest distance
        for each neighbor of node:
            Calculate new distance = distance[node] + edge_weight(node, neighbor)
            if new distance < distance[neighbor]:
                Update distance[neighbor] = new distance
                Enqueue neighbor with the updated distance

    return distance array
```

7. A Search Algorithm

```
A_star(graph, start_node, goal_node, heuristic):
    Initialize g_score[] for all nodes to infinity
    Initialize f_score[] to g_score + heuristic
    Set g_score[start_node] = 0, f_score[start_node] = heuristic(start_node)
    Create a priority queue and enqueue start_node with f_score[start_node]

    while priority queue is not empty:
        node = dequeue the node with the smallest f_score
        if node is the goal_node:
            return the reconstructed path from start_node to goal_node

        for each neighbor of node:
            Calculate tentative_g_score = g_score[node] + edge_weight(node, neighbor)
            if tentative_g_score < g_score[neighbor]:
                Update g_score[neighbor] = tentative_g_score
                Update f_score[neighbor] = g_score[neighbor] + heuristic(neighbor)
                Enqueue neighbor with updated f_score
```

8. Floyd-Warshall Algorithm

```
Floyd_Warshall(graph):
    Create a dist[][] matrix to store distances between all pairs of nodes
    Initialize dist[u][v] = edge_weight(u, v) for all edges, and dist[u][u] = 0

    for k from 1 to num_nodes:
        for i from 1 to num_nodes:
            for j from 1 to num_nodes:
                dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])

    return dist matrix
```

9. Bellman-Ford Algorithm

```
Bellman_Ford(graph, start_node):
    Initialize distance[] for all nodes to infinity
    Set distance[start_node] = 0

    for i from 1 to num_nodes-1:
        for each edge (u, v, weight) in graph:
            if distance[u] + weight < distance[v]:
                Update distance[v] = distance[u] + weight

    for each edge (u, v, weight) in graph:
        if distance[u] + weight < distance[v]:
            Raise error: "Graph contains a negative weight cycle"

    return distance array
```

10. Kruskal’s Algorithm

```
Kruskal(graph, num_nodes):
    Initialize an empty list for Minimum Spanning Tree (MST)
    Sort all edges in graph by weight
    Initialize Union-Find structure

    for each edge (u, v, weight) in sorted edges:
        if Find(u) != Find(v):
            Add edge (u, v, weight) to MST
            Union(u, v)

    return MST
```

11. Prim’s Algorithm

```
Prim(graph, start_node):
    Create a set to keep track of visited nodes
    Create a priority queue (min-heap) and insert start_node with weight 0

    while priority queue is not empty:
        edge = dequeue the edge with the smallest weight
        if the node connected by this edge is not in visited:
            Mark node as visited
            Add edge to the Minimum Spanning Tree (MST)
            for each neighbor of node:
                if neighbor is not visited:
                    Enqueue edge connecting node to neighbor with the edge weight

    return MST
```

12. Tarjan’s Algorithm (for Strongly Connected Components - SCC)

```
Tarjan_SCC(graph):
    Initialize ids[] and low[] arrays for each node, initially unvisited (-1)
    Create a stack to maintain nodes in the current path
    Create a set to track nodes in the stack
    Initialize current_id to 0
    Initialize an empty list of SCCs

    for each node in graph:
        if node is not visited:
            Call DFS(node)

DFS(node):
    Set ids[node] = low[node] = current_id
    Increment current_id
    Push node onto the stack and add to on_stack
    for each neighbor of node:
        if neighbor is not visited:
            Call DFS(neighbor)
            Update low[node] = min(low[node], low[neighbor])
        else if neighbor is on_stack:
            Update low[node] = min(low[node], ids[neighbor])

    if ids[node] == low[node]:
        Start a new SCC
        while stack is not empty:
            Pop node from stack and add it to the SCC
            Break if the popped node is the current node
        Add SCC to the list of SCCs
```
