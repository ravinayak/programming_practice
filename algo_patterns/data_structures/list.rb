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
    curr_index = 0
    # Initialize a header node with nil data. This will act
    # as the dummy node with which we can start iteration
    # of linked list
    node_previous = Node.new(data: nil)
    # head node is not put into the array because it does not
    # contain any element. A list maps elements in array to
    # nodes in linked list. head does not contain any data
    # and is only a placeholder to reference the 1st node in
    # linked list. So, the next line is commented out
    # list << node_previous
    head = node_previous
    while curr_index < input_arr.length
      node_previous, curr_index = *prepare_list_helper(input_arr: input_arr, curr_index: curr_index, list: list,
                                                       node_previous: node_previous)
    end
    [head, list]
  end

  # Helper method to prepare List
  # @param [Array] input_arr
  # @param [Integer] curr_index
  # @param [Array] list
  # @param [Node] node_previous
  # @return [Array]
  #
  def prepare_list_helper(input_arr:, curr_index:, list:, node_previous:)
    node_next = Node.new(data: input_arr[curr_index])
    list << node_next
    node_previous.next = node_next
    node_previous = node_next
    [node_next, curr_index + 1]
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
    # Reference to current 1st node in list
    temp = head.next
    # Update the head to point to new node as the 1st node
    self.head.next = node
    # Prepend new node at the beginnning of the list
    list.unshift(node)
    # Current node should point to previous 1st node as
    # next
    node.next = temp
  end

  # Insert element when index is > 0
  # @param [Integer] element
  # @param [Integer] index
  #
  def insert_element_at_non_head(element:, index:)
    node = Node.new(data: element)
    # Node at index - 1 should point to new node which would be
    # inserted at index position in the list. This new node
    # should point to the node currently at index position in
    # the list
    node_prev = list[index - 1]
    temp = node_prev.next
    node_prev.next = node
    node.next = temp
    # All elements starting from and including index position
    # should be shifted by 1 position in the list
    shift_nodes_in_list(index: index, node: node)
  end

  # Prepares a new list which has element inserted at non_head index
  # @param [Integer] index
  # @param [Node] node
  # @return [NIL]
  #
  def shift_nodes_in_list(index:, node:)
    # Idea here is to start from the end of list and copy the
    # elements to one position greater than their current index
    # This will shift all the elements from the end of list to 
    # the index position where we want to insert new element to
    # one position higher. Thus index position becomes free to
    # include new node
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
    puts '**************************** List ****************************'
    list.each do |node|
      print " #{node.data}  "
    end
    puts "\n*************************************************************"
  end
end

# input_arr = [1, 3, 5, 6, 7, 8]
# puts "Given Input Array :: #{input_arr}"
# list1 = List.new(input_arr: input_arr)
# list1.traverse_list
# list1.insert_element(element: 12, index: 0)
# list1.insert_element(element: 15, index: 5)
# print "\n List with element 12 inserted at 0th index, and element 15"
# puts "inserted at 5th index in the above list is as below :: "
# list1.traverse_list
