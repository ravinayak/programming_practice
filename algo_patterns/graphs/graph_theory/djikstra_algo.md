Dijkstra’s Algorithm

Dijkstra’s Algorithm is a popular algorithm used to find the
shortest path from a starting node (source) to all other nodes
in a graph with non-negative edge weights. It ensures that the
shortest path is found for all nodes from the source by exploring
paths in increasing order of distance from the source.

Key Concepts

• Graph: A set of vertices (nodes) connected by edges, where
each edge has a weight (cost).
• Shortest Path: The path between two nodes with the minimum
sum of edge weights.
• Non-negative Edge Weights: Dijkstra’s algorithm assumes that
all edges have non-negative weights. It does not work correctly
if negative edge weights are present (for that, Bellman-Ford is used).

Algorithm Overview

Dijkstra’s algorithm uses a greedy approach by always expanding the
shortest known path first. It keeps track of the minimum distances
from the source node to each other node and updates these distances
as it traverses the graph.

The algorithm is implemented using:

• A priority queue (min-heap) to efficiently fetch the next node
with the smallest tentative distance.
• A distance array (or map) to store the shortest known distance
from the source node to each node.
• A visited set to ensure that nodes are processed only once.

Steps of Dijkstra’s Algorithm

1. Initialization:
   • Create a distance array (or map) and initialize the distance to
   the source node as 0 and all other nodes as infinity (∞).
   • Initialize a priority queue (min-heap) and insert the source node
   with a distance of 0.
   • Maintain a visited set to keep track of nodes that have already
   been processed.
2. Processing Nodes:
   • While there are nodes to process (i.e., the priority queue is not empty):
3. Extract the node with the smallest distance from the queue (this is
   the node with the shortest known distance from the source).
4. If this node has been visited, skip it (this ensures no repeated work).
5. For each neighbor of the current node, calculate the tentative distance
   to that neighbor as the current node’s distance plus the edge weight.
6. If this tentative distance is smaller than the previously known distance
   for the neighbor, update the neighbor’s distance and add it to the priority
   queue.
7. If this tentative distance is NOT smaller than the previously known distance
   for the neighbor, we do NOT Update the neighbor's distance, and we ALSO DO
   NOT ADD IT to the PRIORITY Queue. Adding it again would only lead to
   redundant work and make the algorithm less Efficient. Since the minimum
   distance to this node has already been computed, the node has been
   processed, and we can avoid pushing into min-heap
   => Purpose of pushing a node to MinHeap is to compute the MINIMUM DISTANCE
   from SOURCE to that NODE
   NOTE: In Dijkstra’s algorithm, if a node is inserted into the min-heap
   more than once (i.e., after its distance is updated), it doesn’t break the
   correctness of the algorithm, but it can lead to redundant work and
   inefficiency.
8. Termination:
   • The algorithm terminates when all nodes have been processed (i.e., visited
   or removed from the priority queue).

Dijkstra’s Algorithm Pseudocode

```
Dijkstra(graph, source):
    Initialize distance[source] = 0 and distance[all other nodes] = infinity
    Create a priority queue (min-heap) and insert (0, source) into it
    Create a visited set to keep track of processed nodes

    while priority queue is not empty:
        (current_distance, current_node) = Extract-Min from the priority queue

        if current_node is already visited:
            continue

        Mark current_node as visited

        for each neighbor of current_node:
            edge_weight = weight of the edge from current_node to neighbor
            tentative_distance = current_distance + edge_weight

            if tentative_distance < distance[neighbor]:
                distance[neighbor] = tentative_distance
                Insert (tentative_distance, neighbor) into the priority queue

    return distance array
```

Graph:

```graph
        1
    A ------- B
    |         | \
   4|         |  2
    |         |   \
    C ------- D    E
        1         5
```

Graph Representation:

    •	Node A connects to B (weight 1) and C (weight 4).
    •	Node B connects to A (weight 1), D (weight 2), and E (weight 5).
    •	Node C connects to A (weight 4) and D (weight 1).
    •	Node D connects to B (weight 2), C (weight 1), and E (weight 5).
    •	Node E connects to B (weight 5) and D (weight 5).

Execution of Dijkstra’s Algorithm (Starting from A):

1. Initialization:
   • distance[A] = 0, distance[B] = ∞, distance[C] = ∞, distance[D] = ∞, distance[E] = ∞
   • Priority queue: [(0, A)]
2. Step 1:
   • Pop (0, A) from the queue (current node: A).
   • For neighbors of A:
   • B: tentative distance = 0 + 1 = 1 → update distance[B] = 1.
   • C: tentative distance = 0 + 4 = 4 → update distance[C] = 4.
   • Priority queue: [(1, B), (4, C)]
3. Step 2:
   • Pop (1, B) from the queue (current node: B).
   • For neighbors of B:
   • A: already visited.
   • D: tentative distance = 1 + 2 = 3 → update distance[D] = 3.
   • E: tentative distance = 1 + 5 = 6 → update distance[E] = 6.
   • Priority queue: [(3, D), (4, C), (6, E)]
4. Step 3:
   • Pop (3, D) from the queue (current node: D).
   • For neighbors of D:
   • B: already visited.
   • C: tentative distance = 3 + 1 = 4 (no update as distance[C] is already 4).
   • E: tentative distance = 3 + 5 = 8 (no update as distance[E] is already 6).
   • Priority queue: [(4, C), (6, E)]
5. Step 4:
   • Pop (4, C) from the queue (current node: C).
   • For neighbors of C:
   • A: already visited.
   • D: already visited.
   • Priority queue: [(6, E)]
6. Step 5:
   • Pop (6, E) from the queue (current node: E).
   • For neighbors of E:
   • B: already visited.
   • D: already visited.
   • Priority queue: []

Final Result:

The shortest distances from A to all nodes are:

    •	distance[A] = 0
    •	distance[B] = 1
    •	distance[C] = 4
    •	distance[D] = 3
    •	distance[E] = 6

Time Complexity

    •	Priority Queue-Based Implementation: O((V + E) * log V)
    •	V is the number of vertices (nodes), and E is the number of edges.
    •	The log V factor comes from the priority queue operations.

Applications of Dijkstra’s Algorithm

    •	Shortest Path in Networks: Used to find the shortest path in transportation
    	 networks, telecommunications, and routing protocols (e.g., OSPF in IP networks).
    •	Navigation Systems: Used in GPS systems to calculate the shortest route between
    	locations.
    •	Resource Optimization: Optimizes resource allocation in various domains like
    	logistics, network management, and more.

Limitations

    •	Non-Negative Weights: Dijkstra’s algorithm cannot handle graphs with negative
    	edge weights. For graphs with negative weights, the Bellman-Ford algorithm
    		should be used.

In summary, Dijkstra’s algorithm is an efficient and widely-used algorithm for finding
the shortest paths in graphs with non-negative edge weights, particularly useful in
network routing and optimization problems.
