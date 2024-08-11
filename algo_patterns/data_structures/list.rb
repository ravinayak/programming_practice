# frozen_string_literal: true

require_relative 'node'
require_relative 'linked_list'
# Prepares linked list based on input array where index of element in array determines the next pointer
#
class List
  # Attribute Accessor
  #
  attr_accessor :input_arr, :head, :list

  # Initialize method
  #
  def initialize(input_arr:)
    @input_arr = input_arr
    @head, @list = *prepare_list
  end

  # Prepares linked list for given input array elements
  # @return [Node] 1st Node of linked list
  #
  def prepare_list
    list = []
    curr_index = 1
    node_previous = Node.new(data: input_arr[0])
    list << node_previous
    initial_node = node_previous
    while curr_index < input_arr.length
      node_next = Node.new(data: input_arr[curr_index])
      list << node_next
      node_previous.next = node_next
      node_previous = node_next
      curr_index += 1
    end
    [initial_node, list]
  end

  # Insert an element at index in the list
  # @param [Integer] index
  # @return [List]
  #
  def insert_element(element:, index:)
    return insert_element_at_head(element: element) if index.zero?

    insert_element_at_non_head(element: element, index: index)
  end

  # Insert element when index is 0
  # @param [Node] node
  #
  def insert_element_at_head(element:)
    node = Node.new(data: element)
    temp = head
    self.head = node
    list.unshift(node)
    head.next = temp
  end

  # Insert element when index is > 0
  # @param [Integer] element
  # @param [Integer] index
  #
  def insert_element_at_non_head(element:, index:)
    node = Node.new(data: element)
    node_prev = list[index - 1]
    temp = node_prev.next
    node_prev.next = node
    node.next = temp
    shift_nodes_in_list(index: index, node: node)
  end

  # Prepares a new list which has element inserted at non_head index
  # @param [Integer] index
  # @param [Node] node
  # @return [NIL]
  #
  def shift_nodes_in_list(index:, node:)
    iteration = list.length - 1
    while iteration >= index
      list[iteration + 1] = list[iteration]
      iteration -= 1
    end
    list[index] = node
  end

  # Traverse List
  # @return [NIL]
  #
  def traverse_list
    # LinkedList.traverse_list(self.head)
    puts '*********************************************************** List *****************************************************************'
    list.each do |node|
      print " #{node.data}  "
    end
    puts "\n**********************************************************************************************************************************"
  end
end

# input_arr = [1, 3, 5, 6, 7, 8]
# puts "Given Input Array :: #{input_arr}"
# list1 = List.new(input_arr: input_arr)
# list1.traverse_list
# list1.insert_element(element: 12, index: 0)
# list1.insert_element(element: 15, index: 5)
# puts "\n List with element 12 inserted at 0th index, and element 15 inserted at 5th index in the above list is as below :: "
# list1.traverse_list
