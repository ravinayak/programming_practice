# frozen_string_literal: true

# Given a string s and a dictionary of strings wordDict, return true if
# s can be segmented into a space-separated sequence of one or more
# dictionary words.

# Note that the same word in the dictionary may be reused multiple times
# in the segmentation.

# Example 1:
# Input: s = "leetcode", wordDict = ["leet","code"]
# Output: true
# Explanation: Return true because "leetcode" can be segmented as "leet code".

# Example 2:
# Input: s = "applepenapple", wordDict = ["apple","pen"]
# Output: true
# Explanation: Return true because "applepenapple" can be segmented as "apple pen apple".
# Note that you are allowed to reuse a dictionary word.

# Example 3:
# Input: s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
# Output: false

# Algorithm: In order to find if a word can be broken into space separated words, each
# of which are contained in a word Dictionary, we use DP strategy

# Step 1:  Initialize a DP array dp of size len(s) + 1 where all values are False, except dp[0],
# which is True. This is because an empty string can always be segmented.

# Step 2:  For each position i in the string s, check all possible substrings s[j:i] where
# 0 ≤ j < i. If dp[j] is True and s[j:i] is in wordDict, set dp[i] to True.
#  => dp[i] = true if the substring s[0:i] can be segmented into words in wordDict, and
#     False otherwise
#  => dp[i]
#    = substring formed by including characters "0" through "i-1" of string
#    = s[0:i] => s[0...i] => s[0] + s[1] + s[2] + .... + s[i-1]
#    = s[0] is included, s[i] is excluded
#    = All characters of string before "i" are included

# Step 3:  After processing the entire string, return dp[len(s)], which tells us whether the
# entire string s can be segmented.

# Step 4: dp[str.length] = true => word can be split into words which are in wordDict

def word_break(word:, word_dict:)
  return [] if word.strip.empty? || word_dict.empty?

  # Create a DP array of size len(s) + 1
  dp = Array.new(word.length + 1, false)
  # String formed by including 0 characters is an empty string and included in wordDict
  # Base Case of DP
  dp[0] = true

  # dp[1] = Substring formed by including 1st 1 characters of string,
  #       = if we start from "0", we will include 0 characters of string = empty substring
  # dp[word.length] = Substring formed by including "s.length" characters of string
  #       = 0...s.length = (0..s.length - 1) = s.length characters of string = Entire string
  # 1..word_length and NOT 1...word_length
  (1..word.length).each do |i|
    # dp[i] = dp[j] + substr[j, i-1] => we start from "0" because we want to include
    # all use cases for string where 0 <= j < i
    #    => for i = 4, for ex: (substring formed by including 1st 4 characters of string can be segmented)
    #    => j = 0 => dp[0] = substr formed by 1st 0 characters of string: substr[], substr[0..3] in wordDict
    #    => j = 1 => dp[1] = substr formed by 1st 1 characters of string: substr[0..0], substr[1..3] in wordDict
    #    => j = 2 => dp[2] = substr formed by 1st 2 characters of string: substr[0..1], substr[2..3] in wordDict
    #    => j = 3 => dp[3] = substr formed by 1st 3 characters of string: substr[0..2], substr[3..3] in wordDict
    # More Explanation: Consider string = 'catsand' and i = 4 => substring formed by including 1st 3 characters of string
    #    => j = 0 => dp[0], substr[0..3] => [], [cats]
    #    => j = 1 => dp[1], substr[1..3] => [c], [ats]
    #    => j = 2 => dp[2], substr[2..3] => [ca], [ts]
    #    => j = 3 => dp[3], substr[3..3] => [cat], [s]
    #    => "", "cats"; "c", "ats"; "ca", "ts"; "cat", "s" are all possible segments for "cats"
    # If we allow j to go till "i", we will have 'cats', "" which is a duplicate of 1st use case
    # and also cause 2 major issues:
    #  Issue 1: Out of bounds: substr[4, 3] => This could be invalid in many programming languages
    #  Issue 2: We would end up checking if an empty string is in wordDict => which could give us faulty results
    #
    # WE start from 0, so all "i-1" combinations of susbstring can be tested in wordDict
    #  We end at "i-1" for "j",
    (0...i).each do |j|
      if dp[j] && word_dict.include?(word[j...i])
        dp[i] = true
        break # we found a valid segmentation, and hence can break here
      end
    end
  end

  # The final value in dp tells if the whole string can be segmented
  dp[word.length]
end

def word_break_with_combs(word:, word_dict:)
  return [] if word.strip.empty? || word_dict.empty?

  dp = Array.new(word.length + 1) { [] } # new arrays for each array element
  # all array elements are initialized to an empty array because we don't
  # know which segments they contain
  # When we include 0 characters from string, it will be an empty string
  dp[0] = ['']

  # Iterate over all characters of word
  # we must include word.length in the range of iteration
  # 1..word.length, AND NOT 1...word.length
  # dp[word.length] => segments formed by including word.length chars of string
  #  = 0..word.length - 1 = word.length chars
  # j goes till i-1 => substring for word_dict check includes chars from "j" to "i-1"
  # chars of word, we never include "i" which could be an issue when we reached word.length
  # This is because word only contains characters from "0" to "i - 1", word[i] is out of bounds
  # word[j...i] => word[j] + word[j+1] + .... + word[i-1] => word[i] is excluded
  (1..word.length).each do |i|
    # Check for dp problem by iterating over 0...i for "j", we include "i-1"
    # characters of string
    (0...i).each do |j|
      # dp[j].empty? allows us to check for single letter from word being included
      # in word_dict because dp[0] is [""] and dp[0].empty? returns false
      # word[0...1] => word[0] => if it is included in word_dict, it will be included
      # in dp[1]
      # if dp[j] is empty => we could not form any valid segments from 1st j characters of
      # string such that the segments are included in word dictionary
      # if !word_dict.include?(word[j...i]) => word_dict does not include segment formed by
      # including characters from "j" through "i" (excluding i) of string, even if dp[j]
      # contains segments which are included in word dictionary, the remaining segment formed
      # by including chars "j"..."i" of string s are not included in word dictionary
      # Hence we cannot form any valid segment for dp[i] through "j", so we skip this iteration
      next if dp[j].empty? || !word_dict.include?(word[j...i])

      dp[j].each do |segment|
        # when dp[j] contains "" as segment, it will return segment.empty? as true
        # and hence word[0...i] will be included in dp[i] array without "" as part
        # of segment
        if segment.empty?
          dp[i] << word[j...i]
        else
          # For every dp[i], we record also possible combination of segments that can
          # be formed by including 1st "i - 1" characters of string
          # Ex: s = "catsanddog", word_dict = ["cat", "cats", "and", "sand", "dog"]
          # dp[3] = "cat"
          # dp[4] = 'cats'
          # dp[7] => j = 3  => cat, sand => dp[7] << 'cat sand'
          # dp[7] => j = 4  => cats, and => dp[7] << 'cats and'
          # At dp[7], two segment combinations are possible with the 1st 7 characters,
          # we record each one by pushing them into the array
          # As we iterate over more characters of string, and we find more segments,
          # we include all those in the array for that dp element
          # In the end, all possible segments are recorded in dp[s.length]
          # dp[10] => j = 7 => dp[10] << 'cat sand dog'
          # dp[10] => j = 7 => dp[10] << 'cats and dog'
          dp[i] << "#{segment} #{word[j...i]}"
        end
      end
    end
  end

  dp[word.length]
end

def word_dict_arr
  [
    {
      word: 'leetcode',
      word_dict: %w[leet code],
      output: true,
      combs: ['leet code']
    },
    {
      word: 'applepenapple',
      word_dict: %w[apple pen],
      output: true,
      combs: ['apple pen apple']
    },
    {
      word: 'catsanddog',
      word_dict: %w[cats dog sand and cat],
      output: true,
      combs: ['cats and dog', 'cat sand dog']
    },
    {
      word: 'catsanddog',
      word_dict: %w[dog sand cats],
      output: false,
      combs: false
    }
  ]
end

def test
  word_dict_arr.each do |word_dict_hsh|
    word = word_dict_hsh[:word]
    word_dict = word_dict_hsh[:word_dict]
    output = word_dict_hsh[:output]
    combs = word_dict_hsh[:combs]

    res = word_break(word:, word_dict:)
    combs_res = word_break_with_combs(word:, word_dict:)

    print "\n word :: #{word}, word_dict :: #{word_dict.inspect}"
    print ", output :: #{output}, combs :: #{combs.inspect} \n"
    print " Result :: #{res}, Res Combs :: #{combs_res.inspect} \n"
  end
end

test
