# frozen_string_literal: true

# Match a char to expected characters, say a-z,A-Z
#   1. char.match?(/[a-zA-Z]/)
#   2. char.downcase.between?('a', 'z')
#   3. char =~ /[a-zA-Z]/
#   4. char.match?(/[[:alpha:]]/)
# 1st and 4th are preferred methods

# A phrase is a palindrome if, after converting all uppercase letters into lowercase
# letters and removing all non-alphanumeric characters, it reads the same forward and
# backward. Alphanumeric characters include letters and numbers.

# Given a string s, return true if it is a palindrome, or false otherwise.

# Tests whether given input string is a valid palindrome
# @param [String] input_str
# @return [Boolean]
#
def valid_palindrome(input_str:)
  return puts "Input String :: '#{input_str}' \t \tPalindrome Test Result :: true" if
    input_str.length < 2

  palindrome_test_str = []
  index = 0
  result = true

  # In Non Ruby method, we would do the following
  # Iterate over all characters in string, choose the characters which are alphabets
  input_str.chars.each do |str_char|
    # Skip to the next iteration unless the character is alphabetic
    # [[:alpha:]] is a POSIX character class that matches any alphabetic character (a-z, A-Z)
    # It's more inclusive than [a-zA-Z] as it also matches alphabetic characters from other languages
    #  we do not use [[:alpha:]]
    # If the character is not alphabetic, we move to the next character in the input string
    # Because we only want to match a-z, A-Z, 0-9
    # (problem statement says remove all non-alphanumeric characters
    #    => we should keep alpha numeric characters in string
    #    => alphabets and numbers in string should only be included
    #    => Every character other than alphabet and number should be excluded/skipped
    #    => alphabetic characters from other languages intentionally ignored
    next unless str_char.match?(/[a-zA-Z0-9]/)

    palindrome_test_str[index] = str_char.downcase
    index += 1
  end

  start_pointer = 0
  end_pointer = palindrome_test_str.length - 1
  # We use two pointers approach where we compare each start character with end character, at any point
  # if they are not equal, break
  # If all iterations succeed, we can have 2 possible use cases:
  #    1. string has odd length  => start_pointer = end_pointer
  #    2. string has even length => start_pointer > end_pointer
  while start_pointer <= end_pointer
    if palindrome_test_str[start_pointer] != palindrome_test_str[end_pointer]
      result = false
      break
    end
    start_pointer += 1
    end_pointer -= 1
  end

  puts "Input String :: '#{input_str}' \t \tPalindrome Test Result :: #{result}"

  # Always return the result from a method, makes it useful in various other use cases
  result
end

input_str_arr = ['A man, a plan, a canal: Panama', 'race a car', ' ']
input_str_arr.each do |input_str|
  valid_palindrome(input_str:)
end

# Example 1:

# Input: s = "A man, a plan, a canal: Panama"
# Output: true
# Explanation: "amanaplanacanalpanama" is a palindrome.
# Example 2:

# Input: s = "race a car"
# Output: false
# Explanation: "raceacar" is not a palindrome.
# Example 3:

# Input: s = " "
# Output: true
# Explanation: s is an empty string "" after removing non-alphanumeric characters.
# Since an empty string reads the same forward and backward, it is a palindrome.
