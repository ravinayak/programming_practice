# Eulerian Path Algorithm for String Chaining

## Problem Description

Given a list of strings, determine if they can be chained together such that the last character of one string matches the first character of the next string.

## Visual Explanation

### 1. Problem Setup

Imagine we have strings that can be chained together if the last character of one string matches the first character of another:

```
Strings: ["abc", "cde", "efg", "ghi"]
```

### 2. Graph Construction

We create a directed graph where:

- **Nodes** represent characters
- **Edges** represent strings (from first char to last char)

```
a → c (via "abc")
c → e (via "cde")
e → g (via "efg")
g → i (via "ghi")
```

### 3. Eulerian Path Conditions

For a directed graph to have an Eulerian path:

- **At most one vertex** has `out_degree - in_degree = 1` (start vertex)
- **At most one vertex** has `in_degree - out_degree = 1` (end vertex)
- **All other vertices** have `in_degree = out_degree`
- **All vertices with non-zero degree** belong to a single strongly connected component

### 4. Hierholzer's Algorithm Steps

**Step 1: Find Start Vertex**

- If there's a vertex with `out_degree > in_degree`, start there
- Otherwise, start at any vertex with non-zero degree

**Step 2: Trace Path**

- Start from the chosen vertex
- Follow edges until you can't go further
- This gives you a path (not necessarily the complete path)

**Step 3: Find Cycles**

- For each vertex in the path that still has unused edges
- Find a cycle starting from that vertex
- Insert the cycle into the original path

**Step 4: Repeat**

- Continue until all edges are used

## Python Implementation

```python
from collections import defaultdict, deque

def can_chain_strings(strings):
    """
    Check if strings can be chained together using Eulerian Path algorithm.
    Returns True if possible, False otherwise.
    """
    if not strings:
        return True

    # Build graph and calculate degrees
    graph = defaultdict(list)
    in_degree = defaultdict(int)
    out_degree = defaultdict(int)

    for string in strings:
        if not string:  # Skip empty strings
            continue
        start = string[0]
        end = string[-1]
        graph[start].append(end)
        out_degree[start] += 1
        in_degree[end] += 1

    # Check Eulerian path conditions
    start_vertex = None
    end_vertex = None

    all_vertices = set(out_degree.keys()) | set(in_degree.keys())

    for vertex in all_vertices:
        out_deg = out_degree[vertex]
        in_deg = in_degree[vertex]
        diff = out_deg - in_deg

        if diff == 1:
            if start_vertex is not None:
                return False  # Multiple start vertices
            start_vertex = vertex
        elif diff == -1:
            if end_vertex is not None:
                return False  # Multiple end vertices
            end_vertex = vertex
        elif diff != 0:
            return False  # Invalid degree difference

    # If no start vertex found, pick any vertex with outgoing edges
    if start_vertex is None:
        start_vertex = next((v for v in all_vertices if out_degree[v] > 0), None)

    if start_vertex is None:
        return True  # No edges, trivially true

    # Check if all vertices are in the same strongly connected component
    return is_strongly_connected(graph, all_vertices, start_vertex)

def is_strongly_connected(graph, vertices, start):
    """Check if all vertices are reachable from start and can reach start."""
    # Forward reachability
    visited = set()
    stack = [start]
    while stack:
        vertex = stack.pop()
        if vertex not in visited:
            visited.add(vertex)
            for neighbor in graph[vertex]:
                if neighbor not in visited:
                    stack.append(neighbor)

    # Check if all vertices are reachable
    if len(visited) != len(vertices):
        return False

    # Reverse reachability (can reach start)
    reverse_graph = defaultdict(list)
    for vertex in graph:
        for neighbor in graph[vertex]:
            reverse_graph[neighbor].append(vertex)

    visited = set()
    stack = [start]
    while stack:
        vertex = stack.pop()
        if vertex not in visited:
            visited.add(vertex)
            for neighbor in reverse_graph[vertex]:
                if neighbor not in visited:
                    stack.append(neighbor)

    return len(visited) == len(vertices)

def find_eulerian_path(strings):
    """
    Find the actual Eulerian path if it exists.
    Returns the path as a list of strings, or None if impossible.
    """
    if not strings:
        return []

    # Build graph
    graph = defaultdict(list)
    in_degree = defaultdict(int)
    out_degree = defaultdict(int)

    for string in strings:
        if not string:
            continue
        start = string[0]
        end = string[-1]
        graph[start].append((end, string))
        out_degree[start] += 1
        in_degree[end] += 1

    # Find start vertex
    start_vertex = None
    all_vertices = set(out_degree.keys()) | set(in_degree.keys())

    for vertex in all_vertices:
        if out_degree[vertex] - in_degree[vertex] == 1:
            start_vertex = vertex
            break

    if start_vertex is None:
        start_vertex = next((v for v in all_vertices if out_degree[v] > 0), None)

    if start_vertex is None:
        return []

    # Hierholzer's algorithm
    path = []
    stack = [start_vertex]

    while stack:
        current = stack[-1]
        if graph[current]:
            next_vertex, string = graph[current].pop()
            stack.append(next_vertex)
            path.append(string)
        else:
            stack.pop()

    return path[::-1]  # Reverse to get correct order

# Example usage
if __name__ == "__main__":
    # Test cases
    test_cases = [
        ["abc", "cde", "efg", "ghi"],  # Should work
        ["abc", "cde", "efg", "ghi", "ijk"],  # Should work
        ["abc", "def", "ghi"],  # Should not work
        ["abc", "cba", "ade", "edf"],  # Should work
        ["a", "aa", "aaa"],  # Should work
    ]

    for i, strings in enumerate(test_cases):
        print(f"Test case {i+1}: {strings}")
        print(f"Can chain: {can_chain_strings(strings)}")
        if can_chain_strings(strings):
            path = find_eulerian_path(strings)
            print(f"Path: {path}")
        print()
```

## Key Insights

1. **Graph Representation**: Each string becomes an edge from its first character to its last character.

2. **Degree Conditions**: The algorithm checks if the graph satisfies Eulerian path conditions by examining in-degrees and out-degrees.

3. **Hierholzer's Algorithm**: Efficiently finds the path by building it incrementally and inserting cycles.

4. **Time Complexity**: O(V + E) where V is the number of unique characters and E is the number of strings.

5. **Space Complexity**: O(V + E) for storing the graph and path.

## Applications

- String chaining problems
- DNA sequencing
- Path-finding problems where you need to visit each edge exactly once
- Network routing problems
- Puzzle solving (like word chains)

## Related Problems

- [LeetCode 332: Reconstruct Itinerary](https://leetcode.com/problems/reconstruct-itinerary/)
- [LeetCode 753: Cracking the Safe](https://leetcode.com/problems/cracking-the-safe/)
- [LeetCode 997: Find the Town Judge](https://leetcode.com/problems/find-the-town-judge/)
