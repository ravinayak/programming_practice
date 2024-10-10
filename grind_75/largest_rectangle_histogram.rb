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

# Algorithm: Core Idea to calculate the largest rectangle formed by bars
# in histogram
# 1. Maintain a Stack which keeps all indexes of heights array such that
# heights for indices in stack are in monotonic increasing order, meaning
# that height[stack[i]] <= height[stack[i+1]]
# 2. Reason behind this is that whenever we encounter a histogram bar which
# is smaller in height than the value of heights array for index referenced by
# current top element in stack, we pop the element from stack, and calculate
# max_area which can be formed with this bar, if it is > max_area, max_area
# is updated
# 3. Index is incremented only when we encounter an element which can be pushed
# onto stack. When we pop elements from stack, we do not increment index. This
# is because we want to keep processing other stack elements to calculate max
# area.
# 4. Width calculation is tricky in this case, and so is index increment
# 5. width = last_seen_index.nil? ? index : index - last_seen_index - 1
# 6. We calculate width using the above formula because height of the bar for
# index at top of stack, will extend from current index to the last seen index.
# Remember that stack always stores only those elements which are >= elements in
# heights array at "current_index". This clearly implies that for all the elements
# which were present at indices
#   a. last_seen_index + 1 b. last_seen_index + 2 c. last_seen_index + 3
#   all the way to current_index must have had a height >= height of bar at current_index
#   => Hence we can form a Rectangle from last_seen_index to current_index using
#   height from index at top of stack
#   => index - last_seen_index - 1
#   => height of bar = heights[top_stack_index], top_stack_index = stack.pop
#   => all the elements from last_seen_index to current_index (index) must have
#   had a height >= height of bar
#   => index - last_seen_index = Steps from last_seen_index to index = n (say)
#   => However, using "n" points, we can only make "n-1" pairs, we have to find width
#   which is evaluated using pairs,
#   => width = (last_seen_index, last_seen_index + 1),
#   (last_seen_index + 1, last_seen_index + 2)....(index - 1, index)
#   => width = n - 1 (n points give us n - 1 pairs)
# 7. It is also possible when we have reached end of heights array during processing,
# there are some elements present in stack
# 8. We use the same logic that we have in "else" condition, where we pop elements from
# stack and process them to calculate max_area. This is because we have no current height
# element to compare the stack elements with, and hence
#   a. index remains same
#   b. pop elements from stack, and process them

def largest_rect_in_histogram(heights:)
  stack = []
  # Initialize with the index of 1st element in heights array
  max_area = 0
  index = 0

  while index < heights.length
    # Fetch index of top element in stack
    # and find its value in heights array
    # stack.empty? short circuits and if stack is empty, stack.last will not be executed
    # stack can become empty during iterations, hence we must check for this condition
    # and push index onto stack because there is no element to compare the current index
    # height with
    if stack.empty? || heights[index] >= heights[stack.last]
      # Current element in heights array is >= top element in
      # stack, we include its index in the stack
      # Stack always contains elements in monotonic inreasing order, subsequent
      # elements in stack are either same in height or greater
      # 	heights[stack[i]] <= heights[stack[i+1]]
      stack.push(index)
      index += 1
    else
      # If stack becomes empty during iteration, we push index onto stack, hence pop is
      # safe operation, there will at least be 1 element in stack when we reach "else"
      # condition
      # Pop element from stack, find the height for this index
      # Find width, this is TRICKY and requires looking at the last element in
      # stack to determine the width
      top_index = stack.pop
      height_top_element = heights[top_index]
      # If the stack is empty, it means the popped element was the smallest so far
      width = stack.empty? ? index : index - stack.last - 1
      area = height_top_element * width
      max_area = [area, max_area].max
      # Index is not incremented in this condition, we keep processing until we have
      # emptied stack => IN this case we push this index onto stack
      # OR when we reach end of heights array when all elements have been processed
    end
  end

  # Stack may contain certain Indices even when heights array has been processed
  # index will remain same just like in "else" condition
  # We process the same way like "else", in this case there is no height element
  # to compare with since we reached end of heights array in above while loop
  # and hence we simply pop and process
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
    },
    {
      heights: [2, 1, 2, 3, 5, 6, 1, 1, 1, 1, 1, 1, 2],
      output: 13
    },
    {
      heights: [2, 1, 2, 3, 5, 6, 1, 12],
      output: 12
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
