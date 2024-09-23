# frozen_string_literal: true

# XXXOOOXXXOOO
# XXXOOOXXXOOO
# OOOXXXOOOXXX
# OOOXXXOOOXXX
# XXXOOOXXXOOO
# XXXOOOXXXOOO
# OOOXXXOOOXXX
# OOOXXXOOOXXX

# mx=3
# Mx=4
# my=2
# My=4

# mx times X is printed in 1st group
# mgroupx times (mx times X/O is printed)
# my times (mgroupx times (mx times X/O is printed)) is printed
# mgroupy times my times (mgroupx times (mx times X/O is printed)) is printed

# Step 1: ---***---*** => --- => mx times, ---***---*** => mgroupx times
# Step 2: mgroupy times
#    a. Characters X and O are flipped
#    b. Pattern is obtained from Step 1
#    c. Pattern is repeated my times
# XXXOOOXXXOOO
# XXXOOOXXXOOO

# Display board according to specified format of X and O
class BoardDisplay
  def new
    BoardDisplay.allocate
  end

  # @param [Integer] mx
  # @param [Integer] my
  # @param [Integer] mgroupx
  # @param [Integer] mgroupy
  def print_chars(mx:, my:, mgroupx:, mgroupy:)
    display_chars = %w[0 X]
    grid_dimensions = [mx, my, mgroupx, mgroupy]
    grid = prep_grid(grid_dimensions:)

    mgroupy.times.each do |i|
      # For every new set of columns which are displayed, display chars printed in the beginning are flipped
      # so we do a reverse to flip the order of chars in display_chars array
      # 1st set of 2 rows = [X O]
      # 2nd set of 2 rows = [O X]
      # 3rd set of 2 rows = [X O]
      # 4th set of 2 rows = [O X]
      # display_chars.reverse! allows us to persist the state in the array, so that it can be flipped
      # back and forth between those arrangements
      #
      display_same_pattern_rows(grid_dimensions:, display_chars: display_chars.reverse!, row: i * my, grid:)
    end

    print_grid(grid:)
  end

  private

  # @param [Array<Integer>] grid_dimensions
  # @return [Array<Array<Integer>>]
  def prep_grid(grid_dimensions:)
    mx, my, mgroupx, mgroupy = grid_dimensions

    cols = mx * mgroupx
    rows = my * mgroupy
    Array.new(rows) { Array.new(cols) }
  end

  # @param [Array<Integer>] grid_dimensions
  # @param [Array<String>] display_chars
  # @param [Array<Array<Integer>>] grid
  # @param [Integer] row
  def display_same_pattern_rows(grid_dimensions:, display_chars:, grid:, row:)
    mx, my, mgroupx, = grid_dimensions
    # Calculation of row and col values is the most critical part of setting grid
    # dimensions
    # mgroupy = 0 => Rows: 0, 1 => mgroupy.times iteration count * 2 => 0 * 2 + my.times iteration count
    # mgroupy = 1 => Rows: 2, 3 => mgroupy.times iteration count * 2 => 1 * 2 + my.times iteration count
    # mgroupy = 2 => Rows: 4, 5 => mgroupy.times iteration count * 2 => 2 * 2 + my.times iteration count

    # mx times a character is repeated, mgroupx defines the number of times this occurs
    # col => For every iteration of mgroupx, mx times the inner loop runs, generating columns
    # col =>  mx * mgroupx iteration count + mx iteration count
    # when mgroupx = 1, mx = 2 in iteration count
    #    => mx columns have been generated + mx current iteration count
    #    => mx * mgroupx iteration count => For every iteration count of mgroupx, mx columns are generated
    #    => mgroupx = 2, mx = 3 => For mgroupx = 0, [0, 1, 2] are generated, mgroupx = 1, [0, 1, 2, 3, 4, 5]
    #    => Current iteration count of mx = 2, => 0, 1 of current iteration have been generated
    #    => [0, 1, 2, 3, 4, 5, 6, 7, 8] => mgroupx = 2, mx current iteration count = 2 (out of 3
    my.times do |j|
      # We reset "i" at the end of every iteration, so that new row starts with the same order of characters
      # as in display_chars, it can switch between X and O depending upon mx
      # Pattern of display for both rows should be same, when we start this display 0th character of display_chars
      # is printed mx times and then switch happens, so we reset i = 0
      i = 0
      mgroupx.times do |k|
        mx.times do |l|
          # CRITICAL! => This is extremely important
          grid[row + j][mx * k + l] = display_chars[i]
        end
        # Switch to another character in display_chars to flip the pattern of chars being displayed
        i = evaluate_i(i:)
      end
    end
  end

  # @param [Integer] i
  def evaluate_i(i:)
    return 1 if i.zero?

    0
  end

  # @param [Array<Array<Integer>>] grid
  def print_grid(grid:)
    print "\n Printing Grid now :: \n"
    (0...grid.length).each do |row|
      print "\n"
      (0...grid[0].length).each do |col|
        print grid[row][col]
      end
    end
    print "\n"
  end
end

def output
  <<~HEREDOC
    XXXOOOXXXOOO
    XXXOOOXXXOOO
    OOOXXXOOOXXX
    OOOXXXOOOXXX
    XXXOOOXXXOOO
    XXXOOOXXXOOO
    OOOXXXOOOXXX
    OOOXXXOOOXXX
  HEREDOC
end

def test
  puts output
  BoardDisplay.new.print_chars(mx: 3, my: 2, mgroupx: 4, mgroupy: 4)
end

test
