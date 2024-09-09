Tarjan’s Algorithm

Tarjan’s Algorithm is an efficient algorithm used to find the strongly
connected components (SCCs) in a directed graph. A strongly connected
component of a graph is a maximal subgraph where every vertex is reachable
from every other vertex within the subgraph.

The algorithm is named after Robert Tarjan, who developed it in 1972. It
works in O(V + E) time, where V is the number of vertices and E is the number
of edges. This makes it highly efficient for large graphs.

Key Concepts

1. Strongly Connected Components (SCCs):
   • A strongly connected component in a directed graph is a subgraph in which
   every vertex is reachable from every other vertex.
   • If you can travel from node A to node B and back from node B to node A,
   they are in the same SCC.
2. DFS (Depth-First Search):
   • Tarjan’s Algorithm uses DFS as its core traversal mechanism.
3. Discovery and Low-Link Values:
   • Discovery Time: The time (or index) when a vertex is first visited during
   DFS.
   • Low-Link Value: The smallest discovery time reachable from the vertex
   (including through its descendants in the DFS tree).
4. Stack:
   • A stack is used to store vertices that are currently being explored in a
   depth-first search and are part of the current SCC.

How Tarjan’s Algorithm Works

1. DFS Traversal:
   • Perform a depth-first search (DFS) on the graph. During the DFS, for each
   node, keep track of its discovery time and low-link value.
   • The low-link value of a node is updated based on its descendants. If the
   node can reach an ancestor, the low-link value is adjusted accordingly.
2. Detecting SCCs:
   • When the discovery time of a node is equal to its low-link value, it
   indicates that the node is the root of an SCC. All nodes in the current
   stack up to this node form an SCC.
3. Backtracking:
   • As the DFS backtracks, the low-link values are updated to reflect whether
   nodes can reach back to earlier nodes in the DFS tree.
4. Stack Management:
   • A node is kept in the stack until its entire SCC is identified. Once a
   strongly connected component is found, the nodes of that SCC are removed
   from the stack.

Steps of Tarjan’s Algorithm

1. Initialize:
   • Assign each vertex an index (discovery time) and a low-link value.
   • Use a stack to keep track of the current path of exploration.
2. DFS:
   • For each unvisited vertex, perform a DFS.
   • During DFS, update the low-link values of the vertices.
3. Form SCCs:
   • If a vertex’s discovery time is equal to its low-link value, pop vertices
   from the stack until the current vertex is reached. This group of vertices
   forms an SCC.
4. Repeat:
   • Continue the process until all vertices have been visited and all SCCs
   have been found.

Tarjan’s Algorithm Pseudocode

```
Tarjan_SCC(graph):
    Initialize index = 0
    Initialize empty stack
    Initialize empty arrays for low_link[], index[], and on_stack[]

    for each vertex v in graph:
        if v is not visited:
            DFS(v)

DFS(v):
    index[v] = low_link[v] = index_counter
    index_counter += 1
    push v onto stack
    on_stack[v] = true

    for each neighbor w of v:
        if w is not visited:
            DFS(w)
            low_link[v] = min(low_link[v], low_link[w])
        else if on_stack[w]:
            low_link[v] = min(low_link[v], index[w])

    if low_link[v] == index[v]:
        Start a new SCC
        while true:
            w = pop from stack
            on_stack[w] = false
            Add w to the current SCC
            if w == v:
                break
        Output the current SCC
```

Explanation of the Algorithm

    •	index[]: Tracks the order in which nodes are visited. Each node gets
    a unique index when it is first visited.
    •	low_link[]: Tracks the smallest index of any node that is reachable
    from the current node. This helps in identifying the root of an SCC.
    •	stack: Stores the nodes in the current DFS path. When an SCC is found,
    nodes are popped from the stack until the SCC root is reached.
    •	on_stack[]: A boolean array that indicates whether a node is currently
    on the stack.

Example

Consider the following directed graph:

```
    1 ---> 2 ---> 3 ---> 4
     ^     |      |     /
      \    v      v    /
       ---- 5 <--- 6 --
```

1. Initialization:
   • Start with vertex 1 and assign it an index and low-link value.
   • Proceed with DFS traversal. 2. DFS Traversal:
   • Explore vertex 2, assign it an index and low-link value.
   • Continue with DFS for vertices 3, 4, 6, and 5. 3. Low-Link Updates:
   • As DFS backtracks, low-link values are updated. For example, vertex 5’s
   low-link is updated when DFS discovers that vertex 1 is reachable from
   vertex 5. 4. Form SCCs:
   • When DFS reaches vertex 1 and finds that its low-link value equals its
   index, it identifies SCC {1, 2, 5}.
   • Similarly, SCCs {3, 6} and {4} are identified.

Detailed Walkthrough for the Example

1. Start DFS from vertex 1, assign index[1] = 0 and low_link[1] = 0, and
   push it onto the stack.
2. From vertex 1, move to vertex 2, assign index[2] = 1 and low_link[2] = 1,
   and push it onto the stack.
3. From vertex 2, move to vertex 3, assign index[3] = 2 and low_link[3] = 2,
   and push it onto the stack.
4. From vertex 3, move to vertex 4, assign index[4] = 3 and low_link[4] = 3,
   and push it onto the stack.
5. From vertex 4, move to vertex 6, assign index[6] = 4 and low_link[6] = 4,
   and push it onto the stack.
6. From vertex 6, move to vertex 5, assign index[5] = 5 and low_link[5] = 5,
   and push it onto the stack.
7. From vertex 5, move back to vertex 1 (since there is an edge from 5 to 1).
   Update low_link[5] = min(low_link[5], index[1]) = 0.
8. Continue backtracking and updating low-link values. Finally, when the low-link
   value of vertex 1 matches its index, all nodes on the stack up to vertex 1 form
   an SCC: {1, 2, 5}.

Time Complexity

    •	Time Complexity: O(V + E), where V is the number of vertices and E is the
    	number of edges. This is because the algorithm performs a DFS and processes
    	each vertex and edge exactly once.

Space Complexity

    •	Space Complexity: O(V) for storing the stack, low-link values, and indices
    	of the vertices.

Applications of Tarjan’s Algorithm

1. Finding Strongly Connected Components (SCCs):
   • Tarjan’s algorithm is primarily used to find SCCs in directed graphs. SCCs are
   useful in understanding the structure of the graph, especially in communication
   networks, dependency resolution, and program analysis.
2. Deadlock Detection:
   • In systems with multiple processes, SCCs can represent a deadlock situation.
   If a process is part of a cycle, it may indicate that it is waiting on itself,
   causing a deadlock.
3. Network Flow Analysis:
   • In network flow problems, SCCs help in identifying bottlenecks and analyzing
   the overall structure of the network.
4. Graph Condensation:
   • After finding all SCCs in a graph, we can “condense” the graph by treating
   each SCC as a single node, reducing the graph to its simplest form.

Comparison with Kosaraju’s Algorithm

    •	Kosaraju’s Algorithm also finds SCCs but requires two passes of DFS, while
    	Tarjan’s Algorithm finds SCCs in one DFS pass.
    •	Both have a time complexity of O(V + E), but Tarjan’s algorithm is generally
    	considered more efficient because it uses a single DFS traversal.

Conclusion

Tarjan’s algorithm is an elegant and efficient method for finding strongly connected
components in a directed graph. It uses DFS, low-link values, and a stack to discover
SCCs in linear time. It is widely used in various applications like network analysis,
program optimization, and detecting cycles in directed graphs.
