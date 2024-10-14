# frozen_string_literal: true

# Given two strings text1 and text2, return the length of their longest common
# subsequence. If there is no common subsequence, return 0.

# A subsequence of a string is a new string generated from the original string
# with some characters (can be none) deleted without changing the relative order
# of the remaining characters.

# For example, "ace" is a subsequence of "abcde".
# A common subsequence of two strings is a subsequence that is common to both
# strings.

# Time Complexity:
# O(m * n) => We have to iterate over all the chars of both words - word1, word2
# to find the longest common subesequence. word1.length = m, word2.length = n
#
# Space Complexity:
# O(m * n) => To reconstruct LCS, it is recommended to use 2D array with (m * n)
# Space optimized solution will be very difficult to implement reconstruction of
# LCS (longest common subsequence)

# Optimized Space Complexity:
# O(n) => We can use 2 rows each of size "n" to calculate LCS, where
# n = min(m,n)
# Optimized Space Complexity is possible because of the fact that calculation of
# LCS requires only 2 rows at any time
# At any time during iteration, when we are at "i", "j"
#   a. if word1[i-1] == word2[j-1], ith char of word1 = jth char of word2, the
#       previous LCS of (i-1, j-1) can be incremented by 1. This is because ith
#       char of word1 is same as jth char of word2, and hence can be included to
#       form the new longer subsequence
#    b. if word1[i-1] != word2[j-1], we consider 2 possible use cases:
#          1. Exclude ith char of word1, Include jth chars of word2 => lcs(i-1,j)
#          2. Include ith char of word1, Exclude jth char of word2 => lcs(i, j-1)
#              => lcs(i,j) = max[lcs(i-1, j), lcs(i,j-1)]
#              => Hence we need one row to hold lcs values for (i-1)th row, and one
#                 row to hold lcs values for (ith) row
#  This is possible because of the below reasons:
#    a. We can exclude characters from word1, word2 to find the lcs as long as we
#       maintain the order of characters
#    b. If we consider ith char of word1, jth char of word2, we shall not be able
#       calculate lcs(i,j) since both ith char of word1 and jth char of word2
#       are not same, and hence cannot be a part of the lcs at the same time. At
#       this time, we have to choose which letter to exclude and from which string
#       There are 2 options available to us at this time:
#         1. Exclude from word1 => ith char from word1 => lcs(i-1,j)
#         2. Exclude from word2 => jth char from word2 => lcs(i,j-1)
#    c. We can only exclude 1 character at a time from a string when trying to find
#       LCS, and we can only select 1 string at a time. So, we only have the 2
#       options available to us
#    d. We cannot choose lcs(i-2,j), or lcs(i,j-2) because this would mean we have
#       to exclude 2 characters at one time from one of the strings
#    e. We cannot choose lcs(i-1,j-1) either when
#         ith char of word1 != jth char of word2
#       This would mean excluding 2 strings => 1 from each word, NOT ALLOWED

# @param [String] word1
# @param [String] word2
# @return [Integer]
#
def lcs_space_optimized(word1:, word2:)
  m = word1.length
  n = word2.length

  prev_row = Array.new(n + 1)
  curr_row = Array.new(n + 1)

  # prev_row => i-1
  # curr_row => i
  # For any iteration of i,j over words to find LCS,
  #  prev_row[j] => Length of LCS for (i-1,j) i-1 chars of word1, j chars of word2
  #  curr_row[j-1] => Length of LCS for (i, j-1) i chars of word1, j-1 chars of word2
  # We need these prev_row and one value in curr_row to calculate LCS

  # To find LCS in space-optimized way, we would need to initialize prev_row
  # when i=0, there cannot be any LCS for word1, word2 => Since word1 has i=0
  #    => 0 chars of word1 => No subsequence possible
  #    => prev_row[j] => 0 (for any j, when i = 0)

  # when j=0, there cannot be any LCS for word1, word2 => Since word2 has j=0
  #    => 0 chars of word2 => No subsequence possible
  #    => curr_row[0] => 0 (for any i, when j = 0)

  (0..n).each do |j|
    prev_row[j] = 0
  end

  (1..m).each do |i|
    # We need this in LCS calculation
    curr_row[0] = 0
    (1..n).each do |j|
      if word1[i - 1] == word2[j - 1]
        curr_row[j] = prev_row[j - 1] + 1 # prev_row[j-1] => (i-1, j-1)
      else
        # prev_row[j] 	=> (i-1, j)
        # curr_row[j-1] => (i, j-1)
        curr_row[j] = [prev_row[j], curr_row[j - 1]].max
      end
    end
    # Duplicate the curr_row array to populate values in prev_row
    # prev_row = curr_row => INCORRECT => Reference Assignment which will
    # cause prev_row to change whenever curr_row is changed
    prev_row = curr_row.dup
  end

  curr_row[n]
end

# @param [String] word1
# @param [String] word2
# @return [Integer]
#
def lcs(word1:, word2:)
  m = word1.length
  n = word2.length

  # Here we do not have to separately initialize this 2D array to contain
  # 0 values when m=0 for all n columns or when n=0 for all m rows
  # The Array creation method here takes care of this for us, as we initialize
  # the array to contain 0 as default value for all indices
  lcs = Array.new(m + 1) { Array.new(n + 1, 0) }

  (1..m).each do |i|
    (1..n).each do |j|
      if word1[i - 1] == word2[j - 1]
        lcs[i][j] = lcs[i - 1][j - 1] + 1
      else
        lcs[i][j] = [lcs[i][j - 1], lcs[i - 1][j]].max
      end
    end
  end

  # To construct the actual longest common subsequence of word1 and word2, we
  # backtrack from (m+1)(n+1)
  # Logic is to follow the same algorithm we used when constructing LCS. Since
  # lcs is a subsequence of two strings word1, word2 => A character will be
  # included in lcs only when it is present in both word1 and word2
  #    => word1[i] == word2[j] for any (i,j) => Only then we can include the
  #       character in lcs
  #    => In this use case, we move diagonally because in formula we selected
  #       lcs[i-1][j-1] => "i" to "i-1", "j" to "j-1"
  # if word1[i] != word2[j]
  #    => According to the formula we used above, we have two directions:
  #         a. going up in the row to previous row, i.e. from "i" to "i-1"
  #         b. going left in the col to previous col, i.e. from "j" to "j-1"
  #    => We can only change direction in one axis at one time
  #    => In the formula above, we have choosen the maximum of possible values
  #       which means, we should move in the direction
  #         a. lcs[i][j-1] > lcs[i-1][j] => lcs[i][j-1] was choosen
  #             => We move left of col "j" => i.e. from "j" to "j-1"
  #         b. lcs[i][j-1] < lcs[i-1][j] => lcs[i-1][j] was choosen
  #             => We move up above row "i" => i.e. from "i" to "i-1"
  #    => We move in the direction of larger value

  subsequence = []

  i = m
  j = n

  # Here we initialize i = m, j = n because we look into the word1
  # and word2 at i-1, j-1. Since word1 has a length of m, it has
  # m-1 chars, word2 has a length of n, it has n-1 chars. We use
  # word1[i-1] and word2[j-1] for comparison of equality
  # Condition: i > 0 && j > 0 ensures that i - 1 is never less than
  # 0. i > 0 => i >= 1 => i - 1 >= 0, Same for j
  # This is critical because word1 ranges from 0 .. m-1
  # i,j cannot run in an iteration loop because their values are NOT
  # statically changing, they change depending upon lcs calculation,
  # i may remain "x", while j may continue to decrement which is not
  # possible in a for loop iteration
  while i.positive? && j.positive?
    if word1[i - 1] == word2[j - 1]
      subsequence << word1[i - 1]
      # Move Diagonally
      i -= 1
      j -= 1
    elsif lcs[i][j - 1] < lcs[i - 1][j]
      # Move to previous row => i-1
      i -= 1
    else
      # Here we must not use elsif lcs[i][j - 1] > lcs[i - 1][j]
      # It is possible that lcs[i][j-1] = lcs[i-1][j], and in this
      # use case, it will go into an infinite loop since i,j will
      # continue to retain their values
      # lcs[i][j - 1] >= lcs[i - 1][j] can be used, but best to
      # use else, since no other use case is possible other than
      # the above 3. If they are equal, we can move in any direction
      # i,j => here we choose to move in col direction
      # Move to left col => j-1
      j -= 1
    end
  end

  [lcs[m][n], subsequence.join('').reverse]
end

def test
  subsequence_arr = [
    { word1: 'abcde', word2: 'ace', lcs: 3, sub_lcs: 'ace' },
    { word1: 'abc', word2: 'abc', lcs: 3, sub_lcs: 'abc' },
    { word1: 'abc', word2: 'def', lcs: 0, sub_lcs: '' }
  ]
  subsequence_arr.each do |word_lcs_hsh|
    word1 = word_lcs_hsh[:word1]
    word2 = word_lcs_hsh[:word2]
    lcs = word_lcs_hsh[:lcs]
    sub_lcs = word_lcs_hsh[:sub_lcs]

    puts "Word Inputs :: #{word1} -- #{word2}"
    puts "Expected Output :: #{lcs} -- #{sub_lcs}"
    print "Result of method call :: #{lcs(word1:, word2:)} \n"
    puts "Result of Space Optimized :: #{lcs_space_optimized(word1:, word2:)}"
  end
end

test
