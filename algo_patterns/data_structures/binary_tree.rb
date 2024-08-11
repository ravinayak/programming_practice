# frozen_string_literal: true

require_relative 'binary_tree_node'
# Class implements BinaryTree
# - Insert Node in BinaryTree
# - Search for data in BinaryTree
# - Traversal of a node in BinaryTree
# -		1. Inorder  2. PreOrder  3. PostOrder (With Recursion and without Recursion)
# - Delete a node from BinaryTree
#
class BinaryTree
  attr_accessor :root

  def initialize(data: nil)
    @root = BinaryTreeNode.new(data: data) unless data.nil?
  end

  # Inserts data in BinaryTree
  # @param [Integer] data
  # @return [BinaryTreeNode] root
  #
  def insert(data:)
    return self.root = BinaryTreeNode.new(data: data) if root.nil?

    recursive_insert(node: root, data: data)
  end

  # Search data in BinaryTree
  # @param [Integer] data
  # @return [Hash] BinaryTreeNode, data
  #
  def search(data:)
    return { node: nil, result: false } if root.nil?

    recursive_search(node: root, data: data)
  end

  # Pre-order Traversal
  #
  def pre_order_traversal
    return puts 'Tree is empty' if root.nil?

    puts '********************* Pre Order Traversal of Binary Tree *********************'
    rec_pre_order_traversal(node: root)
    puts '******************************************************************************'
  end

  # Post-order Traversal
  #
  def post_order_traversal
    return puts 'Tree is empty' if root.nil?

    puts '********************* Post Order Traversal of Binary Tree ********************'
    rec_post_order_traversal(node: root)
    puts '******************************************************************************'
  end

  # In-order Traversal
  #
  def in_order_traversal
    return puts 'Tree is empty' if root.nil?

    puts '********************* In Order Traversal of Binary Tree **********************'
    rec_in_order_traversal(node: root)
    puts '******************************************************************************'
  end

  private

  # Pre-Order Traversal - Recursive
  # @param [BinaryTreeNode] node
  #
  def rec_pre_order_traversal(node:)
    return if node.nil?

    print "#{node.data}, "
    rec_pre_order_traversal(node: node.left)
    rec_pre_order_traversal(node: node.right)
  end

  # Post-Order Traversal - Recursive
  # @param [BinaryTreeNode] node
  #
  def rec_post_order_traversal(node:)
    return if node.nil?

    rec_post_order_traversal(node: node.left)
    rec_post_order_traversal(node: node.right)
    print "#{node.data}, "
  end

  # In-Order Traversal - Recursive
  # @param [BinaryTreeNode] node
  #
  def rec_in_order_traversal(node:)
    return if node.nil?

    rec_in_order_traversal(node: node.left)
    print "#{node.data}, "
    rec_in_order_traversal(node: node.right)
  end

  # Recursive Searche for data in BinaryTree
  # @param [BinaryTreeNode] node
  # @param [Integer] data
  # @return [Hash] BinaryTreeNode, data
  #
  def recursive_search(node:, data:)
    return { node: nil, result: false } if node.nil?

    return { node: node, result: true } if node.data == data

    return recursive_search(node: node.left, data: data) if node.data > data

    recursive_search(node: node.right, data: data)
  end

  # Recursively inserts data in BinaryTree following left/right depending upon if
  # data is greater than data on node
  # @param [BinaryTreeNode] node
  # @param [Integer] data
  # @return [BinaryTreeNode]
  #
  def recursive_insert(node:, data:)
    return BinaryTreeNode.new(data: data) if node.nil?

    if node.data >= data
      node.left = recursive_insert(node: node.left, data: data)
    else
      node.right = recursive_insert(node: node.right, data: data)
    end

    node
  end
end

bt = BinaryTree.new(data: 75)
arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
arr.each do |data|
  bt.insert(data: data)
end
bt.in_order_traversal
bt.pre_order_traversal
bt.post_order_traversal
puts bt.search(data: 35)
puts bt.search(data: 78)
puts bt.search(data: 85)
puts bt.search(data: 129)
