# frozen_string_literal: true

# Given an array nums with n objects colored red, white, or blue,
# sort them in-place so that objects of the same color are adjacent,
# with the colors in the order red, white, and blue.

# We will use the integers 0, 1, and 2 to represent the color red,
# white, and blue, respectively.

# You must solve this problem without using the library's sort function.

# Example 1:
# Input: nums = [2,0,2,1,1,0]
# Output: [0,0,1,1,2,2]

# Example 2:
# Input: nums = [2,0,1]
# Output: [0,1,2]

# This problem is solved using Dutch National Flag Algorithm which is
# used to group 3 distinct elements together in any specified order
# in O(n) time in-place
# It uses the concept of 3 pointers:
# a. low => All elements left of this pointer are Element 1
# b. high => All element right of this pointer are Element 3
# c. (low + 1 .. high - 1) => All elements between low and high are
#    Element2
# d. mid => moves from low to high until 3 sets of grouped elements are
# formed

# mid pointer and its increment are critical for the Dutch Algorithm
# to work correctly
# 1. low = mid = 0, high = arr.length - 1
# 2. if arr[mid] = Element 1
#     a. Swap element at mid with low
#     b. mid +=1 , low += 1
#     c. All elements left of low now contain Element 1
# 3. if arr[mid] = Element 3
#     a. Swap element at mid with high
#     b. high -= 1
#     c. We do not increment mid, This is CRITICAL because
#        when we swap arr[mid] with arr[high], several use
#        cases are possible
#        => 1. arr[mid] now contains Element 1, if we increment
#              mid, there will be an Element 1 right of low, and
#              this will violate the condition
#        => 2. arr[mid] now contains Element 3, if we increment
#              mid, there will be an Element3 left of high, violation
#        => 3. mid should not be incremented
#        => 4. In the next iteration, values at low, mid, high will be
#              compared and swapped accordingly to group them correctly

# @param [Array<Integer>] arr
# @param [Integer] low_element
# @param [Integer] high_element
# @return [Array<Integer>]
def sort_colors(arr:, low_element:, mid_element:, high_element:)
  # Tracks low_element, all elements left of low are low_element
  low = 0
  # mid is not the Binary Search "mid" [= (low + high)/ 2]
  # mid starts at 0, represents mid-element, goes through the
  # entire array or until it reaches high, swapping elements
  # and grouping them in specified order
  mid = 0
  # Tracks high_element, all elements right of high are high_element
  high = arr.length - 1

  while mid <= high
    if arr[mid] == low_element
      swap(arr:, i: mid, index_to_exchange: low)
      mid += 1
      low += 1
    elsif arr[mid] == mid_element
      mid += 1
    elsif arr[mid] == high_element
      swap(arr:, i: mid, index_to_exchange: high)
      high -= 1
    end
  end

  arr
end

# Swap elements at index "i", and index "index_to_exchange" in arr
# @param [Array<Integer>] colors
# @param [Integer] i
# @param [Integer] index_to_exchange
def swap(arr:, i:, index_to_exchange:)
  temp = arr[i]
  arr[i] = arr[index_to_exchange]
  arr[index_to_exchange] = temp
end

def test
  nums_arr = [
    {
      arr: [2, 0, 2, 1, 1, 0],
      output: [0, 0, 1, 1, 2, 2]
    },
    {
      arr: [2, 1, 0],
      output: [0, 1, 2]
    }
  ]
  nums_arr.each do |num_hsh|
    arr = num_hsh[:arr]
    output = num_hsh[:output]
    result = sort_colors(arr:, low_element: 0, mid_element: 1, high_element: 2)
    print "\n Input :: #{arr.inspect}, output :: #{output.inspect}, Res :: #{result.inspect} \n"
  end

  arr =  [2, 0, 2, 1, 1, 0]
  output = [2, 2, 1, 1, 0, 0]
  result = sort_colors(arr:, low_element: 2, mid_element: 1, high_element: 0)
  print "\n Input :: #{arr.inspect}, output :: #{output.inspect}, Res :: #{result.inspect} \n"
end

test
