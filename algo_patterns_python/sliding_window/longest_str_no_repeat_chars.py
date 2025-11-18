from collections import defaultdict
from math import inf

def longest_str_no_repeat_chars(str):
  dict_str = defaultdict(lambda: 0)
  left = 0
  min_res_str = [0, []]
  for right in range(len(str)):
    if dict_str[str[right]] == 0:
      substr(dict_str, str[right], min_res_str)
    else:
      while(dict_str[str[right]] != 0):
        dict_str[str[left]] -= 1
        if dict_str[str[left]] == 0:
          dict_str.pop(str[left])
        left += 1
      substr(dict_str, str[right], min_res_str)
        
  print(f'Length :: {min_res_str[0]}, Substr :: {''.join(min_res_str[1])}')
  return [min_res_str[0], ''.join(min_res_str[1])]
      
def substr(dict_str, character, min_res_str):
  dict_str[character] += 1
  substr = list(dict_str.keys())
  if len(substr) > min_res_str[0]:
    min_res_str[0] = len(substr)
    min_res_str[1] = substr

input_output_list = [['abcabcbb', 'abc'], ['bbbb', 'b'], ['pwwkew', 'kew'], ['abcdefb', 'abcdef']]

for input_output in input_output_list:
	longest_str_no_repeat_chars(input_output[0])
	print(f'Input :: {input_output[0]}, Expected Output :: {input_output[1]}')
    
