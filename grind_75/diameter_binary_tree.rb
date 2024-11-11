# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree'
# Given the root of a binary tree, return the length of the diameter of
# the tree.

# The diameter of a binary tree is the length of the longest path between
# any two nodes in a tree. This path may or may not pass through the root.

# The length of a path between two nodes is represented by the number of
# edges between them

# Algorithm is simple, we calculate the sum of left height, right height
# for every node in the tree as height of that node. We keep a variable
# diameter, and node to keep track of the maximum height encountered so
# far. At any node, if the height of node is greater than diameter, we
# update both diameter and node variables

# Recursion solves this problem easily, non recursive would require some
# more thought
# @param [BinaryTreeNode] root
# @return [Array<Integer, Integer>] diameter, node data
#
def bt_diameter(root:)
  diameter_node_data = { diameter: 0, node_data: nil, height_hsh: {}, path: [] }
  bt_diameter_utility(node: root, diameter_node_data:)

  # Return array
  diameter_node_data
end

# @param [BinaryTreeNode] node
# @param [Hash] diameter_node_data
#
def bt_diameter_utility(node:, diameter_node_data:)
  # Base Case of recursion: If node is nil, there is no height of the node,
  # hence we return 0

  return 0 if node.nil?

  left_height = bt_diameter_utility(node: node.left, diameter_node_data:)
  right_height = bt_diameter_utility(node: node.right, diameter_node_data:)

  # Diameter of a node represents (as per problem statement) the maximum #
  # of (edges in the left subtree, edges in the right subtree) of the node
  # We calculate the sum of left/right heights for the node.
  # Left height of a node represents the maximum number of nodes in the left
  # subtree of that node. Same for right height of the node.
  # Sum of left/right heights of a node represents the maximum number of
  # nodes in the left/right subtree of that node excluding the node
  # Each node in a subtree represents an edge from the current node to
  # the other node. Hence maximum number of nodes in the left/right subtree
  # represents the total number of edges from the current node. When we do
  # NOT add 1, we exclude the node. This gives us the correct answer.
  # This gives the maximum number of edges from one node to another node
  # in the tree.
  # If diameter was defined as the maximum number of nodes from one node
  # to another node in the tree, we would include node as well and in such
  # case, we would add 1
  # Diameter here represents the maximum number of edges going through this
  # node including both left/right subtrees
  diameter = left_height + right_height

  # Height of a node in the binary tree represents the maximum of
  # (nodes in left subtree, nodes in right subtree) of that node
  # including the node iteself.
  # Height of a node in the tree represents the total number of nodes
  # on the longest path from that node to the leaf node including the
  # node itself. So, we add 1 to the height calculation
  # For a leaf node, the height should be 1, this is the yardstick we
  # can use to check the calculation
  height = [left_height, right_height].max + 1

  left_node_data, right_node_data = left_right_data(node:)

  diameter_node_data[:height_hsh].merge!(
    { [node.data, left_node_data, right_node_data] => [left_height, right_height] }
  )

  # If diameter of current node is greater than the max diameter recorded
  # so far, update the diameter
  if diameter > diameter_node_data[:diameter]
    diameter_node_data[:diameter] = diameter
    diameter_node_data[:node_data] = node.data
    path = []

    # For binary tree 1 in test method, the path
    # should be:
    # [48, 50, 47, 60, 65, 70, 80, 75, 73]
    # 48 => Leaf node, 50 => Parent of 48, 47 => Parent of 48
    # 48, 50, 57 are in the left subtree of 60
    # 60 => Node whose diameter is being calculated
    # 65 => 1st right child of 60, 70 => Right child of 65 and so on
    # 65, 70, 80, 75, 73 are in the right subtree of 60
    # From the above path, we can clearly observe that for left
    # subtree of node (60), we want to add node data only when we
    # have recursed down to the leaf node. So in collect_path
    # method, if is_left is true, we push node.data at the end
    # For right subtree, we want to add node data immediately
    # when we encounter the node, so if is_left is false, we
    # add node.data right at the start of the method before
    # recursion
    left_path = collect_path(node: node.left,
                             height_hsh: diameter_node_data[:height_hsh],
                             is_left: true)
    right_path = collect_path(node: node.right,
                              height_hsh: diameter_node_data[:height_hsh],
                              is_left: false)

    # concat method concats array values to existing array
    # 1. left_path array values are concatenated
    # 2. node.data (node whose diameter is max) is added
    # 3. right_path array values are concatenated
    # This is the order we follow

    path.concat(left_path)

    path.push(node.data)

    path.concat(right_path)

    diameter_node_data[:path] = path
  end

  # Return height, since diameter includes left and right height in its
  # calculation
  height
end

# @param [BinaryTreeNode] node
# @param [Hash] height_hsh
# @param [Boolean] is_left
#
def collect_path(node:, height_hsh:, is_left:)
  return [] if node.nil?

  path = []
  left_node_data, right_node_data = left_right_data(node:)
  key = [node.data, left_node_data, right_node_data]

  left_height, right_height = height_hsh[key]

  # If we are in the right subtree of the node, we want to add nodes
  # as we recurse downwards from the given node to leaf on the
  # longest path immediately when we encounter the node
  path.push(node.data) unless is_left

  if left_height > right_height
    path.concat(collect_path(node: node.left, height_hsh:, is_left:))
  else
    path.concat(collect_path(node: node.right, height_hsh:, is_left:))
  end

  # If we are in the left subtree of the node, we want to recurse
  # until we reach the leaf node, and we want to add node data as
  # we recurse upwards from the leaf node to given node. We add node
  # data when we have recursed completely, so adding it here at the
  # bottom
  path.push(node.data) if is_left

  path
end

# @param [BinaryTreeNode] node
# @return[Array<Integer, Integer>]
#
def left_right_data(node:)
  left_node_data = node.left&.data
  right_node_data = node.right&.data
  [left_node_data, right_node_data]
end

def test
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

  bt3 = BinaryTree.new(data: 100)
  arr3 = [60, 47, 45, 50, 48, 65, 63, 62, 61, 70, 80, 75, 73, 110,
          105, 125]
  arr3.each do |data|
    bt3.insert(data:)
  end

  [bt1, bt2, bt3].each do |bt|
    diameter_node_data = bt_diameter(root: bt.root)
    diameter = diameter_node_data[:diameter]
    node_data = diameter_node_data[:node_data]
    path = diameter_node_data[:path]
    print "Diameter :: #{diameter}, Node Data :: #{node_data}, "
    puts "path :: #{path.inspect}"
  end
end

test

# Simplified Diameter Calcluation code

# def diameter_bt
#   diameter_hsh = { max_diameter: -1, node: nil, path_arr: [] }
#   node_hsh = {}
#   diameter_bt_rec(node: root, diameter_hsh:, node_hsh:)
#   diameter_hsh
# end

# private

# def diameter_bt_rec(node:, diameter_hsh:, node_hsh:)
#   return 0 if node.nil?

#   left_height = diameter_bt_rec(node: node.left, diameter_hsh:, node_hsh:)
#   right_height = diameter_bt_rec(node: node.right, diameter_hsh:, node_hsh:)

#   height = [left_height, right_height].max + 1
#   diameter = left_height + right_height

#   node_hsh[node_key(node:)] = [left_height, right_height]

#   return height unless diameter > diameter_hsh[:max_diameter]

#   diameter_hsh[:max_diameter] = diameter
#   diameter_hsh[:node] = node
#   diameter_hsh[:path_arr] = prep_path_arr(node_hsh:, node:)

#   height
# end

# def prep_path_arr(node_hsh:, node:)
#   path_arr = []
#   calculate_path(path_arr:, node: node.left, node_hsh:, is_left: true)
#   path_arr << node.data
#   calculate_path(path_arr:, node: node.right, node_hsh:, is_left: false)
#   path_arr
# end

# def calculate_path(path_arr:, node:, node_hsh:, is_left:)
#   return if node.nil?

#   path_arr << node.data unless is_left

#   left_height, right_height = node_hsh[node_key(node:)]

#   if left_height > right_height
#     calculate_path(path_arr:, node: node.left, node_hsh:, is_left:)
#   else
#     calculate_path(path_arr:, node: node.right, node_hsh:, is_left:)
#   end
#   path_arr << node.data if is_left

#   nil
# end

# def node_key(node:)
#   [node.data, node.left&.data, node.right&.data]
# end


# Simplified Height Calcluation code

# def height
#   height_rec(node: root)
# end

# private

# def height_rec(node:)
#   return 0 if node.nil?

#   left_height = height_rec(node: node.left)
#   right_height = height_rec(node: node.right)
#   [left_height, right_height].max + 1
# end
