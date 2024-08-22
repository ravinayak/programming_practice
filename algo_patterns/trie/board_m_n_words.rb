# frozen_string_literal: true

require_relative '../data_structures/trie'
# Given an m x n board of characters and a list of strings words, return all words
# on the board.
# Each word must be constructed from letters of sequentially adjacent cells, where
# adjacent cells are horizontally or vertically neighboring. The same letter cell may
# not be used more than once in a word.

# Board is represented as an array of sub-arrays where each sub-array contains
# characters on the board along column. Total number of elements in board
# (i.e. total number of sub-arrays represents number of rows)

# Implement method to return all words on the board
# @param [Array<Array>] board
# @param [Array<String>] words_arr
# @return [Array<String>]
#
def find_all_words(board:, words_arr:)
  trie = Trie.new
  insert_words(trie:, words_arr:)
  find_all_words_util(board:, trie:)
end

# Insert each word in trie
# @param [Trie] trie
# @param [Array<String>] words_arr
#
def insert_words(trie:, words_arr:)
  words_arr.each do |word|
    trie.insert(word:)
  end
end

# Utility to find all words in board
# @param [Array<Array>] board
# @param [Trie] trie
#
def find_all_words_util(board:, trie:)
  rows = board.length
  cols = board[0].length
  result = []
  visited = {}

  (0...rows).each do |row|
    (0...cols).each do |col|
      node = trie.root
      dfs_cell_board(board:, row:, col:, node:, visited:, result:)
    end
  end

  result
end

# Performs a DFS search on board for each row, col combination. This
# means we start at every cell on board and perform a DFS from that
# cell to every other cell on board to find if the combination of
# characters during DFS traversal creates a valid word in the list
# (we combine all characters starting from the initial recursion call
# in the method find_all_words_util to form word at each cell)
# Some important things to note here:
#    1. Every recursion must have a base step where we return from
#       recursion:
#          a. In this use case, because we may traverse a cell
#             more than once, we do not want to perform a DFS traversal
#             on the cell more than once. We temporarily change the character
#             of cell during current recursion (i.e. in the call from
#             find_all_words_util) to '#'. This ensures that in current recursion
#             a cell is visited ONLY ONCE for DFS traversal. In subsequent calls
#             from find_all_words_util method, a cell can be traversed for DFS
#             again to form new combinations starting from the character in that
#             cell
#          b. Goal of performing DFS traversal is to find words in trie for allowed
#             combinations of characters in board. If we reach a board cell where the
#             character in that cell is not present in trie, it would imply that there
#             is no word in trie for the given combination of characters until that
#             cell. Since the current character is not present in trie, we should return
#             from DFS. No word exists in trie for the combination of characters found
#             so far and any subequent DFS will not result in any valid word
#    2. At the end of every DFS current recursion, we restore character back in board
#       cell.
#    3. At every depth of recursion, we check if current node in trie (which contains
#       character in board cell as a key), has a word entry. If there is a word entry
#       it implies that the DFS traversal has produced a combination of characters on
#       board cell which results in a valid word in trie.
#    4. To avoid duplicate entries in result array, we mark this word as visited. We
#       push the word in result array. Next time if we come across this word again at
#       any depth of recursion, we will not push the word again in result array since
#       it is marked as visited
#    5. Problem statement allows only horizontal and vertical adjacent cells to be
#       considered for combinations. Hence, only 4 directions are possible for a cell
#           Horizontal => Left of current column, right of current column [[0, -1], [0, +1]]
#          Vertical => Above current row, Below current row [[+1, 0], [-1, 0]]
#      New rows, cols can be obtained by adding these values, however they must be within
#      bounds of board

# @param [Array<Array>] board
# @param [Integer] row
# @param [Integer] col
# @param [TrieNode] Node
# @param [Hash] visited
# @param [Array] result
#
def dfs_cell_board(board:, row:, col:, node:, visited:, result:)
  # Base case of recursion
  char = board[row][col]
  return if char == '#' || node.children[char].nil?

  # Order of the two lines is very important and changing it
  # will give incorrect result
  # This is because in Trie Implementation, we do not store the
  # word entry in node which contains last character of word as
  # a key in children hash. Instead we store word entry in the node
  # referenced by node.children[char]
  # If we change the order:
  #    a. if node.word && !visited[node.word]
  #    b. node = node.children[char]
  # This will give us an empty output for result array always
  # Because of the following reason:
  #    a. Consider we are at the last character of a word. In this
  #       use case, we check if the node which contains current
  #       character as a key in children hash has a word entry.
  #       This node does not have a word entry. The node referenced
  #       by node.children[char] - a node with empty children hash
  #       has the word entry
  #    b. node = node.children[char] => We move to the next node
  #       which contains the word entry. But before we can check
  #       if this node contains word entry, base case of recursion
  #       is encountered. This node does not have any key in children
  #       hash, hence, node.children[char].nil? returns true. We return
  #       from the recursion, and never check if the node contains
  #       word entry. Hence result array never gets word
  #    c. One possible solution to use the order outlined above
  #       could be to remove the node.children[char].nil? from base
  #       case of recursion. Include this check before
  #          => board[row][col] = '#'
  #       But the current implementation is better since base case
  #       of recursion is at one place and right at the top before
  #       we move any further into recursion - standard practice

  # Update node to the node in trie which contains all possible
  # combinations starting from character in board cell
  # If we move in any direction from current board cell, we are
  # basically looking for a prefix to exist in trie with the
  #	current character. Prefix is formed by combination of
  # starting character in call from find_all_boards_util method
  # and the combination of characters formed so far during recursion
  # Node must change to the node referenced by the value for char key
  # in children hash of current node.
  # If this new node contains an entry for character represented by
  # board[new_row][new_col] as key, there is a possibility for finding
  # word with the prefix found so far, else not
  # NOTE: Abstract it like BINARY TREE SEARCH
  node = node.children[char]

  # If word is found in node, push to result array
  if node.word && !visited[node.word]
    result << node.word
    visited[node.word] = true
  end

  # Avoid visiting the node again in current level of recursion
  board[row][col] = '#'

  # Only vertical/horizontal adjacent cells are valid neighbors
  directions_arr = [[+1, 0], [-1, 0], [0, -1], [0, +1]]

  directions_arr.each do |direction|
    new_row = row + direction[0]
    new_col = col + direction[1]

    # Check if new_row and new_col are in valid bounds of board dimensions
    if new_row.between?(0, board.length - 1) && new_col.between?(0, board[0].length - 1)
      dfs_cell_board(board:, row: new_row, col: new_col, node:, visited:, result:)
    end
  end

  # Restore character in board cell at end of current recursion
  board[row][col] = char
end

def test
  board = [%w[o a a n], %w[e t a e], %w[i h k r], %w[i f l v]]
  words_arr = %w[oath pea eat rain]
  res = find_all_words(board:, words_arr:)
  puts "Result Output :: #{res.inspect}"
end

test
