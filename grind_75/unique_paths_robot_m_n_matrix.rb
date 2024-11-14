# frozen_string_literal: true

# There is a robot on an m x n grid. The robot is initially located
# at the top-left corner (i.e., grid[0][0]). The robot tries to move
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
# Total number of moves = m - 1 + n - 1 = m + n - 2
# Out of these total number of moves, user has to select "m - 1" moves, which
# is equivalent to 'n - 1' right moves.
# At each step starting from the start position (0, 0), robot has to select
# whether to go down, or to go right along the column. Each step user can
# select and make a choice for going down, the total steps are "m + n - 2",
# out of these choices, user has to select "m - 1" down moves. This can be
# solved using combinatorics = C(m + n - 2, m - 1)
#  = ( Factorial (m + n - 2) / ( Factorial (m - 1) ) * Factorial ((m + n - 2) - (m - 1))))
#  = ( Factorial (m + n - 2) / ( Factorial (m - 1) ) / Factorial (n - 1) )
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

# @param [Integer] n
# @return [Integer]
def factorial(n:)
  product = 1
  n.downto(1) do |x|
    product *= x
  end

  product
end

# @param [Integer] m
# @param [Integer] n
# @return [Integer]
def total_paths_combinatorics(m:, n:)
  total_set_of_moves = m + n - 2
  fact_total_set = factorial(n: total_set_of_moves)
  fact_down_moves = factorial(n: m - 1)
  fact_diff = factorial(n: n - 1)

  (fact_total_set / (fact_down_moves * fact_diff))
end

# @param [Integer] m
# @param [Integer] n
# @return [Integer]
def total_paths(m:, n:)
  total_combinatorics = total_paths_combinatorics(m:, n:)
  paths = total_paths_dp(m:, n:)

  [total_combinatorics, paths]
end

# @param [Integer] m
# @param [Integer] n
# @return [Array<Array<Integer, Integer>>]
def total_paths_dp(m:, n:)
  # At any time, we only need 2 rows with n-1 columns to calculate
  # DP array, hence we initialize DP array with only 2 rows
  # Each DP array for a column is initialized with an empty array
  dp = Array.new(m) { Array.new(n) { [] } }

  # Base Case:
  # Case 1: When robot is at 1st row, robot can only come from left
  # Case 2: When robot is at 1st col, robot can only come from above row
  # column. dp[0][0] = [[0, 0]] because this is the starting point

  # Remember that every dp array element is an array of arrays where
  # inner array is an array of pair of vertices, where each array of
  # pair of vertices represents a single path of all the vertices
  # that have been traversed to reach the given vertex (i, j)
  # dp array element = Array of paths
  # Each path = Array of Array of Vertices Pairs
  # [path1, path2, path3]
  # path1 = [vertex_pairs_arr]
  # vertex_pairs = [v1, v2]
  # Each path = [ [ [v1, v2], [v2, v3], [v4, v5] ], [ [v1, v3], [v3, v4], [v4, v5] ] ]
  # path 1 = [ [v1, v2], [v2, v3], [v4, v5] ]
  # path 2 = [ [v1, v3], [v3, v4], [v4, v5] ]
  # path 1 represents the vertices which must be traversed to reach the destination
  # Vertex Pair = An array of vertices = [v1, v2]
  # Paths = Array of vertex pairs = [ [v1, v2], [v3, v4] ]
  # All Paths = [ Paths ] = [ [ [v1, v2], [v3, v4] ], [ [ v2, v3], [v4, v5] ] ]
  # 3D array structure
  # [v1, v2], then [v2, v3], then [v4, v5] => this is wrapped in an array since it is a single Path
  # There can be many such paths, hence all those paths are wrapped in an outer array
  # 
  # Path is an ARRAY of ARRAY of ARRAY of vertex pairs
  dp[0][0] = [[[0, 0]]]

  # Initialization of 0th row and 0th column is essential because without
  # properly populating these, we shall end up with incorrect calculations
  # for remaining rows, columns
  # Code below will mutate the existing paths for dp[0][k - 1] which should
  # not be the case, Every dp array element should store correct result of
  # paths for that cell(i, j), this is because we are using "<<" which
  # concatenates [[0, k]] to the existing array
  # When we use map, and if we use "+" instead of "<<", it will return a
  # new array, and not mutate the existing path array

  # dp[0][k] = dp[0][k - 1].map { |path| path << [0, k] }

  (1...n).each do |k|
    dp[0][k] = dp[0][k - 1].map { |path| path + [[0, k]] }
  end

  (1...m).each do |i|
    dp[i][0] = dp[i - 1][0].map { |path| path + [[i, 0]] }

    (1...n).each do |j|
      # if i.positive? is redundant since i >=1 and same for j
      dp[i][j] += dp[i - 1][j].map { |path| path + [[i, j]] } # if i.positive?

      dp[i][j] += dp[i][j - 1].map { |path| path + [[i, j]] } # if j.positive?
    end
  end

  dp[m - 1][n - 1]
end

def input_arr
  [
    {
      m: 3,
      n: 7,
      output: 28
    },
    {
      m: 3,
      n: 2,
      output: 3
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    m = input_hsh[:m]
    n = input_hsh[:n]
    input = "#{m}, #{n}"
    output = input_hsh[:output]

    res_comb, paths = total_paths(m:, n:)

    print "\n Input :: #{input}, Total Paths :: #{output}, \n"
    print " Total Paths Combinatorics :: #{res_comb}, Total Paths DP :: #{paths.size}\n"
    print "\n Paths Below :: \n"
    paths.each do |path|
      path_len = path.length - 1
      path.each_with_index do |vertices_arr, index|
        print " #{vertices_arr.inspect}"
        print ", " unless index == path_len
      end
      print "\n"
    end
  end
end

test
