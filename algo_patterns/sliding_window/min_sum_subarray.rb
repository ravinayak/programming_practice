# Given an array of integers, find the minimum size subarray which has a sum greater than or equal to given target
#
# @param [Array] input_arr
# @param [Integer] sum
# @return [Hash]
#
def min_subarray_sum(input_arr, sum)

	subarr_pointers = { left: 0, right: 0 }
	min_subarr = { size: Float::INFINITY, left: 0, right: 0, sum: 0 }

	while subarr_pointers[:right] < input_arr.length
		min_subarr[:sum] += input_arr[subarr_pointers[:right]]

		while min_subarr[:sum] >= sum
			assign_min_subarr(subarr_pointers, min_subarr)
			min_subarr[:sum] -= input_arr[subarr_pointers[:left]]
			subarr_pointers[:left] += 1
		end

		subarr_pointers[:right] += 1
	end

	puts "Minimum size subarray :: #{input_arr[min_subarr[:left]..min_subarr[:right]]}"
	puts "Minimum subarray size :: #{min_subarr[:size]}"
	puts
end

# Assign minimum size and left, right pointers to min_subarray
# @param [Hash] subarr_pointers
# @param [Hash] min_subarr
# @return NIL
def assign_min_subarr(subarr_pointers, min_subarr)
	return unless is_subarr_size_less?(subarr_pointers, min_subarr)

	min_subarr[:size] = calc_subarr_size(subarr_pointers)
	min_subarr[:left] = subarr_pointers[:left]
	min_subarr[:right] = subarr_pointers[:right]
end

# Returns if window size is less than min_subarr size
# @param [Hash] subarr_pointers
# @param [Hash] min_subarr
# @return [Boolean]
#
def is_subarr_size_less?(subarr_pointers, min_subarr)
	return true if calc_subarr_size(subarr_pointers) < min_subarr[:size]

	false
end

# Calculates size of given subarray
# @param [Hash] subarr_pointers
# @return [Integer]
#
def calc_subarr_size(subarr_pointers)
	subarr_pointers[:right] - subarr_pointers[:left] + 1
end

arr = [ { arr: [1, 2, -3, 5, 6, 8, 3, 4, 5], sum: 3 }, { arr: [2, 3, 1, 2, 4, 3], sum: 7 }, { arr: [-1, 7, 1, 8, 0, 6, 2], sum: 8 } ]

arr.each do |hsh|
	min_subarray_sum(hsh[:arr], hsh[:sum])
end