# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'
# Given an m x n binary matrix mat, return the distance of
# the nearest 0 for each cell.

# The distance between two adjacent cells is 1. There is at
# least one 0 in mat.

# Example 1:
# Input: mat = [[0,0,0],[0,1,0],[1,1,1]]
# Output: [[0,0,0],[0,1,0],[1,2,1]]

# Example 2:
# Input: mat = [[0,0,0],[0,1,0],[0,0,0]]
# Output: [[0,0,0],[0,1,0],[0,0,0]]

# Algorithm: Key idea here is to initialize a results array
# (m * n) with Infinity value (highest value). Iterate over
# each board cell, for any cell, which contains 0, assign
# 0 to results array for (x, y), and enqueue it
# Dequeue elements from the Queue, for each element dequeued
# look in possible 4 directions (horizontal, vertical), if
# the value in results array for that (new_x, new_y) is
#   results[new_x][new_y] > results[x][y] + 1
#    => new_x, new_y is horizontal/vertical of x,y
#    => either 1 row above/below with same column,
#    =>     or 1 col left/right with same row
#    => {(x - new_x) + (y - new_y)}.abs = 1
#    => new_x, new_y is 1 unit of distance from x,y
#    => so we add 1 to results[x][y]
# We checks for results[new_x][new_y] being greater because
# 1. we want to find the minimum distance to 0
#
# if it is greater, we update (new_x, new_y) in results array
# and also ENqueue it.
# => This is critical because results[new_x][new_y] has a new
#    less value. There is a possibility that other cells in
#    its 4 directions may get updated with less value than
#     what they have currently, so we have to process this
#    (new_x, new_y) for all 4 directions
# When queue is empty, stop processing

# @param [Array<Array<integer>>] mat
# @return [Array<Array<integer>>]
#
def solve_0_1_matrix(mat:)
  # each row is stored as an array element
  # num of rows = num of array elements
  # each row contains elements for all columns =>
  #	num of cols = any array element length = mat[0].length
  m = mat.length
  n = mat[0].length

  queue = Queue.new

  # Define 4 possible horizontal/vertical directions
  directions_arr = [[-1, 0], [+1, 0], [0, -1], [0, +1]]

  results = Array.new(m) { Array.new(n) { Float::INFINITY } }

  (0...m).each do |row|
    (0...n).each do |col|
      next unless (mat[row][col]).zero?

      # update results array for row,col and enqueue it
      results[row][col] = 0
      queue.enqueue(data: [row, col])
    end
  end

  until queue.empty?
    # Retrieve row, col values
    row, col = queue.dequeue

    directions_arr.each do |direction|
      # get possible horizontal/vertical cells from row,col
      new_row = row + direction[0]
      new_col = col + direction[1]
      # new_row, new_col should be within valid bounds
      # current value in results array is greater
      row_col_hsh = { new_row:, new_col:, row:, col: }
      next unless process_surrounding_cell?(row_col_hsh:, m:, n:, results:)

      # update to less value and put it in queue
      results[new_row][new_col] = results[row][col] + 1
      queue.enqueue(data: [new_row, new_col])
    end
  end

  results
end

def process_surrounding_cell?(row_col_hsh:, m:, n:, results:)
  new_row, new_col, row, col = row_col_hsh.values_at(:new_row, :new_col, :row, :col)
  new_row >= 0 && new_row < m && new_col >= 0 && new_col < n &&
    results[new_row][new_col] > results[row][col] + 1
end

def test
  arr_hsh = [
    {
      mat: [[0, 0, 0], [0, 1, 0], [0, 0, 0]],
      result: [[0, 0, 0], [0, 1, 0], [0, 0, 0]]
    },
    {
      mat: [[0, 0, 0], [0, 1, 0], [1, 1, 1]],
      result: [[0, 0, 0], [0, 1, 0], [1, 2, 1]]
    }
  ]

  arr_hsh.each do |mat_res_hsh|
    mat = mat_res_hsh[:mat]
    res_expected = mat_res_hsh[:result]
    result = solve_0_1_matrix(mat:)
    print "\n Input board :: #{mat.inspect}\n"
    print " Expected Res :: #{res_expected.inspect}, "
    print "Method Res :: #{result.inspect}\n"
  end
end

test
