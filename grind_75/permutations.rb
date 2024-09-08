# frozen_string_literal: true

# Given an array nums of distinct integers, return all the possible permutations
# You can return the answer in any order.

# Example 1:
# Input: nums = [1,2,3]
# Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]

# Example 2:
# Input: nums = [0,1]
# Output: [[0,1],[1,0]]

# Example 3:
# Input: nums = [1]
# Output: [[1]]

# Algorithm: To generate permutations of all elements in an array, we use the
# strategy of fixing all elements at their index, except 2 indices and swapping
# elements at those indices to generate all possible combinations. This is
# typically achieved using Recursive Technique where we start from index = 0
# and send it as "start" index of dfs, where we loop over from "start" to "len"
# of array, swapping elements at "start" with "index" of iteration in loop. This
# ensures that as we go in dfs we generate a new permutation of elements in array
# Step 1: Start DFS with index 0
# Step 2: DFS routine accepts start, arr
# Step 3: DFS routine loops over start...arr.length
#         => Swap elements at start with index of current iteration in loop
#         => Call DFS with swapped elements
# Step 4: Base Case of DFS: when start == arr.length, permutation consists of
#         all elements in array, push it into results
# NOTE: In 1st iteration, an element is swapped with itself
# This is the general backtracking solution for solving Permutation problems
# NOTE: Whenever we push any object in array in Ruby, we must never push that
#       object in the array if it can Mutate. We must take a "dup" of that
#       object and then push it in the array.
#       Ex:
#       a. result << input_arr => Reference to input_arr object is pushed into
#       result array. If input_arr changes, all elements in result will
#       change to the current value of input_arr
#
#       b. result << input_arr.dup => A copy of input_arr object is pushed
#       into result array, not the reference to input_arr object. Even if
#       input_arr object changes, result will not change because it does
#       not contain the reference

# @param [Array<Integer>] input_arr
# @return [Array<Integer>]
def permutations(input_arr:)
  result = []
  dfs_permutation(input_arr:, start: 0, result:)

  # Return Array which contains all permutations
  result
end

# @param [Array<Integer>] input_arr
# @param [Array<Integer>] result
# @param [Integer] start
def dfs_permutation(input_arr:, start:, result:)
  # Base Case of Recursion: When start == array length
  # append input_arr into result
  # NOTE:
  result << input_arr.dup if start == input_arr.length - 1

  (start...input_arr.length).each do |index|
    swap_elements(input_arr:, start:, index:)
    dfs_permutation(input_arr:, start: start + 1, result:)
    swap_elements(input_arr:, start:, index:)
  end
end

# @param [Array<Integer>] input_arr
# @param [Integer] index
# @param [Integer] start
def swap_elements(input_arr:, start:, index:)
  temp = input_arr[start]
  input_arr[start] = input_arr[index]
  input_arr[index] = temp
end

def test
  values = [
    {
      input_arr: [1, 2, 3],
      output: [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]
    },
    {
      input_arr: [0, 1],
      output: [[0, 1], [1, 0]]
    },
    {
      input_arr: [1],
      output: [[1]]
    }
  ]

  values.each do |val_hsh|
    input_arr = val_hsh[:input_arr]
    output = val_hsh[:output]
    result = permutations(input_arr:)
    print "\n Input :: #{input_arr.inspect}"
    print "\n Output :: #{output.inspect}, Result :: #{result.inspect}\n"
  end
  puts
end

test
