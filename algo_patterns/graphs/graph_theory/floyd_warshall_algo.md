Floyd-Warshall Algorithm

The Floyd-Warshall algorithm is a dynamic programming algorithm used to find the
shortest paths between all pairs of vertices in a weighted graph. It works for
graphs with both positive and negative edge weights, but it does not work with
graphs containing negative weight cycles.

Unlike Dijkstra’s and Bellman-Ford algorithms, which focus on finding the shortest
path from a single source to all other nodes, Floyd-Warshall computes the shortest
paths between every pair of nodes.

Key Concepts

    •	All-Pairs Shortest Path: The algorithm finds the shortest path between every pair
    of vertices (i, j) in the graph.
    •	Dynamic Programming: The algorithm iteratively improves the estimates of the shortest
    paths by considering each vertex as an intermediate node.
    •	Negative Edge Weights: The Floyd-Warshall algorithm can handle graphs with negative
    edge weights but cannot handle negative weight cycles, as they result in an infinitely
    short path.

How It Works

The Floyd-Warshall algorithm builds a solution in steps. It tries to improve the shortest
path between two vertices i and j by considering whether using an intermediate vertex k results
in a shorter path.

The idea is to check whether going through vertex k provides a shorter path from i to j than the
known direct path. If it does, update the shortest path.

The algorithm works by iteratively considering all vertices as potential intermediaries and
updating the distance matrix accordingly.

Steps of Floyd-Warshall Algorithm

    1.	Initialize:
    •	Create a distance matrix dist[][], where dist[i][j] represents the shortest distance between
    	vertices i and j.
    •	Set dist[i][i] = 0 for all vertices i.
    •	For each edge (i, j) with weight w, set dist[i][j] = w. If there is no direct edge between two
    	vertices, set dist[i][j] = ∞ (infinity).
    2.	Dynamic Programming:
    •	For each vertex k, iterate over all pairs of vertices (i, j) and check if dist[i][j] can be
    	improved by going through k, i.e., if dist[i][j] > dist[i][k] + dist[k][j].
    •	Update dist[i][j] = dist[i][k] + dist[k][j] if a shorter path is found.
    3.	Termination:
    •	After considering every vertex as an intermediate, the dist[][] matrix will contain the shortest
    	paths between all pairs of vertices.

Floyd-Warshall Algorithm Pseudocode

```
Floyd_Warshall(graph):
    Initialize dist[][] array:
        for each vertex i:
            for each vertex j:
                if i == j:
                    dist[i][j] = 0
                else if there is an edge from i to j:
                    dist[i][j] = weight of edge (i, j)
                else:
                    dist[i][j] = infinity

    for each intermediate vertex k from 1 to V:
        for each vertex i from 1 to V:
            for each vertex j from 1 to V:
                if dist[i][j] > dist[i][k] + dist[k][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]

    return dist[][]
```

```graph
     3        -2
  (1)----->(2)----->(3)
   |       / \        |
   |     1/   \2      |
   |     /     \      |
   v    /       \     v
  (4)<--------- (1)---(4)
         4
```

1.  Initialization:
    • Start with the given graph represented in the distance matrix:
    ```
    dist[][] =
    [[0,  3,  ∞,  7],
    [8,  0,  2,  ∞],
    [5,  ∞, 0,  1],
    [2,  ∞, ∞,  0]]
    ```
2.  Using Vertex 1 as an Intermediate:
    • Check if going through vertex 1 provides shorter paths.
    • Update dist[2][4] = dist[2][1] + dist[1][4] = 8 + 7 = 15, and other paths
    remain unchanged.
    ```
    dist[][] =
    [[0,  3,  ∞,  7],
    [8,  0,  2,  15],
    [5,  ∞,  0,  1],
    [2,  ∞,  ∞,  0]]
    ```
3.  Using Vertex 2 as an Intermediate:
    • Update dist[1][3] = dist[1][2] + dist[2][3] = 3 + 2 = 5.
    • Update dist[4][2] = dist[4][1] + dist[1][2] = 2 + 3 = 5.
    ```
    dist[][] =
    [[0,  3,  5,  7],
    [8,  0,  2,  15],
    [5,  5,  0,  1],
    [2,  5,  ∞,  0]]
    ```
4.  Using Vertex 3 as an Intermediate:
    • Update dist[1][4] = dist[1][3] + dist[3][4] = 5 + 1 = 6.
    • Update dist[2][4] = dist[2][3] + dist[3][4] = 2 + 1 = 3.
    ```
    dist[][] =
    [[0,  3,  5,  6],
    [8,  0,  2,  3],
    [5,  5,  0,  1],
    [2,  5,  6,  0]]
    ```
5.  Using Vertex 4 as an Intermediate:
    • No updates are needed as no shorter paths are found.
6.  Final Distance Matrix:
    Final Distances:

    ```
    dist[][] =
    [[0,  3,  5,  6],
    [8,  0,  2,  3],
    [5,  5,  0,  1],
    [2,  5,  6,  0]]
    ```

    This matrix now represents the shortest distances between all pairs of vertices.

**Explanation**

• The algorithm checks for all pairs (i, j) and considers each vertex k as
an intermediate point. If going through k results in a shorter path from
i to j, the distance is updated.
• After V iterations (where V is the number of vertices), the algorithm
guarantees that the shortest paths between all pairs of vertices are found.

Time Complexity

• Time Complexity: O(V³), where V is the number of vertices. The algorithm
processes each pair of vertices (i, j) for each intermediate vertex k,
resulting in three nested loops.
• Space Complexity: O(V²) to store the distance matrix.

Applications of Floyd-Warshall Algorithm

1.  All-Pairs Shortest Path: It is mainly used when you need to compute the
    shortest path between all pairs of vertices in a graph.
2.  Network Routing: Floyd-Warshall can be used in network routing algorithms to
    find the shortest paths between all routers.
3.  Transitive Closure: Floyd-Warshall can be adapted to compute the transitive
    closure of a graph, which determines whether there is a path between any two vertices.
4.  Detecting Negative Weight Cycles: If the diagonal elements dist[i][i] become
    negative, it means there is a negative weight cycle in the graph.

Limitations

• Inefficient for Sparse Graphs: The O(V³) time complexity makes it inefficient for
large, sparse graphs where Dijkstra’s algorithm (with better complexity for sparse graphs)
may be preferable.
• Negative Weight Cycles: While it can detect negative weight cycles, it does not work
properly in graphs with such cycles. Special care must be taken when interpreting the
results if negative cycles exist.

Conclusion

The Floyd-Warshall algorithm is a powerful and flexible method for solving the all-pairs shortest
path problem, especially for dense graphs. Though it has a higher time complexity than other
algorithms, its simplicity and ability to handle negative weights make it a valuable tool
in scenarios requiring comprehensive path

```

```

```

```

```

```

```

```

```

```
