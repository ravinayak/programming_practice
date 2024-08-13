# frozen_string_literal: true

# Implement merge sort
# Time Complexity => O(nlogn)
# Space Complexity => O(n) [Temporary array to copy elements]
# @param [Array] arr
# @return [Array]
#
def merge_sort(arr:)
  return arr if arr.length <= 1

  mid = arr.length / 2
  left_arr = arr[0...mid]
  right_arr = arr[mid...arr.length]

  sorted_left = merge_sort(arr: left_arr)
  sorted_right = merge_sort(arr: right_arr)

  merge_combine(left_arr: sorted_left, right_arr: sorted_right)
end

# Combine sorted arrays into one single array which is sorted
# @param [Array] left_arr
# @param [Array] right_arr
# @return [Array]
#
def merge_combine(left_arr:, right_arr:)
  sorted_arr = []
  left_arr_index = right_arr_index = 0

  while left_arr_index < left_arr.length && right_arr_index < right_arr.length
    if left_arr[left_arr_index] <= right_arr[right_arr_index]
      sorted_arr << left_arr[left_arr_index]
      left_arr_index += 1
    else
      sorted_arr << right_arr[right_arr_index]
      right_arr_index += 1
    end
  end

  while left_arr_index < left_arr.length
    sorted_arr << left_arr[left_arr_index]
    left_arr_index += 1
  end

  while right_arr_index < right_arr.length
    sorted_arr << right_arr[right_arr_index]
    right_arr_index += 1
  end
  sorted_arr
end

input_arr = [[21, 7, 15, 3, 1, 25], [1, -15, 95, 24, 85, 65, 20, -110]]
input_arr.each do |arr|
  puts "Sorted Array through Merge Sort: #{merge_sort(arr:)}"
end
