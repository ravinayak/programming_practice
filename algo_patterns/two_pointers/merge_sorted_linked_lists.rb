# frozen_string_literal: true

require_relative '../data_structures/linked_list'
# Merge 2 sorted lists without creating a new list by splicing one list
#
# @param [LinkedList] list1
# @param [LinkedList] list2
# @return [LinkedList]
#
def merge_sorted_linked_lists(list1:, list2:)
  display_lists(list1: list1, list2: list2)

  list1.head
  list2.head

  # The * operator is used here for array destructuring (also known as splat operator in Ruby)
  # It unpacks the array returned by calc_node_with_smaller_val into individual variables
  # This is equivalent to:
  # result = calc_node_with_smaller_val(list1: list1, list2: list2)
  # curr = result[0]
  # node_list_1 = result[1]
  # node_list_2 = result[2]
  curr, node_list_1, node_list_2 = *calc_node_with_smaller_val(list1: list1, list2: list2)
  head_merged_list = curr

  while !node_list_1.nil? && !node_list_2.nil?
    curr, node_list_1, node_list_2 = *assign_curr_next(node_list_1: node_list_1, node_list_2: node_list_2, curr: curr)
  end
  curr.next = !node_list_1.nil? ? node_list_1 : node_list_2

  display_merged_sorted_list(head_merged_list: head_merged_list)
end

# Display Sorted Lists
# @param [LinkedList] list1
# @param [LinkedList] list2
# @return [NIL]
#
def display_lists(list1:, list2:)
  puts "\n\t\tList 1 displayed below"
  list1.traverse_list
  puts "\n\t\tList 2 displayed below"
  list2.traverse_list
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
# @param [LinkedList] list1
# @param [LinkedList]	list2
# @return [Array<Node>]
#
def calc_node_with_smaller_val(list1:, list2:)
  return [list1.head, list1.head.next, list2.head] if list1.head.data < list2.head.data

  [list2.head, list1.head, list2.head.next]
end

# Assign next node to curr based on the data comparison of nodes
# @param [Node] node_list_1
# @param [Node] node_list_2
# @param [Node] curr
# @return [Array<Node>]
#
def assign_curr_next(node_list_1:, node_list_2:, curr:)
  if node_list_1.data < node_list_2.data
    curr.next = node_list_1
    [node_list_1, node_list_1.next, node_list_2]
  else
    curr.next = node_list_2
    [node_list_2, node_list_1, node_list_2.next]
  end
end

list1 = LinkedList.new(input_arr: [1, 3, 5, 11, 15, 25, 28, 30, 31])
list2 = LinkedList.new(input_arr: [2, 4, 6, 8, 9, 10, 13, 14, 16])
merge_sorted_linked_lists(list1: list1, list2: list2)
