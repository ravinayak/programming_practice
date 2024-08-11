# frozen_string_literal: true

# Node class which contains data and next pointer
#
class Node
  attr_accessor :data, :next

  def initialize(data:, next_node: nil)
    @data = data
    @next = next_node
  end
end
