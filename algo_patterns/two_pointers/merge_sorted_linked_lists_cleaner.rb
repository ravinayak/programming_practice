require_relative '../data_structures/linked_list'

def merge_sorted_linked_lists_cleaner(list_one:, list_two:)
  return if list_one.head.next.nil? && list_two.head.next.nil?

  list_one_node = list_one.head.next
  list_two_node = list_two.head.next

  head = assign_head_smaller_data(list_one:, list_two:, list_one_node:, list_two_node:)
  curr = head

  while list_one_node && list_two_node
    curr_node, list_one_node, list_two_node = assign_nodes(list_one_node:, list_two_node:)
    curr.next = curr_node
    curr = curr_node
  end

  # curr will always point on the node which has moved to the next node, only that node can
  # become nil, because the other node must not have been NIL for the comparison to occur
  # in the 1st place. This implies if curr is pointing to list_two node, list_two node has
  # moved and could become NIL. list_one_node is not pointed by curr, and hence we iterate
  # until list_one_node becomes empty and in each iteration before moving list_one_node, we
  # assign curr.next = list_one_node
  #
  while list_one_node
    curr.next = list_one_node
    list_one_node = list_one_node.next
  end

  while list_two_node
    curr.next = list_two_node
    list_two_node = list_two_node.next
  end

  traverse_list(head:)
  head
end

def assign_head_smaller_data(list_one:, list_two:, list_one_node:, list_two_node:)
  return list_one.head if list_one_node.data <= list_two_node.data

  list_two.head
end

def assign_nodes(list_one_node:, list_two_node:)
  return [list_one_node, list_one_node.next, list_two_node] if list_one_node.data <= list_two_node.data

  [list_two_node, list_one_node, list_two_node.next]
end

def traverse_list(head:)
  print "\n\n Printing Sorted Linked List Data :: \n"
  node = head.next
  while node
    print " #{node.data} "
    print '-->' unless node.next.nil?
    node = node.next
  end
  print "\n\n"
end

def test
  list_one = LinkedList.new(input_arr: [1, 3, 5, 11, 15, 25, 28, 30, 31])
  list_two = LinkedList.new(input_arr: [2, 4, 6, 8, 9, 10, 13, 14, 16])
  merge_sorted_linked_lists_cleaner(list_one:, list_two:)
end

test
