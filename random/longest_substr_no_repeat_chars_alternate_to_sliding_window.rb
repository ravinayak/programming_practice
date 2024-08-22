# frozen_string_literal: true

# Given a string s, Implement a ruby method to find the longest substring without
# repeating characters. eg :abcabcbb = >3
# This problem has already been solved using Sliding Window pattern, and that is
# the best pattern to use to solve this problem.
#
# Solution presented below is random, and I used while solving a problem given
# in an interview. Keeping it around to have alternate solutions for the same
# problem

#  
# Example 1:
# when you Input string: s = "abcabcbb"
# the output is 3
#  
# Example 2:
# when you Input string: s = "bbbbb"
# output is 1
#  
# Example 3:
# when you Input string: s = "pwwkew"
# output is 3

# Checks a string "s" and returns the longest substring without repeating characters
# @param [String] input_str
# @return [Integer] result
#
def find_longest_substring(input_str)
  result = ''
  substr_arr = []

  substr_hash = {}

  input_str.chars.each do |str_char|
    if substr_hash.key?(str_char)
      substr_arr << result
      result = str_char
      substr_hash = {}
      substr_hash[str_char] = true
    else
      substr_hash[str_char] = true
      result += str_char
    end
  end

  length = 0
  longest_substr = ''
  substr_arr.each do |str|
    if str.length >= length
      longest_substr = str
      length = str.length
    end
  end
  puts "Longest substring without repeated characters is :: #{longest_substr}"
  puts "Output is #{longest_substr.length}"
  longest_substr.length
end

%w[abcabcbb bbbbb pwwkew].each do |str|
  find_longest_substring(str)
end
