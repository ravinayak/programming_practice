# frozen_string_literal: true

# Implement Binary Search in both recursive and non-recursive way
# @param [Array] input_arr
# @param [Integer] target
# @return [Integer|nil]
#
def binary_search(input_arr:, target:)
  index_rec = binary_search_recursive(input_arr:, low: 0, high: input_arr.length - 1, target:)
  target_not_present = 'Target is not present in input array'
  target_present = "Found Target #{target} at Index"
  str = 'Binary Search Result Recursive :: '
  puts "#{str}#{index_rec.nil? ? target_not_present : "#{target_present} #{index_rec}"}"
  index_non_rec = binary_search_non_recursive(input_arr:, low: 0, high: input_arr.length - 1, target:)
  str = 'Binary Search Result Non-Recursive :: '
  puts "#{str}#{index_non_rec.nil? ? target_not_present : "#{target_present} #{index_non_rec}"}"
end

# Recursive Binary Search
#  Time Complexity => O(log n)
#  Space Complexity => O(log n) Required by Call Stack
# @param [Array] input_arr
# @param [Integer] low
# @param [Integer] high
# @param [Integer] target
# @return [Integer|nil]
#
def binary_search_recursive(input_arr:, low:, high:, target:)
  # We should not use >= because in such a case, we shall not be able to compare the element in input_arr when
  # low=high to target, there is a potential solution which we may miss. This is equivalent to saying that we
  #  1. low < high
  #  2. low = high
  # This is exactly the use cases covered in Iterative approach
  #
  return nil if low > high

  # This can cause overflow issues for large integers
  # mid = (low + high) / 2

  # This is safer and yields the same result
  mid = low + (high - low) / 2

  if input_arr[mid] == target
    mid
  elsif input_arr[mid] > target
    binary_search_recursive(input_arr:, low:, high: mid - 1, target:)
  else
    binary_search_recursive(input_arr:, low: mid + 1, high:, target:)
  end
end

# Recursive Binary Search
#  Time Complexity => O(log n)
#  Space Complexity => O(1)
# @param [Array] input_arr
# @param [Integer] low
# @param [Integer] high
# @param [Integer] target
# @return [Integer|nil]
#
def binary_search_non_recursive(input_arr:, low:, high:, target:)
  # We must use <= and not just <
  # This is because if we use only <, a use case where low = high, the comparison of element
  # in input_arr at that position of low (low = high) will not be made with the target. In this
  # case, even if the input_arr contains target, we shall return nil because the while loop will terminate
  # Recursive condition of returning nil when low > high, considers all use cases where 1. low < high 2. low = high
  #
  while low <= high
    mid = low + (high - low) / 2
    if input_arr[mid] == target
      return mid
    elsif input_arr[mid] > target
      high = mid - 1
    else
      low = mid + 1
    end
  end
  nil
end

arr = [
  { input_arr: [1, 5, 7, 9, 11, 15, 19, 25], target: 7 },
  { input_arr: [-1, -3, -5, 7, 9], target: 9 },
  { input_arr: [13, 15, 17, 19, 21], target: 13 },
  { input_arr: [1, 3, 5, 7, 9], target: 14 }
]
arr.each do |hsh|
  puts "Input Arr :: #{hsh[:input_arr].inspect}, Target :: #{hsh[:target]}, "
  binary_search(input_arr: hsh[:input_arr], target: hsh[:target])
  puts
end
