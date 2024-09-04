# frozen_string_literal: true

# Design a stack that supports push, pop, top, and retrieving the
# minimum element in constant time.

# Implement the MinStack class:

# MinStack() initializes the stack object.
# void push(int val) pushes the element val onto the stack.
# void pop() removes the element on the top of the stack.
# int top() gets the top element of the stack.
# int getMin() retrieves the minimum element in the stack.
# You must implement a solution with O(1) time complexity for
# each function.

# Example 1:

# Input
# ["MinStack","push","push","push","getMin","pop","top","getMin"]
# [[],[-2],[0],[-3],[],[],[],[]]

# Output
# [null,null,null,null,-3,null,0,-2]

# Explanation
# MinStack minStack = new MinStack();
# minStack.push(-2);
# minStack.push(0);
# minStack.push(-3);
# minStack.getMin(); // return -3
# minStack.pop();
# minStack.top();    // return 0
# minStack.getMin(); // return -2

# Key Idea: The tricky portion for this problem is to find the
# minimum value in stack at all times. This is trickier than
# what we would normally expect because, Stack can contain
# many elements, and as we pop, the state of Stack changes
# dynamically. This implies that the minimum element out of all
# elements in Stack should also change dynamically, it cannot be
# static where we maintain a single variable to hold the current
# minimum of Stack. If the minimum element is popped from Stack
# we need to find the next minimum element in Stack.
# Stack: [1, 2, 3, 4, 5, 6, -1], curr_min = -1
# Stack after 1st pop: [21, 6, 5, 3, 5, 6] min = 3
# Stack after 3rd pop: [ 21, 6, 5, 3] min = 3
# Stack after 4th pop: [21, 6, 5] min = 5

# We can implement Stack using min_heap but this would be
# incorrect because Min Heap and Stack are 2 different
# data structures. Push, pop of Stack would correspond to
# Insert, Extract-Max of Max-Heap, both of which would take
# O(log n) time which is not O(1), thus giving us an
# incorrect solution

# Algorithm: We can implement these operations using 2 stacks
# one which maintains all the elements in Stack, and the other
# that maintains min element of all elements in stack. This is
# easy to implement because, right at the time of inserting any
# element in Stack, we can compare it with the top element of
# min stack (which would always contain the smallest element)
# found so far, if the elemnt is <= (Equality is important -
# because a Stack can contain duplicates) top element of min
# stack, we would push it on both stack and min stack. When we
# pop element from a stack, if it is same as top element of
# min stack, pop it from min stack as well.
# CRITICAL: 1st element should be pushed on both stack and
# min stack, min stack does not contain any elements to compare
# it must be initialized to 1st element

# Class to implement Min Stack
class MinStack
  attr_accessor :arr, :min_arr

  def initialize
    @arr = []
    @min_arr = []
  end

  # @param [Integer] data
  #
  def push(data:)
    @arr.push(data)
    # data being pushed is <= Top element in min stack
    # min stack is empty and there is nothing to compare
    # so push 1st element in both stacks, this is crucial
    return unless @min_arr.empty? || data <= @min_arr.last

    @min_arr.push(data)
  end

  # Pop element
  def pop
    begin
      raise StandardError 'Stack is Empty' if empty?
    rescue StandardError
      puts 'Stack is Empty, cannot pop'
      return nil
    end
    element = @arr.pop
    return unless element == @min_arr.last

    @min_arr.pop
  end

  # Min element
  def min_element
    @min_arr.last
  end

  # Top Element
  def peek
    @arr.last
  end

  def size
    @arr.size
  end

  def empty?
    @arr.empty?
  end

  def display
    puts "Stack :: #{@arr.inspect}"
    puts "Min Stack :: #{@min_arr.inspect}"
  end
end

# Test
def test
  arr = [3, 2, 2, 7, 8, 9, -1, 21, 25, -3, 90, -5, 100, 150]
  st = MinStack.new
  arr.each do |data|
    st.push(data:)
  end
  st.display

  2.times do
    st.pop
    puts "Popping elements from Stack, Min should be -5 :: #{st.min_element}"
  end
  2.times do
    st.pop
    puts "Popping elements from Stack, Min should be -3 :: #{st.min_element}"
  end
  3.times do
    st.pop
    puts "Popping elements from Stack, Min should be -1 :: #{st.min_element}"
  end
  5.times do
    st.pop
    puts "Popping elements from Stack, Min should be 2 :: #{st.min_element}"
  end
  st.pop
  puts "Min should be 3 :: #{st.min_element}"
end

test
