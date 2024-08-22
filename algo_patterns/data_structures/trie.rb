# frozen_string_literal: true

require_relative 'trie_node'

# Time Complexity To Build Trie: O(n * L)
#    If longest word has a length "L", and number of words is "n"
#    maximum time to insert a word would be the time to insert
#    each character in trie. Total # of chars in any word < L
#    "n" words => n * L (Maximum time)

# Time Complexity to Search a word in Trie: O(L)
#   If longest word has a length "L", maximum depth we may have to
#    traverse in Trie to search word would be "L" nodes

# Implements Trie Class and basic operations of search, insert
class Trie
  attr_accessor :root

  def initialize
    @root = TrieNode.new
  end

  # In both Insert and Search operations on Trie, the idea is same. Conceptually
  # visualize Trie as a data structure where every node holds a Hash and Word
  # Hash contains references to the other nodes as values. Key of Hash is character
  # in a word. Presence of key implies that a prefix (of string formed by characters
  # starting from root until current node exists in trie). If word is nil, it means
  # current node does not mark end of word, it is only a prefix. If word is present,
  # it means the current node marks end of word. children will be empty for this node
  # Path starting from root until current node contains the word in Trie
  #
  # Insert a word in trie
  # @param [String] word
  # @param [TrieNode] root
  #
  def insert(word:)
    node = root

    word.chars.each do |char|
      node.children[char] ||= TrieNode.new
      node = node.children[char]
    end

    node.word = word
  end

  # Search for a word in Trie
  # @param [String] word
  # @param [String|Nil]
  #
  def search(word:)
    node = root
    word.chars.each do |char|
      return nil if node.children[char].nil?

      node = node.children[char]
    end

    node.word
  end
end

# Method to test execution of trie data structure
def test
  trie = Trie.new
  word_arr = %w[batsman bat baller batting cat cattle dog door]

  word_arr.each do |word|
    trie.insert(word:)
  end

  puts "\nWords inserted in trie :: #{word_arr.inspect}"
  puts

  search_words_arr = %w[baller bat batsman doors cats man]
  search_words_arr.each do |word|
    res = trie.search(word:)
    puts "Searching for word :: '#{word}' in trie, Result :: #{res.nil? ? 'Not Found' : 'Found'}\n"
  end
  puts
end

test
