# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'
# You are given an m x n grid where each cell can have one of
# three values:

# 0 representing an empty cell,
# 1 representing a fresh orange, or
# 2 representing a rotten orange.
# Every minute, any fresh orange that is 4-directionally adjacent
# to a rotten orange becomes rotten.

# Return the minimum number of minutes that must elapse until no
# cell has a fresh orange. If this is impossible, return -1.

# Example 1:
# Input: grid = [[2,1,1],[1,1,0],[0,1,1]]
# Output: 4

# Example 2:
# Input: grid = [[2,1,1],[0,1,1],[1,0,1]]
# Output: -1
# Explanation: The orange in the bottom left corner (row 2, column 0)
# is never rotten, because rotting only happens 4-directionally.

# Example 3:
# Input: grid = [[0,2]]
# Output: 0
# Explanation: Since there are already no fresh oranges at minute 0,
# the answer is just 0.

# Algorithm: To find minimum number of minutes that must elapse until
# no cell has a fresh orange, we use the following key concepts:
# 1.  Scan the grid (just like we did in the number of islands problem)
#     to find all the locations that have rotten oranges
#  2. All oranges that are fresh and are 4-directionally adjacent to
#     this rotten orange, will rot in the next 1 minute. Rotten oranges
#     found in the 1st scan represents 1st level of BFS, where
#     surrounding oranges will remain fresh for the next 1 minute
#  3. We move in the 4-direction adjacent to rotten oranges in the 1st
#     level to find all the oranges which are fresh, convert them to
#     rotten, and enqueue them
# 4.  Rotten oranges from Step 3 represents level 2 which will take
#     another 1 minute to rot
# 5.  Since we only consider cells in 4-dirction traversal that consider
#     fresh oranges (!empty && !rotten), we do not have to use a hash
#     to keep track of visited cells. Cells which have been visited
#     contain 2 (are rotten), so we can never enqueue processed cells
#     again
# 6.  At the end we can iterate over the grid to find any non-empty cell
#     which has a fresh orange - this is much simpler but requires one more
#     iteration over the Grid. This is the simplest and most accurate way
#     to determine if grid can be converted to rotten oranges. Other
#     ways have pitfalls and error conditions to check
# 7.  To process all the rotten oranges which have been rotten and are
#     not going to rot in the next minute, we have to keep track of
#     levels in queue. To do this, we use queue.size at the beginning
#     of insertions from this level to process only those oranges which
#     are at the level. Freshly inserted rotten oranges from this level
#     are at the next level, and should be processed in the next
#     iteration

# @param [Array<Array<Integer>>] grid
# @return [Hash] num_of_minutes, can_convert
def rotten_oranges(grid:)
  rows_num, cols_num = row_col_num(grid:)

  directions_arr = [[-1, 0], [+1, 0], [0, -1], [0, +1]]

  grid_dup = grid.map(&:dup)

  queue = Queue.new

  initial_scan_rotten(grid_dup:, queue:)

  level = 0
  until queue.empty?
    # Determine the length of queue at this level, as we dequeue
    # we shall insert freshly converted rotten oranges into the
    # queue
    level_size = queue.size

    # Only process elements in queue at specific level
    level_size.times do
      row, col = queue.dequeue
      # 4-directionally connected cells
      directions_arr.each do |direction|
        process_queue(row:, col:, direction:, grid_dup:, queue:)
      end
    end
    # This is used to keep track of the minimum number of minutes to
    # convert all fresh oranges to rotten in grid
    # NOTE: It is critical to observe the following:
    # a.  In the initial scan, all oranges are already rotten, if we
    #     process these and at the end of processing all of them, we
    #     do not have any new oranges enqueued, it means that no time
    #     elapsed for oranges to rot. Only if the queue is not empty
    #     at the end of any level, it means that the oranges will take
    #     1 min to rot
    #  b. This applies to each level. Oranges dequeued and processed do
    #     not add to mins for fresh oranges to rot, the next set of
    #     oranges if present in queue indicate that some time will elapse

    # Each level takes 1 minute to rot, queue has certain organges to rot
    level += 1 unless queue.empty?
  end

  (0...rows_num).each do |row|
    (0...cols_num).each do |col|
      return -1 if grid_dup[row][col] == 1
    end
  end

  # Number of minutes elapsed is same as levels processed in queue
  level
end

# @param [Array<Array<Integer>>] grid_dup
# @param [Queue] queue
def initial_scan_rotten(grid_dup:, queue:)
  rows_num, cols_num = row_col_num(grid: grid_dup)

  (0...rows_num).each do |row|
    (0...cols_num).each do |col|
      # Rotten oranges initially in the grid, maintain count and
      # enqueue them
      queue.enqueue(data: [row, col]) if grid_dup[row][col] == 2
    end
  end
end

# @param [Integer] row
# @param [Integer] col
# @param [Array<Integer>] direction
# @param [Array<Array<Integer>>] grid_dup
# @param [Queue] queue
def process_queue(row:, col:, direction:, grid_dup:, queue:)
  new_row = row + direction[0]
  new_col = col + direction[1]

  return unless valid_row_col?(new_row:, new_col:, grid_dup:)

  grid_dup[new_row][new_col] = 2
  queue.enqueue(data: [new_row, new_col])
end

# @param [Integer] new_row
# @param [Integer] new_col
# @param [Array<Array<Integer>>] grid_dup
# @return [Boolean]
def valid_row_col?(new_row:, new_col:, grid_dup:)
  rows_num, cols_num = row_col_num(grid: grid_dup)

  new_row >= 0 && new_row < rows_num && new_col >= 0 &&
    new_col < cols_num && grid_dup[new_row][new_col] != 2 && grid_dup[new_row][new_col] != 0
end

# @param [Array<Array<Integer>>] grid_dup
# @return [Array<Integer>]
def row_col_num(grid:)
  [grid.length, grid[0].length]
end

def test
  grid_arr = [
    {
      grid: grid = [[2, 1, 1], [1, 1, 0], [0, 1, 1]],
      output: 4
    },
    {
      grid: grid = [[2, 1, 1], [0, 1, 1], [1, 0, 1]],
      output: -1
    },
    {
      grid: grid = [[0, 2]],
      output: 0
    }
  ]

  grid_arr.each do |grid_hsh|
    grid = grid_hsh[:grid]
    output = grid_hsh[:output]
    mins = rotten_oranges(grid:)

    print "\n\n Grid :: #{grid.inspect}"
    print "\n Expected Output :: #{output}, "
    print "Result :: #{mins}\n\n"
  end
end

test
