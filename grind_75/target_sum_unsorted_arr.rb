# frozen_string_literal: true

# Given an array of integers nums and an integer target, return indices of the
# two numbers such that they add up to target.
# You may assume that each input would have exactly one solution, and you may not
# use the same element twice.

# You can return the answer in any order.

# NOTE: Array of integers is not Sorted
#    This is an important observation because this implies we cannot use the two
#    pointers method to solve this problem without increasing complexity
#    To use two pointers method:
#      a. Sort the array => O(n * log n)
#      b. Keep track of original indices of elements => We have to return NOT
#         the actual numbers but indices of the numbers
#            => We need An array to store elements and their indices or a hash
#            => O(n)

# More Efficient solution is to use a Hash
# For each element in array, we store its compliment (target - original element) in
# hash as key, and index of that element as value. As we iterate over elements in array,
# if we find any element (stored as key) present in hash, we know that this key is
# the compliment of the original element in array, and we have stored its index.
# Original element and its compliment stored in hash add upto target
#
# Since both original element and current element (same as compliment) add up to target,
# we can return [value of key, current index] as the solution
# Elements are stored in hash as => Target - element => compliment
# Ex: input = [2,7,11], target = 9 => We shall store
#        these keys along with values =>
#          a. 9 - 2 = 7 => 0
#          b. 9 - 7 = 2 => 1
#          c. 9 - 11 = -2   => 2

# Time Complexity => O(n)
# Space Complexity => O(n)

# @param [Array] input_arr
# @param [Integer] target
# @return [Array]
#
def find_indices_for_target_sum(input_arr:, target:)
  compliment_index_hsh = {}

  input_arr.each_with_index do |element, index|
    return [compliment_index_hsh[element], index] unless compliment_index_hsh[element].nil?

    compliment_index_hsh[target - element] = index
  end

  []
end

input_arr = [2, 7, 11, 15]
target = 9
output_str = 'Indices of elements in array which add to target :: '
res = find_indices_for_target_sum(input_arr:, target:)
puts "Input Array :: #{input_arr.inspect} \t \t #{output_str} #{res}"

input_arr = [3, 2, 4]
target = 6
output_str = 'Indices of elements in array which add to target :: '
res = find_indices_for_target_sum(input_arr:, target:)
puts "Input Array :: #{input_arr.inspect} \t \t #{output_str} #{res}"

input_arr = [3, 3]
target = 6
output_str = 'Indices of elements in array which add to target :: '
res = find_indices_for_target_sum(input_arr:, target:)
puts "Input Array :: #{input_arr.inspect} \t \t #{output_str} #{res}"

# Example 1:

# Input: nums = [2,7,11,15], target = 9
# Output: [0,1]
# Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
# Example 2:

# Input: nums = [3,2,4], target = 6
# Output: [1,2]
# Example 3:

# Input: nums = [3,3], target = 6
# Output: [0,1]
