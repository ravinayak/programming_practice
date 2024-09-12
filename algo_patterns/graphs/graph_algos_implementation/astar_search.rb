# frozen_string_literal: true

require_relative '../graph'
require_relative '../../priority_queue/priority_queue_min_heap'
# A star search algorithm is a search algorithm which tries
# to find shortest path from start node to goal node in the
# fastest time possible
# It combines features of both the algorithms:
# a. Djikstra's algorithm
# b. Best first search algorithm

# Unlike Djikstras algorithm it uses a heuristic function
# to estimate the distance of current node n to goal node
# and uses this estimate to select the best node possible
# which has shortest path in the fastest time
#  => Heuristic function is generally provided by domain
#       experts, and is domain specific
# a. g(n): Cost of path from start node to current
#           node "n". This is accurate
# b. h(n): Heuristic estimate of path from start node to
#           node "n". This is an estimate
# c. f(n): Total cost of path from start node to current
#           node "n"
#  => g(n) provides accuracy to algorithm
#  => h(n) provides estimation to select best fit fastest

# Time Complexity: O(E * log V)
# Space Complexity: O(V)
# Maximum number of vertices which can be stored in Priority
# Queue at any time is "V", or for other hashes which are
# used, 1. came_from 2. visited 3. g_score 4. f_score

# AstarSearch algorithm implementation
class AstarSearch
  attr_accessor :graph, :heuristic, :came_from

  def initialize(graph:, heuristic:)
    @graph = graph
    @heuristic = heuristic
    @came_from = {}
  end

  # Find Path from source node to goal node
  # @param [Integer] source_node
  # @param [Integer] goal_node
  # @return [Array | nil]
  def find_path(source_node:, goal_node:)
    g_score, f_score, visited, pq_min_heap = initial_setup(source_node:)

    until pq_min_heap.empty?
      # Extract minimum key node from MinHeap
      node = pq_min_heap.extract_min[:element]

      # Reconstructs path if goal_node is found
      return reconstruct_path(came_from:, current: node) if
        node == goal_node

      # if node has been processed, we skip it. It is possible to
      # insert a node with different key values in MinHeap. But
      # MinHeap always extracts node with minimum key, so multiple
      # insertions into MinHeap for same node is not an issue,
      # when we skip a node, we avoid doing redundant work with
      # higher value of keys for that node
      next if visited[node]

      visited[node] = true

      # Process adjacency matrix for node, and update neighbors
      process_adj_matrix(node:, g_score:, f_score:, pq_min_heap:)
    end
    nil
  end

  private

  # Initial setup to find path
  # @param [Integer] source_node
  # @return [Array]
  def initial_setup(source_node:)
    # Calculates the actual cost of each node from start node
    g_score = Hash.new(Float::INFINITY)
    # Calculate the total cost from start_node to goal_node
    # through each node in the graph
    f_score = {}
    # Maintains a hash of all nodes which have been visited
    visited = {}

    # Initialize actual cost of source_node to 0
    g_score[source_node] = 0
    pq_min_heap = PriorityQueueMinHeap.new(arr: [], heap_size: 0)
    # Initialize a PriorityQueueMinHeap and insert source_node as
    # element with a key of 0
    pq_min_heap.insert_object(object: { element: source_node, key: 0 })
    [g_score, f_score, visited, pq_min_heap]
  end

  # Processes adjacency matrix for node and updates g_score, f_score
  # @param [Integer] node
  # @param [Hash] g_score
  # @param [Hash] f_score
  # @param [PriorityQueueMinHeap] pq_min_heap
  # @return void
  def process_adj_matrix(node:, g_score:, f_score:, pq_min_heap:)
    graph.adj_matrix[node].each do |neighbor, cost|
      tentative_g_score = g_score[node] + cost
      next unless tentative_g_score < g_score[neighbor]

      g_score[neighbor] = tentative_g_score
      f_score[neighbor] = g_score[neighbor] + heuristic[neighbor]
      came_from[neighbor] = node
      pq_min_heap.insert_object(object: { element: neighbor, key: f_score[neighbor] })
    end
  end

  # Reconstructs path from start node to goal node
  # @param [Hash] came_from
  # @param [Integer] current
  # @return [Array]
  def reconstruct_path(came_from:, current:)
    total_path = [current]
    while came_from.key?(current)
      current = came_from[current]
      total_path << current
    end
    total_path.reverse
  end
end

def graph_heuristic
  adj_matrix = {
    0 => [[1, 1], [2, 3]],
    1 => [[3, 1], [4, 5]],
    2 => [[5, 12]],
    3 => [[4, 1]],
    4 => [[5, 1]]
  }
  vertices = [0, 1, 2, 3, 4, 5, 6]
  heuristic = {
    0 => 6,
    1 => 4,
    2 => 7,
    3 => 2,
    4 => 1,
    5 => 0
  }

  [Graph.new(vertices:, adj_matrix:), heuristic]
end

def test
  graph, heuristic = graph_heuristic

  astar = AstarSearch.new(graph:, heuristic:)
  path = astar.find_path(source_node: 0, goal_node: 5)
  puts 'Expected Shortest Path :: [0, 1, 3, 4, 5]'
  puts "A Start Search Result  :: #{path}"
end

test
