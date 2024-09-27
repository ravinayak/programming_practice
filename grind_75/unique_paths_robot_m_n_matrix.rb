# There is a robot on an m x n grid. The robot is initially located 
# at thetop-left corner (i.e., grid[0][0]). The robot tries to move
# to the bottom-rightcorner (i.e., grid[m - 1][n - 1]). The robot can
# only move either down or right at any point in time.

# Given the two integers m and n, return the number of possible unique
# paths that the robot can take to reach the bottom-right corner.

# The test cases are generated so that the answer will be less than or
# equal to 2 * 109.

# Example 1:
# Input: m = 3, n = 7
# Output: 28

# Example 2:
# Input: m = 3, n = 2
# Output: 3
# Explanation: From the top-left corner, there are a total of 3 ways to
# reach the bottom-right corner:
# 1. Right -> Down -> Down
# 2. Down -> Down -> Right
# 3. Down -> Right -> Down

# Algorithm: Total Number of Paths a robot can take can be calculated in
# 2 ways
# a. Binomial Coefficient: If we only want to calculate the total number
# of unique paths that a robot can take, it is easy to calculate based on
# combinatorics.
# Since robot can only move down a cell, or right along the column, at each
# step user has two choices - 
#  1. User can move down
#  2. User can move right along the column
# If user takes only down moves - "m - 1"
# If user reaches the bottom, and wants to go to the right bottom - "n - 1"
# Total number of moves = m - 1 + n - 1 = m + n -2
# Out of these total number of moves, user has to select "m - 1" moves, which
# is equivalent to 'n - 1' right moves.
# At each step starting from the start position (0, 0), robot has to select
# whether to go down, or to go right along the column. Each step user can
# select and make a choice for going down, the total steps are "m + n - 2",
# out of these choices, user has to select "m - 1" down moves. This can be
# solved using combinatorics = C(m + n - 2, m - 1) 
#  = ( Factorial (m + n - 2) / Factorial (m - 1) ) / ( (m + n - 2) - (m - 1))
#  = ( Factorial (m + n - 2) / Factorial (m - 1) ) / n - 1
# b. Dynamic Programming: If we wan to calculate the total number of paths,
# and also the actual paths which the robot can take, we must use DP

# DP Algorithm:
# 1. For any given cell (i, j), there are 2 choices:
#    a. i > 0 => Row is > 0 => Robot can come from cell (i - 1, j) above current
#        cell
#    b. j > 0 => Column is > 0 => Robot can come from cell (i, j - 1) left of
#        current cell
# 2. Based on the Step 1, we can compute dp[i][j] for each cell position, with
# the following initializations
#  a. dp[0][0] = [] => Empty array because there are no paths to reach this cell
#     since robot starts from here
#  b. dp[i][j] = Array of vertices traversed to reach [i][j]
#     = [[0, 0], [1, 0], [1, 1], ....] => Every vertex traversed to reach this
#     cell is included in this array
#  c. dp[i][j] 
#     => dp[i][j] = dp[i][j] + dp[i-1][j].map { |path| path << [i, j]}
#     => This is done to ensure that every path in dp[i-1][j] now contains the
#        new cell (i, j) since robot has traversed and reached this new cell.
#     => dp[i-1][j] contains the pair of vertices traversed to reach (i-1, j),
#        we add (i, j) to each such list
#     => We add it to the existing array of paths for dp[i][j]
#     => Array 1 + Array 2 = Array 3 (= contains elements from both arrays)
