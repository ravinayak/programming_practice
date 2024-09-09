In the context of an undirected graph, connectivity refers to
how the vertices (or nodes) are connected to each other.
Specifically, it describes whether there is a path between
any pair of vertices, and this leads to the concept of connected
components in an undirected graph.

Key Concepts:

1. Connected Component:

   - A connected component in an undirected graph is a subgraph
     in which:
     - Any two vertices are connected by a path (there is a way to travel
       between them following the edges).
     - It is maximal, meaning no additional vertices or edges from the
       original graph can be added without breaking the property of
       connectivity.
     - In simpler terms, a connected component is a group of nodes such
       that every node in the group can reach every other node, either
       directly or through other nodes, and no node outside the group is
       reachable from the nodes inside the group.

2. Connectivity of a Graph:
   • If an undirected graph has only one connected component, it means the
   graph is connected, meaning there is a path between any two vertices in
   the entire graph.
   • If the graph has multiple connected components, it means the graph is
   disconnected, and the graph is divided into multiple isolated subgraphs,
   each of which is a connected component.

Example:

Consider the following undirected graph:

```
  0 --- 1       4
         |     /
         2 --- 3
```

This graph has two connected components:

    •	The first connected component consists of vertices 0, 1, and 2. All of
    	these vertices are connected by paths.
    •	The second connected component consists of vertices 3 and 4. These vertices
    	are connected by a path but are not connected to any vertex in the first
    		component.

Why is Connectivity Important?

    •	Connectivity is a key property in many algorithms and applications, such as
    	network design, social networks, and graph traversal.
    •	It helps identify isolated clusters in the graph or determine whether it is
    	possible to reach every part of the graph from any starting point.

In summary, the connectivity of components refers to how many isolated clusters
(or connected subgraphs) exist in an undirected graph and how the vertices within
each component are interconnected.

    • A graph has one connected component if all vertices in the graph are
    	reachable from one another.

    • A graph has multiple connected components if there are isolated groups of
    	vertices where no path exists between some of the groups.

```
  0 --- 1      3 --- 4


  2             5
```

This graph has two connected components:

This graph has two connected components:

1. First Connected Component:
   • Vertices 0, 1, and 2 form one connected component.
   • There is a path between 0 and 1, and vertex 2 is isolated but still considered
   part of the first component because it is not connected to any vertices outside
   this group.
2. Second Connected Component:
   • Vertices 3, 4, and 5 form another connected component.
   • Vertices 3 and 4 are directly connected, and vertex 5 is isolated in this component,
   not connected to vertices in the other group.

Since there is no path between any vertex in the first group and any vertex in the second
group, the graph is said to have two connected components.

This is a good example of a disconnected graph.
