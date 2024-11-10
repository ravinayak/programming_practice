# frozen_string_literal: true

require_relative '../algo_patterns/sort/quicksort'
# Given an integer array nums, return all the triplets [nums[i], nums[j], nums[k]]
# such that i != j, i != k, and j != k, and nums[i] + nums[j] + nums[k] == 0.

# Notice that the solution set must not contain duplicate triplets. Each triplet
# must contain unique set of elements, any arrangement of the same indices or
# elements within a triplet qualifies as a duplicate.
# Ex: [-1, -1, 2], [2, -1, -1], [-1, 2, -1] are all duplicates since they contain
# same elements arranged in different orders

# Example 1:
# Input: nums = [-1,0,1,2,-1,-4].
# Output: [[-1,-1,2],[-1,0,1]]
# Explanation:
# nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0.
# nums[1] + nums[2] + nums[4] = 0 + 1 + (-1) = 0.
# nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0.
# The distinct triplets are [-1,0,1] and [-1,-1,2].
# Notice that the order of the output and the order of the triplets does not matter.

# Example 2:
# Input: nums = [0,1,1]
# Output: []
# Explanation: The only possible triplet does not sum up to 0.

# Example 3:
# Input: nums = [0,0,0]
# Output: [[0,0,0]]
# Explanation: The only possible triplet sums up to 0.

# Algorithm: We iterate over the array elements from range 0 to n-3. This is
# because we want to find triplets, and at "n-3" index, we have
#  (n-3, n-2, n-1) a triplet possibility. At "n-2", we can only have 2 elements
# pair and no triplet, so final range where we should stop is at "n-3"
# 1. First step is to sort the array, so we can
#    a. Skip duplicates
#    b. Use Two-Pointer Technique
# 2. Use Hash to ensure that every TRIPLET found is inserted into hash as
# a key. This ensures that any new TRIPLET can be checked for duplication
# in hash to avoid TRIPLET DUPLICATES.
#   => This is more of a precautionary measure
#
#
# We use Two-Poiner Technique, start at an index, say "i" in the iteration
# over array elements, at this point, we have the following:
# 1. left = i+1, 1st element after current element in array
# 2. right = n-1, last element in array
# For any element in the array, we try to combine it with the next element
# and last element to find a triplet whose sum can be the specified sum.
# We do not try to combine current element in iteration in array with
# previous elements, because those elements have already been tried combining
# with the current element to form triplets in previous iterations
#  3. Sum Use Cases:
#   a. If sum = given sum, we are good, put it in Hash after checking
#   that the triplet combination does not exist already in hash
#     i. We want to avoid any duplicate triplets, so for left, right, we
#     must check for duplicate elements that have the same value as
#     left, right indices, and increment/decrement left/right until
#     we reach a unique element
#     ii. When we have skipped duplicates, left/right still need to point
#     to the next elements, skipping duplicates ends at an index where
#     left/right point to the same element which has been tried in
#     triplet
#   b. sum < given sum,
#      => array is sorted, so left is at a smaller value, increment it to
#      get to a larger value. right is at a larger value
#      => We increment only 1 of left/right at a time, this is because
#      we want to try all possible combinations of (index, left, right)
#      to find a triplet whose sum is specified sum
#  c. sum > given sum,
#      => array is sorted, so right is at a larger value, decrement it to
#      get to a smaller value
# 4. In array next iteration, check if the current element is same as previous
#    element, this is crucial to avoid trying to find triplets that have
#    already been processed before and ALSO TO AVOID DUPLICATE TRIPLETS
# 5. We do not have to worry about triplets that have different permutations
#    because we are iterating in the array in increasing indices and hence
#    we cannot have different permutations of the same triplet.
#    Ex: [-1, 1, 0] => -1 is at index 1, 1 is at index 3, 0 is at index 4
#    Because we iterate in increasing order of indices,
#     a. -1 will never come again in any triplet (we skip over duplicates).
#     b. [1, -1, 0] is also NOT POSSIBLE, since we only move forward in array
#     with increase of indices and hence CANNOT COME BACK to a previous index
#     Once we have processed index 1, we will not come back to index 1 again
#     c. Hence we can store ANY TRIPLET found in a hash and simply check for
#     that triplet to occur again, we do not have to worry about permutations
#     for the same triplet
# @param [Array] input_arr
# @param [Integer] target_sum
# @return [Array<Array<Integer>>]
#
def find_3_sum(input_arr:, target_sum:)
  len = input_arr.length
  # triplets will be inserted into hash as keys, for every next insertion
  # we can check if key exists to avoid duplicate triplets
  triplet_hsh = {}

  # sort the array elements, we take a dup of current array so that we
  # do not change the order of elements in current array, we should not
  # change input.
  sorted_arr = quicksort(arr: input_arr.dup)

  # Maximum Range where index can increase to find triplets is n-3
  max_range = len - 3

  # Iterate over array
  (0..max_range).each do |index|
    # skip if current element is a duplicate of previous element
    # This condition is Necessary to prevent duplicate TRIPLETS in the solution
    # a. It helps to avoid processing duplicate triplets at the outermost loop level
    # b. It ensures we don't start the two-pointer search from the same value
    # multiple times.
    # c. This check is Different from inner loop skipping: The duplicate
    # skipping we do inside the while loop (for left and right pointers) is
    # different. That skipping happens after we've found a valid triplet and
    # is meant to avoid duplicate results within the current iteration.
    # d. Efficiency: By skipping duplicates at this outer level, we avoid unnecessary
    # iterations that would produce the same results, thus improving the algorithm's
    # efficiency.
    # 4. Correctness: Without this check, we might get duplicate triplets in our final
    # result, even with the hash set we're using.
    # Since the problem specifically states that the solution should NOT CONTAIN DUPLICATE
    # TRIPLETS in solution, we must perform this step, it is NOT ONLY NECESSARY for
    # improving Algorithm's Efficiency, it is ALSO NECESSARY for correctness of solution
    next if index.positive? && sorted_arr[index] == sorted_arr[index - 1]

    # left, right defined to try combination for triplets
    left = index + 1
    right = len - 1

    # Equality is not checked because we need 3 elements to form
    # a triplet
    while left < right

      curr_sum = sorted_arr[index] + sorted_arr[left] + sorted_arr[right]

      if curr_sum == target_sum
        triplet = [sorted_arr[index], sorted_arr[left], sorted_arr[right]]
        # hash should not contain this triplet
        triplet_hsh[triplet] = true unless triplet_hsh.key?(triplet)

        # Skip over duplicates
        left += 1 while left < right && sorted_arr[left] == sorted_arr[left + 1]

        # Next element to try triplet, left will stop in the previous while loop
        # at a position which points to the same duplicate element that was present
        # in the previous index position. If no duplicates exist, left will continue
        # to point to the same index as before, since we have already tried combining
        # current index with left, right, we must increment left, decrement right to
        # try NEW COMBINATIONS. Same logic applies for RIGHT
        left += 1

        # Skip over duplicates
        right -= 1 while right > left && sorted_arr[right] == sorted_arr[right - 1]
        # Next element to try triplet
        right -= 1
      elsif curr_sum < target_sum
        left += 1
      else
        right -= 1
      end
    end
  end

  triplet_hsh.keys
end

def test
  nums_output_arr = [
    {
      input_arr: [-1, 0, 1, 2, -1, -4],
      output: [[-1, -1, 2], [-1, 0, 1]]
    },
    {
      input_arr: [0, 1, 1],
      output: []
    },
    {
      input_arr: [0, 0, 0],
      output: [[0, 0, 0]]
    }
  ]

  nums_output_arr.each do |num_hsh|
    input_arr = num_hsh[:input_arr]
    output = num_hsh[:output]
    res = find_3_sum(input_arr:, target_sum: 0)
    print "\n Input Arr :: #{input_arr.inspect}, Target Sum :: 0"
    print "\n Expected :: #{output.inspect}, Res :: #{res.inspect}\n\n"
  end
end

test
