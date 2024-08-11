# frozen_string_literal: true

# Given an array of sorted integers, and a target sum, find 2 elements in the array which result in target sum
#
# @param [Array] input_arr
# @param [Integer] target_sum
# @return [Hash]
#
def find_target_sum(input_arr, target_sum)
  elements_arr = []
  pointer_one = 0
  pointer_two = input_arr.length - 1

  input_arr.each_with_index do |_element, _index|
    curr_sum = input_arr[pointer_one] + input_arr[pointer_two]
    if curr_sum == target_sum
      elements_arr << input_arr[pointer_one]
      elements_arr << input_arr[pointer_two]
      break
    end
    if is_curr_sum_greater?(target_sum: target_sum, curr_sum: curr_sum)
      pointer_two -= 1
    else
      pointer_one += 1
    end
  end
  puts "Two elements in array which add to target sum :: #{elements_arr.inspect}"
  puts
end

# Returns true if elements add to a value greater than target sum
# @param [Integer] target_sum
# @param [Integer] curr_sum
# @return [Boolean]
#
def is_curr_sum_greater?(target_sum:, curr_sum:)
  return true if curr_sum > target_sum

  false
end

arr = [{ arr: [1, 3, 5, 6, 7, 26, 27], sum: 34 }, { arr: [1, 9, 10, 11, 35], sum: 44 },
       { arr: [-31, -29, -26, -19, -11], sum: -30 }]

arr.each do |hsh|
  find_target_sum(hsh[:arr], hsh[:sum])
end
