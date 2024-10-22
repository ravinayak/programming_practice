# frozen_string_literal: true

# Given an m x n 2D binary grid grid which represents a map of '1's (land)
# and '0's (water), return the number of islands.

# An island is surrounded by water and is formed by connecting adjacent lands
# horizontally or vertically. You may assume all four edges of the grid are all
# surrounded by water.

# Example 1:
# Input: grid = [
#   ["1","1","1","1","0"],
#   ["1","1","0","1","0"],
#   ["1","1","0","0","0"],
#   ["0","0","0","0","0"]
# ]
# Output: 1

# Example 2:
# Input: grid = [
# ["1","1","0","0","0"],
# ["1","1","0","0","0"],
# ["0","0","1","0","0"],
# ["0","0","0","1","1"]
# ]
# Output: 3

# Algorithm: Grid is assumed to be surrounded by water on all sides. This
# means that there is at least 1 island in the grid as long as there is
# at least single 1 in any of the cells. Islands are lands covered by water
# on all sides, and are connected to other pieces of land horizontally,
# vertically in a 4-direction-connection
# To find the number of islands in the grid, we have to find such lands
# which are surrounded by water on all sides, and are not connected to
# any other land which is an island
# To solve this problem,

# Step 1: Iterate over (m * n) Grid
#  => we start iterating over all the cells in Grid and for every 1 we
#  find, we start a DFS in a 4-direction-connection from that cell,
#  converting 1 to 0 (since we already have 0, we would have to check
#  for 1 more character if we converted to any value other than 0).

# Step 2: Keep iterating over the Grid until we can no longer find any
# more 1s

# Step 3: In the main loop, we update num_of_islands whenever we start
# a DFS and find 1 again. In any iteration over Grid, we convert all
# connected pieces of land which form an island to 0, so any more 1s in
# other iterations means that we have found a new island

# @param [Array<Array<Integer>>] grid
# @return [Integer] num_of_islands
def num_of_islands(grid:)
  num_islands = 0
  rows_num = grid.length
  cols_num = grid[0].length

  grid_dup = grid.map(&:dup)

  (0...rows_num).each do |row|
    (0...cols_num).each do |col|
      if grid_dup[row][col] == '1'
        num_islands += 1
        dfs_grid(grid: grid_dup, row:, col:, rows_num:, cols_num:)
      end
    end
  end

  # Number of islands
  num_islands
end

# @param [Array<Array<Integer>>] grid
# @param [Integer] row
# @param [Integer] col
# @param [Integer] rows_num
# @param [Integer] cols_num
def dfs_grid(grid:, row:, col:, rows_num:, cols_num:)
  # Redundant check but keeping it here to make the method independent of implementation
  return if row.negative? || row > (rows_num - 1) || col.negative? || col > (cols_num - 1)

  # Base Case of Recursion: Return if grid has 0 in its cell
  return if grid[row][col] == '0'

  # Change the element of grid to 0
  grid[row][col] = '0'

  directions_arr = [[-1, 0], [+1, 0], [0, -1], [0, +1]]

  directions_arr.each do |direction|
    new_row = row + direction[0]
    new_col = col + direction[1]
    if new_row >= 0 && new_row < rows_num && new_col >= 0 && new_col < cols_num
      dfs_grid(grid:, row: new_row, col: new_col, rows_num:, cols_num:)
    end
  end
end

def test
  grid_arr = [
    {
      grid: [
        %w[1 1 1 1 0],
        %w[1 1 0 1 0],
        %w[1 1 0 0 0],
        %w[0 0 0 0 0]
      ],
      output: 1
    },
    {
      grid: [
        %w[1 1 0 0 0],
        %w[1 1 0 0 0],
        %w[0 0 1 0 0],
        %w[0 0 0 1 1]
      ],
      output: 3
    }
  ]

  grid_arr.each do |grid_hsh|
    grid = grid_hsh[:grid]
    output = grid_hsh[:output]
    result = num_of_islands(grid:)
    print "\n\n Grid Input :: #{grid.inspect}"
    print "\n Expected Output :: #{output}, Result :: #{result}\n\n"
  end
end

test
