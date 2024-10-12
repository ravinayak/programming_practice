# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree'
require_relative '../algo_patterns/data_structures/stack'

# Invert binary tree, make left node right and right node left

# @param [Node] root
# @return [Node]
#
def invert_binary_tree(root:)
  return if root.nil? || (root.left.nil? && root.right.nil?)

  invert_binary_tree_util(node: root)
  # return root of the tree
  root
end

# This is a Top-Down Approach to inverting the binary tree where
# we swap left/right nodes at the top
# @param [Node] node
#
def invert_binary_tree_util(node:)
  return if node.nil?

  # Swap the left/right nodes
  # temp = node.left
  # node.left = node.right
  # node.right = temp
  node.left, node.right = node.right, node.left

  invert_binary_tree_util(node: node.left)
  invert_binary_tree_util(node: node.right)
end

# This is a bottom up approach where we swap the nodes when we reach
# the bottom of the tree, i.e. leaf nodes and all the way up in the
# tree
def invert_bt_util(node:)
  return nil if node.nil?

  node_left = invert_bt_util(node: node.left)
  node_right = invert_bt_util(node: node.right)

  node.right = node_left
  node.left = node_right

  node
end

# @param [Node] node
#
def invert_binary_tree_util_non_rec(node:)
  return if node.nil?

  st = Stack.new

  st.push(data: node)

  until st.empty?

    node = st.pop

    next if node.nil?

    node.left, node.right = node.right, node.left

    # Order of pushing nodes onto stack does not matter. This is because
    # goal of using stack is to pop the node and invert its left/right
    # subtree, whether we accomplish this for left node or right node
    # 1st does not really matter
    # The other method which is a bottom up approach will be harder to
    # implement using Stack, top-down approach is simpler to implement
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
  invert_binary_tree(root: bt.root) if !rec.nil? && rec
  invert_binary_tree_util_non_rec(node: bt.root) if !non_rec.nil? && non_rec
  bt.in_order_traversal
end

test_results(rec: true)
test_results(non_rec: true)
