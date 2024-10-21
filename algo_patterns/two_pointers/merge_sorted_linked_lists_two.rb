require_relative '../data_structures/linked_list'

def merge_sorted_linked_lists_two(list_one:, list_two:)
  return if list_one.head.next.nil? && list_two.head.next.nil?

  node1 = list_one.head.next
  node2 = list_two.head.next

  curr_node = Node.new(data: nil)
  assign_curr_node(list_one_head: list_one.head, list_two_head: list_two.head, curr_node:)
  head = curr_node.next
  # Make this node eligible for garbage collection
  curr_node.next = nil

  curr_node, node1, node2 = compare_node_data(node1:, node2:, curr_node:) while node1 && node2

  curr_node.next = node1 unless node1.nil?
  curr_node.next = node2 unless node2.nil?

  traverse_list(head:)
  head
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

def compare_node_data(node1:, node2:, curr_node:)
  if node1.data <= node2.data
    curr_node.next = node1
    return [node1, node1.next, node2]
  end

  curr_node.next = node2
  [node2, node1, node2.next]
end

def assign_curr_node(list_one_head:, list_two_head:, curr_node:)
  return curr_node.next = list_one_head if list_two_head.next.nil?

  return curr_node.next = list_two_head if list_one_head.next.nil?

  return curr_node.next = list_one_head if list_one_head.next.data <= list_two_head.next.data

  curr_node.next = list_two_head
end

def test
  list_one = LinkedList.new(input_arr: [1, 3, 5, 11, 15, 25, 28, 30, 31])
  list_two = LinkedList.new(input_arr: [2, 4, 6, 8, 9, 10, 13, 14, 16])
  merge_sorted_linked_lists_two(list_one:, list_two:)
end

test
