# frozen_string_literal: true

# Given an integer array nums, return an array answer such that answer[i]
# is equal to the product of all the elements of nums except nums[i].

# The product of any prefix or suffix of nums is guaranteed to fit in a 32-bit
# integer.

# You must write an algorithm that runs in O(n) time and without using the
# division operation.

# Example 1:
# Input: nums = [1,2,3,4]
# Output: [24,12,8,6]

# Example 2:
# Input: nums = [-1,1,0,-3,3]
# Output: [0,0,9,0,0]

# Algorithm: We calculate the left product of every element in the array, where
# left product is the product of all elements left of the current element in
# the array. We start with left_product = 1, such that for element at index 0
# where there is no element left of it, we store the value 1 as its left_product
# Once we have evaluated left_product of all elements in the array and stored
# in the result array, we start calculating right_product of all elements to
# the right of element in the array. Here we also use the same concept that
# right_product of rightmost element at (n-1) index would be 1, and the other
# observation that left_product of element at (n-1) is the product of all
# elements except element at (n-1), since there is no element to right of "n-1"
# For any element at any index, if we multiply result[i] * right_product, we
# will get the product of all elements except element at "i" in the array

# Step 1: Initialize left_product = 1, so that when we iterate in the
# array from index 1, left_product = left_product * nums[i-1]
# Step 2: Iterate from 1 to nums.length -1 and calculate left_product for
# all elements in the array upto (nums.length - 1). As we iterate, we move
# from index "i" to "i + 1", at this time, result[i] holds the left_product
# of all elements in the array from "0" to "i-1", when we multiply left_product
# with nums[i], it gives us the result[i+1]
#    => result[i] = result[i - 1] * nums[i - 1]
#       result[i - 1] = product of all elements in array from "0" to "i-2"
# Step 3: At index "n" = nums.length - 1
#    => result[n-1] = product of all elements in the array from "0" to "n-2"
# Step 4: Initialize right_product = 1
# Step 5: Iterate from "n-1" to "0". At "n-2", result[n-2] = left_product of
# all elements in the array from "0" to "n-3". If we multiply this with nums[n-1]
#  we shall get the product of all elements in the array except element at n-2
#    => result[n-2] = product of all elements from "0" to "n-3"
#    => result[n-2] * nums[n-1] = product of all elements from "0" to "n-3" * nums[n-1]
#    => = Except element at index "n-2", we have calculated product of all elements
# Step 6: While iterating from "n-1" to "0", we calculate right_product of all elements
#  to the right of current element in the array
#  Step 7: result[i] = result[i] * right_product (product of all elements right of "i")

# Ex: nums = [2, 3, 5, 7]
# left_product result = [1, 2, 3 * 2, 5 * 3 * 2] = [1, 2, 6, 30]
# right_prudct for [2, 3, 5, 7] = [3 * 5 * 7, 5 * 7, 7 * 1, 1] = [105, 35, 7, 1]
# NOTE: It is critical to observe that for an element at "n-1" index, the product of all
# elements except self, is the left_product (since there is no element right of it)
# We use this to our advantage because we can do result[index] * right_product, where
# right_product = 1 for "n-1" index

# @param [Array<Integer>] nums
# @return [Array]
def product_elements_except_self(nums:)
  return nil if nums.empty?

  return nil if nums.length == 1

  left_product = 1
  right_product = 1
  result = []

  (0...nums.length).each do |index|
    result[index] = left_product
    left_product *= nums[index]
  end

  (nums.length - 1).downto(0).each do |index|
    result[index] = result[index] * right_product
    right_product *= nums[index]
  end

  # Return result
  result
end

def test
  nums_arr = [
    {
      nums: [1, 2, 3, 4],
      output: [24, 12, 8, 6]
    },
    {
      nums: [-1, 1, 0, -3, 3],
      output: [0, 0, 9, 0, 0]
    }
  ]

  nums_arr.each do |num_hsh|
    nums = num_hsh[:nums]
    output = num_hsh[:output]
    res = product_elements_except_self(nums:)

    print "\n\n Nums :: #{nums.inspect}"
    print "\n Expected Output :: #{output.inspect}, "
    print "Result :: #{res.inspect}\n\n"
  end
end

test
