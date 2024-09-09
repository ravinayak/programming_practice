The time complexity of Breadth-First Search (BFS) traversal of
a graph is O(V + E), where:

    •	V is the number of vertices (or nodes) in the graph.
    •	E is the number of edges in the graph.

Here’s a detailed breakdown of why this is the case:

1. Vertices (V):

   • BFS starts at a given source vertex and explores its neighbors,
   then the neighbors of those neighbors, and so on, level by level.
   • Each vertex is visited exactly once during the traversal because
   BFS marks vertices as visited when it encounters them, preventing
   hem from being revisited.
   • Hence, the time spent on visiting each vertex (and marking it as
   visited) is O(V), as there are V vertices in total.

2. Edges (E):

   • BFS explores all the edges connected to each vertex.
   • For each vertex, BFS inspects all its adjacent vertices by following
   the edges.
   • In an adjacency list representation of the graph (which is typically
   used for BFS), for each vertex, we have a list of all its adjacent
   vertices (i.e., the edges originating from that vertex).
   • The total number of adjacent vertices (or edges) across all vertices
   is exactly E.
   • Since BFS processes each edge exactly once (when it explores the
   neighbors of a vertex), the time spent traversing the edges is O(E).

Putting it all together:

    •	BFS visits V vertices (taking O(V) time).
    •	BFS processes E edges (taking O(E) time).
    •	Therefore, the overall time complexity is the sum of these two
    	components, which is O(V + E).

Special Cases:

    •	For a sparse graph, where the number of edges E is small compared
    	to the number of vertices V (e.g., a tree), the time complexity is
    	closer to O(V).
    •	For a dense graph, where the number of edges E is close to V², the
    	time complexity approaches O(V²).

Thus, O(V + E) captures the worst-case scenario for BFS traversal, ensuring
we account for both the vertices and the edges in the graph.
