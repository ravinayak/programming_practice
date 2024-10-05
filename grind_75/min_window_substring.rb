# frozen_string_literal: true

# Given two strings s and t of lengths m and n respectively,
# return the minimum window
# substring of s such that every character in t (including duplicates)
# is included in the window. If there is no such substring, return the
# empty string "".

# The testcases will be generated such that the answer is unique.

# Example 1:
# Input: s = "ADOBECODEBANC", t = "ABC"
# Output: "BANC"
# Explanation: The minimum window substring "BANC" includes 'A', 'B', and 'C' from string t.

# Example 2:
# Input: s = "a", t = "a"
# Output: "a"
# Explanation: The entire string s is the minimum window.

# Example 3:
# Input: s = "a", t = "aa"
# Output: ""
# Explanation: Both 'a's from t must be included in the window.
# Since the largest window of s only has one 'a', return empty string.

# Algorithm: To find the minimum window substring in 's' which includes all
# characters of 't', we have to use sliding window pattern where we find
# a window which includes all the characters in 't'. As a next step, we
# start shrinking the window, until substring formed by window includes all
# characters in 't'. When the substring formed by window no longer contains
# all characters in 't', we stop shrinking the window. We start increasing the
# size of current window by incrementing right
# At each step in shrinking the window, substring formed by window includes all
# characters in 't', hence, we must check if length of window for substring in
# 's' recorded so far is greater than the current window. If length of substring
# formed by characters in window is less than length of substring recorded so far
# for minimum window substring, we should update min_length, and start/end of
# substring because we have found a new minimum window substring

# Time complexity: m = s.length, n = t.length
# 1. Each character is 's' is processed at most twice (2 times)
#     a. When expanding the window, right pointer moves processing the element
#     b. When shrinking the window, left pointer moves processing the element
#     c. Any element is processed max twice
#     d. 2 * O(m) = O(m)
# 2. Build frequency map of 't' => O(n)
# 3. Total T.C = O(m + n)

# Space Complexity:
# 1. We do not consider variables and small size hashes which are constant in size
#    and independent of Input Size
# 2. Main variables which are used to store elements to process
#     a. s_frequency: Hash which maintains a count of intersecting characters with 't'
#        in 's' = Max length of hash = O(n)
#     b. t_frequency: O(n)
#     c. 2 * O(n) = O(n)

def min_window_substr(s:, t:)
  # Base Case: 's' must have a size >= t.size, 's' and 't' should not
  # be empty
  return { min_len: 0, substr: '' } if s.size < t.size || t.empty? || s.empty?

  # Hash maps which store counts of each character in 't' and characters in
  # 's' which are present in 't'
  t_frequency = Hash.new(0)
  s_frequency = Hash.new(0)

  # length of unique characters in 's' which have matched with 't' with the
  # correct number of frequency
  formed = 0
  t.chars.each { |t_char| t_frequency[t_char] += 1 }

  # Every window formed through substring in 's' is only valid if it contains
  # a. Same frequency of characters for any given character in 't'
  # b. All unique characters in 't' are also present in the 'window'
  required = t_frequency.size

  # Sliding Window pattern
  right = 0
  left = 0

  # max_count is initialized to max value, because we want to compare length
  # of substring window with this max value and update it only if it is less
  # than max_count. Since we are trying to find minimum window
  substr_hsh = { min_len_window: Float::INFINITY, start: nil, end: nil }

  # Increase right until end of 's'
  while right < s.size

    # Include character in s_freq.. hash map only if it is included in 't', this
    # saves space in hash map.
    # Without this condition, we would store every character in 's' => O(m) space
    # With this condition => O(n) space
    if t.include?(s[right])
      s_frequency[s[right]] += 1
      # If we find a character whose count of occurrences in 's' and 't' are same,
      # we have found 1 character which satisfies the condition for being a valid
      # window
      formed += 1 if t_frequency[s[right]] == s_frequency[s[right]]
    end

    # Shrink the window, it is possible that the window contains
    # a. characters in 's' which are not present in 't'
    # b. characters in 's' that have higher count of occurrences than in 't'
    # c. In both 'a' & 'b', we can remove such characters and shrink the window
    while left <= right && formed == required
      # Recorded window length is greater than current valid window of substring
      # We should use current window of substring since it has smaller length
      # and we want to find Minimum Window Substring
      if substr_hsh[:min_len_window] > right - left + 1
        substr_hsh[:min_len_window] = right - left + 1
        substr_hsh[:start] = left
        substr_hsh[:end] = right
      end

      # Decrementing count in s_freq.. only if this character is included in 't'
      # if count of this character in 's' falls less than the count in 't',
      # characters in substring formed by current window which have same count
      # as in 't' has decreased by 1
      if t.include?(s[left])
        s_frequency[s[left]] -= 1
        # s_frequency[s[left]] == t_frequency[s[left]] - 1 can also be written
        # as s_frequency[s[left]] < t_frequency[s[left]] - 1 for the current
        # loop condition but it is safer to use "=" with "-1". This ensures
        # that formed is decremented only once when it falls below the count
        # in 't' for a given character. In the loop we check if formed < required
        # b4 running next iteration. Hence, for the same character, we would NOT
        # decrement formed more than once because the loop will break when the
        # count of any character falls below the count in 't'
        # Using "=" with "-1" ensures that it will be decremented only Once when
        # it falls exactly 1 below the count in 't', even if the loop runs when
        # formed < required, the count of same character will decrease by more
        # than 1, if it occurs again in both "s" and "t"
        formed -= 1 if s_frequency[s[left]] == t_frequency[s[left]] - 1
      end
      # right remains constant and we shrink the window from left

      # Incrementing left
      left += 1
    end

    # Incrementing Right
    right += 1
  end

  return { min_len: 0, substr: '' } if substr_hsh[:start].nil?

  {
    min_len: substr_hsh[:min_len_window],
    substr: s[substr_hsh[:start]..substr_hsh[:end]]
  }
end

def input_arr
  [
    {
      s: 'ADOBECODEBANC',
      t: 'ABC',
      min_window_substr: 'BANC'
    },
    {
      s: 'a',
      t: 'a',
      min_window_substr: 'a'
    },
    {
      s: 'a',
      t: 'aa',
      min_window_substr: ''
    },
    {
      s: 'ADOBANEFCKJLMNABC',
      t: 'EFJ',
      min_window_substr: 'EFCKJ'
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    res = min_window_substr(s: input_hsh[:s], t: input_hsh[:t])
    min_len = res[:min_len]
    substr = res[:substr]
    print "\n Input - s :: #{input_hsh[:s]}, t :: #{input_hsh[:t]} \n"
    print " Result - Min Window Substring Length :: #{min_len}, Min Window Substring :: #{substr}\n"
  end
  print "\n"
end

test
