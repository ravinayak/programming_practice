Union-Find (Disjoint Set Union - DSU) in Graphs

Union-Find is a data structure that helps in efficiently managing
and manipulating disjoint sets (sets that do not overlap). It is
mainly used to determine which components (or sets) certain elements
belong to and to unite two sets. In the context of graphs, Union-Find
is widely used to:

    •	Detect cycles in an undirected graph.
    •	Determine connected components.
    •	Implement Kruskal’s algorithm for finding the Minimum Spanning Tree (MST).

Key Operations in Union-Find

    1.	Find: This operation determines which set a particular element belongs to.
    It returns the “representative” or “root” of the set containing the element.
    •	Helps answer the question: “Is element x in the same set as element y?”
    2.	Union: This operation merges two different sets into a single set.
    •	Helps answer the question: “How do we unite the sets that contain elements x
     and y?”

Core Concepts in Union-Find

    •	Disjoint Sets: The graph is partitioned into different sets where no two sets
     have common elements. Initially, each element is in its own set.
    •	Representative or Root: Each set has a representative (or root) element that
    uniquely identifies the set.
    •	Tree Representation: Union-Find internally represents sets as trees where each
    node points to its parent. The root of the tree represents the entire set, and
    each node ultimately points to this root.
    •	Union by Rank / Size: To keep the tree structure efficient, during union operations,
    the smaller tree is attached under the larger tree. This minimizes the height of the
    resulting tree.
    •	Path Compression: During the find operation, the nodes on the path to the root are
    directly connected to the root. This optimizes future operations by flattening the
    structure.

Union-Find Example

Consider an undirected graph:

    1 -- 2
    |    |
    3 -- 4

Initially, each node is its own set:

1 -> 1, 2 -> 2, 3 -> 3, 4 -> 4

Union(1, 2): We unite the sets containing 1 and 2.

1 -> 1, 2 -> 1, 3 -> 3, 4 -> 4

Union(3, 4): We unite the sets containing 3 and 4.

1 -> 1, 2 -> 1, 3 -> 3, 4 -> 3

Union(1, 3): Now unite the sets containing 1 and 3.

1 -> 1, 2 -> 1, 3 -> 1, 4 -> 3 -> 1

Union-Find Operations

1. Find Operation

The find operation locates the root or representative of a set. It
returns the parent of an element. If two elements have the same parent,
they belong to the same set.

    •	Find(x): If x is the root (i.e., parent[x] == x), return x.
    Otherwise, recursively find the root of x and update x to point
    to its root for path compression.

```
Find(x):
    if parent[x] == x:
        return x
    else:
        parent[x] = Find(parent[x])  # Path compression
        return parent[x]
```

2. Union Operation

The union operation merges two sets. It first finds the roots of the sets
containing the two elements and then merges them based on their rank or size.

    •	Union(x, y): Find the roots of x and y. If they are in different sets,
    unite them by attaching the smaller tree to the larger tree.

```
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

Path Compression and Union by Rank/Size

1. Path Compression:
   • When performing the Find operation, we make every node on the
   path point directly to the root. This flattens the tree, making
   future Find operations faster.

Example: If the path to the root was 3 -> 1 -> 5, after path compression,
it becomes 3 -> 5 directly.

2. Union by Rank/Size:
   • To keep the tree as flat as possible, we always attach the smaller
   tree under the larger tree. This prevents the tree from becoming too tall.
   Example: If rootA has a higher rank than rootB, we attach rootB under rootA.

Applications of Union-Find

    1.	Cycle Detection in Undirected Graphs:
    •	Union-Find is used to detect cycles in an undirected graph. As you
    traverse the edges, use Find to check if two vertices belong to the same set.
    If they do, adding the edge would form a cycle.
    2.	Kruskal’s Algorithm for Minimum Spanning Tree (MST):
    •	Union-Find is essential in Kruskal’s algorithm to check whether adding
    an edge creates a cycle. Only edges that connect different components are
    added to the MST.
    3.	Connected Components:
    •	Union-Find helps in finding connected components in a graph. After all
    unions are performed, the number of distinct sets (roots) gives the number
    of connected components.

Example Problem: Cycle Detection Using Union-Find

Given an undirected graph, detect whether there’s a cycle.

Approach:

    •	For every edge (u, v), perform:
    1.	If Find(u) == Find(v), a cycle exists.
    2.	Otherwise, perform Union(u, v) to merge the sets.

Pseudocode:

```
cycle_detect(graph):
    Initialize parent[] and rank[] arrays

    for each edge (u, v) in graph:
        if Find(u) == Find(v):
            return True  # Cycle exists
        else:
            Union(u, v)

    return False  # No cycle found
```

Time Complexity

• Find: With path compression, the time complexity of Find is
nearly constant, O(α(n)), where α is the inverse Ackermann function,
which grows very slowly and is practically constant for all real-world
inputs.
• Union: With union by rank or size, the union operation also
takes O(α(n)).

Thus, both Find and Union are nearly constant in practice, and the overall
time complexity for m operations on n elements is O(m \* α(n)).

Conclusion

Union-Find is a powerful data structure that efficiently handles the merging
of disjoint sets and is useful for cycle detection, connected components, and
building spanning trees. With optimizations like path compression and union
by rank/size, it performs exceptionally well for large datasets in graph problems.
