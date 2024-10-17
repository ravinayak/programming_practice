# frozen_string_literal: true

# Generally when we have to find contiguous set of elements say characters
# in a string, or fruits in a tree etc, sliding window pattern can be applied
#
# Algorithm: Longest substring is found using Sliding Window Technique by
# initializing two pointers - left, right to an initial value of 0
# Window of substring is maintained by using left/right pointers, such that
# left pointer points to start of substring, and right pointer points to end
# of substring
# We use a Hash to maintain last seen position of every character in string
# If this character is found again while right is moving forward in the
# iteration. Here we have 2 possibilities:

# 1. Current window/substring includes this repeating character: We know that
#   current substring cannot be extended to include this character since it is
#   repeating itself and was found earlier in the substring.
#     => Condition => left <= last seen position of the repeating character
#   In this case we must reset the window/substring to exclude this character
#   and start from an index greater than the last seen occurrence of this
#   character. This is because a substring is formed by contiguous set of
#   characters, and we have only 2 options:
#     a. To exclude last seen occurrence of repeating character by increasing
#        left to (last seen position of the repeating character + 1)
#     b. Jump the current substring by excluding the repeating character BUT
#        THIS will Lead to a NON-CONTIGUOUS set of characters and hence MUST
#        NOT BE USED
#       => left = last seen position of the repeating character + 1
#   New window/substring is formed and it starts at a new left

# 2. Current window/substring DOES NOT include this repeating character: In
#    this use case, we can include this character since no repetition occurs
#     => Condition => left > last seen position of the repeating character
#     => No Update/Resetting of window/substring is required
#

# Hence 1 of 2 actions must be taken:
# 1. Character found earlier must be excluded from the current substring and
#    new substring should start from the last seen position of this character
#    + 1. We have already found a substring with that character in it, we try
#    to find a new substring with that character by resetting left pointer to
#    a character (distinct from this character), just ahead of the last seen
#    position of that repeating character => element_index_hsh[key] + 1
#     => New substring/window will exclude the repeating character by resetting
#        window to another character ahead of the last occurrence of character
#        and start forming substrings again
# 2. At each iteration, we keep calculating the length of substring found so
#    far, and if it exceeds the maximum substring length so found so far, we
#    update maximum length, left and right pointers to point to the maximum
#    substring/window.

# Illustration => aaabcdefcaaaghijckma
# 1. left = right = 0 => window = "a"
# 2. Found "a" again, left <= element_index_hsh[key] => Reset window => left = 1
#     => New window = "a", left = 1, right = 1
# 3. Found "a" again, left <= element_index_hsh[key] => Reset window => left = 2
#     => New window = "a", left = 2, right = 2
# 4. Continue until "c" is found again
#     => Current window = "abcdef", left = 2, right = 8
#     => left <= element_index_hsh[key] => Reset window => left = 5
#     => New window = "defc", left = 5, right = 9
# 5. "a" is found again, but this time, we are good because last seen occurrence
#    of "a" was at index 2, while current window starts at (left) 5, which means
#    "a" is not included in the current window/substring. So, we can include "a"
#    in the current window/substring, we do not have to reset window/substring
#     => Current window => "defc", left = 5, right = 9
#     => left > element_index_hsh[key] = 2
# 6. Continue till we reach end of string
# 7. At each iteration, when we increase right, we check that the max length
#    recorded so far for substring is less than the current window (substring)
#    length. If it is less, we update the max length of substring and also update
#    left/right pointers that contain substring location

# Finds the longest substring in a given string with no repeated characters
# @param [String] input_str
# @return [Hash] ouput_hsh
#
def find_longest_subst_no_repeated_chars(input_str)
  substr_pointers = { left: 0, right: 0 }
  element_index_hsh = {}
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

  print 'Maximum Substring with no repeated characters :: '
  puts(input_str[max_substr_index_len[:left]..max_substr_index_len[:right]])
  puts "Maximum Substring length :: #{max_substr_index_len[:right] - max_substr_index_len[:left] + 1}"
end

# Assign the left and right pointers for maximum substring
# @param [Hash] substr_pointers
# @param [Hash] max_substr_index_len
# @return NIL
#
def assign_max_substr_index(substr_pointers, max_substr_index_len)
  return unless substr_len_greater?(substr_pointers, max_substr_index_len)

  max_substr_index_len[:max_length] = calc_substr_len(substr_pointers)
  max_substr_index_len[:left] = substr_pointers[:left]
  max_substr_index_len[:right] = substr_pointers[:right]
end

# Returns if the current substring length is greater than max_length
# @param [Hash] substr_pointers
# @param [Hash] max_substr_index_len
# @return NIL
#
def substr_len_greater?(substr_pointers, max_substr_index_len)
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

arr = %w[aaabcdefaaaghijklma abcdef aabbccddef aaabcaade]

# Iterate over elements of array and call the function
#
arr.each do |input_str|
  puts "Input String :: #{input_str}"
  find_longest_subst_no_repeated_chars(input_str)
  puts
end
