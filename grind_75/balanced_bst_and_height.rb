# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree'
# This method checks if the BST is balanced in height and also returns
# the height of the tree.
# Height of any node in tree is calculated as the maximum number of nodes
# from that node to any leaf node in the tree.
# Height of tree = Height of root
#   => Maximum height from root to any leaf node in the tree
#   => Implies that if we traverse from root of tree to all leaf nodes of
#       the tree, the path which has maximum number of nodes is the longest
#       path and height of tree
#   => Number of nodes from root to the leaf node on this path, this number
#       of nodes includes both root and leaf node
# From the above definition, height of leaf node = 1

# A height-balanced binary tree is a binary tree in which the depth of the
# two subtrees of every node never differs by more than one. This implies
# that two subtrees of any node in binary tree can differ by 1, not > 1
#
# @param [Node] root
# @return [Hash] is_balanced, height
#
def balanced_and_height(node:)
  # Initialized to true assuming the tree is balanced, if it is unbalanced
  # this flag will be set to false during recursion in utility function
  # We are using hash so that the value for key holds when it changes, if
  # we use a simple variable, changes will be lost when we return from
  # recursion
  is_balanced_hsh = { is_balanced: true }

  height = balanced_and_height_util(node:, is_balanced_hsh:)

  { height:, is_balanced: is_balanced_hsh[:is_balanced] }
end

# Utility function to calculate height of tree and to determine if the tree is
# balanced
# @param [BinaryTreeNode] node
# @param [is_balanced_hsh] Hash
# @return [Integer]
#
def balanced_and_height_util(node:, is_balanced_hsh:)
  # Base case of recursion
  return 0 if node.nil?

  left_subtree_height = balanced_and_height_util(node: node.left, is_balanced_hsh:)
  right_subtree_height = balanced_and_height_util(node: node.right, is_balanced_hsh:)

  # Binary Tree is balanced only if the depth of any two subtrees of any node in the binary
  # tree differ by no more than 1
  is_balanced_hsh[:is_balanced] = false if (left_subtree_height - right_subtree_height).abs > 1

  # Return the maximum of left and right subtree heights incremented by 1.
  # For a leaf node, height calculation evalautes to 1 which is correct
  [left_subtree_height, right_subtree_height].max + 1
end

def test
  bt1 = BinaryTree.new(data: 75)
  arr1 = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
  # This is a balanced binary tree with height 5
  arr1.each do |data|
    bt1.insert(data:)
  end
  bt2 = BinaryTree.new(data: 50)
  arr2 = [40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80]
  # In this binary tree, left subtree of root has height 2, right subtree has height 4
  # Hence it is unbalanced
  arr2.each do |data|
    bt2.insert(data:)
  end
  bt3 = BinaryTree.new(data: 75)
  arr3 = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78, 128]
  # Here we have taken 1st binary tree and deliberately inserted 128 at the end to increase
  # height of rightmost subtree by 1, to fail it the balance criterion. Height of tree
  # increases by 1 to 6
  arr3.each do |data|
    bt3.insert(data:)
  end
  [bt1, bt2, bt3].each do |bt|
    bh = balanced_and_height(node: bt.root)
    puts "Height :: #{bh[:height]}, Is Balanced :: #{bh[:is_balanced]}"
  end
end

test
