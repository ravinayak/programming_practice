# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'
require_relative '../algo_patterns/data_structures/binary_tree'
# Given the root of a binary tree, determine if it is a valid binary
# search tree (BST).

# A valid BST is defined as follows:

# The left subtree of a node contains only nodes with keys less than
# the node's key.
# The right subtree of a node contains only nodes with keys greater
# than the node's key.

# Algorithm: The algorithm to check if a node is valid BST requires
# that every node data must fall within a specified range of values
# 1. When Going Left => Left node data <= node.data
#        => Max should be updated to current node.data
#        => This is because left node data <= max (range check)
# 2. When Going Right => Right node data > min (not Equal)
#        => Min should be updated to current node.data
#        => This is because right node data > min (range check)
# 3. Initialize min = -Infinity, max = +Infinity for root node
#        => Because root node does not have any range check
# When using level order traversal, we check if a node is valid
# by dequing and checking node data for validity. We simply
# enqueue node.left and node.right

# We use range check and not simple comparison with node.data for
# left,right nodes because any node in the right subtree of root
# must not contain a value > root node
# Similary any node in the right subtree must contain data > root
# Hence, range check is CRITICAL
# If we simply compared with the node.data for left node and right
# node, a node could have data which violates the BST requirements
#                      75
#              50             110
#          40     85      100        125
# Node at 50, and node at 80 will satisfy the simple node check
# left child = 40 <= 50 < right child = 85
# 40, 85 are leaf nodes and hence valid BST
# But 85 violates the BST requirement, it is left subtree of 75 (root)
# while it should be in the right subtree

# Both the left and right subtrees must also be binary search trees.

# @param [BinaryTreeNode] root
# @param [Boolean] level_flag
# @return [Boolean]
#
def validate_bst(root:, level_flag:)
  dfs_bst_valid = { is_valid: true }
  level_bst_valid = { is_valid: true }

  level_bst_validity_check(root:, level_bst_valid:) if level_flag

  min = -Float::INFINITY
  max = Float::INFINITY
  dfs_bst_validity_check(node: root, dfs_bst_valid:, min:, max:) unless level_flag

  level_check = level_flag ? level_bst_valid[:is_valid] : dfs_bst_valid[:is_valid]

  { level_check: }
end

# @param [BinaryTreeNode] node
# @param [Hash] dfs_bst_valid
# @param [Integer] min
# @param [Integer] max
# @return [Boolean | nil]
#
def dfs_bst_validity_check(node:, dfs_bst_valid:, min:, max:)
  # Base case of Recursion
  return if node.nil?

  if node.data <= min || node.data > max
    dfs_bst_valid[:is_valid] = false
    return
  end

  dfs_bst_validity_check(node: node.left, dfs_bst_valid:, min:, max: node.data) if node.left

  dfs_bst_validity_check(node: node.right, dfs_bst_valid:, min: node.data, max:) if node.right

  nil
end

# @param [BinaryTreeNode] root
# @param [Hash]
#
def level_bst_validity_check(root:, level_bst_valid:)
  queue = Queue.new
  # min, max are defined as simple variables and not as hash
  # because these need to be updated for every node being
  # added to queue. A hash would get updated and retain its
  # min,max values for all nodes while the requirement is
  # that every node must have a specific range check

  # Multiple assignments on the same line do not work in Ruby
  # a = 2, b = 3
  # a = [2, 3]
  # b = 3
  min = -Float::INFINITY
  max = Float::INFINITY
  queue.enqueue(data: [root, min, max])

  # Start at level 1 by pushing root in Queue
  level = 1
  # Until all nodes in Queue have been processed
  until queue.empty?
    # Determine the number of nodes in queue, because we have
    # to run Iteration those many times to remove each node
    # and validate if BST is valid
    level_size = queue.size
    node_data_arr = []

    level_size.times do
      node, min, max = queue.dequeue
      # Right Node data > Node data (not =) (min)
      # Left node data <= Node data (max)

      # For a node to be valid, it must have a value within the
      # specified range: [min, max]
      # node.data > min && node.data <= max [Valid Node]

      # Invalid Node => node.data <= min || node.data > max
      if node.data <= min || node.data > max
        level_bst_valid[:is_valid] = false
        break
      end

      node_data_arr << node.data

      # If node left exists
      if node.left
        # Initialize 2 new variables, it will alter the existing
        # min, max values which are needed for the right node
        # range update
        new_min = min
        new_max = node.data
        # Manually update the data on node to 85
        # to invalidate given BST
        node.data = 85 if node.data == 60
        # Push node in queue to process that node
        queue.enqueue(data: [node.left, new_min, new_max])
      end

      next unless node.right

      new_min = node.data
      new_max = max
      queue.enqueue(data: [node.right, new_min, new_max])
    end

    # If at any level we find a node which violates BST
    # validity, break from iteration of queue.empty?
    break unless level_bst_valid[:is_valid]

    # Print all nodes at level, and increment level
    print_nodes_at_level(level:, node_data_arr:)
    level += 1

  end
end

# Print Nodes at every level
# @param [Integer] level
# @param [Array<Integer>] node_data_arr
#
def print_nodes_at_level(level:, node_data_arr:)
  print "\n Level #{level} :: "
  node_data_arr.each { |data| print "#{data} " }
  print "\n"
end

def test
  bt = BinaryTree.new(data: 75)
  arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
  arr.each do |data|
    bt.insert(data:)
  end

  bt1 = BinaryTree.new(data: 75)
  arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
  arr.each do |data|
    bt1.insert(data:)
  end

  bfs_valid_check = validate_bst(root: bt.root, level_flag: true)
  dfs_valid_check = validate_bst(root: bt1.root, level_flag: false)

  print "\n Is BST Valid BFS:: #{bfs_valid_check[:level_check]}\n"
  print "\n Is BST Valid DFS:: #{dfs_valid_check[:level_check]}\n\n"

  bfs_valid_check = validate_bst(root: bt.root, level_flag: true)
  dfs_valid_check = validate_bst(root: bt.root, level_flag: false)

  print "\n Is BST Valid BFS:: #{bfs_valid_check[:level_check]}\n"
  print "\n Is BST Valid DFS:: #{dfs_valid_check[:level_check]}\n\n"
end

test
