# frozen_string_literal: true

# Find the maximum average of contiguous 4 elements in a given array
# youtube.com => https://www.youtube.com/watch?v=XfSgQvKfcys&list=PL7g1jYj15RUOjoeZAJsWjwV8XUo9r0hwc&index=2
#
# Naive Solution
#
# @param [Array] input_arr
# @param [Integer] max_contiguous
# @return [Integer] max_avg
# Time Complexity O(n*max_contiguous) ~ O(n^2)
#
def max_contiguous_avg(input_arr, max_contiguous)
  max_avg = 0
  return max_avg if input_arr.empty? || input_arr.length < max_contiguous

  input_arr.each_with_index do |_element, index|
    counter = sum = 0
    while counter < max_contiguous
      sum += input_arr[counter]
      counter += 1
    end
    avg = sum / max_contiguous.to_f
    max_avg = avg if max_avg < avg
    break if (index + max_contiguous) == input_arr.length
  end
  max_avg
end

# arr = [[1, 12, -5, -6, 50, 3], [1,2,3], [3, 4, 5, -5], [1, 100, 9, -81, 82, 67, 120]]
# arr.each do |input_arr|
# 	puts "Maximum Average is :: #{max_contiguous_avg(input_arr, 4)}"
# end

# Sliding Window Solution
#
# @param [Array] input_arr
# @param [Integer] max_contiguous
# @return [Integer] max_avg
# Time Complexity O(n)
#
def max_contiguous_avg_sw(input_arr, max_contiguous)
  max_avg = 0
  return max_avg if input_arr.empty? || input_arr.length < max_contiguous

  counter = sum = 0
  while counter < max_contiguous
    sum += input_arr[counter]
    counter += 1
  end
  input_arr.each_with_index do |_element, index|
    avg = sum / max_contiguous.to_f
    max_avg = avg if max_avg > avg
    break if (index + max_contiguous) == input_arr.length

    sum = (sum - input_arr[index] + input_arr[index + max_contiguous])
  end
  max_avg
end

arr = [[1, 12, -5, -6, 50, 3], [1, 2, 3], [3, 4, 5, -5], [1, 100, 9, -81, 82, 67, 120]]
arr.each do |input_arr|
  puts "Maximum Average is :: #{max_contiguous_avg(input_arr, 4)}"
end
