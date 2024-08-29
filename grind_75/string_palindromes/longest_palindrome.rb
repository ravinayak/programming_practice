# frozen_string_literal: true

# Find longest palindrome in a string, the string may contain uppercase
# and lowercase letters

# The solution is based on expand-around center algorithm where we
# iterate over the entire length of string, and for each index
# position within the string, we look at 2 possible use cases:
# 1. Odd-length palindromes: These are strings which are formed
#     by including 2 chars around the current character, one on
#     the left, and one on the right. The single character at
#     current index in string is also a valid palindrome
#  2. Even-length palindromes: These are strings which are formed
#     by including 2 chars around the current character, one on
#     the left, and one on the right. The two characters at
#     current index in string form a valid palindrome if those
#     characters match
#                   0     1    2    3    4    5    6    7
#  Consider str = ['a', 'b', 'c', 'd', 'c', 'f', 'g', 'h']
#  Suppose we start at index 3 in str:
#  1. Odd-length palindromes:
#     a. "d" is a palindrome
#     b. ['c', 'd', 'c'], move left by 1 (index - 1),
#        right by 1 (index + 1). Since these match, these also
#        form a valid palindrome.
#     c. ['b', 'c', 'd', 'c', 'f'], 'b' and 'f' do not match.
#        we stop
#  2. Even-length palindromes:
#     a. ['d', 'c'] is not a valid palindrome, hence we stop
#
# NOTE: For a given string, to calculate length, when left is
#  decreased by 1 and right is increased by 1, final positions
# when chars do not match are say - 'x', 'y'
#  In this case length of palindrome = y - x - 1
# NOTE: This is critical because char at "y" and char at "x"
# are not part of a valid palindrome
#  'y' - 'x' =
#    = Distance between x and y, includes y and excludes x
#    = 5 - 2 = 3 => 3, 4, 5
# if left has decreased by 3 and right has increased by 3 when
# we stop,
# char at left - 3, char at right + 3 are both not part of
# valid palindrome
#  'left' - 'right' = Length of palindrome which excludes
# char at "left" and INCLUDES char at "right"
# This would be incorrect, both chars at left and right should
# be excluded
# 'left' - 'right' - 1 => left + 1, left + 2, ..., right - 1
#  both left and right are excluded from the palindrome string

# Find the maximum length palindrome in a string, and its
# length
# @param [String] str
# @return [Array<String, Integer>]
#
def longest_palindrome(str:)
  # Edge case: When str is an empty string and does not have any
  # characters. A string can contain spaces, if it does not
  # contain any char, only spaces, it has no valid palindrome
  return [0, nil] if str.strip.empty?

  # This keeps track of start_index of longest palindrome
  start_idx = 0
  # This keeps track of length of longest palindrome. This
  # should always be initialized to 0, even if we guarantee
  # that execution will enter this code only when we have
  # a single character. This is because condition
  #  length > max_length will never execute if 
  #  length = max_length = 1
  # use length >= max_length if max_length = 1
  max_length = 0

  # Iterate over each character in string and try to find
  # even, odd length palindromes possible with that index
  # by expanding around that index as center
  (0...str.length).each do |index|
    # Odd length palindrome
    left, length = expand_around_center(str:, left: index, right: index)
    if length > max_length
      start_idx = left
      max_length = length
    end

    # Even length palindrome
    left, length = expand_around_center(str:, left: index, right: index + 1)
    if length > max_length
      start_idx = left
      max_length = length
    end
  end

  # Return result
  # str[start_idx, max_length]
  #    => Returns string starting from start_idx with a length of max_length
  #    => starting_index = start_idx, ending_index = start_idx + max_length - 1
  [max_length, str[start_idx, max_length]]
end

# @param [String] str
# @param [Integer] left
# @param [Integer] right
# @return [Array<Integer, Integer>]
#
def expand_around_center(str:, left:, right:)
  # If character at left or right are same but are empty spaces, they
  # should not be a part of valid palindrome,
  # str[left].strip == '' => Stripping empty space will give us ''
  # left, right upper bounds check + Char same check + Empty space check
  while left >= 0 && right < str.length && str[left] == str[right] &&
        str[left].strip != '' && str[right].strip != ''
    left -= 1
    right += 1
  end

  # For even length palindromes, if char at left != char at right, there
  # is no valid palindrome. In this case, right = left + 1
  # right - left - 1 = -1 => A palindrome which starts at right but has
  # a length of -1 => No Palindrome => nil (which is expected result)

  # Start index of palindrome = left + 1
  # Length of palindrome = right - left - 1 (logic for -1 explained above)
  [left + 1, right - left - 1]
end

# rubocop:disable Metrics/MethodLength
def test
  str_arr = [
    {
      str: '',
      length: 0,
      pal: nil
    },
    {
      str: 'babad',
      length: 3,
      pal: 'bab'
    },
    {
      str: '   e  ',
      length: 1,
      pal: 'e'
    },
    {
      str: 'cbbd',
      length: 2,
      pal: 'bb'
    }
  ]

  str_arr.each do |str_hsh|
    str = str_hsh[:str]
    len = str_hsh[:length]
    pal = str_hsh[:pal]

    max_length, longest_pal = longest_palindrome(str:)
    puts "Input :: #{str}, Expected => Length :: #{len}, Pal :: #{pal}"
    puts "Result => Length :: #{max_length}, Pal :: #{longest_pal}"
  end
end
# rubocop:enable Metrics/MethodLength
test