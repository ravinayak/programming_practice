# frozen_string_literal: true

# Class TrieNode
class TrieNode
  attr_accessor :children, :word

  def initialize
    @children = {}
    @word = nil
  end
end
