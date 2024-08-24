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
#  O(n) => We can use 2 rows each of size "n" to calculate LCS, where 
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