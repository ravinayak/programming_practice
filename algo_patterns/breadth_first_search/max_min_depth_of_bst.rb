# frozen_string_literal: true

require_relative '../data_structures/binary_tree'
require_relative '../data_structures/queue'
# Find the shortest/longest depth of a BinaryTree where depth is defined as the length from root to a leaf node
# @param [Node] node
# @return [Hash] {node, depth}
#
def find_shortest_depth(node:)
  queue = Queue.new
  queue.enqueue(data: node)
  depth_found_flag = false
  node_depth_hsh = {}
  level = 0
  while !queue.empty? && !depth_found_flag
    level_size = queue.size
    level += 1
    level_size.times do
      node = queue.dequeue
      if node.left.nil? && node.right.nil?
        node_depth_hsh = { node:, depth: level }
        depth_found_flag = true
        break
      end
      queue.enqueue(data: node.left) if node.left
      queue.enqueue(data: node.right) if node.right
    end
  end
  puts "Node with Shortest Depth :: #{node_depth_hsh.inspect}"
end

# @param [Node] node
# @return [Hash] {node, depth}
#
def find_longest_depth(node:)
  queue = Queue.new
  queue.enqueue(data: node)
  node_depth_hsh = { node: nil, depth: 0 }
  level = 0
  until queue.empty?
    level_size = queue.size
    level += 1
    level_size.times do
      node = queue.dequeue
      node_depth_hsh = { node:, depth: level } if node.left.nil? && node.right.nil? && level > node_depth_hsh[:depth]
      queue.enqueue(data: node.left) if node.left
      queue.enqueue(data: node.right) if node.right
    end
  end
  puts "Node with Longest Depth :: #{node_depth_hsh.inspect}"
end

bt1 = BinaryTree.new(data: 75)
arr = [50, 100, 40, 55, 85, 110, 35, 45, 53, 60, 90, 105, 120, 22, 58, 65, 103, 108, 115, 20, 158, 165, 171, 175, 185]
arr.each do |data|
  bt1.insert(data:)
end
bt1.in_order_traversal
find_shortest_depth(node: bt1.root)
find_longest_depth(node: bt1.root)
