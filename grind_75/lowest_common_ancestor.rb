# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree_node'
require_relative '../algo_patterns/data_structures/binary_tree'
# Find the lowest common ancestor of two nodes p, q in a binary tree
# Given a binary search tree (BST), find the lowest common ancestor (LCA) node of two
# given nodes in the BST.

# According to the definition of LCA on Wikipedia: “The lowest common ancestor is defined
# between two nodes p and q as the lowest node in T that has both p and q as descendants
# (where we allow a node to be a descendant of itself).”
# NOTE: To clarify, how do we determine between 2 ancestors - "a", "b" - which one is lowest
# Number of nodes between p(or q) and "a" < Number of nodes between p(or q) and "b"
# => "a" is lowest node in T which is ancestor to both "p" and "q"

# @param [BinaryTreeNode] node1
# @param [BinaryTreeNode] node2
# @param [BinaryTreeNode] node
# @return [Node]
#
def find_lca(node1:, node2:, node:)
  # We will end up reaching a NIL node if any of the following 2 is true
  # a. Both node1, node2 are smaller than the smallest value in the binary tree
  # b. Both node1, node2 are greater than the greatest value in the bianry tree
  return nil if node.nil?

  # This line covers 3 use cases:
  # a. Both node1 and node2 have same data (they are the same nodes) and a node exists in
  #  the tree with that data: node1 = node2 = node
  # In this use case, node1 can be considered as a descendant of itself, as given in the
  # definition.
  # b. If one of the nodes: node1 (say) has same data as node.
  # In this use case, 3 use cases are possible:
  #  1. other node: node2 will either be equal to the 1st node (node1). This will be the 1st
  #      use case
  #  2. other node: node2 < node1, node2 will be in left subtree of node1, node1 is the LCA
  #  3. other node: node2 > node1, node2 will be in right subtree of node1, node1 is the LCa
  #  In use cases 2,3 => node1 is the ancestor of both node1 and node2, any ancestor of node1
  #  (which will also be the ancestor of both node1 and node2 will be higher than node1 and
  # cannot be the LCA), since node1 is the lower in tree than its ancestor
  return node if node1.data == node.data || node2.data == node.data

  # if one node has smaller data and other node has greater than the node we have descended
  # upon in recursion, then this node is the first node in recursion where this left/right
  # subtree split occurs. Hence it is the lowest node in Tree T. Ancestors of this node will
  # also be ancestors of node1, node2 but they will be higher up in the tree and hence not LCA
  return node if (node1.data < node.data && node2.data > node.data) ||
                 (node2.data < node.data && node1.data > node.data)

  # if both nodes have data less than or greater than node that we have descended upon in
  # recursion, ancestor of both nodes will lie in left/right subtree
  return find_lca(node1:, node2:, node: node.left) if node1.data < node.data && node2.data < node.data

  return find_lca(node1:, node2:, node: node.right) if node1.data > node.data && node2.data > node.data

  # This line should never be reached. Just For completeness, mentioned here
  nil
end

# Find LCA non-recursively
# @param [BinaryTreeNode] node1
# @param [BinaryTreeNode] node2
# @param [BinaryTreeNode] node
# @return [BinaryTreeNode | nil]
#
def find_lca_non_rec(node1:, node2:, root:)
  node = root
  lca = nil

  while !node.nil? && lca.nil?

    # Better to organize in if/elsif code syntax: Rubocop may not like it
    # but it avoids checking un-necessary conditions and is actually
    # more readable and easy to understand
    if node_lca?(node1:, node2:, node:)
      lca = node
    elsif node1.data < node.data && node2.data < node.data
      node = node.left
    elsif node1.data > node.data && node2.data > node.data
      node = node.right
    end
  end

  lca
end

# Checks if node1/node2 lie in left/right subtree of node
# @param [BinaryTreeNode] node1
# @param [BinaryTreeNode] node2
# @param [BinaryTreeNode] node
# @return [Boolean]
#
def node_lca?(node1:, node2:, node:)
  (node1.data == node.data) || (node2.data == node.data) ||
    (node1.data < node.data && node2.data > node.data) ||
    (node2.data < node.data && node1.data > node.data)
end

def test
  bt = BinaryTree.new(data: 75)
  arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
  # This is a balanced binary tree with height 5
  arr.each do |data|
    bt.insert(data:)
  end

  node_arr = [
    { node1_data: 78, node2_data: 50, lca_data: 75 },
    { node1_data: 80, node2_data: 90, lca_data: 85 },
    { node1_data: 15, node2_data: 25, lca_data: 'NIL' },
    { node1_data: 145, node2_data: 155, lca_data: 'NIL' },
    { node1_data: 80, node2_data: 130, lca_data: 110 }
  ]
  node_arr.each do |node_hsh|
    node1 = BinaryTreeNode.new(data: node_hsh[:node1_data])
    node2 = BinaryTreeNode.new(data: node_hsh[:node2_data])
    str_lca = "Recursive: LCA for node #{node_hsh[:node1_data]}, "
    str_lca += "#{node_hsh[:node2_data]} should be "
    str_lca += node_hsh[:lca_data] == 'NIL' ? 'NIL' : "node with data #{node_hsh[:lca_data]}"
    node = find_lca(node1:, node2:, node: bt.root)
    puts "#{str_lca} : #{node.nil? ? 'NIL' : node.data}"
    node = find_lca_non_rec(node1:, node2:, root: bt.root)
    puts "Non-#{str_lca} :: #{node.nil? ? 'NIL' : node.data}"
  end
end

test
