# frozen_string_literal: true

require_relative '../graph'
# Time Complexity: O(V * E)
#     => Less efficient than Dijkstra’s algorithm for
#        large graphs but more flexible due to its
#        ability to handle negative weights

# Space Complexity: O(V)

# Bellman Ford finds distance of all vertices from
# source. It handles both
# a. Directed Graph
# b. Undirected Graph
# c. Negative weights
# d. Detects Negative Cycles
# If there is a -ve cycle in connected component of
# a Graph, no distance can be found, since every time
# we move in the negative cycle, the distance will be
# decreased, meaning the distance will be -ve Infinity

# @param [Graph] graph
# @param [Integer] source
def bellman_ford(graph:, source:)
  n = graph.vertices.length

  # Initialize distance of all vertices to Infinity
  distance = Array.new(n, Float::INFINITY)

  # Bellman Ford algorithm finds distance of all
  # vertices in Graph from source
  distance[source] = 0

  relax_edges(graph:, distance:)

  return negative_cycle_use_case if
    negative_cycle_exists?(graph:, distance:)

  [distance, false]
end

def negative_cycle_use_case
  puts ' Negative Cycle detected in graph'
  [nil, true]
end

# @param [Graph] graph
# @param [Array<Integer>] distance
def relax_edges(graph:, distance:)
  n = graph.vertices.length

  # Relax edges n-1 times which is |V-1| times
  # since "n" is the number of vertices
  # (0...n) is incorrect because it runs from
  # 0 to n-1 which is "n" times, to run it "n-1"
  # times, we should use (0...n-1) which will run
  # from 0 to n-2 which is n-1, it is simpler to
  # simply use (n-1).times
  (n - 1).times do
    # Adjacency matrix contains tuples which are
    # [vertex, weight] for each edge from vertex u
    # as the key. Contains an array of tuples which
    # represents the edges from vertex "u" to other
    # vertices with their weights
    graph.adj_matrix.each_pair do |u, neighbor_weight|
      # v, weight is the tuple which is split into
      # vertex and weight
      neighbor_weight.each do |v, weight|
        # current distance of vertex "u" from source
        # is greater than the distance of vertex "u"
        # from source + weight. We found a shorter
        # path to reach vertex "v" from source
        distance[v] = distance[u] + weight if
          distance[u] + weight < distance[v]
      end
    end
  end
end

# Relax edges in the graph 1 more time, if the distance
# of any vertex from source decreases in this iteration
# it means there is a negative cycle in the graph
# @param [Graph] graph
# @param [Integer] source
def negative_cycle_exists?(graph:, distance:)
  graph.adj_matrix.each_pair do |u, neighbor_weight|
    # v, weight is the tuple which is split into
    # vertex and weight
    neighbor_weight.each do |v, weight|
      # If distance of a vertex still decreases, there
      # is a negative cycle in the graph
      return true if distance[u] + weight < distance[v]
    end
  end

  # No Negative Cycle detected
  false
end

def directed_graph
  adj_matrix = {
    0 => [[1, 6], [2, 4]], # Vertex 0 has edges to 1 with weight 6 and to 2 with weight 4
    1 => [[3, 2], [2, 3]],  # Vertex 1 has edges to 3 with weight 2 and to 2 with weight 3
    2 => [[3, 1]],          # Vertex 2 has an edge to 3 with weight 1
    3 => []                 # Vertex 3 has no outgoing edges
  }
  vertices = [0, 1, 2, 3]
  Graph.new(vertices:, adj_matrix:)
end

def negative_cycle_graph
  adj_matrix = {
    0 => [[1, 1]], # Vertex 0 has an edge to 1 with weight 1
    1 => [[2, 1], [0, -4]], # Vertex 1 has an edge to 2 with weight 1 and a back edge to 0 with weight -4
    2 => [] # Vertex 2 has no outgoing edges
  }
  vertices = [0, 1, 2]
  Graph.new(vertices:, adj_matrix:)
end

def undirected_graph
  adj_matrix = {
    0 => [[1, 4], [2, 1]], # Vertex 0 has an edge to 1 with weight 4 and an edge to 2 with weight 1
    1 => [[0, 4], [3, 2]],  # Vertex 1 has an edge to 0 with weight 4 and to 3 with weight 2
    2 => [[0, 1], [3, 3]],  # Vertex 2 has an edge to 0 with weight 1 and to 3 with weight 3
    3 => [[1, 2], [2, 3]]   # Vertex 3 has edges to 1 with weight 2 and to 2 with weight 3
  }
  vertices = [0, 1, 2, 3]
  Graph.new(vertices:, adj_matrix:)
end

def graph_arr
  [
    {
      graph: directed_graph,
      negative_cycle: false,
      distance: [0, 6, 4, 5]
    },
    {
      graph: negative_cycle_graph,
      negative_cycle: true,
      distance: nil
    },
    {
      graph: undirected_graph,
      negative_cycle: false,
      distance: [0, 4, 1, 4]
    }
  ]
end

def test
  graph_arr.each do |graph_hsh|
    graph = graph_hsh[:graph]
    negative_cycle = graph_hsh[:negative_cycle]
    distance = graph_hsh[:distance]
    result_distance, result_neg_cycle = bellman_ford(graph:, source: 0)

    print "\n Input Graph :: #{graph.adj_matrix.inspect}\n"
    print " Expected Negative cycle :: #{negative_cycle}, "
    print " Distance :: #{distance.inspect} \n"
    print " Result Negative Cycle :: #{result_neg_cycle},"
    print " Result Distance:: #{result_distance.inspect} \n\n"
  end
end

test
