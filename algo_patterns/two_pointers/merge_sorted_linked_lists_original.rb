# frozen_string_literal: true

require_relative '../data_structures/linked_list'
# Merge 2 sorted lists without creating a new list by splicing one list
#
# @param [LinkedList] list_one
# @param [LinkedList] list_two
# @return [LinkedList]
#
def merge_sorted_linked_lists(list_one:, list_two:)
  display_lists(list_one:, list_two:)

  # The * operator is used here for array destructuring (also known as splat operator in Ruby)
  # It unpacks the array returned by calc_node_with_smaller_val into individual variables
  # This is equivalent to:
  # result = calc_node_with_smaller_val(list_one: list_one, list_two: list_two)
  # curr = result[0]
  # node_list_one = result[1]
  # node_list_two = result[2]
  node_list_one = list_one.head
  node_list_two = list_two.head

  curr, node_list_one, node_list_two = *calc_node_with_smaller_val(node_list_one:, node_list_two:)
  head_merged_list = curr

  while !node_list_one.nil? && !node_list_two.nil?
    curr, node_list_one, node_list_two = *assign_curr_next(node_list_one:, node_list_two:,
                                                           curr:)
  end
  curr.next = !node_list_one.nil? ? node_list_one : node_list_two

  display_merged_sorted_list(head_merged_list:)
end

# Display Sorted Lists
# @param [LinkedList] list_one
# @param [LinkedList] list_two
# @return [NIL]
#
def display_lists(list_one:, list_two:)
  puts "\n\t\tList 1 displayed below"
  list_one.traverse_list
  puts "\n\t\tList 2 displayed below"
  list_two.traverse_list
  puts
end

# Display merged sorted list
# @param [Node] head_merged_list
# @return [NIL]
#
def display_merged_sorted_list(head_merged_list:)
  LinkedList.traverse_list(head_merged_list)
  puts
end

# Initialize curr with the node whose data is less
# @param [LinkedList] node_list_one
# @param [LinkedList]	node_list_two
# @return [Array<Node>]
#
def calc_node_with_smaller_val(node_list_one:, node_list_two:)
  return [node_list_one, node_list_one.next, node_list_two.next] if
    node_list_one.next.data < node_list_two.next.data

  [node_list_two, node_list_one.next, node_list_two.next]
end

# Assign next node to curr based on the data comparison of nodes
# @param [Node] node_list_one
# @param [Node] node_list_two
# @param [Node] curr
# @return [Array<Node>]
#
def assign_curr_next(node_list_one:, node_list_two:, curr:)
  if node_list_one.data < node_list_two.data
    curr.next = node_list_one
    [node_list_one, node_list_one.next, node_list_two]
  else
    curr.next = node_list_two
    [node_list_two, node_list_one, node_list_two.next]
  end
end

list_one = LinkedList.new(input_arr: [1, 3, 5, 11, 15, 25, 28, 30, 31])
list_two = LinkedList.new(input_arr: [2, 4, 6, 8, 9, 10, 13, 14, 16])
merge_sorted_linked_lists(list_one:, list_two:)
