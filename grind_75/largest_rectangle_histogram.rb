# frozen_string_literal: true

# Given an array of integers heights representing the histogram's
# bar height where the width of each bar is 1, return the area of
# the largest rectangle in the histogram.

# Example 1:
# Input: heights = [2,1,5,6,2,3]
# Output: 10
# Explanation: The above is a histogram where width of each bar is 1.
# The largest rectangle is shown in the red area, which has an area = 10 units.

# Example 2:
# Input: heights = [2,4]
# Output: 4

def largest_rect_in_histogram(heights:)
  stack = []
  # Initialize with the index of 1st element in heights array
  max_area = 0
  index = 0

  while index < heights.length
    # Fetch index of top element in stack
    # and find its value in heights array
    if stack.empty? || heights[index] >= heights[stack.last]
      # Current element in heights array is >= top element in
      # stack, we include its index in the stack
      # Stack always contains elements in monotonic inreasing order, subsequent
      # elements in stack are either same in height or greater
      # 	heights[stack[i]] <= heights[stack[i+1]]
      stack.push(index)
      index += 1
    else
      # Pop element from stack, find the height for this index
      # Find width, this is TRICKY and requires looking at the last element in
      # stack to determine the width
      top_index = stack.pop
      height_top_element = heights[top_index]
      # If the stack is empty, it means the popped element was the smallest so far
      width = stack.empty? ? index : index - stack.last - 1
      area = height_top_element * width
      max_area = [area, max_area].max
    end
  end

  until stack.empty?
    top_index = stack.pop
    height_top_element = heights[top_index]
    width = stack.empty? ? index : index - stack.last - 1
    area = height_top_element * width
    max_area = [area, max_area].max
  end

  max_area
end

def input_arr
  [
    {
      heights: [2, 1, 5, 6, 2, 3],
      output: 10
    },
    {
      heights: [2, 4],
      output: 4
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    print "\n\n Heights :: #{input_hsh[:heights].inspect}"
    print "\n Output :: #{input_hsh[:output]}"
    print "\n Result :: #{largest_rect_in_histogram(heights: input_hsh[:heights])} \n"
  end
  print "\n"
end

test
