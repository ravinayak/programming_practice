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

  def insert(data:)
    print "\n Inserting data :: #{data}"
    node = head
    node = node.next until node.next.nil?
    new_node = Node.new(data:)
    node.next = new_node
    print "\n Data inserted :: #{new_node.data}\n"
  end

  def search(data:)
    print "\n Searching for data :: #{data}"
    node = head
    until node.next.nil?
      if node.data == data
        print "\n Search Result found :: #{node.data} \n"
        return
      end
      node = node.next
    end
    print "\n Search not found\n"
  end

  # Prepares linked list for given input array elements
  # @return [Node] 1st Node of linked list
  #
  def prepare_list
    curr_index = 0
    # This is the header node which is a dummy node and is initialized
    # with nil value. This serves as a start point for iteration over
    # linked list
    node_prev = Node.new(data: nil)
    header = node_prev

    while curr_index < input_arr.length
      new_node = Node.new(data: input_arr[curr_index])
      curr_index += 1
      node_prev.next = new_node
      node_prev = new_node
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

linked_list = LinkedList.new(input_arr: [1, 3, 6, 8, 9, 13, 19, 21, 26])
linked_list.traverse_list
linked_list.insert(data: 95)
linked_list.search(data: 8)
linked_list.search(data: 99)
print "\n\n"
