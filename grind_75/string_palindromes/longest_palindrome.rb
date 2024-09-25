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
  start_idx = -1
  # This keeps track of length of longest palindrome. This
  # should always be initialized to (<= 0)
  # This is because if we initialize it to 1, for the 1st
  # character in the string (when we start expanding around arr[0])
  #  => length > max_length will never execute since length = max_length = 1
  #  => And typically when we write algorithm to update a maximum, we always
  #     check if current value is > current maximum (not equal for update)
  #     (current_val > current_max) AND NOT (current_val >= current_max)
  # To be safe, we assign start_idx = -1, max_length = -1
  # use length >= max_length if max_length = 1
  max_length = -1

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
  while left > -1 && right < str.length && str[left] == str[right] &&
        str[left].strip != '' && str[right].strip != ''
    left -= 1
    right += 1
  end

  # While loop terminates with the following conditions:
  # 1. palindrome = str[(left + 1)..(right - 1)]
  # 2. left points to index - 1, where index represents start of palindrome
  # 3. right points to index + 1, where index represents end of palindrome
  # 4. y - x = Number of steps from "x + 1" to reach "y" including "x + 1" and "y"
  # 5. right - left = Length between "left + 1"  and "right" including "right"
  #    => "right" = end_index + 1     => end_index    = right - 1
  #    => "left"  = start_index - 1   => start_index  = left + 1
  #    => Length of Palindrome = end_index - start_index + 1 
  #    => We add 1 because start_index includes palindrome character
  #    => (end_index - start_index) excludes start_index character
  #    => (right - 1) - (left + 1) + 1 = right - 1 - left - 1 + 1
  #    => right - left - 1

  # Start index of palindrome = left + 1
  # Length of palindrome = right - left - 1 (logic for -1 explained above)
  # We return only start index, and length of palindrome because only these 2
  # values are needed to create palindrome from string. We can also return
  # end_index but it is redundant
  # str[start_index, length_of_palindrome] = Palindrome String
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
    },
    {
      str: 'defabdcbbcdbafed',
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
