# frozen_string_literal: true

# Given two strings ransomNote and magazine, return true if ransomNote can be
# constructed by using the letters from magazine and false otherwise

# Each letter in magazine can only be used once in ransomNote.

# This problem can also be solved using sorting, we sort both the strings, but
# this will destroy input strings. Once sorted, use 2 pointers each at start
# index of both strings.
# Time Complexity: O(n * log n)
# Space Complexity: O(1)

#  index1 = index2 = 0
#  while index1 < str1.length && index2 < str2.length
#  a. If char at index1 in str1 and char at index2 in str2 are same,
#      index1 += 1, index2 += 1
#  b. If char at index1 in str1 is not same as char at index2 in str2
#    1. Use Case 1. char1 > char2 => index2 += 1. Move index2 pointer ahead. Since
#       strings are sorted, keep moving index2 unless we find char2 or a char
#       greater than char1
#    2. Use Case 2. char1 < char2 => return false. At this point, all othe chars
#       in str2 are greater than char1, and hence char1 cannot be found
#       Idea here is to keep scanning string2 until we get the char in str1 at index1
# When we exit the loop
# if index1 == str1.length => We have found all chars of str1 in str2, and hence
# we can construct str2 from str1

# Time Complexity: O(n) => n = [str1.length, str2.length].max => We have to iterate
# over both strings - str1, str2
# Space Complexity: O(n) => Hash to store all chars of str2 and their frequency of
# occurrence

# @param [String] ransom_note
# @param [String] magazine
# @return [Boolean]
#
def ransom_note_using_hsh(ransom_note:, magazine:)
  count_occurrences = {}

  # Iterate over all characters of magazine and store
  # their frequency of occurrence in a hash
  magazine.chars.each do |mag_char|
    if count_occurrences.key?(mag_char)
      count = count_occurrences[mag_char]
      count += 1
    else
      count = 1
    end
    count_occurrences[mag_char] = count
  end

  # For each character in the string to build, we check
  # if the hash contains that character. If not present
  # in hash, we cannot construct this string using the
  # other string, return false
  # If present, we retrieve the count from hash, decrease
  # by 1, and put it back in hash. We decrement because
  # we have used this character once, and we are allowed
  # to use any character in magazine only once
  # If count of any char in hash reaches 0, we remove it
  # This is because the character has been used as many
  # times as it was present (frequency) in other string
  # and cannot be used anymore
  ransom_note.chars.each do |ransom_char|
    return false unless count_occurrences.key?(ransom_char)

    count = count_occurrences[ransom_char]
    count -= 1
    count_occurrences[ransom_char] = count
    count_occurrences.delete(ransom_char) if count.zero?
  end

  true
end

def test
  str_arr = [
    { ransom_note: 'a', magazine: 'b', output: false },
    { ransom_note: 'aa', magazine: 'ab', output: false },
    { ransom_note: 'aa', magazine: 'aab', output: true }
  ]

  str_arr.each do |str_hsh|
    ransom_note = str_hsh[:ransom_note]
    magazine = str_hsh[:magazine]
    output = str_hsh[:output]
    puts "Input Strings :: '#{ransom_note}' -- '#{magazine}'"
    res = ransom_note_using_hsh(ransom_note:, magazine:)
    puts "Expected Output :: #{output}, Actual Result :: #{res}"
  end
end

test

# Example 1:
# Input: ransomNote = "a", magazine = "b"
# Output: false

# Example 2:
# Input: ransomNote = "aa", magazine = "ab"
# Output: false

# Example 3:
# Input: ransomNote = "aa", magazine = "aab"
# Output: true
