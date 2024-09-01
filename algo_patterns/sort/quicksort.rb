# frozen_string_literal: true

require_relative '../data_structures/stack'
# frozen_string_literal: true

# Algorithm: Quicksort uses the concept of Partitioning an array
# into TWO SubArrays with left subarray containing elements <= Pivot
# and right subarray containing elments > Pivot
# It places Pivot at its correct index in the array
# meaning the index at which the Pivot would have been placed if
# the array were sorted in Ascending Order
# 1. Quicksort recursively partitions left and right subarray,
#    thereby placing all the elements in those subarrays at
#    their correct index positions in the array
# 2. When Quicksort is called recursively on left subarray, it
#    sorts all the elements in left subarray correctly using
#    pivot such that they are sorted correctly amongst themselves
# 3. When Quicksort is called recursively on right subarray, it
#    sorts all the elements in right subarray correctly using
#    pivot such that they are sorted correctly amongst themselves
# 4. Left Subarray contains elements <= Pivot
#    Right Subarray contains elements > Pivot
# 5. (Left Subarray Sorted correctly) + Pivot + (Right Subarray sorted correctly)
#    => Left Subarray sorted (<= Pivot) + Pivot + (> Pivot) Right Subarray sorted
#    => Above is the order of sorting of elements in the original Array
#    => This is the correct ascending order for all elements in the Array
#    => Sorted Array

# Thus key idea of Quicksort is as follows:
# 1. Place each element (one element at a time in recursion) at its correct index
#    in the array (i.e. the index at which this element would have been placed
#    if array were sorted in Ascending Order)
# 2. Use Pivot to partition an array into 2 halves:
#     a. 1st half with elements <= Pivot
#     b. 2nd half with elements > Pivot


# Youtube: https://www.youtube.com/watch?v=Vtckgz38QHs
# Class implements QuickSort
# @param [Array] arr
# @param [Integer] low
# @param [Integer] high
# @return [Array]
#
def quicksort_rec(arr:, low:, high:)
  return unless low < high

  pivot_index = partition(arr:, low:, high:)

  quicksort_rec(arr:, low:, high: pivot_index - 1)
  quicksort_rec(arr:, low: pivot_index + 1, high:)

  arr
end

# The main intuition behind non-recursive algorithm of quicksort
# is to simulate the recursion call stack. In order to simulate
# recursion call stack, we would normally use a stack
# Quicksort recursively calls itself on left and right partition
# of array to partition the left and right sides of pivot to sort
# array elements
# If we push the low and high of left and right partition on stack
# and run a while loop until stack is empty, partitioning the
# array elements, we can achieve the same effect
# @param [Array] arr
# @param [Integer] low
# @param [Integer] high
# @return [Array]
#
def quicksort_non_rec(arr:, low:, high:)
  return if low > high

  stack = Stack.new

  # Initialize stack with low and high before starting loop
  #
  stack.push(data: low)
  stack.push(data: high)

  until stack.empty?

    high = stack.pop
    low = stack.pop

    pivot_index = partition(arr:, low:, high:)

    # Simulates left partition recursive call
    if pivot_index - 1 > low
      stack.push(data: low)
      stack.push(data: pivot_index - 1)
    end

    # Simulates right partition recursive call
    if pivot_index + 1 < high
      stack.push(data: pivot_index + 1)
      stack.push(data: high)
    end
  end

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

  # Algorithm: 
  # 1. Pointer "i" is the highest index at which an element <= pivot
  #    is present in array(low..high)
  #    => Keeps track of elements <= Pivot
  # 2. Pointer "j" is the highest index at which an element > pivot
  #    is present in array(low..high)
  #    => Keeps track of elements > Pivot
  # 3. Any time in iteration (j < high), if we find an element at
  #    arr[j] < pivot,
  #    => Violates the rule that element at "j" > Pivot
  #    => Highest index at which element <= Pivot is present = i
  #    => Index "i+1" is the lowest index at which element > Pivot
  #       is present
  #    => i = i + 1
  #    => Swap arr[j] with arr[i]
  #    => "i" now points to an element which is < Pivot and is the
  #       highest index at which < Pivot elements are placed
  # 4. At the end of iteration, we reach the following condition:
  #     a. (low..i) => Elements <= pivot
  #     b. (i+1..high-1) => Elements > pivot
  # 5. Exchange "i+1" with "high", pivot is placed at "i+1" and
  #    element at "i+1" (> pivot) is placed at "high"
  # 6. Elements (low..i) <= pivot
  # 7. Elements (i+2..high) > pivot
  # 8. Element at "i+1" = pivot

  # Thus, partition effectively partitions the array into 2 halves
  #    => (low..i) < pivot AND (i+2..high) > pivot with pivot at (i+1)
  # These are the two subarrays,
  # a. left subarray contains elements < pivot
  # b. right subarray contains elements > pivot
  # c. "pivot" is placed at its correct index in the array, correct
  #    index means the index at which pivot would have been placed
  #    if the array were sorted in Ascending Order
  while j < high # Iterate (low..high - 1)
    # If the 1st n elements are less than pivot, for each such "n"
    # elements, they will be swapped with themselves. Swapping stops
    # when we find an element > Pivot
    if arr[j] < pivot
      i += 1
      swap_elements(index_one: j, index_two: i, arr:)
    end
    j += 1
  end

  # "i+1" is the 1st index at which an element > Pivot is present
  # Swap pivot with element at index "i+1" ("i+1" <=> high)
  # (low..i) <= Pivot, Pivot at i+1, (i+2..high) > Pivot
  swap_elements(index_one: i + 1, index_two: high, arr:)

  # Pivot index
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
puts "Input Array :: #{arr.inspect}"
puts quicksort_rec(arr:, low: 0, high: arr.length - 1).inspect
puts quicksort_non_rec(arr:, low: 0, high: arr.length - 1).inspect
