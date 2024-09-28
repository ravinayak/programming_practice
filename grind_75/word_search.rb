# frozen_string_literal: true

# Given an m x n grid of characters board and a string word,
# return true if word exists in the grid.

# The word can be constructed from letters of sequentially
# adjacent cells, where adjacent cells are
# horizontally or vertically neighboring. The same letter
# cell may not be used more than once.

# Algorithm: Similar to board problem with Tries,

# Step 1: Whenever we can move horizontally or vertically ONLY,
# we have 4 directions possible with current Cell Location
#	(-1, 0) [Row decrease], (+1, 0) [Row Increase] => Vertical
# (0, -1) [Column decrease], (0, +1) [Column Increase] => Horizontal

# Step 2: If we cannot reuse a character on Board more than once,
# or an element from array more than once, we have to ensure that
# this element is masked in search path once it has been processed.
# This is because, when we can move horizontally/vertically, we can
# come back to the same position again in current level of recursion
# and at this time, we should not use this character, since it has
# already been used before in the search path of Current Recursion

# Step 3: Since word can be formed by using any character on the
# board as the starting character, similar to when we combine any
# elements in the array in any order to sum upto target, we must
# perform DFS from all cell locations

DIRECTION_ARR = [[0, -1], [0, +1], [-1, 0], [+1, 0]].freeze
# @param [Array<Array<char>>] board
# @param [String] word
# @return [Array<boolean, Array<Integer>>] found
def word_search(board:, word:)
  path_arr = []
  rows = board.length
  cols = board[0].length
  found = false
  index = 0

  (0...rows).each do |i|
    (0...cols).each do |j|
      curr_path = []
      found = word_search_rec_utility(board:, path_arr:, i:, j:, curr_path:, index:, word:)
      break if found
    end
    # We must break from this loop as well, else, outer loop will continue processing and
    # overwrite any true values found for found with new found. Even if we found 1 combination
    # and in all other combinations, we got false, net found will be false
    break if found
  end

  [found, path_arr]
end

# @param [Array<Array<char>>] board
# @param [Array<Array<Integer, Integer>>] path_arr
# @param [Integer] i
# @param [Integer] j
# @param [Array<Array<Integer, Integer>>] curr_path
# @param [Integer] index
# @param [String] word
def word_search_rec_utility(board:, path_arr:, i:, j:, curr_path:, index:, word:) # rubocop:disable Metrics/ParameterLists
  # Every word char has matched with a char on board by moving in allowed directions
  if index == word.length
    # Clone curr_path because it is an object and would copy reference otherwise
    # causing path_arr to reflect any changes made to curr_path array
    path_arr << curr_path.clone
    return true
  end

  # i, j out of bounds check, and if board[i][j] char does not match char in word at index
  return false if i.negative? || i > board.length - 1 || j.negative? || j > board[0].length - 1 || board[i][j] != word[index]

  # Push (i, j) into current result array since board character at index matches the word character
  # and if further matches occur, we will keep pushing those vertices to track the positions on board
  # which generated the word
  curr_path << [i, j]

  # Mask currently processed board character, so that it is not reused in current Search Path if it
  # is encountered in Recursion again
  temp = board[i][j]
  board[i][j] = '#'

  # Move in all possible directions - horizontally / vertically
  # We use OR Operator to short circuit DFS calls, if we find any such board position which can contruct
  # word
  dfs_result = word_search_rec_utility(board:, path_arr:, i: i + 1, j:, curr_path:, index: index + 1, word:) ||
               word_search_rec_utility(board:, path_arr:, i: i - 1, j:, curr_path:, index: index + 1, word:) ||
               word_search_rec_utility(board:, path_arr:, i:, j: j + 1, curr_path:, index: index + 1, word:) ||
               word_search_rec_utility(board:, path_arr:, i:, j: j - 1, curr_path:, index: index + 1, word:)

  # Pop last pushed vertex pair from curr_path
  curr_path.pop
  # Restore board
  board[i][j] = temp

  dfs_result
end

def input_arr
  [
    {
      board: [%w[A B C E], %w[S F C S], %w[A D E E]],
      word: 'ABCCED',
      output: true
    },
    {
      board: [%w[A B C E], %w[S F C S], %w[A D E E]],
      word: 'SEE',
      output: true
    },
    {
      board: [%w[A B C E], %w[S F C S], %w[A D E E]],
      word: 'ABCB',
      output: false
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    board = input_hsh[:board]
    word = input_hsh[:word]
    output = input_hsh[:output]

    result, path_arr = word_search(board:, word:)

    print "\n Board :: #{board.inspect}, word :: #{word}"
    print "\n Output :: #{output}, Result :: #{result}"
    print "\n Path Array Board :: #{path_arr.inspect} \n"
  end
end

test
