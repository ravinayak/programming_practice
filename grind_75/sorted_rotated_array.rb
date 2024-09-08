# frozen_string_literal: true

# There is an integer array nums sorted in ascending order (with distinct values).
# Prior to being passed to your function, nums is possibly rotated at an unknown
# pivot index k (1 <= k < nums.length) such that the resulting array is
# [nums[k], nums[k+1], ..., nums[n-1], nums[0], nums[1], ..., nums[k-1]] (0-indexed)
# For example, [0,1,2,4,5,6,7] might be rotated at pivot index 3 and become [4,5,6,7,0,1,2].

# Given the array nums after the possible rotation and an integer target, return
# the index of target if it is in nums, or -1 if it is not in nums.

# You must write an algorithm with O(log n) runtime complexity.

# Example 1:
# Input: nums = [4,5,6,7,0,1,2], target = 0
# Output: 4

# Example 2:
# Input: nums = [4,5,6,7,0,1,2], target = 3
# Output: -1

# Example 3:
# Input: nums = [1], target = 0
# Output: -1

# Rotated Array: If an array of length "n" is rotated around a pivot index, say "k"
# elements at index "k", "k+1", "k+2"...."n-1" will be shifted to
# index "0", "1", "2"..."n-k-1". Elements at "0", "1", "2" will shift to
#  "n-k", "n-k+1", "n-k+2", "n-k+3"...."n-1"
# Easiest way to rotate an array is to copy the array into a new array going in 2
# directions for Iteration:
#  a. 0 to k-1
#  b. k to n-1

# Search in Rotated Array:
# Algorithm: When a Sorted Array is rotated, there will be some index "x" in the
# array such taht
# a. Left/Right of 'x' will be in ascending order
# b. Right/Left of 'x' will be in descending order
# If we want to search for a target in this sorted rotated array, we can always
# search in O(n) time doing a Linear Search, but if we want to search in O(log n)
# time, we would have to use Binary Search. Problem here is that we would not be
# able to use Binary Search over the whole array because some part of it is
# sorted, some part of it is NOT sorted. To use Binary Search, we have to SKIP
# 1/2 of the Search Space in every Iteration.
# a. One Key Observation here is that whenever we calculate "mid", either "LEFT"
#    or "Right" of "mid" will always be Sorted. It is important to find this and
#    use this "Sorted" Half, because for the other half, elements are arranged
#    in Arbitrary Order (Binary Search can reduce Search Space by 1/2 only if
#    elements are sorted by comparing with "mid" element).
# b. When we know the sorted half, we can take advantage of the fact that this
#    half will have a DEFINED Range of values, and "target" will either be
#    present or absent in this Range. This can help us to reduce Search Space
#    by 1/2. We go into Sorted Half to search or we skip Sorted Half if target
#    is not in the Range of values

# @param [Array<Integer>] input_arr
# @param [Integer] k
# @param [Integer] target
# @return [Integer | nil]
def search_sorted_rotated_arr(input_arr:, k:, target:)
  rotated_arr = rotate_arr(input_arr:, k:)

  puts " Rotated Array :: #{rotated_arr.inspect}"

  low = 0
  high = rotated_arr.length - 1

  while low <= high

    mid = low + (high - low) / 2

    if rotated_arr[mid] == target
      return mid
    elsif rotated_arr[low] <= rotated_arr[mid] # Left half is sorted
      # Is target present in this range of values
      if rotated_arr[low] <= target && target < rotated_arr[mid]
        high = mid - 1 # Search in Left half
      else
        low = mid + 1 # Search in Right half
      end
    elsif rotated_arr[mid] < target && target <= rotated_arr[high] # Right half is sorted
      # Is target present in this range of values
      low = mid + 1
    else
      high = mid - 1
    end
  end

  # Target not found
  -1
end

# @param [Array<Integer>] input_arr
# @param [Integer] k
# @return [Array<Integer>]
def rotate_arr(input_arr:, k:)
  arr = []
  index_arr = 0
  (k..input_arr.length - 1).each do |index|
    arr[index_arr] = input_arr[index]
    index_arr += 1
  end

  (0..k - 1).each do |index|
    arr[index_arr] = input_arr[index]
    index_arr += 1
  end

  # Rotated Array
  arr
end

def test
  values = [
    {
      input_arr: [0, 1, 2, 4, 5, 6, 7],
      k: 3,
      target: 0,
      output: 4
    },
    {
      input_arr: [0, 1, 2, 4, 5, 6, 7],
      k: 3,
      target: 7,
      output: 3
    },
    {
      input_arr: [0, 1, 2, 4, 5, 6, 7],
      k: 3,
      target: 5,
      output: 1
    },
    {
      input_arr: [0, 1, 2, 4, 5, 6, 7],
      k: 3,
      target: 3,
      output: -1
    },
    {
      input_arr: [1],
      k: 1,
      target: 0,
      output: -1
    }
  ]

  values.each do |arr_hsh|
    input_arr = arr_hsh[:input_arr]
    k = arr_hsh[:k]
    target = arr_hsh[:target]
    output = arr_hsh[:output]

    print "\n Input Arr :: #{input_arr}, k :: #{k}, Target :: #{target}, "
    print " Output :: #{output}\n"
    result = search_sorted_rotated_arr(input_arr:, k:, target:)
    print " Result :: #{result} \n\n"
  end
end

test
