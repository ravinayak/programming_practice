# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/linked_list'

# Reverse a linked list

# Algorithm: Reversing a linked list is not possible with 3
# pointers or 2 nodes at a time for reversal, we MUST OPERATE
# on one node at a time to reverse. If we start with 2 nodes
# at the beginning of the linked list => curr and curr.next,
# this will not work, we must use only 1 node => curr. To
# accomplish this, we use prev as nil and proceed with this
# observation.
# 1. Start from the 1st node as curr, and prev as NIL
# 2. Reverse its next pointer while keeping a reference to
#    the next node of curr
# 3. prev = curr, curr = curr.next (initially stored in step 2)
# 4. Continue until curr becomes nil

# @param [Node] head
# @return [Node]
#
def reverse_linked_list(head:)
  # If linked list is empty, return head
  return head if head.next.nil?

  prev = nil
  curr = head.next

  # Even if curr.next is nil, this condition will not fail in
  # the iteration because curr_next will become nil, next is
  # not accessed on nil value
  until curr.nil?
    curr_next = curr.next
    # Reverse next pointer of curr node
    curr.next = prev
    # Move curr and prev
    prev = curr
    curr = curr_next
  end

  # At the end, when curr == nil, we have reached the last
  # node of the linked list, this should now be the 1st node
  # head should point to this node
  # prev stores the last node of linked list
  head.next = prev

  # Return head
  head
end

def test
  linked_list = LinkedList.new(input_arr: [1, 3, 6, 8, 9, 13, 19, 21, 26])
  linked_list.traverse_list
  reverse_linked_list(head: linked_list.head)
  puts 'Linked List post reversal :: '
  linked_list.traverse_list
end

test
