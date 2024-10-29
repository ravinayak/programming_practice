# frozen_string_literal: true

require_relative '../../data_structures/queue'
require_relative '../graph'
# BFS traversal of a Graph to find the shortest path between 2 nodes
# and to find if a graph is connected

# BFS can be used to find shortest path from Source Node to Destination
# Node in Undirected Graph with Equal edge weights:
# 1. All edge weights are same in the Undirected Graph:
#    BFS guarantees that when we encounter the target node for the 1st
#    time, the path found is the Shortest Path. This is because BFS
#    encounters nodes in increasing order of distance from Source. Hence
#    it is safe to break from Loop, when we have updated distance of
#    node (= destination node) with respect to dequeued node
# 2. We must mark a node as visited when the node is DEQUEUED and not
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
# 3. BFS should not be used for Undirected Graphs with UnEQUAL WEIGHTS.
#    Djikstra's algo should be used, we can hack BFS to make it work
#    but BFS is not meant for such graphs. BFS assumes level order
#    traversal by definition, and also that the 1st time a node is
#    encountered, it has the shortest path, since we have reached it
#    using fewest EDGES
# 4. BFS does not work for Undirected Graph with -ve Weight Edges
#
# Can we use BFS for finding shortest paths with unequal weight edges.
# The short answer is: standard BFS alone is not suitable for finding
# shortest paths in graphs with unequal edge weights. Let me explain why
# and what alternatives exist.
# 1. BFS and Equal Weights:
#    BFS works perfectly for finding shortest paths when all edges have equal
#    weights (or in unweighted graphs). It naturally explores nodes in order
#    of their distance from the source.
# 2. BFS and Unequal Weights:
#    When edge weights are unequal, BFS loses its guarantee of finding the
#    shortest path. This is because:
#    BFS explores nodes based on the number of edges from the source, not the
#    total weight of the path.
#    A path with more edges but lower total weight could be shorter than a
#    path with fewer edges but higher total weight.
# BFS has exactly same algorithm as djikstras except that it uses queue
# data structure while djikstras algo uses PriorityMinHeap

# explores paths in order of increasing distance from the source node.

# Find the shortest path between nodes "0" and "3"
# 0 ---- 1
# |      | \
# |      |  \
# 4 ---- 3 -- 2
def shortest_distance(source_node:, destination_node:, graph:)
  queue = Queue.new
  visited = {}

  queue.enqueue(data: source_node)

  distance = Hash.new { |h, k| h[k] = Float::INFINITY }
  distance[source_node] = 0

  until queue.empty?
    # Mark node as visited as soon as it is dequeued for BFS traversal
    # in Graph
    node = queue.dequeue

    # If all EDGE WEIGHTS ARE SAME, BFS explores nodes in increasing order of distance
    # from source. This implies that 1st time when we encounter destination node,
    # distance of destination node from the source is the shortest distance possible
    # from source. At this time, we have updated distance of destination node by
    # evaluating distance[node] + 1, hence it is safe to break from the loop
    return distance[node] if node == destination_node

    next if visited [node]

    visited[node] = true

    graph.adj_matrix[node]&.each do |neighbor, weight|
      # Undirected Graph with Equal Edge Weights:
      #  • In an unweighted or equally weighted graph, BFS will naturally
      #    explore nodes in increasing order of distance from the source.
      #    In this case, once you mark a node as visited and process it, you
      #    should skip it when encountered again, because BFS guarantees that
      #    the first time you visit a node, you’ve found the shortest path to it.
      # Weighted Graph (Unequal Edge Weights):
      #  • In a graph with unequal edge weights, simply skipping a node because
      #    it’s been visited before can be problematic. The reason is that there
      #    might be a shorter path to that node through a different route, even
      #    after the node has been visited once. A longer path with more edges
      #    may have fewer weights assigned to it and hence may have less distance
      #    from source. BFS guarantee of level order traversal does not hold in
      #    such a use case
      #  • In this case, you can’t mark nodes as visited immediately when dequeued,
      #    and you need to relax edges (like in Dijkstra’s algorithm), ensuring that
      #    every possible shorter path is considered.
      next if visited[neighbor]

      next unless distance[neighbor] > distance[node] + weight

      distance[neighbor] = distance[node] + weight
      queue.enqueue(data: neighbor)
    end
  end

  distance[destination_node]
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
    result = shortest_distance(source_node: 0, destination_node: 5, graph:)

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

  [
    {
      adj_matrix: adj_matrix_one,
      vertices: vertices_one
    }
  ]
end

test_connectivity
