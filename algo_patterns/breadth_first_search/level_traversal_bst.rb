# frozen_string_literal: true

require_relative '../data_structures/binary_tree'
require_relative '../data_structures/queue'
# Perform level order traversal of binary search tree
# @param [Node] root
# @return [NIL]
#
def level_order_traversal(node:)
  queue = Queue.new
  queue.enqueue(data: node)
  level = 1
  until queue.empty?
    level_size = queue.size
    node_data_arr = []
    level_size.times do
      node = queue.dequeue
      node_data_arr << node.data
      queue.enqueue(data: node.left) if node.left
      queue.enqueue(data: node.right) if node.right
    end
    print_nodes_at_level(level:, node_data_arr:)
    calc_avg_of_level(node_data_arr:)
    level += 1
  end
end

# Calculate the average of all data in nodes at a given level
# @param [Array<Integers>] node_data_arr
#
def calc_avg_of_level(node_data_arr:)
  print 'Average :: '
  avg = node_data_arr.reduce(0) { |acc, data| acc + data } / node_data_arr.size.to_f
  print avg
  puts
end

# Display node data at a specific level
# @param [Integer] level
# @param [Array<Integers>] node_data_arr
#
def print_nodes_at_level(level:, node_data_arr:)
  print "Level #{level} :: "
  node_data_arr.each { |data| print "#{data} " }
  puts
end

bt = BinaryTree.new(data: 50)
arr = [40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
arr.each do |data|
  bt.insert(data:)
end
level_order_traversal(node: bt.root)

puts

bt1 = BinaryTree.new(data: 75)
arr = [50, 100, 40, 55, 85, 110, 35, 45, 53, 60, 90, 105, 120, 22, 58, 65, 103, 108, 115, 20]
arr.each do |data|
  bt1.insert(data:)
end
level_order_traversal(node: bt1.root)
