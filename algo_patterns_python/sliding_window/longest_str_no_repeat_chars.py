def longest_str_no_repeat_chars(str):
	dict_chars = {}
	result_str = ''
	left = 0
	for right in range(len(str)):
		if not str[right] in dict_chars:
			dict_chars[str[right]] = 1
			str_arr = dict_chars.keys()
			if len(str_arr) > len(result_str):
				result_str = ''.join(str_arr)
		else:
			while str[right] in dict_chars:
				dict_chars.pop(str[left])
				left += 1
			dict_chars[str[right]] = 1
    
	print(f'Longest substring without repeating characters :: {result_str}')
	return result_str

input_output_list = [['abcabcbb', 'abc'], ['bbbb', 'b'], ['pwwkew', 'kew'], ['abcdefb', 'abcdef']]

for input_output in input_output_list:
	longest_str_no_repeat_chars(input_output[0])
	print(f'Input :: {input_output[0]}, Expected Output :: {input_output[1]}')
    
