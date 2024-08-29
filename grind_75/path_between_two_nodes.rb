# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree'
# Given two nodes in a binary tree, find the path between them
# and the number of nodes between them

# Algorithm:
# 1. Find LCA of the two nodes
# 2. If node1.data < LCA(data)
#    Find the nodes in left subtree of LCA upto the smaller node
# 3. Push node.data in the path array
# 4. If node2.data > LCA (data)
#    Find the nodes in right subtree of LCA upto the larger node
#

# @param [BinaryTreeNode] node1
# @param [BinaryTreeNode] node2
# @param [BinaryTreeNode] root
# @return [Array]
#
def nodes_on_path(node1:, node2:, root:)
  return [0, []] if root.nil?

  lca = find_lca(node1:, node2:, node: root)
  return [0, []] if lca.nil?

  path = []

  left_node = left_node_eval(node1:, node2:, node: lca)
  right_node = right_node_eval(node1:, node2:, node: lca)

  left_path = collect_path(node_to_find: left_node, node: lca.left, is_left: true)

  right_path = collect_path(node_to_find: right_node, node: lca.right, is_left: false)

  # concat returns an array concatenated with elements of the other array passed to
  # it in method call.
  # Concatenates returns all the nodes in the left subtree of LCA excluding LCA
  # in the reverse order of how they are encountered in recursion, i.e. while going
  # UP from bottom to top. Only when recursion - both left and right for a node has
  # completed, node is pushed on to path array. This gives an ascending order from
  # lower node to greater node through LCA
  path.concat(left_path)
  # Push LCA data
  path.push(lca.data)
  # Concatenates all the nodes in the right subtree of LCA in the order they are
  # encountered while recursing from top to bottom
  path.concat(right_path)

  path
end

# @param [BinaryTreeNode] node1
# @param [BinaryTreeNode] node2
# @param [BinaryTreeNode] node
# @return [BinaryTreeNode | nil]
#
def left_node_eval(node1:, node2:, node:)
  return node1 if node1.data < node.data

  return node2 if node2.data < node.data

  nil
end

# @param [BinaryTreeNode] node1
# @param [BinaryTreeNode] node2
# @param [BinaryTreeNode] node
# @return [BinaryTreeNode | nil]
#
def right_node_eval(node1:, node2:, node:)
  return node1 if node1.data > node.data

  return node2 if node2.data > node.data

  nil
end

# @param [BinaryTreeNode] node_to_find
# @param [BinaryTreeNode] node
# @param [Boolean] is_left
# @return [Array]
#
def collect_path(node_to_find:, node:, is_left:)
  # Base Case of Recursion: if during recursion we descend to a node
  # which is nil (left of a leaf node for example), return []
  # node_to_find.nil? check is because left_node/right_node may not
  # exist if node1.data == lca.data || node2.data == lca.data. In
  # this case, path.concat(left_path) will throw error if we do not
  # peform this check here. Alternatively we can do this check in
  # the code above when path.concat(left_path) to check for nil value
  # Then we would have to check for path.concat(right_path) as well
  # Putting this check here removes the duplicate checks above
  return [] if node.nil? || node_to_find.nil?

  path = []

  # If we are in the right subtree of the node, we want to add nodes
  # as we recurse downwards from the given node to leaf on the
  # longest path immediately when we encounter the node
  path.push(node.data) unless is_left

  if node_to_find.data < node.data
    path.concat(collect_path(node_to_find:, node: node.left, is_left:))
  elsif node_to_find.data > node.data
    path.concat(collect_path(node_to_find:, node: node.right, is_left:))
  else
    # if it is the right subtree, we have already pushed node.data into
    # the path array. So, we simply return path, else we push node.data
    # in path array
    return path unless is_left

    return path.push(node.data)
  end

  # If we are in the left subtree of the node, we want to recurse
  # until we reach the leaf node, and we want to add node data as
  # we recurse upwards from the leaf node to given node. We add node
  # data when we have recursed completely, so adding it here at the
  # bottom
  path.push(node.data) if is_left

  path
end

# Find LCA of two nodes - node1, node2
# @param [BinaryTreeNode] node1
# @param [BinaryTreeNode] node2
# @param [BinaryTreeNode] node
# @return [BinaryTreeNode | nil]
#
def find_lca(node1:, node2:, node:)
  return nil if node.nil?

  return node if node.data == node1.data || node.data == node2.data

  return node if node1.data < node.data && node2.data > node.data ||
                 node1.data > node.data && node2.data < node.data

  return find_lca(node1:, node2:, node: node.left) if
    node1.data < node.data && node2.data < node.data

  return find_lca(node1:, node2:, node: node.right) if
    node1.data > node.data && node2.data > node.data

  nil
end

# @param [BinaryTreeNode] node
# @return[Array<Integer, Integer>]
#
def left_right_data(node:)
  left_node_data = node.left&.data
  right_node_data = node.right&.data
  [left_node_data, right_node_data]
end

def test # rubocop:disable Metrics/MethodLength
  bt1 = BinaryTree.new(data: 100)
  arr1 = [60, 47, 45, 50, 48, 65, 70, 80, 75, 73, 110, 105, 125]
  arr1.each do |data|
    bt1.insert(data:)
  end

  bt2 = BinaryTree.new(data: 50)
  arr2 = [40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80]
  arr2.each do |data|
    bt2.insert(data:)
  end

  node_hsh = {
    bt1 => [
      node_arr_one: {
        node1: BinaryTreeNode.new(data: 45),
        node2: BinaryTreeNode.new(data: 70)
      },
      node_arr_two: {
        node1: BinaryTreeNode.new(data: 47),
        node2: BinaryTreeNode.new(data: 73)
      },
      node_arr_three: {
        node1: BinaryTreeNode.new(data: 47),
        node2: BinaryTreeNode.new(data: 47)
      }
    ],
    bt2 => [
      node_arr_one: {
        node1: BinaryTreeNode.new(data: 35),
        node2: BinaryTreeNode.new(data: 130)
      },
      node_arr_two: {
        node1: BinaryTreeNode.new(data: 125),
        node2: BinaryTreeNode.new(data: 130)
      },
      node_arr_three: {
        node1: BinaryTreeNode.new(data: 80),
        node2: BinaryTreeNode.new(data: 80)
      }
    ]
  }
  [bt1, bt2].each do |bt|
    node_arr = node_hsh[bt]
    node_arr.each do |node_values|
      node_values.each_value do |node_pair|
        node1 = node_pair[:node1]
        node2 = node_pair[:node2]
        path = nodes_on_path(node1:, node2:, root: bt.root)
        puts "path :: #{path.inspect}"
      end
    end
  end
end

test
