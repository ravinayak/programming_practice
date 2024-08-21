# frozen_string_literal: true

# Time Complexity:
#   1. The worst-case time complexity can be approximated as O(n^(target/min)), where
#      n is the number of candidates, target is the target value, and min is the smallest
#      value in the candidates array.
#   2. This represents the maximum number of nodes in the recursion tree.

# Combination Sum (Can re-use elements)
# @parm [Integer] target
# @param [Array] candidates_arr
# @return [Array] results
#
def combination_sum(target:, candidates_arr:)
  results = []
  combination = []
  start_index = 0
  candidates = candidates_arr.sort
  backtrack_comb_sum(candidates:, combination:, start_index:, results:, target:)

  results
end

# Backtrack recursively tries every possible combination of elements in array by
# reusing them to check if any combination can give us the sum as target.
# If a specific combination can or cannot give us the sum, it is removed from the
# array, and next element in candidates array is tried
# Starting from index 0, it tries all possible combinations until it exhausts all
# elements in array (reusing elements), then moves to next index. Here combination
# array is initialized to the element at next index, and process is repeated until
# we reach end of array
#
# @param [Array] candidates
# @param [Array] combination
# @param [Integer] start_index
# @param [Array] results
# @param [Integer] target
#
def backtrack_comb_sum(candidates:, combination:, start_index:, results:, target:)
  if target.zero?
    # This implies that combination has elements which sum up to target
    #
    results << combination.dup
    return
    # This condition means sum of elements in combination array is greater than target
    #
  elsif target.negative?
    return
  end

  # Iterate over each element in array
  (start_index...candidates.length).each do |index|
    combination << candidates[index]
    # We initialize start_index as index. This is crucial because this implies we can re-use current element
    # of array in the next recursion to check if any combination of same element when summed up can give us
    # the target
    # Target is initialized to target - candidates[index] to determine if the sum of elements in combination
    # array can sum up to target
    #
    backtrack_comb_sum(candidates:, combination:, start_index: index, results:, target: target - candidates[index])

    # In both cases of whether the current element of array when added to combination
    #  - Sums up to target
    #  - Sums up to a value greater than target
    # We remove the current element of combination, and try the next element in array
    combination.pop
  end
end

candidates_arr = [2, 3, 5, 6, 9, 15]
target = 20

puts "Input Arr :: #{candidates_arr.inspect}, Target :: #{target}"
results_arr = combination_sum(target:, candidates_arr:)
puts 'Combinations of elements in candidates array which sum to target (elements can be reused) :: '
results_arr.each do |result|
  puts "\t \t \t Combination :: #{result.inspect}, Sum of elements in array :: #{result.sum} "
end
puts "Total number of possible combinations :: #{results_arr.size}"
