# frozen_string_literal: true

# Time Complexity:  O(V^3), where V is the number of vertices.
# Space Complexity: O(V^2), 2D array to hold distance for each
#                   pair of vertices (i, j)
# Handling Negative Edge Weights:

# Negative Cycle Detection: If graph has a cycle where the sum
# of all edge weights in the cycle is negative, it cannot be
# handled by Floyd-Warshall algorithm. However, it can be detected
# by the algorithm. In case of negative Weight Cycle, this algorithm
# cannot compute distance of nodes correctly.
# Floyd-Warshall can handle negative edge weights, but if there’s a
# negative weight cycle (a cycle where the sum of the edge weights is
# negative), the algorithm cannot properly compute the shortest paths.
# To detect negative cycles, after running the algorithm, you check if
# any dist[i][i] < 0 for any vertex i. If this happens, it indicates
# that there is a negative cycle in the graph.

# Floyd Warshall Algorithm expects the adjacency matrix to be a 2D
# matrix where each pair of vertices (i, j) has some weight assigned
# it if there is an edge between (i, j)
# adj_matrix[i][j] = weight (if there is an edge between "i" and "j")
# adj_matrix[i][j] = nil (if there is no edge between "i" and "j")

# Graph class to handle adjacent matrix in the form of 1s and 0s
class Graph
  attr_accessor :adj_matrix

  def initialize(adj_matrix:)
    @adj_matrix = adj_matrix
  end
end

def floyd_warhsall(graph:)
  n = graph.adj_matrix.length

  # Below will create an Array of size "n", where each element of the
  # array will be initialized to an array of size "n" with a default
  # value of 0
  # Array.new(3, Array.new(3, 0)) => [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
  # Array.new(n, Array.new(n, 0))

  # NOTE: But there is a HUGE PROBLEM WITH THIS APPROACH. It creates a
  # SHALLOW COPY
  # This approach initializes a 2D array by creating one inner array
  # (Array.new(n)) and then assigning the same inner array reference to
  # each row of the outer array.
  # If any element of the outer array changes elements in the sub array
  # sub-arrays of all elements will be changed leading to UnIntended
  # Behavior
  #
  # DO NOT USE THIS => distance = Array.new(n, Array.new(n))

  # Below CREATES => Unique Inner Arrays
  # This approach initializes the 2D array using a block. The block is
  # evaluated separately for each row, ensuring that each row gets a new,
  # independent inner array.
  distance = Array.new(n) { Array.new(n) }

  initialize_distance(graph:, distance:)
  compute_distance(distance:, n:)

  [distance, negative_cycle?(distance:, n:)]
end

def negative_cycle?(distance:, n:)
  (0...n).each do |i|
    return true if (distance[i][i]).negative?
  end

  false
end

def compute_distance(distance:, n:)
  # Outer Loop is the intermediary vertex
  (0...n).each do |k|
    (0...n).each do |i|
      (0...n).each do |j|
        # Skip if either path segment is unreachable
        next if distance[i][k] == Float::INFINITY || distance[k][j] == Float::INFINITY

        # Path from vertex "i" to vertex "j" through the intermediary
        # vertex "k" is shorter than current path distance
        distance[i][j] = distance[i][k] + distance[k][j] if distance[i][j] > distance[i][k] + distance[k][j]
      end
    end
  end
end

def initialize_distance(graph:, distance:)
  n = graph.adj_matrix.length

  (0...n).each do |i|
    (0...n).each do |j|
      # Distance of a node from itself is 0
      if i == j
        distance[i][j] = 0
      elsif graph.adj_matrix[i][j].nil?
        # No edge exists between vertex "i" and "j
        distance[i][j] = Float::INFINITY
      else
        # Edge exists between vertex "i" and "j"
        distance[i][j] = graph.adj_matrix[i][j]
      end
    end
  end
end

def test
  # Graph as adjacency matrix
  # nil represents no direct edge between two vertices
  adj_matrix = [
    [0, 3, nil, 7],
    [8, 0, 2, nil],
    [5, nil, 0, 1],
    [2, nil, nil, 0]
  ]
  graph = Graph.new(adj_matrix:)

  distance, negative_cycle = floyd_warhsall(graph:)

  puts "Adjacency Matrix Input :: #{adj_matrix.inspect}"
  puts "Floyd Warshall Distance Computation :: #{distance.inspect}"
  puts "Negative Cycle Exists :: #{negative_cycle}"
end

test
