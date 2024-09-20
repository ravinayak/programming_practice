# frozen_string_literal: true

# Given an integer array nums of unique elements, return all
# possible subsets
#  (the power set).

# The solution set must not contain duplicate subsets. Return
# the solution in any order.

# Example 1:
# Input: nums = [1,2,3]
# Output: [[],[1],[2],[1,2],[3],[1,3],[2,3],[1,2,3]]

# Example 2:
# Input: nums = [0]
# Output: [[],[0]]

# Algorithm: Backtracking and Iterative approaches can be used to
# generate subsets, backtracking is more complicated and requires
# more understanding, PREFER ITERATIVE APPROACH

# NOTE: SEE BACKTRACKING MARKDOWN FILE FOR IMPORTANT OBSERVATION
# Backtracking: For each element, we use the same strategy as we
# use in generation of permutations for an element, where we pass
# start (index) and iterate over the entire length of the array
# from start (index) for each Recursive Step
# Fundamental observation here is that when we iterate over elements
# of array from start till array.length
#  => For each index position in the 1st call to recursion, all
#     possible combinations of that element with other elements
#     is generated
#  => As we iterate and increase index, combinations of next element
#     with elements ahead of it in array are generated
#  => At the end, power subsets are formed
#  => Always start with [] as starting point, because no element is
#     also an element of power subset

# Iterative: More Intuitive,
# Step 1: Initialize result = [[]], contains an empty array to start with
# Step 2: Iterate over each element of array,
# Step 3: For each element of the array, we generate subsets by creating
#         an array of this element, and combining with existing elements
#         in result set
# Step 4: As we iterate to higher indices in the array, new element combines
#         with existing elements in result set to form all combinations
#         Because result set contains [], a single element combination with
#         that element (say 3 => [3]) is formed
# Step 5: Element combines with combinations already formed from previous
#         elements in result set to form new combinations with this element
#         included
#         For ex: arr = [1, 2, 3],
#         At index = 1, result = [[], [1], [2], [1, 2]]
#         When we reach 3 at index 2, 3 combines in following way:
#         a. [] + [3] = [3]
#         b. [1] + [3] = [1, 3]
#         c. [2] + [3] = [2, 3]
#         d. [1, 2] + [3] = [1, 2, 3]
#         => When we reach an element, at the end of iteration, all possible
#         combinations which could be made using that element with elements
#         at Previous Indices are formed

# @param [Array<Integer>] arr
# @return [Array<Array<Integer>>] result
def subsets(arr:)
  [recursive_subsets(arr:), iterative_subsets(arr:)]
end

# @param [Array<Integer>] arr
# @return [Array<Array<Integer>>] result
def recursive_subsets(arr:)
  # Base Case
  return [] if arr.empty?

  result = []
  current = []
  recursive_subsets_util(arr:, result:, current:, start: 0)

  # Return result
  result
end

def recursive_subsets_util(arr:, result:, current:, start:)
  # Clone the current to get a new copy of current array
  # and push into result
  # In the 1st call to recursion, [] is pushed into result
  # All subsequent calls prepare current with new combination
  # and when we come to the next level of recursion, it is
  # immediately pushed into result array
  result << current.clone

  (start...arr.length).each do |i|
    # Push current element to current array
    current << arr[i]
    # Call utility recursively by increasing index to generate
    # all possible combinations with element at index "i" in the
    # 1st call to recursion
		# We advance start by increasing it to current index + 1
		# This is very similary to combinations sum problem
    recursive_subsets_util(arr:, result:, current:, start: i + 1)
    # current element has been used to generate all possible combinations
    # pop the element from current array
    current.pop
  end
end

# @param [Array<Integer>] arr
# @return [Array<Array<Integer>>] result
def iterative_subsets(arr:)
  # Base Case
  return [] if arr.empty?

  result = [[]]
  arr.each do |element|
    # map function returns an array, it will return [[1]], if we do
    # result << next_subsets => result = [[], [[1]]]
    # When we add 2 arrays in Ruby, it combines elements of both arrays
    # to generate a new array, [[]] + [[1]] = [], [1] will be combined
    # to generate a new array => [[], [1]]
    # result + next_subsets = [[]] + [[1]] = [[], [1]]
    next_subsets = result.map { |result_element| result_element + [element] }
    # result << next_subsets is INCORRECT
    result += next_subsets
  end

  # Return result
  result
end

def input_arr
  [
    {
      arr: [1, 2, 3],
      output: [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]
    },
    {
      arr: [0],
      output: [[], [0]]
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    arr = input_hsh[:arr]
    output = input_hsh[:output]
    rec_res, iter_res = subsets(arr:)

    print "\n\n Input Arr :: #{arr.inspect}, Output :: #{output}"
    print "\n Recursive Res :: #{rec_res.inspect}\n"
    print "\n Iterative Res :: #{iter_res.inspect}\n\n"
  end
end

test
