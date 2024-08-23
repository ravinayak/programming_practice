# frozen_string_literal: true

# Design an autocomplete system where given a prefix, you need to return the top-k most
# frequently used words that start with the prefix

# Implement TrieNode which holds children hash and word_frequencies. word_frequencies
# is an array which contains at max k sub-array tuples where each tuple contains
# frequency, word. At any node, given a prefix, we can easily return top k most
# frequently used words with that prefix just by visiting that node
#
class TrieNode
  attr_accessor :children, :word_frequencies

  def initialize
    @children = {}
    @word_frequencies = []
  end
end

# AutoCompleteSystem allows us to quickly search for top k most frequently used words
# for a given prefix
class AutoCompleteSystem
  attr_accessor :root, :k

  # @param [Integer] k
  #
  def initialize(k:)
    @root = TrieNode.new
    @k = k
  end

  # Insert word, frequency into AutoCompleteSystem
  # Critical part here is to update the word frequencies array at each node as we insert
  # characters from the word into this system. At any node, when we insert a character
  # (as key of children hash), we update the word_frequencies array to hold top k most
  # frequently used words with the word being inserted. This is an acceptable design
  # because when we parse characters from word and insert into AutoCompleteSystem, all
  # words which can be formed from using prefix (combination of characters obtained by
  # traversing this system from root to current node), should include the current word
  # since the current word uses the prefix. Given a prefix, we can easily navigate to the
  # node which contains last character of the word as key, and return top K frequently used
  # words from that node

  # NOTE: Explanation of why we do not store "k" in TrieNode
  #	We do not need include information about "k" in TrieNode, so that it is independent of
  # the number of most used words we want to store and can store any number of most frequently
  # used words depending upon the requirements. If we store k in TrieNode, it will be hard
  # bound to storing "k" most frequently used words, and we shall not be able to change/update
  # the "k" value if requirement changes
  # Unlike Trie, where we do not store word in the node which contains last character of word
  # but in the node which is referenced by node.children[char], in AutoCompleteSystem, we must
  # store word_frequencies in the node which contains the character as key. This is crucial
  # because every node should reflect the top k words which can be formed through any prefix
  # formed through combination of characters from the root to the current node.
  # Remember that there are multiple prefixes possible at any node within Trie or the current
  # system

  # Insert word into AutoCompleteSystem
  # @param [String] word
  # @param [Integer] frequency
  #
  def insert(word:, frequency:)
    node = root
    word.chars.each do |word_char|
      node.children[word_char] ||= TrieNode.new
      # This order is important, we must 1st go to the node which is referenced
      # by the word_char key in children hash before updating word_frequencies
      # Current node which contains word_char as key does not represent the node
      # which contains the prefix obtained by traversing from root to the node
      # The node referenced by node.children[word_char] represents the prefix
      # As we insert words into Trie, we must update word_frequencies for each
      # node, and not at the end like we do for storing words
      node = node.children[word_char]
      update_word_freq(word:, frequency:, node:)
    end
  end

  # Find top k most frequently used words for a given prefix
  # @param [String] prefix
  # @return [Array]
  #
  def find_top_k_words(prefix:)
    node = root
    prefix.chars.each do |prefix_char|
      return [] if node.children[prefix_char].nil?

      node = node.children[prefix_char]
    end

    # Return only words from the tuples
    node.word_frequencies.map { |_frequency, word| word }
  end

  private

  # Update word frequencies array in node to hold top k most frequently used words with a given
  # prefix
  # @param [String] word
  # @param [Integer] frequency
  # @param [TrieNode] node
  #
  def update_word_freq(word:, frequency:, node:)
    # Insert [frequency, word] tuple in array
    node.word_frequencies << [frequency, word]
    # Once tuple is inserted, sort the tuples in descending order of frequency. If frequency is
    # same, sort them in ascending order of word size
    node.word_frequencies.sort_by! { |freq, w| [-freq, w] }
    # since array should hold only top k most frequently used words, we remove a word immediately
    # if the size of array becomes greater than "k". This ensures that at all times the array
    # holds maximum of k words with their frequencies
    node.word_frequencies.pop if node.word_frequencies.size > k
  end
end

def test
  # Example Usage
  autocomplete = AutoCompleteSystem.new(k: 3)

  words_frequencies_arr = [
    { word: 'apple', frequency: 5 },
    { word: 'app', frequency: 3 },
    { word: 'ape', frequency: 8 },
    { word: 'application', frequency: 6 },
    { word: 'apply', frequency: 4 }
  ]
  # Insert words with their frequencies
  words_frequencies_arr.each do |word_freq_hsh|
    autocomplete.insert(word: word_freq_hsh[:word], frequency: word_freq_hsh[:frequency])
  end

  puts "\n\t\tWord Frequencies inserted into Trie :: \n\t\t\t#{words_frequencies_arr.inspect}"

  print "\n\t\tSearch for top 3 words for prefix: 'app' :: "
  print " #{autocomplete.find_top_k_words(prefix: 'app').inspect}"
  print "\n\t\tExpected Output :: ['application', 'apple', 'apply']"

  print "\n\t\tSearch for top 3 words for prefix: 'ap' :: "
  print " #{autocomplete.find_top_k_words(prefix: 'ap').inspect}"
  print "\n\t\tExpected Output :: ['ape', 'application', 'apple']"
end

test
