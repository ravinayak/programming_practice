# Find the maximum contiguous size for elements in an array where the maximum different elements
# in the contiguous sequence can only be k
# This is dynamic window sliding problem
# @param [Array] input_arr
# @param [Integer] k
# @return [Hash] max_sw_size_arr 
#
# arr = [1,2,1,2,1,2,3,4,5,6,6,8,6,8,8,6,6,7]
def dynamic_sw_max_contiguous_sequence(input_arr, k)
	return { max_size: 0, max_sw_arr: [] } if input_arr.empty? || k == 0

	sw_pointers = { left: 0, right: 0 }
	max_sw_size_arr = { max_size: 0, max_sw_arr: [] }
	k_elements_count_hsh = Hash.new(0)

	while sw_pointers[:right] < input_arr.length
		k_elements_count_hsh[input_arr[sw_pointers[:right]]] += 1
		while k_elements_count_hsh.size > k
			adjust_elements_count_hsh(k_elements_count_hsh, k, input_arr, sw_pointers)
		end
		assign_max_sw_size_arr(input_arr, sw_pointers, max_sw_size_arr) if size_greater_max_size?(sw_pointers, max_sw_size_arr)
		sw_pointers[:right] += 1
	end

	puts "Maxium contiguous size for elements in array where maximum different elements is #{k} :: #{max_sw_size_arr[:max_size]}"
	puts "Elements in the contiguous sequence is :: ##{max_sw_size_arr[:max_sw_arr]}"

	[max_sw_size_arr]
end

# Adjusts elements in hash based on input parameter k
# @param [Hash] k_elements_count_hsh
# @param [Integer] k
# @param [Array] input_arr
# @param [Hash] sw_pointers
# @return [NIL]
#
def adjust_elements_count_hsh(k_elements_count_hsh, k, input_arr, sw_pointers)
	key = input_arr[sw_pointers[:left]]
	k_elements_count_hsh[key] -= 1
	k_elements_count_hsh.delete(key) if k_elements_count_hsh[key] == 0
	sw_pointers[:left] += 1
end

# Assign max size and max sliding window elements to max array
# @param [Array] input_arr
# @param [Hash] sw_pointers
# @param [Hash] max_sw_size_arr
# @return [NIL]
#
def assign_max_sw_size_arr(input_arr, sw_pointers, max_sw_size_arr)
	max_sw_size_arr[:max_size] = cal_sw_size(sw_pointers)
	max_sw_size_arr[:max_sw_arr] = input_arr[sw_pointers[:left]..sw_pointers[:right]]
end

# checks if current max size is less than sliding window size
# @param [Hash] sw_pointers
# @param [Hash] max_sw_size_arr
# @return [Boolean]
#
def size_greater_max_size?(sw_pointers, max_sw_size_arr)
	sw_size = cal_sw_size(sw_pointers)
	return true if sw_size > max_sw_size_arr[:max_size]

	false
end

# Calculates the sliding window size
# @param [Hash] sw_pointers
# @return [Integer]
#
def cal_sw_size(sw_pointers)
	sw_pointers[:right] - sw_pointers[:left] + 1
end

# arr = [[1,2,3,2,2,1,2,4,2,1], [1,2,3,2,2], [1,2,-1,2,2], [1,2,3,4,5,6],[1,2,1,2,1,2,3,4,5,6,6,8,6,8,8,6,6,7]]
arr = [[1,2,1,2,1,2,1,2,3,4,-1,-2,1,2,1,2,3,4,2,2,1,4,3,2,1,3,2,3,4,8,-9,10]]
arr.each do |input_arr|
	puts "Input Arr :: #{input_arr}"
	dynamic_sw_max_contiguous_sequence(input_arr, 4)
	puts ""
end