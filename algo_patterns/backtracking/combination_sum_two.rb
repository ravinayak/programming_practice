# frozen_string_literal: true

# Combination Sum II - Elements of array sum to target - Elements CANNOT be reused
# only once

# @param [Array] candidates_arr
# @param [Integer] target
# @return [Array]
#
def combination_sum_two(candidates_arr:, target:)
  results = []
  candidates = candidates_arr.sort
  start_index = 0
  combinations = []

  backtrack_comb_sum_two(candidates:, results:, target:, start_index:, combinations:)

  results
end

# @param [Array] candidates
# @param [Array] results
# @param [Array] target
# @param [Integer] start_index
# @param [Array] combinations
# @return [Array]
#
def backtrack_comb_sum_two(candidates:, results:, target:, start_index:, combinations:)
  # Base case of recursion
  if target.zero?
    # This implies that combinations has elements which sum up to target
    #
    # If you use this, results will contain references to the same combinations array
    # that's being modified throughout the backtracking process. By the end of the algorithm,
    # all entries in results would point to the same (empty) array.

    # This creates a shallow copy of the combinations array at the moment it's added to results.
    # This way, each entry in results is a separate array, preserving the state of combinations
    # at that point in the backtracking process.

    # In short, .dup is required to create independent copies of the combinations array, ensuring
    # that results contains distinct combinations rather than multiple references to the same,
    # constantly changing array.

    results << combinations.dup
    return
  elsif target.negative?
    return
  end

  (start_index...candidates.length).each do |index|
    # This is to ensure that we do not end up having duplicate combinations. We can avoid duplicate
    # combinations by using uniq method but that would not be performative. A number of combinations
    # and hence recursions will be tried for same combinations which can be avoided easily using this
    # comparison
    # index > start_index => This is significant because it ensures that duplicate elements in
    # combinations are not allowed at current level of recursion
    # Ex: candidates = [1, 1, 2, 2, 3, 3, 5] and target = 4
    # At recursion step 3, when combinations = [1, 1, 2] we have results array
    # when it returns from this recursion, start_index = 2, "2" is popped off and we move to the next
    # index in the array -> 3
    # Here we encounter same element '2', Any combinations which will be tried at recursion step 3, will
    # be same as recursions tried previously. 
    # This is because combinations bakctracking algorithm will use "2" at start index "2", and combine
    # with every other element in the array
    #   1. Combinations WITH "2" at index "3" which will be like [2, 2, ....]
    #   2. Combinations WITHOUT "2" at index "3", which will be like [2, ....]
    # Step 2 represents all combinations which can be formed by using "2" at index "3", and hence will
    # only give us duplicates, wasting time, recursive calls + Answer asks not to include duplicates
    # which means we would have to do uniq which will require another O(n log n) to sort and find/remove
    # duplicates
    # This will lead to duplicates and also wasted recursion calls
    # index => 3, start_index => 2, satisfies the condition and next element in candidates array is same
    # as previous element, which means all possible combinations have been tried in previous iteration. So
    # we can safely skip it
    # Replacing index > start_index by index - 1 > 0 will not work because it will skip possible
    # combinations which could lead to solution
    # index > start_index ties the comparison to current level of recusion ensuring that only in current
    # level of recusion, elements are skipped if they result in duplicate combinations and repeat recursions
    # Consider candidates = [1, 1, 2, 2, 3] and target = 9
    # At Recursion Step 4, where
    #     combinations = [1, 1, 2], start_index = 2
    #      this will skip element "2" at index 3 because index - 1 > 0 and candidates[2] == candidates[3]
    #      So possible combination [1, 1, 2, 2] will not be tried although it should be because each element
    #      in the array can be used once in the problem statement regardless of whether it is a duplicate
    #      Many combinations may be missed
    # Ex: ➜  backtracking git:(main) ✗ ruby combination_sum_two.rb
    #         Input Arr :: [1, 1, 2, 2, 3], Target :: 5
    #         Combinations of elements in candidates array which sum to target (elements can be reused) ::
    #         Combination :: [1, 1, 3], Sum of elements in array :: 5
    #         Combination :: [2, 3], Sum of elements in array :: 5
    #         Total number of possible combinations :: 2
    #
    # Where as with index > start_index, we get the correct output
    # Ex: ➜ backtracking git:(main) ✗ ruby combination_sum_two.rb
    #         Input Arr :: [1, 1, 2, 2, 3], Target :: 5
    #         Combinations of elements in candidates array which sum to target (elements can be reused) ::
    #          Combination :: [1, 1, 3], Sum of elements in array :: 5
    #          Combination :: [1, 2, 2], Sum of elements in array :: 5
    #          Combination :: [2, 3], Sum of elements in array :: 5
    # Total number of possible combinations :: 3

    # With index - 1 > 0, we miss the combination [1, 2, 2]
    #

    next if index > start_index && candidates[index] == candidates[index - 1]

    combinations << candidates[index]

    # start_index = index + 1 => Ensures that we do not reuse existing element in the array
    # Each element in the array should be used only once
    #
    backtrack_comb_sum_two(candidates:, results:, target: target - candidates[index], start_index: index + 1,
                           combinations:)

    combinations.pop
  end
end

candidates_arr = [1, 1, 2, 2, 3]
target = 5

puts "Input Arr :: #{candidates_arr.inspect}, Target :: #{target}"
results_arr = combination_sum_two(target:, candidates_arr:)
puts 'Combinations of elements in candidates array which sum to target (elements can be reused) :: '
results_arr.each do |result|
  puts "\t \t \t Combination :: #{result.inspect}, Sum of elements in array :: #{result.sum} "
end
puts "Total number of possible combinations :: #{results_arr.size}"
