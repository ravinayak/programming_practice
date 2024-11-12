# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'
# Given a reference of a node in a connected undirected graph.

# Return a deep copy (clone) of the graph.

# Each node in the graph contains a value (int) and a list (List[Node])
# of its neighbors.

# class Node {
#     public int val;
#     public List<Node> neighbors;
# }

# Test case format:

# For simplicity, each node's value is the same as the node's index (1-indexed).
# For example, the first node with val == 1, the second node with val == 2, and
# so on. The graph is represented in the test case using an adjacency list.

# An adjacency list is a collection of unordered lists used to represent a finite
# graph. Each list describes the set of neighbors of a node in the graph.

# The given node will always be the first node with val = 1. You must return the
# copy of the given node as a reference to the cloned graph

# Example 1
# Input: adjList = [[2,4],[1,3],[2,4],[1,3]]
# Output: [[2,4],[1,3],[2,4],[1,3]]
# Explanation: There are 4 nodes in the graph.
# 1st node (val = 1)'s neighbors are 2nd node (val = 2) and 4th node (val = 4).
# 2nd node (val = 2)'s neighbors are 1st node (val = 1) and 3rd node (val = 3).
# 3rd node (val = 3)'s neighbors are 2nd node (val = 2) and 4th node (val = 4).
# 4th node (val = 4)'s neighbors are 1st node (val = 1) and 3rd node (val = 3).

# Example 2
# Input: adjList = [[]]
# Output: [[]]
# Explanation: Note that the input contains one empty list. The graph consists
# of only one node with val = 1 and it does not have any neighbors.

# Node class which contains data and neighbors for that node
#
class Node
  attr_accessor :data, :neighbors

  def initialize(data:, neighbors: [])
    @data = data
    @neighbors = neighbors
  end
end

# Algorithm: Use BFS to traverse given graph
# 1. Maintain a hash which stores cloned node referenced for each
#    node value
# 2. Maintain a visited hash which maintains all the nodes that
#    have been processed
# 3. Put 1st node in queue
# 4. until queue.empty?
#     a. Process the node by looking at its adjacency matrix, for
#     each node in the adjacency matrix
#       1. If it is not present in the hash of cloned nodes,
#       clone it and insert it into hash, else retrieve
#       a reference to the node from hash
#       2. If it is not in visited hash, insert the nodes data
#       into queue
#       3. Insert this node in the neighbors for current node
#     b. Mark this node as visited

# Clone graph, return an array which contains copy of nodes
# that have been cloned for each node in the original graph
# @param [Array<Integer, Integer>] adj_matrix
# @return [Array<Node, Node>]
#
def clone_graph(adj_matrix:)
  return [[]] if adj_matrix.empty?

  visited = {}
  cloned_nodes_hsh = {}
  results = []

  queue = Queue.new
  queue.enqueue(data: 1)

  # Process until Queue is empty
  until queue.empty?
    temp = []
    # Remove elment from queue and store its value
    node_val = queue.dequeue
    neighbors = adj_matrix[node_val - 1]
    # Retrieve node if it exists in hash, else create a new node
    # and insert it into hash
    curr_node = cloned_hsh_utility(cloned_nodes_hsh:, node_val:)
    # Iterate over neighbors of curr_node
    neighbors.each do |neighbor|
      # Reference to neigbor
      node = cloned_hsh_utility(cloned_nodes_hsh:, node_val: neighbor)
      # if node has not been processed, put it into queue
      queue.enqueue(data: neighbor) unless visited[neighbor]

      curr_node.neighbors << node
      # Store neighbor node in temp array
      temp << neighbor
    end
    # Push the neighbors of curr_node in results array if it has not
    # been processed
    results[node_val] = temp unless visited[node_val]
    # Mark curr_node as visited
    visited[node_val] = true
  end

  # 1st entry will be nil since it is 1-index based, remove nil entries
  results.compact!

  # Return results
  results
end

# This is a much simplified method and can be used to solve the problem
def clone_graph_simple(adj_matrix:)
  return [[]] if adj_matrix.nil? || adj_matrix.empty?

  node_hsh = {}
  (0...adj_matrix.length).each do |index|
    node = Node.new(data: index + 1)
    node_hsh[index + 1] = node
  end

  results = []
  adj_matrix.each_with_index do |neighbors, index|
    node = node_hsh[index + 1]
    temp_arr = []
    neighbors.each do |neigbor_index|
      neighbor_node = node_hsh[neigbor_index]
      node.neighbors << neighbor_node
      temp_arr << neighbor_index
    end
    results << temp_arr
  end
  results
end

# Returns reference of existing node for node_val in hash
# Creates a new node if it does not exist, insert it into
# hash and return a reference to it
# @param [Hash] cloned_nodes_hsh
# @param [Integer] node_val
# @return [Node]
#
def cloned_hsh_utility(cloned_nodes_hsh:, node_val:)
  return cloned_nodes_hsh[node_val] if
    cloned_nodes_hsh.key?(node_val)

  node = Node.new(data: node_val)
  cloned_nodes_hsh[node_val] = node

  # Return node
  node
end

def test
  adj_matrix_arr = [
    {
      adj_matrix: [[2, 4], [1, 3], [2, 4], [1, 3]],
      output: [[2, 4], [1, 3], [2, 4], [1, 3]]
    },
    {
      adj_matrix: [[]],
      output: [[]]
    }
  ]

  adj_matrix_arr.each do |adj_matrix|
    res = clone_graph(adj_matrix: adj_matrix[:adj_matrix])
    print "\n Adj Matrix :: #{adj_matrix[:adj_matrix].inspect}"
    print "\n Expected :: #{adj_matrix[:output].inspect}, "
    print "Result :: #{res.inspect} \n\n"
  end
end

test
