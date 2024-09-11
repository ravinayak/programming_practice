# frozen_string_literal: true

require_relative '../../priority_queue/priority_queue_min_heap'
require_relative '../graph'
# Prims algorithm works for undirected graphs without
# negative edge weights, this is because it chooses
# edge with least weight from priority queue, and if
# negative weights are involved, it may make a non
# optimal choice. For -ve weights, use Kruskals algo

# Prims algorithm works only for undirected Graphs
# like Kruskals algo. The concept of Spanning Tree
# itself applies to undirected Graphs, because for
# a Spanning Tree to be defined, the graph must be
# connected, and Directed Graphs do not have the
# same connectivity

# Prims algo constructs a MST by choosing a NEW VERTEX
# with the minimum edge weight which connects this
# vertex to already included vertices in MST. It uses
# GREEDY APPROACH

# Time Complexity: O(E log V)
# Prims algo works by constructing a min-heap from the
# edges of a vertex
# adj_matrix[vertex] => Edges are inserted into Min Heap
# At any point in time, only "V" edges are possible for
# the Given Vertex, hence O(log V) time would be taken
# This process can iterate over max edges => E
# O(E log V)

# Time Complexity Breakdown:

# 1.Priority Queue (Min-Heap) Operations:
#  • Insertions and updates to the priority queue take
#  O(log V) time per operation, because inserting into
#  or updating a priority queue involves reordering the heap.
#  • Extracting the minimum edge also takes O(log V) time
#  because you must remove the smallest element and restore
#  the heap property. The heap contains up to V vertices at
#  any given time.
# 2. Processing Edges:
#  • Every vertex is connected to some number of edges. In
#  the worst case, the graph is dense, and the number of edges
#  is proportional to E.
#  • For each vertex added to the MST, the algorithm examines
#  its adjacent edges. There are E edges in total in the graph.
# 3. Overall Time Complexity:
#  • The algorithm processes V vertices, and for each vertex,
#  it performs an extract-min operation from the heap, which
#  takes O(log V). This gives a total cost of V * O(log V) for
#  extracting the minimum vertex.
#  • For each edge examined, we perform an insert/update operation
#  in the heap, which takes O(log V). Since the algorithm examines
#  E edges in total, this gives a total cost of E * O(log V) for
#  edge insertions and updates.

# Combined Time Complexity:

#  • The time complexity for extracting vertices is O(V log V).
#  • The time complexity for processing edges is O(E log V).

# Since E is typically larger than or equal to V (because a connected
#  graph must have at least V - 1 edges), the dominant term is O(E log V).

# Algorithm: In order to extract the edge with minimum weight for a given
# vertex, we use MinHeap data strcuture in Prims Algorithm implementation
# Step 1: Choose any random vertex, assign it a cost of 0 and push it in
# MinHeap
# Step 2: Data Structures:
#   a. MST [] => Array holds all the vertices which are in Min
#   Spanning Tree
#   b. min_heap => Maintains edges with least possible weights
#   from extracted node to neighbors such that neighbor is not
#   present in MST. This is because we will choose the next node
#   to process from MinHeap
#   c. AdjacencyMatrix => Maintains an array of Tuples for each
#   vertex, where tuple consists of [neighbor, weight] and
#   represents edge from vertex to neighbor with "weight"
#   d. Edges => Array which holds all the Edges in MST
# Step 3: Repeat the loop until MinHeap is empty
# Step 4: Extract Min Element from MinHeap
# Step 5: If this vertex is included in MST array, skip processing
# Step 6: If this vertex has a cost > 0, push it in the edges array,
#   this is to skip start node which has a fake (random) weight
#   assigned to it
# Step 7: Include this vertex in MST, since it is being processed
# Step 8: Process adjacency matrix for this vertex, and look at each
#   vertex in the array of tuples [neighbor, weight]. If
#   neighbor is present in MST, this edge is skipped. If we
#   include an edge with a neighbor that is already present in
#   MST, it will be extracted and simply skipped in next iteration
#   This saves redundant work

def prims_algo(graph:)
  graph.vertices.length

  mst_edges = []
  mst_vertices = []
  pq_min_heap = PriorityQueueMinHeap.new(arr: [], heap_size: 0)

  obj = { element: graph.vertices[0], key: 0 }
  pq_min_heap.insert_object(object: obj)

  until pq_min_heap.empty?
    min_element = pq_min_heap.extract_min
    vertex, cost = min_element.values_at(:element, :key)

    next if mst_vertices.include?(vertex)

    mst_edges << [vertex, cost] if cost.positive?
    mst_vertices << vertex

    graph.adj_matrix[vertex].each do |neighbor_weight|
      neighbor, weight = neighbor_weight
      next if mst_vertices.include?(neighbor)

      obj = { element: neighbor, key: weight }
      pq_min_heap.insert_object(object: obj)
    end
  end

  total_cost = mst_edges.reduce(0) do |sum, neighbor_weight|
    sum + neighbor_weight[1]
  end

  # Return MST Edges
  [mst_edges, total_cost]
end

def graph
  adj_matrix = {
    0 => [[1, 10], [2, 6], [3, 5]],
    1 => [[0, 10], [3, 15]],
    2 => [[0, 6], [3, 4]],
    3 => [[0, 5], [1, 15], [2, 4]]
  }
  vertices = [0, 1, 2, 3]
  Graph.new(vertices:, adj_matrix:)
end

def test
  mst_edges, total_cost = prims_algo(graph:)
  puts "MST Edges :: #{mst_edges.inspect}"
  puts "Total Cost :: #{total_cost}"
end

test
