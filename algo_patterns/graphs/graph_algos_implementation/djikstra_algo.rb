# frozen_string_literal: true

require_relative '../../heap/min_binary_heap'
require_relative '../graph'

# Why Skipping Inside the Adjacency List in Dijkstra’s Algorithm is Incorrect:

# 1. The core idea of Dijkstra’s algorithm is to relax the edges. This means
#    that every time you reach a node, you check if going through that node
#    provides a shorter path to its neighbors. If you skip checking neighbors
#    because they are marked as “visited” early on, you might miss opportunities
#    to find a shorter path via the current node.
# 2. Dijkstra’s algorithm guarantees the shortest path only when the node is
#    dequeued (extracted from the heap). At this point, you know that the node
#    has the minimum distance, but its neighbors may still have not been updated
#    with their shortest distance. You need to update (relax) the neighbors even
#    if they were previously visited.
# 3. Why visited check at extraction works: The reason we mark nodes as visited
#    at the point of extraction from the heap is because, once extracted, we know
#    for sure that the shortest path to that node has been found. However, its
#    neighbors still need to be checked for potential updates.

# Djikstra's algorithm implementation
def djikstras(graph:, source_node:, destination_node:)
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
    # This is different from bfs_traversal where we skip
    # iterating over a node if inside iteration over
    # adjacency list of that node if its neighbor has 
    # been visited
    next if visited[node]

    # Mark this node as visited, it can be marked here
    # or at the end of processing all its neighbors
    # This will prevent redundant work, since a node
    # can be inserted twice into min-heap with different
    # values of distance
    # A --1--- B --1--> C
    #  \      /
    #   5    3
    #    \  /
    #      D
    # In the above graph,
    # Step 1: distance[A] = 0, B and D will be put into
    #         min-heap with values of 1 and 5
    # Step 2: B will be extracted, and distances of its
    #         neighbors - C (1), and D (3) will be updated
    #         distance[D] = 3 + 1 = 4 < existing distance[D]
    #         D will be put into min-heap with a value of
    #         4
    # Step 3: So min-heap will have 2 entries for D, one
    #         with a value of 5, and the other with a value
    #         of 4.
    # Step 4: Min-Heap extraction guarantees that D will be
    #         extracted with a value of 4 and its neighbors
    #         will be processed with this value
    # Step 5: But D will be extracted again with a value of
    #         '5', here it is critical to use this check of
    #          visited[node], since this node has already
    #          been processed, it will simply add more time
    #          to compute distance of neighbors which will
    #          never get updated from their existing values
    #   => This is because when D was extracted and its
    #      neighbors were processed for distance computation
    #      they were evaluated with a distance of 4, with
    #      increased distance of 5, they will ONLY get
    #      higher values of distance from SOURCE, and so
    #      they will be NEVER BE UPDATED leading to a 
    #      waste of cycle. This can be avoided if we skip
    #      the node since it was visited and processed before
    #
    visited[node] = true

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
