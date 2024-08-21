# frozen_string_literal: true

# Time Complexity : O(n!)
# The time complexity of this algorithm is O(n!). This is because, in the worst case,
# the algorithm may need to explore all permutations of the queens on the board.
# However, because the algorithm prunes invalid configurations early (backtracking), it
# often performs better than O(n!) in practice. The exact time complexity is hard to determine
# because it depends on the number of valid partial solutions that are explored before backtracking,
# but O(n!) serves as the upper bound

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
  (0...col).each do |i|
    return false if board[row][i] == 1
  end

  # Queens can be placed in a col in any row since we iterate over all rows for a given col
  # to find the appropriate row for which no queen can attack current queen. Since queens can
  # attack diagonally, and we increment from left to right, there are only two possibilities
  # for diagonal attack
  #  - Left Upper diagonal (queens can be placed in any row on cols to left of current col)
  #  - Left Lower diagonal (queens can be placed in any row on cols to left of current col)
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
  #  - 3. Maximum iterations of decrement will be min(n - (row + 1), col)
  #        a. n - (row + 1) => Ensures that row can only increase till n - 1 if this is
  #           the minimum. Say n = 7, row = 3, col = 4.
  #             => [7 - (3 + 1), 4].min = [3, 4].min = 3. Only 3 iterations are allowed
  #                which means row can only increase till 6
  #        b. col => This is because if this is minimum and is selected, "col" number of
  #               iterations will be allowed where col at the end will become 0 which is correct
  #  - 4. Start of iteration will be 1, if we use 0, it will consider placement as an attack
  #       which is incorrect and always fail
  #
  (1..[(n - (row + 1)), col].min).each do |i|
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
# @return [boolean]
def place_n_queen_util(board:, col:, n:)
  # Base case: If all queens are placed, return true
  return true if col >= n

  # Try placing the queen in all rows one by one
  (0...n).each do |row|
    if safe_arrangement_util(board:, row:, col:, n:) # rubocop:disable  Style/Next

      board[row][col] = 1

      return true if place_n_queen_util(board:, col: col + 1, n:)

      # If placing queen at (row, col) doesn't lead to a solution, remove the queen (backtrack)
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
  board = Array.new(n) { Array.new(n, 0) }

  return success_arrangement(board:, n:) if place_n_queen_util(board:, col:, n:)

  puts 'No arrangement exists where n queens can be placed as per given instructions'
end

place_n_queen(n: 4)
place_n_queen(n: 8)
