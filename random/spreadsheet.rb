# frozen_string_literal: true

# Spreadsheet implementation in Ruby where columns are
# 26 in number from 'A' to 'Z' but rows can be any number
# Cell locations are given as 'A12', 'A1', 'B131', if the
# cell location does not contain any entry, return empty
# string
class Spreadsheet
  COLS = 26
  attr_accessor :cells

  def initialize
    @cells = Array.new(COLS) { {} }
  end

  def assign_val_cell_location(cell_location:, val:)
    col, row = retrieve_row_col(cell_location:)
    @cells[col][row] = val
  end

  def val_cell_location(cell_location:)
    col, row = retrieve_row_col(cell_location:)

    cells[col][row].nil? ? '' : cells[col][row]
  end

  private

  def retrieve_row_col(cell_location:)
    col = col_cell_location(cell_char: cell_location[0])
    row = cell_location[1..].to_i

    raise 'Invalid Row: Row number must be greater than 0' if row <= 0

    [col, row]
  end

  def col_cell_location(cell_char:)
    raise 'Invalid Colum Location, Must be between A and Z' if cell_char > 'Z' || cell_char < 'A'

    cell_char.ord - 'A'.ord
  end
end

def test
  s = Spreadsheet.new
  s.assign_val_cell_location(cell_location: 'A10', val: 'Hi There')
  puts s.val_cell_location(cell_location: 'A10')
  puts s.val_cell_location(cell_location: 'Z1')
  s.assign_val_cell_location(cell_location: 'Z12', val: '2nd entry')
  s.assign_val_cell_location(cell_location: 'B5', val: '3rd entry')
  puts s.val_cell_location(cell_location: 'B1')
  puts s.val_cell_location(cell_location: 'Z12')
  puts s.val_cell_location(cell_location: 'D12')
  puts s.cells.inspect
end

test
