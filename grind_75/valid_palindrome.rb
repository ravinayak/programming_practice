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
# Since an empty string reads the same forward and backward, it is a palindrome

# Tests whether given input string is a valid palindrome
# @param [String] input_str
# @return [Boolean]
#
def valid_palindrome(input_str:)
  return puts "#{" Input Str :: '#{input_str}'".ljust(60)}Palindrome Test Result :: true" if
    input_str.length < 2

  start_pointer = 0
  end_pointer = input_str.length - 1
  result = true

  # In Non Ruby method, we would do the following
  # Iterate over all characters in string, choose the characters which are alphabets
  # We use two pointers approach where we compare each start character with end character, at any point
  # if they are not equal, break
  # If all iterations succeed, we can have 2 possible use cases:
  # 1. string has odd length  => start_pointer = end_pointer
  #  start_pointer < end_pointer will work in odd case because both start_pointer and end_pointer
  #  will converge to the same character at odd position (which is the middle of string), and
  #  they will compare the same character on both sides
  #     str[start_pointer] == str[end_poiner]
  # 2. string has even length => start_pointer < end_pointer will work because in even length,
  #  during comparison, start_pointer will cross the end_pointer when it reaches middle of string
  #  which will be 2 characters, start_pointer will point to the character whose index is lower,
  #  after comparsion, start_pointer will increase by 1, end_pointer will decrement by 1
  #  resulting in
  #   start_pointer > end_pointer
  #   => start_poiner < end_pointer, start_pointer <= end_pointer both will work
  while start_pointer <= end_pointer
    # Skip to the next iteration unless the character is alphabetic
    # [[:alpha:]] is a POSIX character class that matches any alphabetic character (a-z, A-Z)
    # It's more inclusive than [a-zA-Z] as it also matches alphabetic characters from other languages
    # we do not use [[:alpha:]]
    # If the character is not alphabetic, we move to the next character in the input string
    # Because we only want to match a-z, A-Z, 0-9
    # (problem statement says remove all non-alphanumeric characters
    #  => we should keep alpha numeric characters in string
    #  => alphabets and numbers in string should only be included
    #  => Every character other than alphabet and number should be excluded/skipped
    #  => alphabetic characters from other languages intentionally ignored
    # We increment start_pointer / decrement end_pointer as long as the input_str
    # contains characters referenced by start_pointer/end_pointer are not valid
    # characters for palindrome test (valid character = letter/number)
    # empty space is also a string and match/other string operators can be used
    # on empty space character
    start_pointer += 1 while start_pointer <= end_pointer &&
                             !input_str[start_pointer].match?(/[a-zA-Z0-9]/)
    end_pointer -= 1 while end_pointer >= start_pointer &&
                           !input_str[end_pointer].match?(/[a-zA-Z0-9]/)

    # It is possible that input_str has A at start_pointer and a at end_pointer
    # We must match them as equal because palindrome test is case insensitive
    if input_str[start_pointer].downcase != input_str[end_pointer].downcase
      result = false
      break
    end

    start_pointer += 1
    end_pointer -= 1
  end

  # The `ljust` method is used to left-justify the string within a field of a given width.
  # It pads the string with spaces on the right if it's shorter than the specified width.
  # In this case, it ensures that the "Input String" part always takes up 60 characters,
  # which aligns the "Palindrome Test Result" part regardless of the input string's length.
  puts " Input String :: '#{input_str}'".ljust(60) + "Palindrome Test Result :: #{result}"

  # Always return the result from a method, makes it useful in various other use cases
  result
end

def valid_palindrome_using_reverse(input_str:)
  return puts "#{" Input Str :: '#{input_str}'".ljust(60)}Palindrome Test Result :: true" if
    input_str.length < 2

  palindrome_test_str = []
  index = input_str.length - 1
  result = true

  while index >= 0
    palindrome_test_str[(input_str.length - 1) - index] = input_str[index]
    index -= 1
  end

  input_str_index = 0
  test_str_index = 0
  while input_str_index < input_str.length
    input_str_index += 1 while input_str_index < input_str.length &&
                               !input_str[input_str_index].match?(/[a-zA-Z0-9]/)
    test_str_index += 1 while test_str_index < input_str.length &&
                              !palindrome_test_str[test_str_index].match?(/[a-zA-Z0-9]/)

    if palindrome_test_str[test_str_index].downcase != input_str[input_str_index].downcase
      result = false
      break
    end

    input_str_index += 1
    test_str_index += 1
  end

  # The `ljust` method is used to left-justify the string within a field of a given width.
  # It pads the string with spaces on the right if it's shorter than the specified width.
  # In this case, it ensures that the "Input String" part always takes up 60 characters,
  # which aligns the "Palindrome Test Result" part regardless of the input string's length.
  puts " Input String :: '#{input_str}'".ljust(60) + "Palindrome Test Result :: #{result}"

  # Return result of comparision
  result
end

def test
  input_str_arr = ['A man, a plan, a canal: Panama', 'race a car', ' ', 'abc 01233210 cba', 'abc 0123210 cba',
                   'a man is here']

  print "\n Testing Palindrome using Reverse where we copy characters into another string :: \n\n"
  input_str_arr.each do |input_str|
    valid_palindrome_using_reverse(input_str:)
  end
  print "\n Testing Palindrome using 2 pointers - start/end pointer\n\n"
  input_str_arr.each do |input_str|
    valid_palindrome(input_str:)
  end
  print "\n"
end

test
