# Node Class
class Node
  attr_accessor :data, :next

  def initialize(data: nil, next_node: nil)
    @data = data
    @next = next_node
  end
end

# Linked List Implementation
class LinkedList
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
    data
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
  end

  def search(data:)
    return if empty?

    curr = head.next

    while curr
      return data if curr.data == data

      curr = curr.next
    end
    nil
  end

  def display
    return if empty?

    print "\n Linked List Elements :: "
    curr = head.next

    while curr
      print "#{curr.data} "
      curr = curr.next
    end
  end

  def empty?
    head.next.nil?
  end
end

def test
  linked_list = LinkedList.new
  print "\n Inserting 95 :: #{linked_list.insert(data: 95)}"
  print "\n Inserting 8 :: #{linked_list.insert(data: 8)}"
  print "\n Inserting 81 :: #{linked_list.insert(data: 81)}"
  print "\n Inserting 110 :: #{linked_list.insert(data: 110)}"
  linked_list.display
  print "\n Removing 81 :: #{linked_list.remove(data: 81)}"
  linked_list.display
  print "\n Removing 811 which does not exist :: #{linked_list.remove(data: 811)}"
  print "\n Searching for 8 :: #{linked_list.search(data: 8)}"
  print "\n Searching for 99 which does not exist :: #{linked_list.search(data: 99)}"
  print "\n\n"
end

test
