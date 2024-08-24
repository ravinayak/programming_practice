# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/stack'
# To implement a queue using two stacks in Ruby efficiently, we will use two stacks
# to manage the queue operations. This approach ensures that each element is moved
# only once between the stacks, making the operations efficient.

# Approach:
# 1. Two Stacks: Use two stacks, stack_in and stack_out.
#     a. stack_in is used for enqueue operations.
#     b. stack_out is used for dequeue operations.
# 2. Enqueue Operation (push):
#     a. Simply push the new element onto stack_in.
# 3. Dequeue Operation (pop):
#     a. If stack_out is empty, pop all elements from stack_in and push them onto stack_out.
#     b. This reverses the order, making the first element to be enqueued the first to be
#        dequeued.
#     c. Then, pop the top element from stack_out.
#     d. If stack_out is NOT empty, we have already transferred elements from stack_out to
#         stack_in reversing the order. 1st element to be enqueued is at the top of stack_out
#         We keep popping elements from stack_out unitl it becomes empty. This gives the
#          elements (removes) them in correct order (since order has been reversed)
#     e. If stack_out is empty even after a transfer, it means there are no elements in both
#         stack_in and stack_out. Raise an error, nothing to pop
#  4. Size of Queue:
#      a. Total elements in Queue = Elements in stack_in + Elements in stack_out
#      b. stack_in may contain elements that were pushed onto it but have not been transferred
#      c. stack_out may contain elements that were transferred to it before a pop/peek
#  5. Peek:
#      a. Same as Dequeue but we do not remove element from top of stack_out, we simply return
#         element at top of stack_out
#      b. If stack_out is empty even after a transfer, no elements in stack_in or stack_out. In
#         this use case, we simply return NIL
#  6. Empty:
#      a. Since both stack_in and stack_out may contain elements, Queue will be empty if both
#         stack_in and stack_out are empty. If one of them contains elements, it means there
#         are elements in Queue, and Queue is NOT EMPTY

# Understanding Amortized Time Complexity for the Dequeue Operation in a Queue Implemented with
# Two Stacks To explain why the dequeue operation in a queue implemented using two stacks has
# an amortized time complexity of O(1), we need to understand how the stacks are used and what
# "amortized" means in this context.

# How the Two-Stack Queue Works
# 1. Two Stacks (stack_in and stack_out):
#     a. stack_in is used to push (enqueue) new elements.
#     b. stack_out is used to pop (dequeue) elements.
# 2. Enqueue (enqueue) Operation:
#     a. Every element is simply pushed onto stack_in. This operation always takes O(1) time
# 3. Dequeue (dequeue) Operation:
#     a. If stack_out is not empty, pop an element from stack_out and return it. This operation
#         is O(1)
#      b. If stack_out is empty, all elements from stack_in are transferred to stack_out
#        (one by one),and then an element is popped from stack_out.
#      c. The transfer operation can take up to O(n) time if there are n elements in stack_in

# Amortized Analysis: Why Dequeue is O(1) on Avergae:
# Amortized time complexity considers the average time per operation over a sequence of operations,
# rather than the worst-case time of a single operation. Here’s why the amortized time complexity
# of the dequeue operation is O(1)
# 1. Single Transfer Per Element:
#     a. An element is moved from stack_in to stack_out at most once throughout its lifetime in
#        the queue.
#     b. Once transferred to stack_out, an element will not be moved back to stack_in. It stays
#        in stack_out until it is dequeued
# 2. Cost Breakdown:
#     a. When an element is enqueued, it is pushed to stack_in, costing O(1)
#     b. When a dequeue operation requires a transfer from stack_in to stack_out, the cost of
#        transferring n elements is O(n)
#     c. After the transfer, each of these n elements can be dequeued in O(1) time because they
#        are now in stack_out
# 3. Amortized Calculation:
#     a. Consider n enqueue operations followed by n dequeue operations
#     b. Each element is enqueued in O(1) time
#     c. The first dequeue operation after the transfer is O(n) because of the transfer, but
#        all subsequent dequeues are O(1) since elements are already in stack_out
#     d. The total cost for dequeuing n elements is
#          => O(n)+O(1)+O(1)+...+O(1) = O(n) (after the transfer)
#     e. The total cost for n enqueue operations and n dequeue operations is O(n) + O(n) = O(2n)
#     f. The average (amortized) time per operation is = O(2n)/n = O(1)

# Summary:
# 1. Worst-case time complexity for a single dequeue operation can be O(n) when a transfer is needed.
# 2. Amortized time complexity for dequeue over a sequence of operations is O(1) because each
#    element is transferred at most once and then only popped once.
# 3. This O(1) amortized time is achieved because the cost of transferring elements from stack_in to
#    stack_out is spread out over all the dequeue operations, effectively making each operation constant
#     time on average.

# Implement Queue using Stacks
class QueueImplementedUsingStacks
  attr_accessor :stack_in, :stack_out

  def initialize
    @stack_in = Stack.new
    @stack_out = Stack.new
  end

  # Enqueue Operation
  # @param [Integer] data
  #
  def enqueue(data:)
    @stack_in.push(data:)
  end

  # Dequeue Operation
  # @return [Integer|NIL]
  #
  def dequeue
    # This line can be abstracted into a method transfer_elements
    # as written below which can be called directly in both
    # dequeue and peek without checking for @stack_out.empty?
    # Keeping this code to ensure better understanding of
    # implementation
    if @stack_out.empty?
      until @stack_in.empty? # rubocop:disable Style/WhileUntilModifier
        @stack_out.push(@stack_in.pop)
      end
    end

    # Error condition when stack_out is empty is taken care of by
    # stack class. It prints StandardError "Stack is empty" and returns NIL
    @stack_out.pop
  end

  # Return the 1st element in Queue
  # @return [Integer|NIL]
  #
  def peek
    if @stack_out.empty?
      until @stack_in.empty? # rubocop:disable Style/WhileUntilModifier
        @stack_out.push(@stack_in.pop)
      end
    end
    # If no elements are present in stack_out, returns NIL
    @stack_out.peek
  end

  # Return the size of Queue
  # @return [Integer]
  #
  def size
    @stack_in.size + @stack_out.size
  end

  # Empty
  # @return [Boolean]
  #
  def empty?
    @stack_in.empty? && @stack_out.empty?
  end

  private

  def transfer_elements
    return unless @stack_out.empty?

    @stack_out.push(@stack_in.pop) until @stack_in.empty?
  end
end

def test
  st = Stack.new
  st.push(data: 1)
  st.push(data: 2)
  st.push(data: 3)
  st.display
  puts "Peek :: #{st.peek}"
  puts "Pop :: #{st.pop}"
  puts "Pop :: #{st.pop}"
  puts "Pop :: #{st.pop}"
  puts 'All elements have been removed from Stack, and so it should be empty as displayed below ::'
  st.display
  st.pop
end

test
