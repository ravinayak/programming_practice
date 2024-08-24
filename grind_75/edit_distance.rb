# frozen_string_literal: true

# The Edit Distance problem, also known as the Levenshtein distance, is a
# classic problem in computer science that measures the minimum number of
# operations required to convert one string into another. The allowed
# operations are:
#   1. Insertion: Add a character.
#   2. Deletion: Remove a character.
#   3. Substitution: Replace one character with another.

# Dynamic Programming Approach
#   The most common approach to solve the Edit Distance problem efficiently is
#   by using Dynamic Programming (DP). This approach involves constructing a
#   2D table (matrix) where each cell (i, j) represents the minimum edit
#   distance between the first i characters of string word1 and the first j
#   characters of string word2.

# Steps to Solve the Problem:

# 1. Create a DP Table:
#   a. Initialize a table dp of size (m+1) x (n+1) where m is the length of
#       word1 and n is the length of word2.
#   b. We initialize a table of (m+1) * (n+1) because we have to find the
#       solution for converting "m" characters of wordinto "n" characters of
#       word2. We do not initialize a table of (m) * (n) because of Step c
#   c. Table of (m) * (n) => (m-1) and (n-1) entries in DP table, since array
#       starts at 0. This will give us the solution for converting (m-1) chars
#       of word1 into (n-1) characters of word2 which is incorrect since word1
#        has "m" characters and word2 has "n" characters
# 2. Initialize the Base Cases:
#   a. dp[0][0] is 0 because the edit distance between two empty strings is 0.
#   b. dp[i][0] is i because converting a string of length i (word1) to an empty
#       string (word2) requires i deletions from word1. These "i" deletions can
#        be performed sequentially one after the other. NOTE: Only 1 operation
#        transformation is allowed at a time
#   c. dp[0][j] is j because converting an empty string (word1) to a string of
#       length j (word2) requires j insertions into word1. These "i" insertions
#        can be performed sequentially one after the other. NOTE: Only 1 operation
#        transformation is allowed at a time
# 3. Fill the DP Table:
#   a. Iterate over each character of both strings.
#   b. For each cell (i, j),
#       1. if word1[i-1] equals word2[j-1], then dp[i][j] = dp[i-1][j-1]
#          (no operation needed): This is logical because word1[i-1] represents
#          ith character in word1 and word2[j-1] represents jth character in
#          word2. Since they are same, if we consider dp[i-1][j-1], which
#          represents the minimum number of operations required for converting
#          i-1 characters of word1 into j-1 characters of word2, we would not
#          have to do anything to convert ith characer of word1 to jth character
#          of word2 (since they are same).
#          Thus
#           dp[i][j]
#             = Minimum number of operations to convert i chars of word1 to j
#               chars of word2
#             = Minimum number of operaitons to convert i-1 chars of word1 to j-1
#               chars of word2.
#               Since ith char of word1 is same as jth char of word2, we will
#               follow this simple algorithm.
#               At the end of every transformation applied to i-1 chars of word1
#               and only 1 tansformation can be applied at any step, we will
#               append ith char of word1 to the result of transformation at
#               each step.
#               At the last step when i-1 chars of word1 have been converted to
#               j-1 chars of word2, and we append ith char of word1, we will have
#               j chars of word2]
#               So, by applying transformations needed for converting i-1 chars of
#               word1 into j-1 chars of word2, we have been able to obtain j chars
#               of word2 without any extra operation (simply by appending ith char)
#               Appending ith char is not a transformation or a step, it simply means
#               we keep the ith char of word1 at its place where it was located. ith
#               char in word1 will move around to new positions (increase/decrease)
#               automatically as we insert/delete chars from word1 without any
#               additional transformation steps
#            = dp[i-1][j-1]
#       2. Otherwise, calculate the minimum of:
#           a. dp[i-1][j] + 1 (deletion):
#                dp[i-1][j]:
#                So, if we consider "i" chars of word1, and we delete ith char, we
#                would have "i-1" chars of word1. We already have dp[i-1][j], so
#                we have the solution
#                a. Start with "i" chars of word1
#                b. Delete "ith" char fo word1
#                c. Now, we have "i-1" chars of word1
#                d. dp[i-1][j] exists and is the solution for converting "i-1" to "j"
#           b. dp[i][j-1] + 1 (insertion):
#                We already have converted "i" chars of word1 to "j-1" chars of word2
#                Now, we only add 1 char - jth char of word2, i.e. word2[j-1], and we
#                have "j" chars of word2.
#                a. Start with "i" chars of word1
#                b. Convert to "j-1" chars of word2
#                c. Append word2[j-1] (jth char) to result of Step b
#                d. We have converted "i" chars of word1 to "j" chars of word2
#           c. dp[i-1][j-1] + 1 (substitution):
#                We have converted "i-1" chars of word1 to "j-1" chars of word2. If
#                we start with "i" chars of word1, and we substitute "ith" char in
#                word1 with "jth" char of word2, we have the same use case as Step 1
#                a. Start with "i" chars of word1
#                b. Substitute "ith" char of word1 with "jth" char of word2
#                c. Remaining "i-1" chars of word1 need to be converted to "j-1" chars
#                   of word2. At each step of the transformation from "i-1" chars to
#                   "j-1" chars of word2, we simply keep the "ith" char in word1. If
#                   word1 array decrements by 1, ith char of word1 will move to left,
#                   else it would move to right (if we add an element). This can be
#                   incorrectly summarized as Appending "ith" char of word1 to result
#                   of every transformation step. In reality we are not appending
#                   we are simply keeping "ith" char of word1 where it was
#                d. "i-1" chars have been converted to "j-1" chars of word2, and "ith"
#                   char of word1 is same as "jth" char of word2
#                e. We have converted "i" chars of word1 to "j" chars of word2

# Why we do not consider i+1 or j-2 in combinations?
#    DP is a bottom up approach where we fill from bottom to top. We iterate from 0 to i
#    and at each step of this iteration we iterate from 0 to j. If we are at any step
#    p,q in the 2nd loop, we have still not iterated to p+1 in 1st loop, so p+1 cannot
#    be considered.
#    Any dp with q-2 such as dp[p][q-2] would need 2 insertions to convert to dp[p][q].
#    Since we are only allowed 1 transformation step at any given time, we cannot consider
#    dp[p][q-2], for a possible solution. This implies we can only consider q-1.
#    "q-2", "q-3", "q-4" etc would give us incorrect starting point, since we would have
#    to do >1 transformation to convert from [p, q-2], [p, q-3], [p, q-4] to [p,q]
#    Same logic applies for "p-2", "p-3" etc. Consider [p-2][q], in this case we would need
#    to delete 2 chars from word1 in one step to convert "p" chars of word1 to "p-2" chars
#    before using the solution. This is not allowed, since only 1 transformation step is
#    allowed

# Result:
# The value at dp[m][n] will be the minimum edit distance between word1 and word2.

# @param [String] word1
# @param [String] word2
# @return [Integer]
#
def edit_distance(word1:, word2:)
  m = word1.length
  n = word2.length

  dp = Array.new(m + 1) { Array.new(n + 1, 0) }

  # Initialize dp table
  # "m" represents length of word1, to convert "i" chars of word1 to 0 chars of word2,
  # we would need "i" deletions from word1 sequentially
  (0..m).each do |i|
    dp[i][0] = i
  end

  # "n" represents length of word2, to convert "0" chars of word1 to "j" chars of word2,
  # we would need "j" insertions into word1 sequentially
  (0..n).each do |j|
    dp[0][j] = j
  end

  # In the above loops, d[0][0] = 0 will be set automatically
  # We have already covered the use cases where i=0 or j=0, so we start from "1" in both
  # cases
  (1..m).each do |i|
    (1..n).each do |j|
      if word1[i - 1] == word2[j - 1] # ith char of word1 is same as jth char of word2
        dp[i][j] = dp[i - 1][j - 1]
      else
        dp[i][j] =
          [
            dp[i - 1][j - 1] + 1, # Substitute ith char of word1 with jth char of word2
            dp[i][j - 1] + 1, # Insert jth char of word2 at the end result to get "j" chars of word2
            dp[i - 1][j] + 1 # Delete ith char of word1 to get "i-1" chars of word1
          ].min
      end
    end
  end

  # Return the result of m,n
  dp[m][n]
end

def test
  test_arr = [
    { word1: 'kitten', word2: 'sitting', output: 3 },
    { word1: 'flaw', word2: 'lawn', output: 2 },
    { word1: 'intention', word2: 'execution', output: 5 },
    { word1: 'horse', word2: 'ros', output: 3 }
  ]

  test_arr.each do |word_output_hsh|
    word1 = word_output_hsh[:word1]
    word2 = word_output_hsh[:word2]
    output = word_output_hsh[:output]
    res = edit_distance(word1:, word2:)
    puts "Input words :: #{word1} -- #{word2}, Output :: #{res}, Expected Output :: #{output}"
  end
end

test
