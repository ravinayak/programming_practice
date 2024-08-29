# frozen_string_literal: true

# You are climbing a staircase. It takes n steps to reach the top.

# Each time you can either climb 1 or 2 steps. In how many distinct
# ways can you climb to the top?

# 1. Core idea here is to use array in recursion which will hold all
# steps used so far.

# 2. Another Core idea is that in any recursion, when we come back
# to an earlier depth in call stack, a data structure which is an
# object like Array in Ruby or a hash will Ruby will NOT hold the value
# it had before the recursion call was made. Any additional elements
# inserted in array at deeper levels will BE PRESENT. This is
# because although every depth of recursion stack maintains its own
# variables in a separate Stack, objects are referenced through
# Reference and they continue to point to the same object regardless
# of any depth of recursion
# So, if at depth 3, arr = [1, 1, 3, 5], and we insert element 4 at
# depth 4, the array at depth 4 = [1, 1, 3, 5, 4]
# When we return to depth 3, arr will still be = [1, 1, 3, 5, 4]
# Both depths 3, 4 will reference the same array through reference
# This is very crucial to understand the following implementation

# This is a classic problem of combination and backtracking

# @param [Integer] total_steps
# @param [Array<Integer>] allowed_step_sizes
# @return [Array]
#
def staircase_combinations(total_steps:, allowed_step_sizes:)
  result = []
  curr_step_combs = []

  staircase_combs_utility(total_steps:, allowed_step_sizes:, curr_step_combs:, result:)

  # Return the result array which holds all possible combinations of steps
  # to reach the total steps given possible steps at one time
  result
end

# @param [Integer] total_steps
# @param [Array<Integer>] allowed_step_sizes
# @param [Stack<Integer>] curr_step_combs
# @param [Array<Array<Integer>>] result
#
def staircase_combs_utility(total_steps:, allowed_step_sizes:, curr_step_combs:, result:)
  # Base case of recursion: If we have a current combination of steps which sums upto
  # total number of steps in staircase, it is a possible solution. We push onto
  # result array and return
  if curr_step_combs.sum == total_steps
    result << curr_step_combs.dup
    return
  end

  allowed_step_sizes.each do |step_size|
    # if the sum of current steps and possible step_size is greater than total_steps
    # we cannot include this step_size, since it is not a possible combination of
    # steps to climb staircase
    next if step_size + curr_step_combs.sum > total_steps

    # Push step_size to array holding current combination of steps
    curr_step_combs << step_size

    # Call the method to recursively determine more combinations
    staircase_combs_utility(total_steps:, allowed_step_sizes:, curr_step_combs:, result:)

    # When we reach this line, it means we have reached final combination and returned
    # from base case. At this time, in order to try step size of next iteration, we must
    # pop existing last element from the array (which represents step_size of current 
    # iteration). current_step_combs array must be restored to the state it was before 
    # current iteration.
    # So, we pop => Remove the final step_size added to this array in current iteration
    # When it goes to next iteration, new step_size is added at the position where previous
    # step_size was present, so we can try more combination of steps
    curr_step_combs.pop
  end
end

def test
  x = [[1, 1, 1, 1, 1], [1, 1, 1, 2], [1, 1, 2, 1], [1, 2, 1, 1], [1, 2, 2], [2, 1, 1, 1], [2, 1, 2], [2, 2, 1]]
  staircase_arr = [
    { total_steps: 2, allowed_step_sizes: [1, 2], output: [[1, 1], [2]] },
    { total_steps: 3, allowed_step_sizes: [1, 2], output: [[1, 1, 1], [1, 2], [1, 2]] },
    { total_steps: 5, allowed_step_sizes: [1, 2], output: x }
  ]

  staircase_arr.each do |staircase|
    total_steps = staircase[:total_steps]
    allowed_step_sizes = staircase[:allowed_step_sizes]
    output = staircase[:output]
    puts "\nInput => Total Steps :: #{total_steps}, Step Sizes :: #{allowed_step_sizes}"
    puts "Expected Output :: #{output.inspect}"
    puts "Result :: #{staircase_combinations(total_steps:, allowed_step_sizes:)}"
    puts
  end
end

test

# Example 1:
# Input: n = 2
# Output: 2
# Explanation: There are two ways to climb to the top.
# 1. 1 step + 1 step
# 2. 2 steps

# Example 2:
# Input: n = 3
# Output: 3
# Explanation: There are three ways to climb to the top.
# 1. 1 step + 1 step + 1 step
# 2. 1 step + 2 steps
# 3. 2 steps + 1 step