# frozen_string_literal: true

# Merge all overlapping intervals
# @param [Array] intervals_arr
# @return [Array]
#
def merge_intervals(intervals_arr:)
  sorted_intervals_arr = sort_intervals(intervals_arr:)
  merged = []

  sorted_intervals_arr.each_with_index do |sorted_arr, _index|
    if merged.empty? || merged.last[1] < sorted_arr[0]
      merged << sorted_arr
    else
      merged.last[1] = [merged.last[1], sorted_arr[1]].max
    end
  end

  merged
end

# Sort merge intervals based on start time
# @param [Array] intervals_arr
# @return [Array]
#
def sort_intervals(intervals_arr:)
  quicksort(arr: intervals_arr, low: 0, high: intervals_arr.length - 1)
end

# Modified version of quicksort for sorting merge intervals
# based on start time of interval
# @param [Array] intervals_arr
# @param [Integer] low
# @param [Integer] high
# @return [Array]
#
def quicksort(arr:, low:, high:)
  return if low > high

  pivot_index = partition(arr:, low:, high:)

  quicksort(arr:, low:, high: pivot_index - 1)
  quicksort(arr:, low: pivot_index + 1, high:)

  arr
end

# Partitions intervals_arr based on comparison
# of start time of intervals
# @param [Array] intervals_arr
# @param [Integer] low
# @param [Integer] high
# @return [Array]
#
def partition(arr:, low:, high:)
  # Generate randomized number for selection of pivot
  # to avoid worst case Time Complexity of O(n ^ 2) when
  # array is already sorted
  #
  random_index = rand(low..high)
  swap_elements(index_one: high, index_two: random_index, arr:)

  pivot = arr[high][0]

  i = low - 1
  j = low

  while j < high
    if arr[j][0] < pivot
      i += 1
      swap_elements(index_one: j, index_two: i, arr:)
    end
    j += 1
  end

  swap_elements(index_one: i + 1, index_two: high, arr:)

  i + 1
end

# Swaps elements of array
# @param [Integer] index_one
# @param [Integer] index_two
# @param [Array] arr
#
def swap_elements(index_one:, index_two:, arr:)
  temp = arr[index_one]
  arr[index_one] = arr[index_two]
  arr[index_two] = temp
end

intervals_arr = [[5, 7], [-2, 1], [-5, -2], [-1, 2], [7, 9], [3, 4]]
intervals_arr_one = [[1, 3], [2, 6], [8, 10], [15, 18]]
puts "Input intervals array :: #{intervals_arr.inspect}"
puts "Overlapping intervals merged :: #{merge_intervals(intervals_arr:)}"
puts "Input intervals array :: #{intervals_arr_one.inspect}"
puts "Overlapping intervals merged :: #{merge_intervals(intervals_arr: intervals_arr_one)}"
