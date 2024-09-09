# frozen_string_literal: true

require_relative '../../data_structures/queue'
require_relative '../graph'
# BFS traversal of a Graph to find the shortest path between 2 nodes
# and to find if a graph is connected

# Find the shortest path between nodes "0" and "3"
# 0 ---- 1
# |      | \
# |      |  \
# 4 ---- 3 -- 2
def shortest_distance(node1:, node2:, graph:)
  queue = Queue.new
  queue.enqueue(data: node1)
  visited = {}

  distance = Hash.new { |h, k| h[k] = Float::INFINITY }
  distance[node1] = 0

  until queue.empty?
    node = queue.dequeue
    visited[node] = true

    graph.adj_matrix[node].each do |neighbor|
      distance[neighbor] = distance[node] + 1 if distance[node] + 1 < distance[neighbor]
      break if neighbor == node2

      queue.enqueue(data: neighbor) unless visited[neighbor]
    end
  end

  distance[node2]
end

def connectivity_check(graph:)
  visited = {}

  queue = Queue.new
  queue.enqueue(data: graph.vertices[0])

  until queue.empty?
    vertex = queue.dequeue
    visited[vertex] = true

    graph.adj_matrix[vertex].each do |neighbor|
      queue.enqueue(data: neighbor) unless visited[neighbor]
    end
  end

  graph.vertices.each do |neighbor|
    return false unless visited[neighbor]
  end

  # Graph is connected if all vertices were visited
  true
end

def test_connectivity
  graph_arr = [
    {
      graph: Graph.connected_undirected_graph,
      output: true
    },
    {
      graph: Graph.disconnected_undirected_graph,
      output: false
    }
  ]

  graph_arr.each do |graph_hsh|
    graph = graph_hsh[:graph]
    output = graph_hsh[:output]
    result = connectivity_check(graph:)

    puts " Expected Output :: #{output}, Result :: #{result}"
  end

  str = ' Expected Distance between nodes 0 and node 2 :: 2'
  graph = graph_arr[0][:graph]
  result = shortest_distance(node1: 0, node2: 2, graph:)
  puts "#{str}, Result :: #{result}"
end

test_connectivity
