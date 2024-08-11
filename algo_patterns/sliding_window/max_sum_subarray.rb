# frozen_string_literal: true

# Given an array of integers, find the maximum sum of contiguous elements in the subarray

# @param [Array] input_arr
# @return [Hash] output_hsh
#
# subarr[:max_current_sum] represent the maximum sum of contiguous elements in the subarray ending at current index
# subarr keeps track of the starting pointer of subarray. If the new element at current index is greater than the
# sum of contiguous elements in the subarray recorded so far, the new element would be the smallest subarray with
# the highest sum. In this case, the subarray starts at this index. If the sum of contiguous elements in the subarray
# is less than or equal to the sum of element and the sum recorded so far, we include the element in the subarray.
# sum of subarray is updated, and the current starting point of subarray holds

# if max_global_sum is less than the max_curr_sum, max_global_sum is updated to max_curr_sum. Because max_curr_sum
# represents the sum of contiguous elements in subarray ending at current index, the right pointer of max_curr_sum
# is set to current index. Start of this max_subarray is set to the starting pointer (left) of subarr. This is because
# left pointer of subarray keeps track of the start position of subarray
#
def find_max_sum_subarr(input_arr)
  subarr = { left: 0, right: 0, max_curr_sum: input_arr[0] }
  max_subarr = { left: 0, right: 0, max_global_sum: input_arr[0] }

  input_arr.each_with_index do |element, index|
    next if index.zero?

    if element > subarr[:max_curr_sum] + element
      subarr[:max_curr_sum] = element
      subarr[:left] = index
    else
      subarr[:max_curr_sum] += element
    end

    next unless subarr[:max_curr_sum] > max_subarr[:max_global_sum]

    max_subarr[:max_global_sum] = subarr[:max_curr_sum]
    max_subarr[:right] = index
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
