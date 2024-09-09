Bellman-Ford Algorithm

The Bellman-Ford algorithm is an algorithm used to find the
hortest path from a single source node to all other nodes in a
graph. It works for graphs with negative edge weights, unlike
Dijkstra’s algorithm, which only works for non-negative weights.
Additionally, Bellman-Ford can detect negative weight cycles,
which can cause issues in shortest path problems.

Key Concepts

    •	Negative Edge Weights: The algorithm can handle negative edge
    	weights and still compute the shortest path, unlike Dijkstra’s
    		algorithm.
    •	Negative Weight Cycles: If a graph contains a negative weight
    	cycle (a cycle where the total sum of edge weights is negative),
    		Bellman-Ford can detect it. In such cases, there is no well-defined
    			shortest path since traversing the cycle indefinitely reduces the
    				path length.

How the Algorithm Works

Bellman-Ford is based on a dynamic programming approach. It repeatedly
“relaxes” the edges of the graph by attempting to improve the known
shortest distance to each vertex.

The algorithm performs V-1 iterations over all the edges, where V is the
number of vertices. After each iteration, the shortest distance to each
vertex is refined. After these V-1 iterations, it guarantees the shortest
path if there are no negative weight cycles.

In the V-th iteration, if any distance can still be reduced, a negative
weight cycle exists.

Steps of the Bellman-Ford Algorithm

    1.	Initialize:
    •	Set the distance to the source node as 0 and to all other nodes as infinity (∞).
    •	Repeat the relaxation process for V-1 iterations, where V is the number
    	of vertices.
    2.	Relaxation:
    •	For each edge (u, v) with weight w, if the shortest known distance to v is
    	 greater than the shortest known distance to u plus the edge weight w, update
    		 the shortest distance to v.
    3.	Negative Cycle Detection:
    •	After the V-1 iterations, check all edges again. If you can still relax any
    	edge, there is a negative weight cycle.

Bellman-Ford Algorithm Pseudocode

```
Bellman_Ford(graph, source):
    Initialize distance[source] = 0 and distance[all other nodes] = infinity

    for i from 1 to V-1:  # V is the number of vertices
        for each edge (u, v) in graph:
            if distance[u] + weight(u, v) < distance[v]:
                distance[v] = distance[u] + weight(u, v)

    # Check for negative-weight cycles
    for each edge (u, v) in graph:
        if distance[u] + weight(u, v) < distance[v]:
            Raise error: "Graph contains a negative-weight cycle"

    return distance array
```

Explanation

    •	Distance Array: Stores the shortest known distance to each vertex.
    •	Relaxation: Updates the distance array by comparing the current known
    	shortest path with a newly found shorter path through an edge.
    •	Negative Cycle Check: If, after the V-1 iterations, any edge can still be
    	relaxed, this implies the presence of a negative weight cycle.

Example

Consider the following graph with negative weights:

```graph
        4         -10
    A ------> B --------> C
     \         |
    6 \        | 2
       \      \|/
        --------> D
```

The edges and their weights:

    •	A → B (weight 4)
    •	A → D (weight 6)
    •	B → C (weight -10)
    •	B → D (weight 2)

graph = {
A: [(B, 4), (D, 6)],
B: [(C, -10), (D, 2)],
D: []
}

Execution of Bellman-Ford Algorithm (Starting from A):

    1.	Initialization:
    •	distance[A] = 0, distance[B] = ∞, distance[C] = ∞, distance[D] = ∞
    2.	First Iteration:
    •	For edge A → B (weight 4): distance[B] = 0 + 4 = 4
    •	For edge A → D (weight 6): distance[D] = 0 + 6 = 6
    •	For edge B → C (weight -10): distance[C] = 4 + (-10) = -6
    •	For edge B → D (weight 2): No update since distance[D] = 6 is smaller than 4 + 2 = 6

Distance array:
distance[A] = 0, distance[B] = 4, distance[C] = -6, distance[D] = 6 3. Second Iteration:
• No updates occur in this iteration since all current distances are optimal. 4. Negative Cycle Check:
• Check all edges one more time:
• For each edge, no further relaxation is possible, so no negative cycle exists.

Final Distances:

    •	distance[A] = 0
    •	distance[B] = 4
    •	distance[C] = -6
    •	distance[D] = 6

Time Complexity

    •	Time Complexity: O(V * E), where V is the number of vertices and E is the number of
    	edges.
    	The algorithm runs in O(V) iterations, and in each iteration, it checks all edges.
    •	Space Complexity: O(V) for storing distances.

Applications of Bellman-Ford Algorithm

    1.	Graphs with Negative Weights:
    •	The Bellman-Ford algorithm is used to find the shortest path in graphs with negative
    	edge
    	weights, where Dijkstra’s algorithm fails.
    2.	Detecting Negative Weight Cycles:
    •	The algorithm can detect negative weight cycles, which can be important in financial
    	modeling, network routing, or any situation where infinite reductions in costs are
    	undesirable.
    3.	Routing Algorithms:
    •	Bellman-Ford is used in some network routing algorithms, such as Distance Vector Routing
    	Protocols (e.g., RIP – Routing Information Protocol), to compute the shortest paths and
    		detect routing loops.

Limitations

    •	Inefficiency: Bellman-Ford has a higher time complexity than Dijkstra’s algorithm,
    	making it less efficient for large graphs, especially if all edge weights are non-negative.

In summary, Bellman-Ford is a versatile and robust algorithm for finding the shortest path in
graphs with negative weights and for detecting negative weight cycles. Though less efficient
than Dijkstra’s algorithm for non-negative weights, it plays an important role in scenarios
where negative weights and cycles need to be accounted for.
