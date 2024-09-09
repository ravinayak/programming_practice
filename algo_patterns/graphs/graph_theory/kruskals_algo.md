Kruskal’s Algorithm

Kruskal’s Algorithm is a greedy algorithm used to find the Minimum Spanning
Tree (MST) of a connected, undirected graph. The Minimum Spanning Tree is a
subgraph that connects all the vertices together without any cycles and with
the minimum possible total edge weight.

Kruskal’s algorithm works by sorting all the edges of the graph by their weights
and then adding edges to the MST in increasing order of weight, ensuring that no
cycles are formed.

Key Concepts

    •	Spanning Tree: A subgraph of a graph that includes all the vertices of the
    	graph and is a tree (no cycles).
    •	Minimum Spanning Tree (MST): A spanning tree with the minimum sum of edge weights.
    •	Greedy Algorithm: Kruskal’s algorithm is greedy because it picks the smallest
    	possible edge at each step without regard for the global structure, only considering
    		local decisions.

How Kruskal’s Algorithm Works

    1.	Sort all edges of the graph in non-decreasing order of their weights.
    2.	Initialize: Each vertex is its own set (disjoint sets) using a Union-Find data structure.
    3.	Process edges:
    •	For each edge in the sorted list of edges:
    •	Check if the two vertices of the edge belong to different sets
    		(using the Find operation in Union-Find).
    •	If they belong to different sets, include the edge in the MST
    	(using the Union operation in Union-Find) and merge the two sets.
    •	If they are in the same set, adding the edge would form a cycle, so discard it.
    4.	Terminate: The algorithm ends when there are exactly V - 1 edges in the MST
    	(where V is the number of vertices).

Kruskal’s Algorithm Pseudocode

```
Kruskal(graph):
    Initialize result[] to store the MST edges
    Initialize Union-Find data structure (parent[] and rank[])

    Sort all edges in non-decreasing order by their weight

    for each edge (u, v) in sorted edges:
        if Find(u) != Find(v):  # Check if u and v are in different sets
            Add edge (u, v) to result[]
            Union(u, v)  # Merge the sets of u and v

    return result[]  # Contains the edges of the MST
```

Union-Find Data Structure

Kruskal’s algorithm uses Union-Find to keep track of which vertices are in which
components (or sets). The two main operations in Union-Find are:

    1.	Find: Determines the set to which a particular element belongs.
    2.	Union: Merges two sets.

Union-Find Operations Pseudocode:

```
Find(x):
    if parent[x] != x:
        parent[x] = Find(parent[x])  # Path compression
    return parent[x]

Union(x, y):
    rootX = Find(x)
    rootY = Find(y)

    if rootX != rootY:
        if rank[rootX] > rank[rootY]:
            parent[rootY] = rootX
        else if rank[rootX] < rank[rootY]:
            parent[rootX] = rootY
        else:
            parent[rootY] = rootX
            rank[rootX] += 1
```

Example of Kruskal’s Algorithm

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

    1.	Sort the edges by weight:
    •	(A, B): 1
    •	(A, D): 2
    •	(B, D): 3
    •	(B, E): 4
    •	(A, C): 5
    •	(C, D): 6
    2.	Initialize Union-Find:

Each vertex is in its own set: {A}, {B}, {C}, {D}, {E}. 3. Process each edge:
• (A, B): 1 → Add edge to MST. Sets: {A, B}, {C}, {D}, {E}.
• (A, D): 2 → Add edge to MST. Sets: {A, B, D}, {C}, {E}.
• (B, D): 3 → Discard this edge, since A, B, and D are already in the same set (would form a cycle).
• (B, E): 4 → Add edge to MST. Sets: {A, B, D, E}, {C}.
• (A, C): 5 → Add edge to MST. Sets: {A, B, C, D, E}.
• (C, D): 6 → Discard this edge, since all nodes are already in the same set. 4. Result:
The Minimum Spanning Tree includes the edges:
• (A, B) with weight 1
• (A, D) with weight 2
• (B, E) with weight 4
• (A, C) with weight 5

The total weight of the MST is 1 + 2 + 4 + 5 = 12.

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

Time Complexity

    •	Sorting the edges: O(E log E), where E is the number of edges.
    •	Union-Find operations: The Find and Union operations take nearly constant
    	time, O(α(V)), where α is the inverse Ackermann function (which grows extremely
    		slowly and is considered constant for practical purposes).

Thus, the overall time complexity of Kruskal’s algorithm is O(E log E), which is efficient
for sparse graphs where E (number of edges) is much smaller than V².

Space Complexity: O(V + E) for storing the graph and the Union-Find structure.

Applications of Kruskal’s Algorithm

    1.	Minimum Spanning Tree: Kruskal’s algorithm is used to find the MST of a graph,
    	which has applications in:
    •	Network design: Minimizing the cost of connecting all nodes in a network
    	(e.g., telecommunications, power grids).
    •	Approximation algorithms: In some algorithms, MST can be used as a starting point
    	to solve more complex problems (e.g., in the approximation of the traveling salesman problem).
    2.	Clustering: In hierarchical clustering, Kruskal’s algorithm can be used to partition a
    	graph into clusters by removing the most expensive edges from the MST.

Comparison with Prim’s Algorithm

    •	Kruskal’s Algorithm works better for sparse graphs because it sorts the edges and processes
    	each edge only once. It is more efficient when the graph has fewer edges.
    •	Prim’s Algorithm works better for dense graphs because it selects edges based on the nearest
    	unconnected vertex, and it doesn’t require sorting all the edges at the beginning.

Limitations

    •	Kruskal’s algorithm may be inefficient for dense graphs because sorting all edges could be slow
    	when there are many edges.

Conclusion

Kruskal’s algorithm is a simple and efficient greedy algorithm for finding the Minimum Spanning Tree
of a graph. By utilizing the Union-Find data structure, it ensures that no cycles are formed as it builds
the MST. It is particularly useful for sparse graphs and has important applications in network design and
clustering.
