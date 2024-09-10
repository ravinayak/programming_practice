# frozen_string_literal: true

require_relative '../../data_structures/queue'
require_relative '../graph'
# BFS traversal of a Graph to find the shortest path between 2 nodes
# and to find if a graph is connected

# BFS can be used to find shortest path from Source Node to Destination
# Node in Undirected Graph with +ve edge weights:
# 1. All edge weights are same in the Undirected Graph:
#    BFS guarantees that when we encounter the target node for the 1st
#    time, the path found is the Shortest Path. This is break BFS
#    encounters nodes in increasing order of distance from Source. Hence
#    it is safe to break from Loop, when we have updated distance of
#    node (= destination node) with respect to dequeued node
# 2. If all Edge weights are NOT SAME in Undirected Graph:
#    We must not exit when we find destination node for the 1st time,
#    this is because at this time, we have found destination node with
#    fewest edges, and the total weight of these edges may not be the
#    least weight. A path with more number of Edges could potentially
#    have less weight. Hence "break" should not be used in the loop
#    We must continue exploring all nodes until queue becomes empty
# 3. We must mark a node as visited when the node is DEQUEUED and not
#    when it is ENQUEUED. If we mark a node as visited, when we ENQUEUE
#    any future attempts to visit that node through different paths will
#    be ignored, even if the alternate path might provide useful
#    information. This is important in certain algorithms where different
#    paths need to be explored before determining the optimal route
#    This will compute distance for the node with fewest edges, and if edge
#    weights are assigned such that longer path has less weights, we
#    shall end up computing longer distance from source to that node
#      => Correct Approach: Marking Nodes as Visited on Dequeue
#    Consider a graph like below:
#       0 ---- 1
#       |      | \
#       |      |  \
#       4 ---- 3 -- 2
#       => In this graph, we
#           Step 1: Dequeue node 0, visited[0] = true
#           Step 2: Enqueue nodes 1 and 4
#           Step 3: Dequeue node 1, visited[1] = true
#           Step 4: Enqueue nodes 3 and 2
#           Step 5: Dequeue node 4, visited[4] = true
#           Step 6: Enqueue nodes 3 (node 0 is visited)
#           Thus, node 3 gets enqueued more than once
#
# NOTE: BFS does not work for Undirected Graph with -ve Weight Edges
#

# explores paths in order of increasing distance from the source node.

# Find the shortest path between nodes "0" and "3"
# 0 ---- 1
# |      | \
# |      |  \
# 4 ---- 3 -- 2
def shortest_distance(node1:, node2:, graph:, same_weights:)
  queue = Queue.new
  visited = {}

  queue.enqueue(data: node1)

  distance = Hash.new { |h, k| h[k] = Float::INFINITY }
  distance[node1] = 0

  until queue.empty?
    # Mark node as visited as soon as it is dequeued for BFS traversal
    # in Graph
    node = queue.dequeue
    visited[node] = true

    graph.adj_matrix[node].each do |neighbor_weight|
      neighbor, weight = neighbor_weight
      # If a node has been processed, meaning, distance of all its neighbors
      # (adjacency matrix) has been updated by evaluating distance from
      # current node, this node has been used for calculation of minimum
      # distance. This node will be encountered again when we enqueue its
      # neighbor because it is an undirected graph and there is a 2-way
      # path between every set of nodes which has an edge. Since, this
      # node and its adjacency matrix has been processed, we would be
      # doing duplicate work if we enqueued it again, which is redundant
      # Hence we mark the node as visited, and skip it if it is encountered
      # again
      next if visited[neighbor]

      distance[neighbor] = distance[node] + weight if
           distance[node] + weight < distance[neighbor]
      # If all EDGE WEIGHTS ARE SAME, BFS explores nodes in increasing order of distance
      # from source. This implies that 1st time when we encounter destination node,
      # distance of destination node from the source  is the shortest distance possible
      # from source. At this time, we have updated distance of destination node by
      # evaluating distance[node] + 1, hence it is safe to break from the loop

      # If all EDGE WEIGHTS ARE NOT SAME, if we encounter a node for the 1st time, we
      # have found the node with fewest number of edges, but this may have weights
      # allocated to it such that it has larger total weight than other path to the
      # same node from source which has lesser weights. Breaking from a loop for the
      # 1st time will prevent us from exploring other longer paths which may have
      # less weights and give us incorrect answer
      break if same_weights && (neighbor == node2)

      queue.enqueue(data: neighbor)
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
    # Mark node as visited as soon as it is dequeued for BFS traversal
    # in Graph
    visited[vertex] = true

    graph.adj_matrix[vertex].each do |neighbor|
      next if visited[neighbor]

      queue.enqueue(data: neighbor)
    end
  end

  graph.vertices.each do |neighbor|
    return false unless visited[neighbor]
  end

  # Graph is connected if all vertices were visited
  true
end

def test_connectivity
  graph = []
  shortest_path_data.each do |adj_matrix_vertex_hsh|
    adj_matrix = adj_matrix_vertex_hsh[:adj_matrix]
    vertices = adj_matrix_vertex_hsh[:vertices]

    graph << Graph.new(adj_matrix:, vertices:)
  end

  shortest_dist_arr = [
    {
      graph: graph[0],
      output: 3,
      same_weights: true
    },
    {
      graph: graph[1],
      output: 6,
      same_weights: false
    }
  ]
  puts
  connectivity_check_arr.each do |graph_hsh|
    graph = graph_hsh[:graph]
    output = graph_hsh[:output]

    result = connectivity_check(graph:)
    str = ' Graph Connectivity Check => '
    puts "#{str}Expected Output :: #{output}, Result :: #{result}"
  end

  shortest_dist_arr.each do |graph_hsh|
    graph = graph_hsh[:graph]
    output = graph_hsh[:output]
    same_weights = graph_hsh[:same_weights]
    result = shortest_distance(node1: 0, node2: 5, graph:, same_weights:)

    str = ' Expected Distance between nodes 0 and node 5 :: '
    puts "#{str}#{output}, Result :: #{result}"
  end
  puts
end

def connectivity_check_arr
  [
    {
      graph: Graph.connected_undirected_graph,
      output: true
    },
    {
      graph: Graph.disconnected_undirected_graph,
      output: false
    }
  ]
end

def shortest_path_data
  adj_matrix_one = {
    0 => [[1, 1], [2, 1]],
    1 => [[0, 1], [3, 1], [6, 1]],
    2 => [[0, 1], [3, 1]],
    3 => [[1, 1], [2, 1], [4, 1]],
    4 => [[3, 1], [5, 1]],
    5 => [[4, 1]],
    6 => [[1, 1], [5, 1]]
  }
  vertices_one = [0, 1, 2, 3, 4, 5, 6]
  adj_matrix_two = {
    0 => [[1, 1], [2, 4]],
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

test_connectivity
