# Fibonacci Heap: Complete Guide

## Table of Contents
1. [Introduction](#introduction)
2. [What is a Fibonacci Heap?](#what-is-a-fibonacci-heap)
3. [Key Properties](#key-properties)
4. [Structure and Terminology](#structure-and-terminology)
5. [Visual Representation](#visual-representation)
6. [Operations and Time Complexity](#operations-and-time-complexity)
7. [Detailed Operations](#detailed-operations)
8. [Why "Fibonacci" Heap?](#why-fibonacci-heap)
9. [Python Implementation](#python-implementation)
10. [Usage Examples](#usage-examples)
11. [Comparison with Other Heaps](#comparison-with-other-heaps)
12. [When to Use Fibonacci Heaps](#when-to-use-fibonacci-heaps)

---

## Introduction

A **Fibonacci Heap** is an advanced data structure for priority queue operations, invented by Michael L. Fredman and Robert E. Tarjan in 1984. It's named after the Fibonacci sequence because Fibonacci numbers are used in the runtime analysis.

---

## What is a Fibonacci Heap?

A Fibonacci heap is a collection of **heap-ordered trees** (min-heap or max-heap property). Unlike binary heaps:
- Trees are NOT necessarily binary
- Trees can have any number of children
- Structure is very flexible and "lazy"
- Most operations are delayed/amortized

**Key Insight:** Fibonacci heaps achieve better amortized time by being "lazy" - they defer work until absolutely necessary.

---

## Key Properties

### 1. **Heap Property**
- **Min-Heap:** Parent key ≤ Child key
- **Max-Heap:** Parent key ≥ Child key

### 2. **Structure**
- Collection of min-heap ordered trees
- Trees are stored in a circular doubly-linked list (root list)
- Each node has:
  - Pointer to parent
  - Pointer to one child
  - Pointers to left and right siblings (circular doubly-linked list)
  - Degree (number of children)
  - Mark (boolean flag)

### 3. **Minimum Pointer**
- Always points to the tree root with minimum key
- Enables O(1) find-min operation

---

## Structure and Terminology

```
Node Structure:
┌─────────────────────┐
│  key: value         │
│  degree: # children │
│  mark: true/false   │
│  parent: pointer    │
│  child: pointer     │
│  left: pointer      │
│  right: pointer     │
└─────────────────────┘
```

### Terminology:

- **Root List:** Circular doubly-linked list of tree roots
- **Degree:** Number of children of a node
- **Mark:** Indicates if node has lost a child since becoming a child of another node
- **Consolidate:** Process of merging trees of same degree
- **Cascading Cut:** Chain reaction of cuts when a marked node loses a child

---

## Visual Representation

### Example 1: Simple Fibonacci Heap

```
Min Pointer
    ↓
┌───3───┐     ┌───7───┐     ┌──18───┐
│       │     │       │     │       │
5      10     8      15    21      25
│             │
12           24
```

Root List (circular): 3 ↔ 7 ↔ 18 ↔ (back to 3)

### Example 2: After Insert(2)

```
Min Pointer
    ↓
┌───2───┐   ┌───3───┐     ┌───7───┐     ┌──18───┐
│       │   │       │     │       │     │       │
           5      10     8      15    21      25
           │             │
          12            24
```

New node added to root list, min pointer updated.

### Example 3: Node Structure Detail

```
        Parent
          ↑
          │
    ┌─────┴─────┐
    │   Node    │
    │  key: 5   │
    │  deg: 3   │
    │  mark: F  │
    └─────┬─────┘
          │ child
          ↓
    Left←[10]→Right
          ↓
    ┌────┴────┐
    │         │
   [8]←──────→[12]
```

Children form a circular doubly-linked list.

---

## Operations and Time Complexity

| Operation | Amortized Time | Worst Case |
|-----------|---------------|------------|
| **Find-Min** | O(1) | O(1) |
| **Insert** | O(1) | O(1) |
| **Union (Merge)** | O(1) | O(1) |
| **Extract-Min** | O(log n) | O(n) |
| **Decrease-Key** | O(1) | O(log n) |
| **Delete** | O(log n) | O(n) |

**Why so fast?**
- Lazy operations: defer work until necessary
- Amortized analysis: occasional expensive operations balanced by many cheap ones

---

## Detailed Operations

### 1. **Find-Min: O(1)**

Simply return the node pointed to by the minimum pointer.

```python
def find_min():
    return min_pointer.key
```

```
Min Pointer
    ↓
┌───3───┐     ┌───7───┐
│       │     │       │
    ↓
  Return 3
```

---

### 2. **Insert: O(1)**

Add new node to root list and update min pointer if necessary.

**Steps:**
1. Create new node
2. Add to root list
3. Update min pointer if new key < current min

**Visual:**

```
Before Insert(2):
Min → [3] ↔ [7] ↔ [18]

After Insert(2):
Min → [2] ↔ [3] ↔ [7] ↔ [18]
  ↓
  New node added, min updated
```

---

### 3. **Union (Merge): O(1)**

Merge two Fibonacci heaps by concatenating their root lists.

**Steps:**
1. Concatenate root lists
2. Update min pointer to smaller of the two minimums

**Visual:**

```
Heap 1:          Heap 2:
[3] ↔ [7]        [2] ↔ [5]

After Union:
[2] ↔ [3] ↔ [7] ↔ [5]
 ↓
Min
```

---

### 4. **Extract-Min: O(log n) amortized**

Most complex operation. Remove minimum node and restructure heap.

**Steps:**
1. Remove min node from root list
2. Add all children of min node to root list
3. **Consolidate:** Merge trees of same degree until no two trees have same degree
4. Find new minimum

**Visual Example:**

```
Step 1: Before Extract-Min
Min → [3] ↔ [7] ↔ [18]
       │     │
       5     8
       │
      12

Step 2: Remove min (3), add children to root list
[5] ↔ [7] ↔ [18]
 │     │
12     8

Step 3: Consolidate (merge trees of same degree)
Degree 0: [18]
Degree 1: [5], [7] → merge
         [5]
          │
          7
Degree 2: None

Step 4: Result after consolidation
Min → [5] ↔ [18]
       │
      ┌┴┐
      7 12
      │
      8
```

**Consolidation Process:**

```
Degree Array: [None, None, None, ...]
              idx:  0     1     2

For each tree in root list:
  - Check its degree
  - If degree slot empty: place tree there
  - If degree slot occupied: merge trees, increase degree, repeat
```

---

### 5. **Decrease-Key: O(1) amortized**

Decrease a node's key and maintain heap property.

**Steps:**
1. Decrease the key
2. If heap property violated (key < parent):
   - **Cut:** Remove node from parent, add to root list
   - If parent is marked: **Cascading Cut**
   - Mark parent if not root

**Visual Example:**

```
Step 1: Before Decrease-Key(21 → 1)
    [3]
   ┌─┴─┐
   5   10
   │
  [21]

Step 2: After decreasing 21 → 1
    [3]
   ┌─┴─┐
   5   10
   │
  [1]  ← Violates heap property! (1 < 5)

Step 3: Cut node and add to root list
[1] ↔ [3]
      ┌─┴─┐
      5*  10  ← Mark parent (5)
```

**Cascading Cut:** If marked parent loses another child, cut it too!

```
Before:
      [3]
     ┌─┴─┐
    5*   10  ← 5 is marked
    │
   [7]

Decrease-Key(7 → 0):

Step 1: Cut 7
[0] ↔ [3]
      ┌─┴─┐
     5*   10  ← 5 is marked and lost child!

Step 2: Cascading cut of 5
[0] ↔ [5] ↔ [3]
             │
            10
```

---

### 6. **Delete: O(log n) amortized**

Delete a node by decreasing its key to -∞ and then extracting min.

**Steps:**
1. Decrease-Key(node, -∞)
2. Extract-Min()

---

## Why "Fibonacci" Heap?

The Fibonacci sequence appears in the analysis of the maximum degree of any node.

### Key Theorem:

**A node with degree k has at least F_{k+2} descendants (including itself).**

Where F_i is the i-th Fibonacci number: 1, 1, 2, 3, 5, 8, 13, 21, ...

### Why This Matters:

- If a node has degree k, it has ≥ F_{k+2} descendants
- F_n ≈ φ^n / √5 (where φ = golden ratio ≈ 1.618)
- Therefore: F_{k+2} ≥ φ^k
- If tree has n nodes: n ≥ φ^k
- Solving: k ≤ log_φ(n) = O(log n)

**Conclusion:** Maximum degree is O(log n), which bounds:
- Number of trees in root list after consolidation: O(log n)
- Time for extract-min: O(log n)

---

## Python Implementation

```python
class FibonacciHeapNode:
    """Node in a Fibonacci Heap"""
    
    def __init__(self, key, value=None):
        self.key = key
        self.value = value if value is not None else key
        self.degree = 0  # Number of children
        self.mark = False  # Whether node has lost a child
        self.parent = None
        self.child = None
        self.left = self  # Circular doubly-linked list
        self.right = self
    
    def __repr__(self):
        return f"Node({self.key})"


class FibonacciHeap:
    """Min Fibonacci Heap implementation"""
    
    def __init__(self):
        self.min_node = None
        self.total_nodes = 0
    
    def is_empty(self):
        """Check if heap is empty"""
        return self.min_node is None
    
    def insert(self, key, value=None):
        """Insert a new node with given key. O(1)"""
        node = FibonacciHeapNode(key, value)
        
        # Add to root list
        if self.min_node is None:
            # First node
            self.min_node = node
        else:
            # Add to root list
            self._add_to_root_list(node)
            # Update min if necessary
            if node.key < self.min_node.key:
                self.min_node = node
        
        self.total_nodes += 1
        return node
    
    def find_min(self):
        """Return minimum key. O(1)"""
        if self.min_node is None:
            return None
        return self.min_node.key
    
    def extract_min(self):
        """Remove and return minimum node. O(log n) amortized"""
        min_node = self.min_node
        
        if min_node is None:
            return None
        
        # Add all children to root list
        if min_node.child is not None:
            child = min_node.child
            while True:
                next_child = child.right
                # Remove parent pointer
                child.parent = None
                # Add to root list
                self._add_to_root_list(child)
                
                if next_child == min_node.child:
                    break
                child = next_child
        
        # Remove min_node from root list
        self._remove_from_root_list(min_node)
        
        # Update min pointer
        if min_node == min_node.right:
            # Was the only node
            self.min_node = None
        else:
            self.min_node = min_node.right
            self._consolidate()
        
        self.total_nodes -= 1
        return min_node.key
    
    def union(self, other_heap):
        """Merge with another Fibonacci heap. O(1)"""
        if other_heap.min_node is None:
            return
        
        if self.min_node is None:
            self.min_node = other_heap.min_node
        else:
            # Concatenate root lists
            self._concatenate_lists(self.min_node, other_heap.min_node)
            # Update min
            if other_heap.min_node.key < self.min_node.key:
                self.min_node = other_heap.min_node
        
        self.total_nodes += other_heap.total_nodes
    
    def decrease_key(self, node, new_key):
        """Decrease key of a node. O(1) amortized"""
        if new_key > node.key:
            raise ValueError("New key is greater than current key")
        
        node.key = new_key
        parent = node.parent
        
        # If heap property violated
        if parent is not None and node.key < parent.key:
            self._cut(node, parent)
            self._cascading_cut(parent)
        
        # Update min if necessary
        if node.key < self.min_node.key:
            self.min_node = node
    
    def delete(self, node):
        """Delete a node. O(log n) amortized"""
        self.decrease_key(node, float('-inf'))
        self.extract_min()
    
    # Helper methods
    
    def _add_to_root_list(self, node):
        """Add node to root list"""
        if self.min_node is None:
            self.min_node = node
            node.left = node
            node.right = node
        else:
            # Insert to the right of min_node
            node.left = self.min_node
            node.right = self.min_node.right
            self.min_node.right.left = node
            self.min_node.right = node
    
    def _remove_from_root_list(self, node):
        """Remove node from root list"""
        if node == node.right:
            # Only node in list
            return
        node.left.right = node.right
        node.right.left = node.left
    
    def _concatenate_lists(self, list1, list2):
        """Concatenate two circular doubly-linked lists"""
        # Connect list1's right to list2
        list1_right = list1.right
        list2_left = list2.left
        
        list1.right = list2
        list2.left = list1
        
        list1_right.left = list2_left
        list2_left.right = list1_right
    
    def _consolidate(self):
        """Consolidate trees in root list so no two have same degree"""
        # Maximum degree is O(log n)
        max_degree = int(self.total_nodes ** 0.5) + 1
        degree_table = [None] * max_degree
        
        # Collect all roots
        roots = []
        current = self.min_node
        if current is not None:
            while True:
                roots.append(current)
                current = current.right
                if current == self.min_node:
                    break
        
        # Consolidate
        for root in roots:
            degree = root.degree
            
            # Merge with trees of same degree
            while degree < max_degree and degree_table[degree] is not None:
                other = degree_table[degree]
                
                # Make sure root has smaller key
                if root.key > other.key:
                    root, other = other, root
                
                # Link other under root
                self._link(other, root)
                degree_table[degree] = None
                degree += 1
            
            if degree < max_degree:
                degree_table[degree] = root
        
        # Rebuild root list and find new min
        self.min_node = None
        for root in degree_table:
            if root is not None:
                if self.min_node is None:
                    self.min_node = root
                    root.left = root
                    root.right = root
                else:
                    self._add_to_root_list(root)
                    if root.key < self.min_node.key:
                        self.min_node = root
    
    def _link(self, child, parent):
        """Make child a child of parent"""
        # Remove child from root list
        self._remove_from_root_list(child)
        
        # Make child a child of parent
        child.parent = parent
        if parent.child is None:
            parent.child = child
            child.left = child
            child.right = child
        else:
            # Add to parent's child list
            child.left = parent.child
            child.right = parent.child.right
            parent.child.right.left = child
            parent.child.right = child
        
        parent.degree += 1
        child.mark = False
    
    def _cut(self, node, parent):
        """Cut node from parent and add to root list"""
        # Remove node from parent's child list
        if node == node.right:
            # Only child
            parent.child = None
        else:
            if parent.child == node:
                parent.child = node.right
            node.left.right = node.right
            node.right.left = node.left
        
        parent.degree -= 1
        
        # Add to root list
        node.parent = None
        node.mark = False
        self._add_to_root_list(node)
    
    def _cascading_cut(self, node):
        """Perform cascading cut"""
        parent = node.parent
        
        if parent is not None:
            if not node.mark:
                # First child lost, mark it
                node.mark = True
            else:
                # Already marked, cut it
                self._cut(node, parent)
                self._cascading_cut(parent)
    
    def display(self):
        """Display the heap structure (for debugging)"""
        if self.min_node is None:
            print("Empty heap")
            return
        
        print(f"Min: {self.min_node.key}")
        print("Root list:")
        self._display_node(self.min_node, "", True)
    
    def _display_node(self, node, prefix, is_root_list):
        """Helper to display tree structure"""
        if node is None:
            return
        
        start = node
        while True:
            mark = "*" if node.mark else ""
            print(f"{prefix}└─ {node.key}{mark} (deg={node.degree})")
            
            if node.child is not None:
                self._display_node(node.child, prefix + "   ", False)
            
            node = node.right
            if node == start:
                break
            if is_root_list:
                print(f"{prefix}")
```

---

## Usage Examples

### Example 1: Basic Operations

```python
# Create heap
fib_heap = FibonacciHeap()

# Insert elements
fib_heap.insert(10)
fib_heap.insert(5)
fib_heap.insert(20)
fib_heap.insert(3)
fib_heap.insert(15)

print("Min:", fib_heap.find_min())  # Output: 3

# Extract minimum
min_val = fib_heap.extract_min()
print("Extracted:", min_val)  # Output: 3
print("New min:", fib_heap.find_min())  # Output: 5
```

### Example 2: Decrease Key

```python
fib_heap = FibonacciHeap()

# Insert and keep references
node1 = fib_heap.insert(10)
node2 = fib_heap.insert(20)
node3 = fib_heap.insert(30)

print("Min before:", fib_heap.find_min())  # Output: 10

# Decrease key
fib_heap.decrease_key(node2, 5)
print("Min after decrease:", fib_heap.find_min())  # Output: 5
```

### Example 3: Union (Merge)

```python
heap1 = FibonacciHeap()
heap1.insert(1)
heap1.insert(5)
heap1.insert(9)

heap2 = FibonacciHeap()
heap2.insert(2)
heap2.insert(6)
heap2.insert(10)

# Merge heaps
heap1.union(heap2)
print("Min after union:", heap1.find_min())  # Output: 1
```

### Example 4: Using in Prim's Algorithm

```python
def prims_with_fibonacci_heap(graph):
    """Prim's MST algorithm using Fibonacci Heap"""
    fib_heap = FibonacciHeap()
    node_refs = {}  # Map vertex to heap node
    visited = set()
    mst_edges = []
    total_cost = 0
    
    # Start from vertex 0
    start = 0
    node_refs[start] = fib_heap.insert(0, start)
    parent = {start: None}
    
    while not fib_heap.is_empty():
        # Extract minimum
        min_key = fib_heap.extract_min()
        
        # Find which vertex this was
        current = None
        for vertex, node in node_refs.items():
            if vertex not in visited and node.key == min_key:
                current = vertex
                break
        
        if current is None:
            continue
        
        visited.add(current)
        
        if parent[current] is not None:
            mst_edges.append((parent[current], current))
            total_cost += min_key
        
        # Update neighbors
        for neighbor, weight in graph[current]:
            if neighbor not in visited:
                if neighbor not in node_refs:
                    node_refs[neighbor] = fib_heap.insert(weight, neighbor)
                    parent[neighbor] = current
                elif weight < node_refs[neighbor].key:
                    fib_heap.decrease_key(node_refs[neighbor], weight)
                    parent[neighbor] = current
    
    return mst_edges, total_cost
```

---

## Comparison with Other Heaps

| Operation | Binary Heap | Binomial Heap | Fibonacci Heap |
|-----------|-------------|---------------|----------------|
| **Find-Min** | O(1) | O(1) | O(1) |
| **Insert** | O(log n) | O(log n) | **O(1)** |
| **Extract-Min** | O(log n) | O(log n) | O(log n) |
| **Decrease-Key** | O(log n) | O(log n) | **O(1)** |
| **Delete** | O(log n) | O(log n) | O(log n) |
| **Union** | O(n) | O(log n) | **O(1)** |

### Why Fibonacci Heap is Faster:

1. **Lazy Consolidation:** Defer tree merging until extract-min
2. **Lazy Decrease-Key:** Just cut and add to root list
3. **Amortized Analysis:** Expensive operations are rare

---

## When to Use Fibonacci Heaps

### ✅ **Use Fibonacci Heaps When:**

1. **Decrease-key is frequent** (e.g., Dijkstra's, Prim's algorithms)
2. **Large datasets** where constant factors don't matter
3. **Theoretical optimality** is important
4. **Many insert/union operations**

### ❌ **Don't Use Fibonacci Heaps When:**

1. **Simple applications** - binary heap is easier
2. **Small datasets** - overhead not worth it
3. **Extract-min is the dominant operation**
4. **Memory is limited** - more pointers = more memory
5. **Practical performance matters** - hidden constants are large

### Real-World Usage:

- **Academic/Theoretical:** Yes, widely studied
- **Production Code:** Rarely used due to complexity
- **Better Alternative:** Pairing heaps (similar performance, simpler)

---

## Complexity Analysis Summary

### Time Complexities (Amortized):

| Operation | Cost | Reason |
|-----------|------|--------|
| Insert | O(1) | Just add to root list |
| Find-Min | O(1) | Maintain min pointer |
| Union | O(1) | Concatenate root lists |
| Extract-Min | O(log n) | Consolidation needed |
| Decrease-Key | O(1) | Cut and add to root list |
| Delete | O(log n) | Decrease to -∞ + extract |

### Space Complexity:

- **O(n)** where n = number of nodes
- Each node has ~7 pointers (more than binary heap's 2)

---

## Advantages and Disadvantages

### ✅ Advantages:

1. **Best theoretical complexity** for many operations
2. **O(1) decrease-key** - crucial for graph algorithms
3. **O(1) union** - useful for merging priority queues
4. **Flexible structure** - adapts to usage patterns

### ❌ Disadvantages:

1. **Complex implementation** - many edge cases
2. **Large constant factors** - slower in practice for small n
3. **High memory overhead** - many pointers per node
4. **Poor cache performance** - pointer chasing
5. **Not cache-friendly** - scattered memory access

---

## Key Takeaways

1. **Fibonacci heaps are theoretically optimal** for many priority queue operations
2. **O(1) decrease-key** makes them ideal for graph algorithms like Dijkstra and Prim
3. **Lazy evaluation** defers work, giving better amortized complexity
4. **Complex to implement** - use existing libraries in practice
5. **Fibonacci numbers bound the maximum degree** - hence the name
6. **In practice**, simpler heaps often perform better due to cache effects

---

## Further Reading

- **Original Paper:** Fredman & Tarjan (1987) - "Fibonacci Heaps and Their Uses in Improved Network Optimization Algorithms"
- **CLRS (Introduction to Algorithms):** Chapter 19 - Fibonacci Heaps
- **Advanced Data Structures:** MIT OCW 6.851

---

## Conclusion

Fibonacci heaps are a beautiful example of how **lazy evaluation** and **amortized analysis** can lead to better theoretical performance. While rarely used in practice due to implementation complexity and constant factors, they remain important in:

- Theoretical algorithm analysis
- Understanding amortized complexity
- Graph algorithms (Dijkstra, Prim)
- Academic research

For most practical applications, use **binary heaps** or **pairing heaps** instead!
