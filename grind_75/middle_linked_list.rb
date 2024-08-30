# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/linked_list'
# frozen_string_literal: true

# To find the middle of a linked list, we can use the
# bare approach,
# 1. Traverse till the end of list, count number of
#    nodes
# 2. Traverse list again until count becomes n/2
# This would require us to traverse the linked list
# twice

# We can use the 2 poiner approach to solve this in
# one iteration
# Key Idea here is to use a pointer which moves at
# 2x speed (2 nodes at a time)
# In any iteration, if we have iterated "x" times,
# slow will move "x", while fast will move "2x"
# When fast reaches end of list (nil), slow will
# be at middle (n/2)
# Because fast moves at 2x speed, we have to check if
# the next pointer of next node after fast is not nil

# @param [Node] head
# @return [Node]
#
def middle_linked_list(head:)
  # If linked list is empty, return nil
  return nil if head.next.nil?

  slow = fast = head.next

  while fast&.next
    # fast.next is not nil, so it is safe to access next
    fast = fast.next.next
    # For even number of elements in list, fast will be
    # nil when slow is at the middle

    # Odd Number of nodes in linked list:
    # Both slow/fast start at 1, fast moves 2 nodes at a
    # time, hence fast will always land on an odd node
    # (1 + Even) = odd => (odd + Even) = odd
    # fast in such a case will reach the last node in the
    # linked list and slow will be at the exact middle.
    # fast.next = nil and hence iteration will stop
    # num of nodes = 3, slow = 2, fast = 3 => iteration stops
    # num of nodes = 5, slow = 3, fast = 5 => iteraiton stops

    # Even number of nodes in linked list:
    # Both slow/fast start at 1, fast moves 2 nodes at a time,
    # hence fast will become nil in current iteration while
    # slow is at the middle position. If we move slow, we will
    # get incorrect result. Hence we must check if fast is still
    # valid
    # num of nodes = 2, slow = 1, fast = 3 = nil in current
    # iteration. If we move slow while fast is nil in current
    # iteration, it will become 2 and be incorrect. Check for
    # fast = nil before moving ahead
    # num of nodes = 4, slow = 2, fast = 5 = nil
    slow = slow.next if fast
  end

  # slow points to the middle node
  slow
end

def test
  l1 = LinkedList.new(input_arr: [1, 3, 6, 8, 9, 13, 19, 21, 26])
  l2 = LinkedList.new(input_arr: [1])
  l3 = LinkedList.new(input_arr: [1, 2])
  l4 = LinkedList.new(input_arr: [1, 2, 3, 4])
  list_arr = [
    { list: l1, middle: 9 },
    { list: l2, middle: 1 },
    { list: l3, middle: 1 },
    { list: l4, middle: 2 }
  ]
  list_arr.each do |list_hsh|
    list = list_hsh[:list]
    expected_middle = list_hsh[:middle]
    middle = middle_linked_list(head: list.head)
    middle_data = middle.nil? ? 'NIL' : middle.data
    puts 'Linked List below'
    list.traverse_list
    print "Expected Middle :: #{expected_middle}, "
    print "Middle Element found :: #{middle_data} \n"
    puts
  end
end

test
