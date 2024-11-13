# frozen_string_literal: true

require_relative 'node'
require_relative 'linked_list'
# Prepares linked list based on input array where index of element in array determines the next pointer
#
class List
  # Attribute Accessor
  #
  attr_accessor :head

  def initialize
    @head = Node.new
  end

  def insert(data:)
    prev = head
    curr = head.next

    while curr
      prev = curr
      curr = curr.next
    end
    prev.next = Node.new(data:)
    head
  end

  def remove(data:)
    return if empty?

    prev = head
    curr = head.next

    while curr
      if curr.data == data
        prev.next = curr.next
        curr.next = nil
        return curr.data
      end
      prev = curr
      curr = curr.next
    end
    head
  end

  def search(data:)
    return if empty?

    curr = head.next
    while curr
      return curr.data if curr.data == data

      curr = curr.next
    end
    nil
  end

  def empty?
    head.next.nil?
  end

  # Both insert_data and remove_data have the exact same structure
  def insert_data(data:, index:)
    # To insert, start count at 1, because we can insert at index 1 even if
    # the element does not exist at that index, say when list is empty, we
    # can insert data at index 1
    count = 1
    prev = head
    curr = head.next

    while curr && count < index
      prev = curr
      curr = curr.next
      count += 1
    end

    return 'Element cannot be inserted at specified index' if count < index

    node = Node.new(data:)
    prev.next = node
    node.next = curr

    head
  end

  def remove_data(index:)
    # This ensures that there is a node to remove, and we can safely initialize
    # count to 1 because when count = 1, curr is the 1st node in list and no
    # iteration of while loop is run
    # For subsequent runs, we increment count and move curr to the point to that
    # specific node
    return if empty?

    count = 1
    prev = head
    curr = head.next

    while curr && count < index
      count += 1
      prev = curr
      curr = curr.next
    end

    return 'Element cannot be removed from specified index' if count < index

    prev.next = curr.next
    curr.next = nil

    head
  end

  # Traverse List
  # @return [NIL]
  #
  def traverse_list
    return 'Empty List' if empty?

    # LinkedList.traverse_list(self.head)
    puts '**************************** List ****************************'
    curr = head.next
    while curr
      print " #{curr.data} "
      curr = curr.next
    end
    puts "\n*************************************************************"
  end
end

def test
  input_arr = [1, 3, 5, 6, 7, 8]
  list1 = List.new
  input_arr.each do |element|
    list1.insert(data: element)
  end
  list1.traverse_list
  list1.insert_data(data: 12, index: 1)
  list1.insert_data(data: 15, index: 5)
  print "\n List with element 12 inserted at 1st index, and element 15 at index 5"
  puts 'inserted at 5th index in the above list is as below :: '
  list1.traverse_list
  list1.remove_data(index: 5)
  list1.remove_data(index: 6)
  list1.remove_data(index: 1)
  print "\n List with elements at index 5 and then at index 1 removed :: Should remove elements 15, 7 and 12 \n"
  list1.traverse_list
end

test
