# frozen_string_literal: true

# Given an array of integers, find the maximum sum of contiguous elements in the subarray

# Solution represented here is an implemention of Kadane's Algorithm which is a famous algorithm used
# to solve the Maximum Subarray Problem - one of the classic problems in computer science
# Time Complexity: O(n)
# Space Complexity: O(1)

# Intuition Behind Kadane's Algorithm:
# Kadane’s Algorithm is essentially an application of the Greedy strategy, where at each step, we decide
# whether to include the current element in the existing subarray or start a new subarray. This decision
# is based on maximizing the sum, hence ensuring that we always carry forward the best possible result.

# This algorithm is efficient and straightforward, making it a popular choice for solving the maximum
# subarray problem and similar problems involving the sum of subarrays or subsegments.

# @param [Array] input_arr
# @return [Hash] output_hsh
#
# subarr[:max_current_sum] represents the maximum sum of contiguous elements in the subarray ending at current index
# subarr keeps track of the starting pointer of subarray.
# max_subarr[:max_global_sum] represents the maximum sum recorded so far. left and right pointers keep track of the
# starting and ending pointer of the subarray which has this maximum sum

# If the new element at current index is greater than the sum of contiguous elements in the subarray recorded so far
# with the new element added to it, then the new element would be the smallest subarray with he highest sum. In this
# case, the subarray starts at the index of new element.
# If the new element at current index is less than or equal to the sum of contiguous elements in the subarray recorded
# so far with the new element added to it, then we include the element in the subarray.
# Sum of subarray is updated, and the current starting point of subarray holds

# if max_global_sum is less than the max_curr_sum, max_global_sum is updated to max_curr_sum.
# Because max_curr_sum represents the sum of contiguous elements in subarray ending at current index, if it is greater
# than the max_global_sum, this would mean that we have found a new subarray of contiguous elements whose sum is
# greater than the previous subarray whose start/end (left/right) positions were recorded in max_subarr hash.
# These pointers need to be updated to record (left/right) start/end positions of new max subarray
# Since subarr temporarily ends at current index, we record the current index as right pointer (end) of max_subarr
# Start of this max_subarray is set to the starting pointer (left) of subarr. This is because
# left pointer of subarray keeps track of the start position of subarray
#
def find_max_sum_subarr(input_arr)
  subarr = { left: 0, right: 0, max_curr_sum: input_arr[0] }
  max_subarr = { left: 0, right: 0, max_global_sum: input_arr[0] }

  input_arr.each_with_index do |element, index|
    # Element at index "0" has already been processed in both subarr and max_subarr
    next if index.zero?

    if element > subarr[:max_curr_sum] + element
      subarr[:max_curr_sum] = element
      # New Max subarray starts at index of element, we don't know where it ends,
      # so we do not update right of subarr
      subarr[:left] = index
    else
      subarr[:max_curr_sum] += element
    end

    next unless subarr[:max_curr_sum] > max_subarr[:max_global_sum]

    max_subarr[:max_global_sum] = subarr[:max_curr_sum]

    # Maximum subarray will always temporarily end at current index, so we record the
    # current index as right pointer and keep updating it to maintain its correctness
    max_subarr[:right] = index

    # subarr[:left] always maintains the starting position of contiguous elements in
    # subarr which has the maximum sum recorded so far, we update it to reflect this
    # in maximum subarray
    max_subarr[:left] = subarr[:left]
  end

  puts "Maximum sum of contiguous elements in subarray :: #{max_subarr[:max_global_sum]}"
  puts "Maximum sum contiguous elements subarray :: #{input_arr[max_subarr[:left]..max_subarr[:right]]}"
  puts
end

arr = [[1, 2, 3, 4, -8, 6, 100, -90, -50, -200, 210], [1, -1, -6, -7, 8, 4, 12, -8, -9], [2, 4, 6, 8, 9]]

arr.each do |input_arr|
  find_max_sum_subarr(input_arr)
end
