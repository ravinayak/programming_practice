# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/binary_tree'
require_relative '../algo_patterns/data_structures/queue'
# Given the root of a binary tree, imagine yourself standing on
# the right side of it, return the values of the nodes you
# can see ordered from top to bottom.

# Algorithm: If we want to print only right side / left side of
# a BST, it can be easily implemented using BFS. While performing
# BFS, level-order traversal of a BST
# a. Collect 1st node of each level in BST, this forms left side
#    view
# b. Collect Last node of each level in BST, this forms right
#    side view

# @param [BinaryTreeNode] root
# @return [Array<Array<Integer>>]
def left_right_side_bst(root:)
  # left_side view of BST
  # right_side view of BST
  return [[], []] if root.nil?

  queue = Queue.new
  left_side_view = []
  right_side_view = []

  queue.enqueue(data: root)
  level = 1

  until queue.empty?
    level_size = queue.size

    level_size.times do |i|
      node = queue.dequeue
      left_side_view << node.data if i.zero?
      right_side_view << node.data if i == level_size - 1

      queue.enqueue(data: node.left) if node.left
      queue.enqueue(data: node.right) if node.right
    end

    level += 1
  end

  [left_side_view, right_side_view]
end

def bst
  bt = BinaryTree.new(data: 75)
  arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
  arr.each do |data|
    bt.insert(data:)
  end

  bt1 = BinaryTree.new(data: 91)
  arr = [82, 85, 93, 94]
  arr.each do |data|
    bt1.insert(data:)
  end

  [bt, bt1]
end

def test
  bst_arr = bst
  bst_arr.each do |bst|
    left_side_view, right_side_view = left_right_side_bst(root: bst.root)
    print "\n\n Left side view of BST :: #{left_side_view.inspect}"
    print "\n Right side view of BST :: #{right_side_view.inspect}\n"
  end
end

test
