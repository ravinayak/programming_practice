Prim’s Algorithm

Prim’s Algorithm is a greedy algorithm used to find the Minimum Spanning
Tree (MST) of a connected, undirected graph. The MST is a subset of the graph
that connects all vertices together, without cycles, and with the minimum
possible total edge weight.

Unlike Kruskal’s Algorithm, which starts by sorting all edges, Prim’s Algorithm
starts with a single vertex and grows the MST one edge at a time, always choosing
the smallest edge that connects a vertex in the MST to a vertex outside of it.

Key Concepts

    •	Spanning Tree: A subgraph that includes all vertices of the graph and is
    	a tree (no cycles).
    •	Minimum Spanning Tree (MST): A spanning tree with the minimum sum of edge
    	weights.
    •	Greedy Algorithm: Prim’s algorithm is greedy because it always picks the
    	smallest available edge at each step.

How Prim’s Algorithm Works

    1.	Start with an arbitrary vertex and add it to the MST.
    2.	Grow the MST by adding the smallest edge that connects a vertex in the
    	MST to a vertex outside the MST.
    3.	Repeat until all vertices are included in the MST.

Steps of Prim’s Algorithm

    1.	Initialization:
            • Start with a single vertex (arbitrary) and initialize an empty MST.
            • Use a min-priority queue (min-heap) to store edges based on their weights.
    	      all edges from the start vertex to the priority queue.
            • Keep a visited set to track vertices already included in the MST.
    2.	Process Edges:
            • Extract the minimum weight edge from the priority queue.
            • If the edge connects a vertex inside the MST to a vertex outside the MST, add the edge to the MST.
            • Add all edges from the newly included vertex to the priority queue.
    3.	Termination:
            • The algorithm ends when the MST contains V - 1 edges, where V is the number of vertices in the graph.

Prim’s Algorithm Pseudocode

```
Prim(graph, start_vertex):
    Initialize an empty list mst_edges[] to store the MST edges
    Initialize an empty set visited to track visited vertices
    Initialize a priority queue (min-heap) pq
    Add all edges from start_vertex to pq

    while pq is not empty and the number of mst_edges < V - 1:
        (weight, u, v) = Extract-Min from pq
        if v is not in visited:
            Add edge (u, v, weight) to mst_edges[]
            Add v to visited
            for each edge (v, neighbor, weight):
                if neighbor is not in visited:
                    Add edge (v, neighbor, weight) to pq

    return mst_edges[]
```

Explanation

    •	Priority Queue (min-heap): Stores edges based on their weights.
    	The edge with the smallest weight is extracted first.
    •	Visited Set: Keeps track of vertices that have already been included
    	in the MST.
    •	Greedy Approach: At each step, the algorithm selects the smallest edge
    	that connects a vertex inside the MST to one outside the MST.

Example of Prim’s Algorithm

Consider the following graph:

```
      1
   A ----- B
   | \     | \
  5|  \2  3|  \4
   |   \   |   \
   C ----- D --- E
        6
```

Steps:

    1.	Start from vertex A:
    •	Add edges from A: (A, B, 1), (A, C, 5), (A, D, 2).
    •	Priority queue: [(1, A, B), (5, A, C), (2, A, D)]
    •	MST: []
    2.	Select edge (A, B, 1):
    •	Add edge to MST: (A, B)
    •	Add edges from B: (B, D, 3), (B, E, 4).
    •	Priority queue: [(2, A, D), (5, A, C), (3, B, D), (4, B, E)]
    •	MST: [(A, B, 1)]
    3.	Select edge (A, D, 2):
    •	Add edge to MST: (A, D)
    •	Add edges from D: (D, C, 6), (D, E, 4).
    •	Priority queue: [(3, B, D), (4, B, E), (5, A, C), (6, D, C)]
    •	MST: [(A, B, 1), (A, D, 2)]
    4.	Select edge (B, E, 4):
    •	Add edge to MST: (B, E)
    •	Priority queue: [(5, A, C), (6, D, C)]
    •	MST: [(A, B, 1), (A, D, 2), (B, E, 4)]
    5.	Select edge (A, C, 5):
    •	Add edge to MST: (A, C)
    •	MST is complete with 4 edges: [(A, B, 1), (A, D, 2), (B, E, 4), (A, C, 5)]

Final MST:

```
      1
   A ----- B
   |       |
  5|       |4
   |       |
   C       E
    \
     2
      D
```

The total weight of the MST is 1 + 2 + 4 + 5 = 12.
Time Complexity

    •	Using a Priority Queue (Min-Heap): The algorithm runs in O(E log V) time,
        where E is the number of edges and V is the number of vertices.
    •	Priority queue operations take O(log V) time, and each edge is processed once.

Space Complexity

    •	O(V + E): The algorithm needs to store the graph, priority queue, and the MST,
        so the space complexity is O(V + E).

Applications of Prim’s Algorithm

    1.	Network Design: Prim’s algorithm is commonly used in network design, such as
        laying out cables for networks, designing telecommunications networks, electrical
        grids, etc.
    2.	Approximation Algorithms: In algorithms like the Traveling Salesman Problem,
        MST is used to find an approximate solution.
    3.	Cluster Analysis: Prim’s algorithm can also be applied in hierarchical clustering
        methods to find clusters based on proximity.

Comparison with Kruskal’s Algorithm

    •	Prim’s Algorithm is more suitable for dense graphs (graphs with a lot of edges) because
        it doesn’t need to sort all edges at the beginning and uses a priority queue to handle
        edges efficiently.
    •	Kruskal’s Algorithm is better for sparse graphs because it first sorts all edges, which
        is more efficient when there are fewer edges.

Conclusion

Prim’s algorithm is an efficient and intuitive method for finding the Minimum Spanning Tree of a
graph. It grows the MST one edge at a time, always choosing the smallest possible edge that connects
the tree to a new vertex. The algorithm is widely used in network design and other applications where
a minimum-cost spanning tree is needed.
