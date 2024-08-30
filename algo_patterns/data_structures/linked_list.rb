# frozen_string_literal: true

require_relative 'node'
# Prepares linked list based on input array where index of element
# in array  determines the next pointer. The implementation creates
# a dummy node which acts as a header, or the initial node to start
# iteration. This node contains nil data and is a placeholder
class LinkedList
  # Attribute Accessor
  #
  attr_accessor :input_arr, :head

  # Initialize method
  #
  def initialize(input_arr:)
    @input_arr = input_arr
    @head = prepare_list
  end

  # Prepares linked list for given input array elements
  # @return [Node] 1st Node of linked list
  #
  def prepare_list
    curr_index = 0
    # This is the header node which is a dummy node and is initialized
    # with nil value. This serves as a start point for iteration over
    # linked list
    node_previous = Node.new(data: nil)
    header = node_previous
    while curr_index < input_arr.length
      node_next = Node.new(data: input_arr[curr_index])
      node_previous.next = node_next
      node_previous = node_next
      curr_index += 1
    end
    header
  end

  # Class Method to Traverse linked list
  # @param [Node] head
  # @return [NIL]
  #
  def self.traverse_list(head)
    traverse_list_helper(head)
  end

  # Instance Method to traverse linked list
  #
  def traverse_list
    self.class.traverse_list(head)
  end

  def self.traverse_list_helper(head)
    puts '*******************************************'
    print 'Linked List :: '
    node = head.next
    until node.nil?
      print node.data
      print '  --> ' unless node.next.nil?
      node = node.next
    end
    puts
    puts '*******************************************'
  end
end

# linked_list = LinkedList.new(input_arr: [1, 3, 6, 8, 9, 13, 19, 21, 26])
# linked_list.traverse_list
