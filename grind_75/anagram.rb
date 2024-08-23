# frozen_string_literal: true

# Given two strings s and t, return true if t is an anagram of s, and false otherwise.

# An Anagram is a word or phrase formed by rearranging the letters of a different word
# or phrase, typically using all the original letters exactly once

# Solution 1: Use Hash Map, iterate over 's', and for each unique alphabet/letter
# encountered, increment existing count. If no key exists, initialize count to 1
# for this alphabet/letter as key. Iterate over 't', and for each alphabet/letter
# check if hash contains this letter/alphabet as key. If key exists, decrement count 
# by 1. If count for any key reaches "0", remove the key from Hash Map.
# If no key exists in Hash Map, return false. 
# At the end of iteration over "t", Hash Map should not contain any keys. This is 
# because if "t" is an anagram of "s", same letters/alphabets should occur in "s" 
# with same frequency. So, all keys should have their count reduced to "0", and should 
# be removed. If Hash Map contains any key, "t" is NOT an ANAGRAM of "S"

# Time Complexity: O(n) => Iterate over "s", and "t", where n is [s.length, t.length].max
# Space Complexity: O(1) => We say constant space for Space Complexity because although
# string can contain many letter/alphabets and we have to maintain count for each
# letter/alphabet in the Hash, there is only fixed number of letters/alphabets in a
# language (say 26 in English), so the Hash would only contain 26 keys. Space requirements
# is independent of Size of string inputs - [s.length, t.length]
#
# Solution 2: Use Sorting => This allows us to avoid using Hash Map and constant space
# requirements but increases Time Complexity. We sort both the strings in place (although
# input strings should not be altered ideally, we do it to avoid needing extra space for
# storage). Once strings are sorted, we iterate over both "s" and "t" using same index
# (starting from 0), if at any point in iteration, we find that "s" and "t" do not have
# same character at same index, return false

# Time Complexity: O(n log n)
#
# Checks if t is an anagram of s
# @param [String] s
# @param [String] t
# @return [Boolean]
#
def anagram(s:, t:)
  count_occurrences = {}
  s.chars.each do |s_char|
    if count_occurrences.key?(s_char)
      count_occurrences[s_char] += 1
    else
      count_occurrences[s_char] = 1
    end
  end

  t.chars.each do |t_char|
    return false unless count_occurrences.key?(t_char)

    count_occurrences[t_char] -= 1
    count_occurrences.delete(t_char) if count_occurrences[t_char].zero?
  end


  count_occurrences.keys.empty? ? true : false
end

def test
  str_arr = [{ s: 'anagram', t: 'nagaram' }, { s: 'rat', t: 'car' }]
  str_arr.each do |str_hsh|
    puts "Input Strings :: #{str_hsh.inspect}"
    puts "'s' and 't' Anagrams check :: #{anagram(s: str_hsh[:s], t: str_hsh[:t])}"
  end
end

test
# Example 1:

# Input: s = "anagram", t = "nagaram"
# Output: true
# Example 2:

# Input: s = "rat", t = "car"
# Output: false
