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

  # This initialization is important because if we
  # initialize slow = fast = head.next, we would have
  # to check for fast being nil in iteration loop and
  # only if fast is NOT NIL, we would advance slow pointer
  # This is more work and more complex, than the simple
  # condition of checking fast && fast.next, and letting
  # the iteration loop stop whenever fast becomes NIL
  # slow in this case will be the middle element
  slow = head
  fast = head

  # This condition is logical because we are going to access
  # a. fast = fast -> next -> next
  #    => fast -> next: We can only access "next" pointer on fast
  #       if fast != null
  #    => fast -> next -> next: We can only access "next" pointer
  #       on fast -> next if fast -> next is not null
  while fast && fast.next # rubocop:disable Style/SafeNavigation
    # fast is not null, fast.next is not nil, so it is safe to access next
    fast = fast.next.next
    # For even number of elements in list, fast will be
    # nil when slow is at the middle

    # Odd Number of nodes in linked list:
    # Both slow/fast start at 0, fast moves 2 nodes at a
    # time, hence fast will always land on an even node
    # (0 + Even) = Even
    # fast in such a case will reach the last node in the
    # linked list and slow will be at the exact middle.
    # fast.next = nil and hence iteration will stop
    # num of nodes = 3, slow = 2, fast = nil => iteration stops
    # num of nodes = 5, slow = 3, fast = nil => iteraiton stops

    # Even number of nodes in linked list:
    # Both slow/fast start at 0, fast moves 2 nodes at a time,
    # hence fast will become nil in current iteration while
    # slow is at the middle position. The condition that fast != null
    # will ensure that iteration stops, and slow will continue
    # to retain its middle position, which we can return
    # num of nodes = 2, slow = 1, fast = 3 = nil in current
    # iteration.
    # In next iteration, fast != nil fails, and hence we stop
    # num of nodes = 4, slow = 2, fast = 5 = nil
    slow = slow.next
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
