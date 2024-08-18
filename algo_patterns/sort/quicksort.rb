# frozen_string_literal: true

# Class implements QuickSort
# @param [Array] arr
# @return [Array]
#
def quicksort(arr:, low:, high:)
  return unless low < high

  pivot_index = partition(arr:, low:, high:)

  quicksort(arr:, low:, high: pivot_index - 1)
  quicksort(arr:, low: pivot_index + 1, high:)

  arr
end

# Partition routine which partitions the array into two halves
# around the pivot element.
# All elements in the array which have an index less than the
# pivot element are in the 1st half and are less than or equal
# to the pivot element
# All elements in the array which have an index greater than the
# pivot element are in the 2nd half and are greater than the pivot
# element
# Elements in the both the halves are not in any order, the order
# is simply with respect to pivot element
# Finally this routine returns the index of pivot element, so the
# array can be further sub-divided
# As is clear, quicksort sorts the array in place
#
def partition(arr:, low:, high:)
  # Generate randomized number for selection of pivot
  # to avoid worst case Time Complexity of O(n ^ 2) when
  # array is already sorted
  #
  random_index = rand(low..high)
  swap_elements(index_one: high, index_two: random_index, arr:)

  pivot = arr[high]

  i = low - 1
  j = low

  while j < high
    if arr[j] < pivot
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

arr = [1, 3, -9, 10, 19, -25, -30, 85, 100, -210]
puts quicksort(arr:, low: 0, high: arr.length - 1).inspect
