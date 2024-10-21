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
# (-1, 0) [Row decrease], (+1, 0) [Row Increase] => Vertical
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
  path_hsh = { path_arr: [], curr_path: [], word_found: false }
  rows = board.length
  cols = board[0].length
  index = 0

  (0...rows).each do |i|
    (0...cols).each do |j|
      word_search_rec_utility(board:, i:, j:, index:, word:, path_hsh:)
    end
  end

  # path_arr may contain duplicate entries because when we do DFS, we may reach the same combination
  # of paths from different cells while moving horizontally/vertically
  path_hsh[:path_arr].uniq!

  [path_hsh[:word_found], path_hsh[:path_arr]]
end

# @param [Array<Array<char>>] board
# @param [Integer] i
# @param [Integer] j
# @param [Integer] index
# @param [String] word
# @param [Hash] path_hsh
def word_search_rec_utility(board:, i:, j:, index:, word:, path_hsh:)
  if index == word.length
    path_hsh[:path_arr] << path_hsh[:curr_path].clone
    # It is CRITICAL to store word_found in the hash and not rely on returning true/false from
    # DFS call because even if we find true in a Recursive call, we still continue processing
    # and this result can be over-written by another Recursive call which may be false
    path_hsh[:word_found] = true
    return true
  end

  # i, j out of bounds check, and if board[i][j] char does not match char in word at index
  return false if i.negative? || i > board.length - 1 || j.negative? || j > board[0].length - 1 || board[i][j] != word[index]

  # Push (i, j) into current result array since board character at index matches the word character
  # and if further matches occur, we will keep pushing those vertices to track the positions on board
  # which generated the word
  path_hsh[:curr_path] << [i, j]

  # Mask currently processed board character, so that it is not reused in current Search Path if it
  # is encountered in Recursion again
  temp = board[i][j]
  board[i][j] = '#'

  # Move in all possible directions - horizontally / vertically
  dfs_result = false
  DIRECTION_ARR.each do |dir|
    dfs_result = word_search_rec_utility(board:, i: i + dir[0], j: j + dir[1], index: index + 1, word:,
                                         path_hsh:)
  end

  # Restore board
  board[i][j] = temp

  # If we want to find all paths, we must pop and continue processing, since it is possible that there are other
  # adjacent cells which contain the character that can form the word
  # Pop last pushed vertex pair from curr_path since the current character at board[i][j] could not form a
  # word successfully
  path_hsh[:curr_path].pop

  # We could not form the word successfully using characters at board
  dfs_result
end

def input_arr
  [
    {
      board: [%w[A B C E], %w[S F C S], %w[A D E D]],
      word: 'ABCCED',
      output: true
    },
    {
      board: [%w[A B S E], %w[S F E S], %w[A D E E]],
      word: 'SEE',
      output: true
    },
    {
      board: [%w[A B E E], %w[S F C S], %w[A D E E]],
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
    next unless result

    path_arr.each do |path|
      print "\n Path Array Board :: #{path.inspect}"
    end
    print "\n"
  end
  print "\n\n"
end

test
