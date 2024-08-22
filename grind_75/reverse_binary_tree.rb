# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree'
require_relative '../algo_patterns/data_structures/stack'

# Reverse binary tree, make left node right and right node left

# @param [Node] root
# @return [Node]
#
def reverse_binary_tree(root:)
  return if root.nil? || (root.left.nil? && root.right.nil?)

  reverse_binary_tree_util(node: root)
  # return root of the tree
  root
end

# @param [Node] node
#
def reverse_binary_tree_util(node:)
  return if node.nil?

  # Swap the left/right nodes
  # temp = node.left
  # node.left = node.right
  # node.right = temp
  node.left, node.right = node.right, node.left

  reverse_binary_tree_util(node: node.left)
  reverse_binary_tree_util(node: node.right)
end

# @param [Node] node
#
def reverse_binary_tree_util_non_rec(node:)
  return if node.nil?

  st = Stack.new

  st.push(data: node)

  until st.empty?

    node = st.pop

    next if node.nil?

    node.left, node.right = node.right, node.left

    st.push(data: node.right)
    st.push(data: node.left)
  end

  node
end

# @param [Boolean] rec
# @param [Boolean] non_rec
#
def test_results(rec: false, non_rec: false)
  bt = BinaryTree.new(data: 75)
  arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
  arr.each do |data|
    bt.insert(data:)
  end
  bt.in_order_traversal
  reverse_binary_tree(root: bt.root) if !rec.nil? && rec
  reverse_binary_tree_util_non_rec(node: bt.root) if !non_rec.nil? && non_rec
  bt.in_order_traversal
end

test_results(rec: true)
test_results(non_rec: true)
