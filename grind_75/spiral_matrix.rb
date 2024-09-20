# frozen_string_literal: true

# Given an m x n matrix, return all elements of the matrix in
# spiral order.

# @param [Arrray<Array<Integer>>] board
# @return [Array<Integer>]
def spiral_order_traversal(board:)
  # Base Case:
  return [] if board.nil? || board.empty?

  # Board starts at [0,0] on top left where row = 0, col = 0
  # Board ends at [m - 1, n - 1] on bottom right where
  #  row = m - 1, col = n - 1
  # Number of elements in board indicates rows, and for each
  # row, we store column information as an array
  # Board is represented as 2D array
  # board[x][y]
  #  Row Information => For row x => board[x - 1]
  #    => board[x - 1] is an array with n elements
  # Column Information => Access [y - 1] element in array board[x - 1]
  top = 0
  bottom = board.length - 1
  left = 0
  right = board[0].length - 1

  # Algorithm: We move spirally in the following way
  # top <= bottom
  #    => top represents the upper-most part of board, 0th row
  #    => bottom represents the lower-most part of board, last row
  # left <= right
  #    => left represents the left-most column of board, 0th column
  #    => right represents the right-most column, (n - 1)th column
  # We move across the board, to move across the board there should
  #  be some row, and some column which has not already been traversed
  # We increment top, decrement right, decrement bottom, increment
  # left as we move spirally, hence,
  #  To move there should be some row, some column which is not yet
  # traversed
  #  Condition => top <= bottom, left <= right
  # top + , bottom -
  # top increases, bottom decreases as we move spirally, so board
  # shrinks vertically, there should be some row to traverse, if
  # top > bottom, we have traversed all rows, and there is nothing
  # left to traverse
  # left +, right -
  # left increases, right decreases as we move along columns
  # vertically, the board shrinks along horizontal line, if
  # left > right, we have traversed all columns and there is no column
  # left to traverse
  #  a. Along the top row, we move horizontally from left to right
  #      => col increases from left to right, and at the end we have
  #         processed top row,
  #      => top = top + 1
  #  b. On reaching right, we move vertically down from top to bottom
  #      => row increases from top to bottom, and at the end we have
  #         processed right column,
  #      => right = right - 1
  #  c. Upon reaching bottom, we move horizontally from right to left
  #      => If there is still a row to process, if top > bottom, there
  #         is no row to process
  #      => Condition: top <= bottom
  #      => At the end,
  #      => bottom = bottom - 1
  # d. Upon reaching left, we move vertically up from bottom to top
  #      => If there is still a column to process, if left > right,
  #         there is no col to process
  #      => Condition: left <= right
  #      => At the end,
  #      => left = left + 1

  # A 1D array which holds elements of array obtained by traversing
  # Spirally
  result = []

  while top <= left && top <= bottom

    (left..right).each do |i|
      result << board[top][i]
    end
    # Top row has been processed, moving horizontally from left to right
    top += 1

    # Element at right-most end of board [top, n-1] has been traversed
    # When we increment top, we avoid traversing it again
    # We go from top + 1 to bottom
    (top..bottom).each do |i|
      result << board[i][right]
    end
    # Right column has been traversed vertically from top to bottom
    right -= 1

    # If a row is still left to traverse, move from right to left
    # Element at bottom-right has been traversed, decrementing right
    # prevents traversing it again
    if top <= bottom
      # right.downto(left) because right > left, and ruby uses downto
      right.downto(left).each do |i|
        result << board[bottom][i]
      end
    end
    # Bottom row has been traversed horizontally from right to left
    bottom -= 1

    # If a column is still left to traverse, move vertically up from
    # bottom to top
    # Element at bottom, left has been processed, decrementing bottom
    # prevents traversing it again
    if left <= right
      # bottom > top
      bottom.downto(top).each do |i|
        result << board[i][left]
      end
    end
    # Left column has been processed
    left += 1
  end

  # Result array
  result
end

def board_arr
  [
    {
      board: [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
      output: [1, 2, 3, 6, 9, 8, 7, 4, 5]
    },
    {
      board: [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]],
      output: [1, 2, 3, 4, 8, 12, 11, 10, 9, 5, 6, 7]
    }
  ]
end

def test
  board_arr.each do |board_hsh|
    board = board_hsh[:board]
    output = board_hsh[:output]
    result = spiral_order_traversal(board:)
    print "\n\n Board :: #{board.inspect}\n"
    print "\n Output :: #{output.inspect}, "
    print "Result :: #{result.inspect}, "
    print "Correct Ouput :: #{result == output}\n\n"
  end
end

test
