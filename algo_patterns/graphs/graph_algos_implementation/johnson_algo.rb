# frozen_string_literal: true

# Breakdown of Dijkstra’s Complexity in Johnson’s Algorithm:

#   • Dijkstra’s algorithm for finding the shortest paths from a single
#   source has a time complexity of O((V + E)log V), where:
#   • E is the number of edges.
#   • V is the number of vertices.
#   • In Johnson’s Algorithm, you run Dijkstra’s algorithm from each
#   vertex in the graph, so the complexity becomes V * O((V + E log V)).

# Thus, for all vertices, the complexity of the Dijkstra part is:

# V * O((V + E log V))

# Overall Time Complexity of Johnson’s Algorithm:

# Johnson’s algorithm consists of two major steps:

#   1.  Bellman-Ford Algorithm to reweight the graph.
#   2.  Dijkstra’s Algorithm for each vertex.

# 1. Bellman-Ford Step: O(V * E)

#   • Bellman-Ford is run from the new vertex q, which takes O(V * E)
#   time.
#   • This part computes the reweighting function h(v) for each vertex
#   and detects if there are any negative-weight cycles.

# 2. Dijkstra’s Algorithm for Each Vertex: O(V * ((V + E) log V))

#   • After reweighting the graph, Dijkstra’s algorithm is run V times
#   (once for each vertex) to compute the shortest paths for all pairs.
#   • Each run of Dijkstra’s algorithm has time complexity O((V + E) log V),
#   so the total time complexity for running Dijkstra V times is:

# O(V * ((V + E) * log V))

# Combining the Two Steps:

# To get the total time complexity of Johnson’s algorithm, we combine
# the two main steps:

#   1. Bellman-Ford step: O(V * E)
#   2. Dijkstra’s step: O(V * ((V + E) log V))

# Thus, the overall time complexity is:

# O(V * E) + O(V * ((V + E) * log V)) = O(V * E + V^2 log V + V * E * log V)

# Now, depending on the structure of the graph, we get two cases:

#   1. For Sparse Graphs:
#   • If the graph is sparse, E ≈ V, so the total time complexity becomes:

# O(V^2 + V^2 * log V + V^2 * log V) = O(V^2 * log V)

#   2.  For Dense Graphs:
#   • If the graph is dense, E ≈ V^2, so the total time complexity becomes:

# O(V * V^2 + V * V^2 * log V + V * V^2 * log V) = O(V^3 + V^3 * log V) = O(V^3 * log V)

# Why is the Overall Complexity Often Written as O(V² log V + V * E * log V)?

# The actual complexity is: O(V * E + V² log V + V * E * log V)

# We can factor this expression:
#   O(V * E + V² log V + V * E * log V)
#   = O(V * E + (V² + V * E) * log V)
#   = O(V * E + V * (V + E) * log V)

# Now, depending on the structure of the graph:

#   • Sparse Graphs (E ≈ V): 
#     O(V² + V² log V + V² log V) = O(V² log V)
#     Here, V * E ≈ V², and V * E * log V ≈ V² log V, so V² log V dominates.

#   • Dense Graphs (E ≈ V²):
#     O(V³ + V² log V + V³ log V) = O(V³ log V)
#     Here, V * E ≈ V³, and V * E * log V ≈ V³ log V, so V³ log V dominates.

# Why the Common Expression O(V² log V + V * E * log V)?

# The expression O(V² log V + V * E * log V) is more accurate because:
#   • It correctly captures O(V² log V) for sparse graphs.
#   • It correctly captures O(V³ log V) for dense graphs (since V * E * log V = V³ log V when E ≈ V²).

# Alternative Expression: O(V * (V + E) * log V)
#   This is equivalent and sometimes preferred because it clearly shows:
#   • V iterations (one per vertex)
#   • Each iteration: O((V + E) * log V) for Dijkstra's algorithm

# Final Conclusion:

#   • The accurate time complexity is: O(V * E + V² log V + V * E * log V)
#   • This can be expressed as: O(V² log V + V * E * log V)
#   • Or equivalently: O(V * (V + E) * log V)
#   • For sparse graphs: O(V² log V)
#   • For dense graphs: O(V³ log V)
#   • Note: The expression O(V² log V + V * E) is INCORRECT because it misses
#     the log V factor in the V * E * log V term, which is significant for dense graphs.

require_relative 'djikstra_algo'
require_relative 'bellman_ford'
require_relative '../graph'

def johnson_algo(graph:)
  q = graph.vertices.length
  new_graph = prep_new_graph_with_q(graph:, q:)

  # Run Bellman Ford algorithm
  h, _cycle = bellman_ford(graph: new_graph, source: q)
  return nil if h.nil?

  reweighted_graph = prep_reweighted_graph(graph:, h:)

  all_pairs_shortest_paths = {}

  djikstra_algo_for_vertices(graph:, reweighted_graph:, all_pairs_shortest_paths:)

  readjust_weights(all_pairs_shortest_paths:, h:)

  # Return all pairs of shortest paths
  all_pairs_shortest_paths
end

def prep_new_graph_with_q(graph:, q:)
  new_graph =
    Graph.new(vertices: graph.vertices + [q])
  adj_matrix = {}

  # Add new vertex q with outgoing edges to all other vertices
  adj_matrix[q] = graph.vertices.map { |u| [u, 0] }

  # Deep copy the rest of the adjacency matrix
  graph.vertices.each do |u|
    adj_matrix[u] = graph.adj_matrix[u].map(&:dup) unless
       graph.adj_matrix[u].nil?
  end

  new_graph.adj_matrix = adj_matrix

  # Return new graph
  new_graph
end

def prep_reweighted_graph(graph:, h:)
  # Create reweighted graph
  reweighted_graph = Graph.new(vertices: graph.vertices.dup)
  graph.adj_matrix.each_pair do |u, neighbor_weight_tuples|
    tuples_arr = []
    neighbor_weight_tuples.each do |v, weight|
      new_weight = weight + h[u] - h[v]
      tuples_arr << [v, new_weight]
    end

    reweighted_graph.adj_matrix[u] = tuples_arr
  end

  # Return reweighted graph
  reweighted_graph
end

def djikstra_algo_for_vertices(graph:, reweighted_graph:, all_pairs_shortest_paths:)
  # Run Djikstras algo for each vertices
  graph.vertices.each do |vertex|
    destination_node = graph.vertices.reject { |u| u == vertex }[0]
    _d, distance =
      djikstras(graph: reweighted_graph, source_node: vertex,
                destination_node:)
    all_pairs_shortest_paths[vertex] = distance
  end
end

def readjust_weights(all_pairs_shortest_paths:, h:)
  # Adjust distances based on the reweighting function 'h'
  all_pairs_shortest_paths.each do |u, distance_hsh|
    distance_hsh.each_pair do |v, distance|
      all_pairs_shortest_paths[u][v] += h[v] - h[u] if distance < Float::INFINITY
    end
  end
end

def prep_graph
  vertices = [0, 1, 2, 3]
  adj_matrix = {
    0 => [[1, 4], [2, 5]],
    1 => [[3, 2]],
    2 => [[1, -6]],
    3 => [[2, 5]]
  }

  Graph.new(vertices:, adj_matrix:)
end

def test
  graph = prep_graph
  res = johnson_algo(graph:)
  res.each_key do |vertex|
    puts " From vertex #{vertex}:"
    res[vertex].each do |v, weight|
      wt = weight == Float::INFINITY ? 'Unreachable' : weight
      puts "#{vertex} -> #{v}: #{wt}"
    end
    puts
  end
end

test
