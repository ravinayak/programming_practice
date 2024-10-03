# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/linked_list'
# To detect a cycle in linked list, we use the concept of 2
# pointers, just like we did to find middle of a linked list
# Here condition check remains same with slight twist in logic

# Algorithm: Key idea here is that if there is a cycle in
# linked list, both slow and fast pointer will converget to
# the same node at some point during iteration. If there is
# no cycle, iteration will end with fast or fast.next becoming
# nil

# @param [Node] head
# @return [Boolean]
#
def detect_cycle(head:)
  return { cycle: false } if head.nil? || head.next.nil?

  # Initialize both slow/fast pointers to head like finding
  # middle of a linked list
  slow = head
  fast = head

  # fast moves 2x, so we have to check both fast and fast.next of
  # not becoming nil
  # Both slow and fast must be initialized to the same node before
  # iteration. This is to ensure that in the loop fast/slow converge
  # to the same node. If slow is initialized to nil, we would have
  # 2 problems:
  #   a. slow.next is error
  #   b. fast == slow must be checked in the while loop
  #   c. loop will exit and we would have to check if fast == slow to
  #    detect cycle

  # Consider a linked list with 2 nodes and a cycle where 2nd node
  # points to 1st node
  while fast&.next
    # Both fast & fast.next are not nil, so it is safe
    fast = fast.next.next
    slow = slow.next

    # If slow and fast meet, there's a cycle
    return { cycle: true } if slow == fast
  end

  # We have reached end of linked list and no cycle was detected
  { cycle: false }
end

def test
  linked_list = LinkedList.new(input_arr: [1, 3, 6, 8, 9, 13, 19, 21, 26])
  print "\nLinked List below :: \n"
  linked_list.traverse_list
  print "Cycle in Linked List :: #{detect_cycle(head: linked_list.head)[:cycle]}\n\n"

  cycle_list = LinkedList.new(input_arr: [1, 2, 3, 4, 5])
  curr = cycle_list.head
  node_data_three = nil
  while curr.next
    node_data_three = curr if curr.data == 3
    curr = curr.next
  end
  curr.next = node_data_three
  cycle_str = '1 -> 2 -> 3 -> 4 -> 5 -> 3 -> 4 -> 5 -> 3.....'

  puts "Linked list with cycle :: #{cycle_str}"
  print "Cycle in Linked List :: #{detect_cycle(head: cycle_list.head)[:cycle]}\n\n"
end

test
