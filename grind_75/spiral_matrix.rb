# frozen_string_literal: true

# Given an m x n matrix, return all elements of the matrix in
# spiral order.

# @param [Arrray<Array<Integer>>] board
# @return [Array<Integer>]
def spiral_order_traversal(board:)
  # Base Case:
  return [] if board.nil? || board.empty?

  # Board starts at [0,0] on top left where row = 0, col = 0
  # rows = board.length => Elements in board indicate # of rows
  # cols = board[0].length => Elements in board at any index
  # represents number of cols in the board
  # Board ends at [m - 1, n - 1] on bottom right where
  #  row = m - 1, col = n - 1
  # Number of elements in board indicates rows, and for each
  # row, we store column information as an array
  # Board is represented as 2D array
  # board[x][y]
  #  Row Information => For row x => board[x - 1]
  #    => board[x - 1] is an array with n elements
  # Column Information => Access [y - 1] element in array board[x - 1]
  m = board.length
  n = board[0].length

  # Algorithm: We move spirally in the following way
  # top <= bottom
  #  => top represents the upper-most part of board, 0th row
  #  => bottom represents the lower-most part of board,
  #  => last row, (m -1)th row
  # left <= right
  #  => left represents the left-most column of board, 0th column
  #  => right represents the right-most column, (n - 1)th column
  # We move across the board, to move across the board there should
  # be some row, and some column which has not already been traversed
  # We increment top, decrement right, decrement bottom, increment
  # left as we move spirally, hence,
  # To move there should be some row, some column which is not yet
  # traversed
  #  Condition => top <= bottom, left <= right
  # top + , bottom -
  # top increases, bottom decreases as we move spirally, so board
  # shrinks horizontally, there should be some row to traverse, if
  # top > bottom, we have traversed all rows, and there is nothing
  # left to traverse
  # left +, right -
  # left increases, right decreases as we move along columns
  # horizontally, the board shrinks along vertical line, if
  # left > right, we have traversed all columns and there is no column
  # left to traverse
  #  a. Along the top row, we move horizontally from left to right
  #      => col increases from left to right, and at the end we have
  #         processed top row,
  #      => top = top + 1
  #     At the end of processing top row, we have processed element at
  #     the rightmost end of the board in top row, which is (top, n-1)
  #     Because we increment top, when we process from left to right
  #     vertically from top to bottom, we do not process the element
  #     at the rightmost end of the board (top, n-1) again because
  #     top = top + 1. We start at (top + 1, n - 1)
  #  b. On reaching right, we move vertically down from top to bottom
  #      => row increases from top to bottom, and at the end we have
  #         processed right column,
  #      => right = right - 1
  #    Same logic as above applies in this use case. We have processed
  #    element at the bottom most part of the board, (m - 1, n - 1)
  #    We decrement right, right = m - 2 now, and hence in next iteration
  #    when we move from right to left, we do not process the same
  #    element at rightmost end of the board again.
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
  top = 0
  bottom = m - 1
  left = 0
  right = n - 1

  while left <= right && top <= bottom

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
    # When we traverse bottom row from right to left, we are traversing
    # a row, we can only traverse a row if a row exists which has not
    # been processed yet. The condition to ensure that a row exists such
    # that it has not been processed is
    #   top <= bottom => Row exists which has not been processed
    # Same logic applies for column, when we check for left <= right
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
    print "\n Result :: #{result.inspect}, "
    print "\n Correct Ouput :: #{result == output}\n\n"
  end
end

test
