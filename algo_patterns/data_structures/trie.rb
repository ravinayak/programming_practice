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

# TrieNode: Every TrieNode contains a hash "children" and an instance
# variable "word". "word" is initialized to nil, children to an empty
# hash
# "children" hash contains keys. Each key represents a character. Path
# from root to given node represents a combination of characters which
# is the prefix for possible words stored in Trie. Value of this key in
# children hash references another TrieNode which contains keys as
# characters that form prefix for words with the prefix
# Ex: See the image for explanation
# Whenever we iterate to search for a character, we perform the following:
#    1. Does current node store the word being searched? Yes - Stop and return
#    2. children[char] is nil => No entry in trie data structure for the prefix
#       formed by combination of characters until current node. Word with the
#       prefix does not exist in Trie
#    3. children[char] exists => Go to this node. Repeat steps 1,2
#
# NOTE:

# 1.Correct implementation: Node which contains last character of a word as a key 
#	SHOULD not contain the word entry, instead the node referenced by node.children[char] 
# which is a node with empty "children" hash should contain entry for word
# This is a VERY VERY CRUCIAL FACT because this implies we must move to the next node, 
# i.e. node = node.children[char] before checking if node contains the word 
# i.e. !node.word.nil?

# 2. This is the correct implementation. If we store word on the same node which contains
# that character as a key in children hash, it will be incorrect. This is because the
# node which contains character as key in children hash will also contain other
# characters as keys, hence the prefix formed by traversing from root to the current
# node will not be 1 prefix, but several prefixes - Storing the word at the current
# node would be incorrect in a use case where many words are possible for different
# prefix combinations achieved by traversing from root to current node. Hence we must
# store word on the node referenced by node.children[char]. This node accurately
# reflects the node which contains a single prefix obtained by traversing from root
# the parent node of this node

# 3. Every node in Trie data structure represents 1 and only 1 prefix. Although a node
# may contain several characters as keys in its children hash, it represents only 1
# Prefix.

# Reference the image of Trie in TrieTheory.md for more explanation. 
# 4. Prefix for any node in Trie data structure is obtained by traversing from root
# to parent of node in question. Given node is not included in prefix calculation
# This means => Root of Trie => NO PREFIX

# Reference - trie/top_k_frequency_words.rb
#	5. This will be especially problematic if we store word frequencies for prefix
# on the same which contains the last character of prefix as a key. This will give
# us INCORRECT RESULTS. This is because the node which contains last character as
# key in children hash will have SEVERAL PREFIXES possible when traversing from 
# root to the node in question since it has several characters as keys in its
# children hash. During insert operation, when we insert a word, and frequency,
# for each prefix possible at this node, we will end up updating word_frequencies
# for each different prefix possible at the node.
# Consider possible prefixes at a node: 1. bats	2. batt 3. batm. This is the 4th
# node from root and contains keys - s, t, m as keys in its children hash
# When we insert (words, frequency) -> ("batman", 2), ("batting", 3), ("bats", 5) 
#	in trie - we will update the word frequencies array at the node to store all
# these words, since we can store 3 most used words with their frequencies
# Now, If we are given a prefix bats", and asked to return top 3 most frequently 
# used words with this prefix we will end up returning - batman, batting, bats. 
# This would be incorrect because batting, batman do not contain prefix "bats", we 
# stored these words at the node for the other possible prefixes at the 
# node - 1. batt 2. batm

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
