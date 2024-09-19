# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree_node'
require_relative '../algo_patterns/data_structures/binary_tree'

# @param [BinaryTreeNode] root1
# @param [BinaryTreeNode] root2
# @return [Boolean]
def same_binary_tree(root1:, root2:)
  same_bt(node1: root1, node2: root2)
end

# Algorithm: The algorithm involves following steps:
# 1. To check data on both nodes, we must ensure that no node is NIL
# 2. If both nodes are nil, we have reached leaf nodes and they are same, return true
# 3. If one node is NIL, the other node is NOT NIL, they are not same, return false
# 4. If we reached here, both nodes are not NIL, compare data on both nodes for sameness
# 5. If nodes do not have same data, they are not SAME, return false
# 6. If they have same data, check for left nodes and right nodes of both trees for sameness

# @param [BinaryTreeNode] root1
# @param [BinaryTreeNode] root2
# @return [Boolean]
def same_bt(node1:, node2:)
  # Both nodes are nil, meaning we've reached the leaf nodes on both trees
  return true if node1.nil? && node2.nil?

  # One node is nil and the other is not, so the trees are not the same
  return false if (node1.nil? && !node2.nil?) || (!node1.nil? && node2.nil?)

  # The current node's data is not equal, so the trees are not the same
  return false if node1.data != node2.data

  # Recursively compare the left and right subtrees
  same_bt(node1: node1.left, node2: node2.left) && same_bt(node1: node1.right, node2: node2.right)
end

def binary_tree_arr
  bt1 = BinaryTree.new(data: 75)
  arr1 = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
  arr1.each do |data|
    bt1.insert(data:)
  end

  bt2 = BinaryTree.new(data: 75)
  arr1.each do |data|
    bt2.insert(data:)
  end

  bt3 = BinaryTree.new(data: 75)
  arr3 = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80]
  arr3.each do |data|
    bt3.insert(data:)
  end
  [bt1, bt2, bt3]
end

def test
  bt1, bt2, bt3 = binary_tree_arr
  puts "bt1 and bt2 are same trees :: #{same_binary_tree(root1: bt1.root, root2: bt2.root)}"
  puts "bt1 and bt3 are NOT same trees :: #{same_binary_tree(root1: bt1.root, root2: bt3.root)}"
end

test
