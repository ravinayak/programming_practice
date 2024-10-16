# frozen_string_literal: true

# Implement Binary Search in both recursive and non-recursive way
# @param [Array] input_arr
# @param [Integer] target
# @return [Integer|nil]
#
def binary_search(input_arr:, target:)
  index_rec = binary_search_recursive(input_arr:, low: 0,
                                      high: input_arr.length - 1, target:)
  target_not_present = ' Target is not present in input array'
  target_present = "Found Target #{target} at Index"
  str = ' Binary Search Result Recursive :: '
  rec_res = if index_rec.nil?
              target_not_present
            else
              "#{target_present} #{index_rec}"
            end
  puts "#{str}#{rec_res}"
  index_non_rec = binary_search_non_recursive(input_arr:, low: 0,
                                              high: input_arr.length - 1, target:)
  str = ' Binary Search Result Non-Recursive :: '
  non_rec_res = if index_non_rec.nil?
                  target_not_present
                else
                  "#{target_present} #{index_non_rec}"
                end
  puts "#{str}#{non_rec_res}"
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
  # We should not use >= because in such a case, we shall not be able to
  # compare the element in input_arr when
  # low = high to target, there is a potential solution which we may miss.
  # This is equivalent to saying that we
  #  1. low < high
  #  2. low = high
  #  3. low > high
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

# @param [Array<Integer>] input_arr
# @param [Integer] target
def modified_binary_search(input_arr:, target:)
  return nil if input_arr.empty?

  return input_arr[0] if input_arr.length == 1 && input_arr[0] <= target

  return nil if input_arr.length == 1 && input_arr[0] > target

  low = 0
  high = input_arr.length - 1
  best = nil

  while low <= high
    mid = low + (high - low) / 2

    if input_arr[mid] == target
      return target
    elsif input_arr[mid] < target
      best = input_arr[mid]
      low = mid + 1
    else
      high = mid - 1
    end
  end

  best
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
  # This is because if we use only <, a use case where low = high,
  # the comparison of element in input_arr at that position of low (low = high)
  # will not be made with the target. In this case, even if the input_arr contains
  # target, we shall return nil because the while loop will terminate
  # Recursive condition of returning nil when low > high, considers all use cases
  # where
  # 1. low < high
  # 2. low = high
  # 3. low > high
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
  {
    input_arr: [1, 5, 7, 9, 11, 15, 19, 25],
    target: 7,
    modified_target: 18,
    output: 15
  },
  {
    input_arr: [-5, -3, -1, 7, 9],
    target: 9,
    modified_target: 9,
    output: 9
  },
  {
    input_arr: [13, 15, 17, 19, 21],
    target: 13,
    modified_target: 16,
    output: 15
  },
  {
    input_arr: [1, 3, 5, 7, 9],
    target: 14,
    modified_target: 6,
    output: 5
  }
]

arr.each do |hsh|
  puts " Input Arr :: #{hsh[:input_arr].inspect}, Target :: #{hsh[:target]}, "
  binary_search(input_arr: hsh[:input_arr], target: hsh[:target])
  puts

  input_arr = hsh[:input_arr]
  target = hsh[:modified_target]
  output = hsh[:output]
  res = modified_binary_search(input_arr:, target:)
  print "\n Input Arr :: #{hsh[:input_arr].inspect}, Target :: #{target}"
  print "\n Output :: #{output}, Modified Binary Search :: #{res} \n\n"
end
