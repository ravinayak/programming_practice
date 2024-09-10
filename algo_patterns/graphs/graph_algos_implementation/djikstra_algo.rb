# frozen_string_literal: true

require_relative '../../data_structures/queue'
require_relative '../../heap/min_binary_heap'
require_relative '../graph'

# Djikstra's algorithm implementation
def djikstras(graph:, source_node:, destination_node:)
  Queue.new
  visited = {}

  distance = Hash.new { |h, k| h[k] = Float::INFINITY }
  distance[source_node] = 0

  min_heap = MinBinaryHeap.build_min_heap(arr: [], heap_size: 0)
  min_heap.insert_key(key: source_node)

  until min_heap.empty?
    # Extract minimum element from min-heap
    node = min_heap.extract_min
    # if this node has been processed, all the neighbors
    # of this node have been udpated for minimum distance
    # from the source node, hence we can skip it
    next if visited[node]

    graph.adj_matrix[node]&.each do |neighbor_weight|
      neighbor, weight = neighbor_weight
      # If current distance of neighbor is less than the
      # distance of current node from source + weight of
      # the edge from current node to neighbor, then the
      # neighbor has already been udpated for minimum
      # distance, putting it into min-heap is only going
      # to result in Redundant Work. We skip updating
      # the distance of neighbor and inserting into
      # min-heap
      if distance[neighbor] > distance[node] + weight
        distance[neighbor] = distance[node] + weight
        min_heap.insert_key(key: neighbor)
      end
    end
  end

  distance[destination_node]
end

def shortest_path_data
  adj_matrix_one = {
    0 => [[1, 1], [2, 1]],
    1 => [[0, 1], [3, 5], [6, 8]],
    2 => [[0, 1], [3, 1]],
    3 => [[1, 5], [2, 1], [4, 5]],
    4 => [[3, 5], [5, 4]],
    5 => [[4, 4]],
    6 => [[1, 8], [5, 10]]
  }
  vertices_one = [0, 1, 2, 3, 4, 5, 6]

  adj_matrix_two = {
    0 => [[1, 1], [2, 3]],
    1 => [[0, 1], [4, 5], [3, 1]],
    2 => [[0, 4], [4, 1]],
    3 => [[1, 1], [5, 8]],
    4 => [[1, 5], [2, 1], [5, 1]],
    5 => [[4, 1], [3, 8]]
  }
  vertices_two = [0, 1, 2, 3, 4, 5]

  [
    {
      adj_matrix: adj_matrix_one,
      vertices: vertices_one
    },
    {
      adj_matrix: adj_matrix_two,
      vertices: vertices_two
    }
  ]
end

def shortest_dist_arr
  graph = []

  shortest_path_data.each do |adj_matrix_vertex_hsh|
    adj_matrix = adj_matrix_vertex_hsh[:adj_matrix]
    vertices = adj_matrix_vertex_hsh[:vertices]

    graph << Graph.new(adj_matrix:, vertices:)
  end

  [
    {
      graph: graph[0],
      output: 11,
      same_weights: true
    },
    {
      graph: graph[1],
      output: 5,
      same_weights: false
    }
  ]
end

def test
  shortest_dist_arr.each do |graph_hsh|
    graph = graph_hsh[:graph]
    output = graph_hsh[:output]
    result = djikstras(graph:, source_node: 0, destination_node: 5)

    str = ' Expected Distance between nodes 0 and node 5 :: '
    puts "#{str}#{output}, Result :: #{result}"
  end
end

test
