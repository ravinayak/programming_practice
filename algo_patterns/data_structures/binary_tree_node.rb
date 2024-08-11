# frozen_string_literal: true

# Defines BinaryTreeNode
#
class BinaryTreeNode
  attr_accessor :data, :left, :right

  def initialize(data:, left: nil, right: nil)
    @data = data
    @left = left
    @right = right
  end
end
