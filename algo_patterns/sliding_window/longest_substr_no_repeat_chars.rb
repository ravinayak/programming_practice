# Generally when we have to find contiguous set of elements say characters in a string, or fruits in a tree etc,
# sliding window pattern can be applied
# 
# Finds the longest substring in a given string with no repeated characters
# @param [String] input_str
# @return [Hash] ouput_hsh
#
def find_longest_subst_no_repeated_chars(input_str)
	substr_pointers = { left: 0, right: 0 }
	element_index_hsh = { }
	max_substr_index_len = { max_length: 0, left: 0, right: 0 }

	while substr_pointers[:right] < input_str.length
		key = input_str[substr_pointers[:right]]

		if element_index_hsh.key?(key) && element_index_hsh[key] >= substr_pointers[:left]
			substr_pointers[:left] = element_index_hsh[key] + 1
		end

		element_index_hsh[key] = substr_pointers[:right]

		assign_max_substr_index(substr_pointers, max_substr_index_len)
		substr_pointers[:right] = substr_pointers[:right] + 1
	end

	puts "Maximum Substring with no repeated characters :: #{input_str[max_substr_index_len[:left]..max_substr_index_len[:right]]}"
	puts "Maximum Substring length :: #{max_substr_index_len[:right] - max_substr_index_len[:left] + 1 }"
end

# Assign the left and right pointers for maximum substring
# @param [Hash] substr_pointers
# @param [Hash] max_substr_index_len
# @return NIL
#
def assign_max_substr_index(substr_pointers, max_substr_index_len)
	return unless is_substr_len_greater?(substr_pointers, max_substr_index_len)

	max_substr_index_len[:max_length] = calc_substr_len(substr_pointers)
	max_substr_index_len[:left] = substr_pointers[:left]
	max_substr_index_len[:right] = substr_pointers[:right]
end

# Returns if the current substring length is greater than max_length
# @param [Hash] substr_pointers
# @param [Hash] max_substr_index_len
# @return NIL
#
def is_substr_len_greater?(substr_pointers, max_substr_index_len)
	return true if calc_substr_len(substr_pointers) > max_substr_index_len[:max_length]

	false
end

# Returns the size of substring
# @param [Hash] substr_pointers
# @return [Integer]
#
def calc_substr_len(substr_pointers)
	substr_pointers[:right] - substr_pointers[:left] + 1
end

arr = ['aaabcdefaaaghijklma', 'abcdef', 'aabbccddef', 'aaabcaade']

arr.each do |input_str|
	puts "Input String :: #{input_str}"
	find_longest_subst_no_repeated_chars(input_str)
	puts
end