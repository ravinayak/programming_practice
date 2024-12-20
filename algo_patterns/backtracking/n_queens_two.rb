# Find all distinct solutions for the N-Queens problem and also return the total number
# of distinct solutions

# In the N Queens Problem, two queens can attack each other under the following conditions:

#   1.  Same Row: If two queens are placed on the same row, they can attack each other.
#   In chess, queens can move horizontally along the row. Hence, no two queens can be
#   placed on the same row.
#   2.  Same Column: If two queens are placed in the same column, they can attack each
#   other because queens can move vertically along the column. Therefore, no two queens
#   can be placed in the same column.
#   3.  Diagonally: Two queens can attack each other if they are placed on the same
#   diagonal. Queens can move diagonally in two directions:
#     •  Top-left to bottom-right diagonal (also known as the main diagonal): This
#     happens when the absolute difference between their row indices is equal to the
#     absolute difference between their column indices. In mathematical terms, if two
#     queens are placed at positions (row1, col1) and (row2, col2), they are on the same
#     diagonal if:
#       => |row1 - row2| = |col1 - col2|
#     •  Top-right to bottom-left diagonal (also known as the anti-diagonal): This is
#     handled similarly by checking the absolute difference in row and column indices.

# frozen_string_literal: true

# Time Complexity : O(n!)
# The time complexity of this algorithm is O(n!). This is because, in the worst case,
# the algorithm may need to explore all permutations of the queens on the board.
# However, because the algorithm prunes invalid configurations early (backtracking), it
# often performs better than O(n!) in practice. The exact time complexity is hard to determine
# because it depends on the number of valid partial solutions that are explored before backtracking,
# but O(n!) serves as the upper bound

# Reasoning for  O(n!)  Time Complexity:

# 1. Choosing a Column for Each Queen:
#   • In the first row, there are n possible columns where we can place the queen.
#   • In the second row, after placing a queen in the first row, there are fewer valid columns
#     to place the next queen. Typically, we have at most n-1 columns to choose from
#     (because of the column and diagonal constraints).
#   • In the third row, after placing queens in the first two rows, there are at most n-2 valid
#     columns.
#   • This pattern continues until the last row, where we have only one valid column left.
# 2. Combinatorial Nature:
#   • At each row, the number of valid columns decreases because we are not only eliminating the
#     columns where the queens from previous rows are placed but also accounting for the diagonals
#     where no queen can be placed.
#   • In the worst-case scenario, the number of valid column choices follows a decreasing pattern
#     similar to the factorial function:

# N Queens problem solutionimplementation
# Board is initialized as an array of arrays where each index of the outer array
# represents rows, and each index of the inner arrays represents column
# board = Array.new(3) { Array.new(3) }
# board = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
# board[1][2] => "1" index is the row, "2" index is the column =>
#  - board[1] = 2nd array at index 1 => board[1][2] = 3rd element in the 2nd array at index 1
# Visualize this a 2d matrix from top left to top right and top upper to top bottom
#  - left to right => cols, top to bottom => rows,
#  - left to right => 0 to n, top to bottom => 0 to n

# Util function to check if it is safe to place queen at a given row and col
# position on the board
# @param [Array<Array>] board
# @param [Integer] row
# @param [Integer] col
# @param [Integer] n
# @return [Boolean]
#
def safe_arrangement_util(board:, row:, col:, n:)
  # Check for a given row and col combination, if there are any queens placed to the left
  # of the current column for specified row. Since row is constant and col value will increase
  # from left to right until "col" (current col) board[row][i] will be used
  #
  (1..col).each do |i|
    return false if board[row][col - i] == 1
  end

  # Queens can be placed in a col in any row since we iterate over all rows for a given col
  # to find the appropriate row for which no queen can attack current queen. Since queens can
  # attack diagonally, and we increment from left to right, there are only two possibilities
  # for diagonal attack
  #  - Left Upper diagonal
  #     => queens can be placed in any row < CURRENT ROW on cols to left of current col
  #  - Left Lower diagonal
  #     => queens can be placed in any row > CURRENT ROW on cols to left of current col
  #  - Right diagonal is out of question since we only move from left to right meaning there
  #    can be no queens to the right of current col, we backtrack to the left

  # To find upper left diagonal, we have to do following
  #  - 1. Upper here means above current position of board (row,col). Moving up diagonally
  #       means both row and col must decrease
  #  - 2. Decrement row and col by 1
  #  - 3. We must keep decrementing in increasing units of 1 until one of row,col becomes 0
  #  - 3. Maximum iterations of decrement will be min(row, col)
  #         If we take max(row, col), we will get board[i][j], where one of (i, j) will be -1
  #         causing error
  #  - 4. Start of iteration will be 1, if we use 0, it will consider placement as an attack
  #       which is incorrect and always fail
  #
  (1..[row, col].min).each do |i|
    return false if board[row - i][col - i] == 1
  end

  # To find lower left diagonal, we have to do following
  #  - 1. Lower here means below current position of board (row,col). Moving lower diagonally
  #         means row must increase while col must decrease
  #  - 2. Increment row by 1
  #  - 3. Decrement col by 1
  #  - 4. Increment should not make row > n - 1, decrement must not make col < 0
  #  - 3. Maximum iterations of decrement will be min((n - 1) - row, col)
  #        a. (n - 1) - row
  #             => Row values can only increase till (n-1), which is the maximum possible
  #                value for any Row, i.e Units of Increment possible for row = (n - 1) - row
  #             => This is same as finding the number of steps a given number must take to
  #                reach another number,
  #                Say 3 wants to find number of steps it must take to reach 7
  #                (7 - 3) => 4 steps => 4, 5, 6, 7 => 4 steps
  #             => Ensures that row can only increase till n - 1 if this is the minimum.
  #                Say n = 7, row = 3, col = 4.
  #             => [(7 - 1) - 3, 4].min = [3, 4].min = 3. Only 3 iterations are allowed
  #                which means row can only increase till 6
  #        b. col => This is because if this is minimum and is selected, "col" number of
  #               iterations will be allowed where col at the end will become 0 which is correct
  #  - 4. Start of iteration will be 1, if we use 0, it will consider placement as an attack
  #       which is incorrect and always fail
  #
  (1..[((n - row) - 1), col].min).each do |i|
    return false if board[row + i][col - i] == 1
  end
  # We do not have to check if a queen can be attacked by another queen in the same column because
  # we always place only 1 queen in every col at a given row, and move to the next col. There is a
  # never use case where there is > 1 queen in any col

  # Must return true if queen cannot be attacked
  true
end

# This function places queen in increasing order of columns
# searching for each row within a column where the queen
# will not be attacked by another queen possibly placed in
# the same row, or upper left diagonal or lower left diagonal
# It places queen in increasing order of column from top left
# to top right, and if number of cols reaches n, it returns
# true, since we have found one such arrangement of queens
# on board where no queen can attack another queen

# @param [Array<Array>] board
# @param [Integer] col
# @param [Integer] n
# @param [Array] solutions
# @return [boolean]
#
def place_n_queen_util(board:, col:, n:, solutions:)
  # Base case: If all queens are placed, return true
  if col >= n
    solutions << board.each.map(&:dup) # board.dup will not work, iterate over all arrays and dup them
    return
  end

  # Try placing the queen in all rows one by one
  (0...n).each do |row|
    if safe_arrangement_util(board:, row:, col:, n:) # rubocop:disable  Style/Next

      board[row][col] = 1

      # We no longer return true because we want to find all possible solutions
      # If a solution is found for a given board arrangement, it will backtrack
      # and re-initialize the board arrangement for row,col to 0, so other rows
      # in the same column can be tried to find other solutions
      #
      place_n_queen_util(board:, col: col + 1, n:, solutions:)

      # If placing queen at (row, col) doesn't lead to a solution, remove the queen (backtrack)
      # Even if placing queen at (row, col) does lead to a solution, remove the queen to try
      # other row and find valid arrangement
      #
      board[row][col] = 0
    end
  end

  false
end

# Prints arrangement of queens on board where no queen
# can attack another queen
# @param [Array<Array>] board
# @param [Integer] n
#
def print_board(board:, n:)
  output_arr = []
  (0...n).each do |i|
    puts "\n\t\t"
    (0...n).each do |j|
      if board[i][j] == 1
        print "\t\t Q  "
        output_arr << "(#{i}, #{j})"
      else
        print "\t\t .  "
      end
    end
  end

  puts "\n \n \t\t Output (row,col) values where queen can be placed :: #{output_arr}"
  puts "\n"
end

# If successful arrangement, print board and return row,col values
# @param [Array<Array>] board
# @param [Integer] n
# @return [Array] output_arr
#
def success_arrangement(board:, n:)
  puts "\n \t \t \t n Queens can be placed in the following arrangement :: "
  print_board(board:, n:)
end

# Initializes board and calls the place_n_queen function
# If solution exists, prints it, else prints no solution
# @param [Integer] n
#
def place_n_queen(n:)
  col = 0
  solutions = []
  board = Array.new(n) { Array.new(n, 0) }

  place_n_queen_util(board:, col:, n:, solutions:)

  return puts 'No arrangement exists where n queens can be placed as per given instructions' if
    solutions.empty?

  solutions.each do |solution_board|
    success_arrangement(board: solution_board, n:)
  end

  puts "\n \t \t Total Number of distinct solutions :: #{solutions.size}"
end

place_n_queen(n: 8)
