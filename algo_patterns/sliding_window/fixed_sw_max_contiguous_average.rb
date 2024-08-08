# Find the maximum average of contiguous 4 elements in a given array
# youtube.com => https://www.youtube.com/watch?v=XfSgQvKfcys&list=PL7g1jYj15RUOjoeZAJsWjwV8XUo9r0hwc&index=2
#
# Naive Solution
#
# @param [Array] input_arr
# @param [Integer] k
# @return [Integer] max_avg
# Time Complexity O(n*k) ~ O(n^2)
#
def max_contiguous_avg(input_arr, k)
	max_avg = 0
	return max_avg if input_arr.empty? || input_arr.length < 4


	input_arr.each_with_index do |element, index|
		avg = (element + input_arr[index+1] + input_arr[index+2] + input_arr[index+3])/4.to_f
		max_avg = avg if max_avg < avg
		break if (index + 4) == input_arr.length
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
# @param [Integer] k
# @return [Integer] max_avg
# Time Complexity O(n)
#
def max_contiguous_avg_sw(input_arr, k)
	max_avg = 0
	return max_avg if input_arr.empty? || input_arr.length < 4

	start_index = 0
	sum = (input_arr[start_index] + input_arr[start_index + 1] + input_arr[start_index + 2] + input_arr[start_index + 3])
	input_arr.each_with_index do |element, index|
		avg = sum/4.to_f
		max_avg = avg if max_avg > avg
		break if (index + 4) == input_arr.length
		sum = (sum - input_arr[index] + input_arr[index + 4])
	end
	max_avg
end

arr = [[1, 12, -5, -6, 50, 3], [1,2,3], [3, 4, 5, -5], [1, 100, 9, -81, 82, 67, 120]]
arr.each do |input_arr|
	puts "Maximum Average is :: #{max_contiguous_avg(input_arr, 4)}"
end
