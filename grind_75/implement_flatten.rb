# frozen_string_literal: true

# Implement Flatten method in Ruby using custom implementation
# Idea here is that flatten method takes an array which could
# contain simple elements, or other nested arrays and returns
# a flattened array which only contains elements from nested
# arrays, simple elements. i.e A single array which contains
# only elements. Order of elements returned in the flattened
# array should be same as the elements in original array

# Algorithm: Core idea here is to use recursion where we pass
# results array. Iterate over each element in the array, if the
# element is an array, we call the recursion with this element
# and results array, else we push the element into array
# Recursion will keep getting called unless we reach an element
# in nested array which is not an array but a simple element,
# and will be pushed into the array. Recursion will backtrack
# to previous level and repeat the same process

# @param [Array<Integer|Array<Integer>] input_arr
# @return [Array<Integer>]
#
def custom_flatten(input_arr:)
  results = []
  custom_flatten_helper(input_arr:, results:)
end

# @param [Array<Integer|Array<Integer>] input_arr
# @param [Array<Integer>] results
# @return [Array<Integer>]
#
def custom_flatten_helper(input_arr:, results:)
  # Precaution step not base case of recursion
  return if input_arr.empty?

  # Iterate over each element in the array
  input_arr.each do |element|
    # Call the recursion again with this element if it
    # is an array
    if element.is_a?(Array)
      custom_flatten_helper(input_arr: element, results:)
    else
      # element is not an array, push the element into
      # results array
      results << element
    end
  end

  # Return results array
  results
end

# This is the non-recursive implementation for flatten method. In
# non-recursive implementation, we have to maintain a stack
# In most places, we can simulate stack using an array
# if we have a method (on objects which are to be pushed onto stack)
# to reverse the objects before pushing onto stack.
# Key Idea: Push an element into an array, which serves as a stack.
# Until the stack is empty, pop elements from the stack and for each
# element popped from the stack, check if it is an array.
# a. If element is NOT an array, we can push it into results array
# b. If element is an array, we would iterate over its elements onto
# stack. This is because we do not know if the elements in the array
# are simple elements or arrays themselves. However, stack is LIFO
# data structure. If we push elements by iterating over array, when
# we pop, the last element of array will get added to results array
# reversing the order of elements in the original array. To avoid
# this, we reverse array before pushing each element onto stack. This
# guarantees that the elements will be popped from stack in correct
# order,
#  reverse => last element will be the 1st to be pushed onto stack
#          => 1st element will be the last to be pushed onto stack
#    => Pop => 1st element will be popped and added to results array
#    => results array will get elements added to it in correct order

# @param [Array<Integer|Array<Integer>] input_arr
# @param [Array<Integer>] results
# @return [Array<Integer>]
#

def non_rec_custom_flatten(input_arr:)
  results = []

  # simulate stack using array
  stack = []
  stack.push(input_arr)

  # Push/pop from stack to remove nesting of arrays and flatten them
  until stack.empty?
    # 1st element is the input_arr we pushed onto stack, it is surely
    # an array, and we shall iterate over its elements pushing elements
    # from input array in reverse order onto stack. In 1st run, all
    # elements of input array will be pushed onto stack in reverse order
    # i.e element at last index pushed 1st, element at 1st index pushed
    # last. When we pop (once the iteration is complete), 1st element
    # will be popped and investigated
    # if any element in this array is also an array, the array will be
    # reversed, and its elements pushed such that 1st element of this
    # array will be added to results array maintaining the original
    # order of elements in input array intact in results array
    curr = stack.pop

    # if element is an array, reverse it before pushing its elements
    # in iteration onto stack
    if curr.is_a?(Array)
      curr.reverse.each do |element|
        stack.push(element)
      end
    else
      # element is not an array, push to results array
      results << curr
    end
  end
  # Return results
  results
end

# Test this program
def test
  arr = [
    [1, 2, 3, 4, 5],
    [1, 2, 3, [4, 5, [6, 7, [8, 9]]], 10, 11, 12, [13, 14], [15, [16, 17]]],
    [1, 2, 3, [4, 5], [6, 7], [8, 9], [10, [11, 12, [13, 14]]], [15, 16], 17, 18]
  ]

  arr.each do |input_arr|
    print "\nInput Arr :: #{input_arr.inspect}\n"
    puts "Flattened Arr :: #{custom_flatten(input_arr:)}"
    puts "Flattened Arr - Non Rec :: #{non_rec_custom_flatten(input_arr:)}"
    print "Flatten Ruby Output :: #{input_arr.flatten}\n"
  end
end

test
