# frozen_string_literal: true

# Given two strings s and p, return an array of all the start indices of p's
# anagrams in s. You may return the answer in any order.

# Example 1:

# Input: s = "cbaebabacd", p = "abc"
# Output: [0,6]
# Explanation:
# The substring with start index = 0 is "cba", which is an anagram of "abc".
# The substring with start index = 6 is "bac", which is an anagram of "abc".

# Example 2:
# Input: s = "abab", p = "ab"
# Output: [0,1,2]
# Explanation:
# The substring with start index = 0 is "ab", which is an anagram of "ab".
# The substring with start index = 1 is "ba", which is an anagram of "ab".
# The substring with start index = 2 is "ab", which is an anagram of "ab".

# Algorithm: str_1 is an Anagram of str_2 if all the characters of
# str_1 are present in str_2, order of these characters does not
# matter. Generally str_1 will be smaller (or equal) in size to str_2
# Step 1: Find frequency of chars appearing in str_1
# Step 2: Use Sliding Window Technique, where we slide a window of size "p"
# over string "str_2", As we do this, we check if the frequency of chars in
# str_2 is same as str_1. If the frequence is same, this substring in str_2
# is an Anagram of str_1
# Step 3: Because we are having strings which can only have lowercase letters,
# we can use Arrays of size 26, to represent each character, and store
# count/frequency of each character appearing in str_1, str_2. This is faster
# than hash. In general if range of keys is constant, array is a better
# choice than hash.
# Step 4: As we slide window over str_2, we just have to decrement frequency
# of last character which is being slided over, and increase the frequency
# of new char in str_2 window
# Step 5: The above steps require that we construct an initial window in str_2
# of same size as str_1 to implement the algorithm. Without this initial window
# we would not be able to slide over str_2 looking for same size as "p".
# NOTE: An Anagram of str_1 in str_2 is a substring which contains all the chars
# that are present in str_1 in any order, BUT THIS SUBSTRING is a set of
# consecutive characters, we cannot combine chars in any arbitrary index positions
# to construct anagram, they must be consecutive. HENCE, we NEED WINDOW SLIDING
# Step 6: At the end, we have to perform check for last window

# Time Complexity: O(n) => We iterate over str_2 only 1nce using window sliding
# Space Complexity: O(1) => 2 arrays of constant size to maintain Frequency/Count

# @param [String] p
# @param [String] s
# @return [Array<Integer>] result
def start_indices_of_anagrams(p:, s:)
  # Initialize an array of size 26, each element for a character and assign it
  # a value of 0
  p_count = Array.new(26, 0)
  s_count = Array.new(26, 0)
  result = []

  # We construct 2 arrays which maintain frequency of chars appearing in "p" and
  # the 1st window of "s"
  (0...p.length).each do |index|
    # p[index] is a letter 'a' - 'z', to map it to an index in array of 26 chars
    # we can do p[index].ord - 'a.ord' => a.ord is a number, b.ord = a.ord + 1
    # z = a.ord + 26; 'a' will map to index 0, 'b' will map to index 1 etc
    p_letter_index = p[index].ord - 'a'.ord
    s_letter_index = s[index].ord - 'a'.ord

    p_count[p_letter_index] += 1
    s_count[s_letter_index] += 1
  end

  (p.length...s.length).each do |index|
    # If frequency of chars in p is same as frequency of chars in s, which means
    # that 2 arrays are same, then this window of "s" is an anagram of 'p'
    # We start from the next char after 1st window, which means
    # 2nd Window Start => Check 1st window is an anagram of 'p'
    # => Last Window will not be checked because when index = s.length - 1,
    # 	 the s_count array is updated with count of last element but this
    # 	 window never gets checked because we have reached the end of iteration
    if p_count == s_count
      # Start of anagram in "s" is the 1st char in window
      result << index - p.length
    end

    # Update count of char being slided over, and char being included in new window
    s_count[s[index - p.length].ord - 'a'.ord] -= 1
    s_count[s[index].ord - 'a'.ord] += 1
  end

  # Check for the last window
  result << (s.length - 1) - (p.length - 1) if p_count == s_count

  found = result.empty? ? false : true
  [found, result]
end

def input_arr
  [
    {
      s: 'cbaebabacd',
      p: 'abc',
      output: [0, 6]
    },
    {
      s: 'abab',
      p: 'ab',
      output: [0, 1, 2]
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    found, result = start_indices_of_anagrams(p: input_hsh[:p], s: input_hsh[:s])

    print "\n p :: #{input_hsh[:p]}, s :: #{input_hsh[:s]}"
    print "\n Output :: #{input_hsh[:output].inspect}"
    print "\n Result :: #{result.inspect}"
    print "\n found :: #{found} \n"
  end
end

test
