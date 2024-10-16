# frozen_string_literal: true

# Queue ImplementationWithoutUsingInBuiltRuby Methods
class QueueWithoutRubyMethods
  # Typically we use front and rear, front is where we
  # remove elements from queue and rear is where we
  # add elements to the queue
  # front => dequeue_index
  # rear => enqueue_index
  attr_accessor :queue, :front, :rear

  # Increment rear and then add elements to the queue
  # Delete elements at front and then decrement front
  def initialize
    @queue = []
    @front = 0 # deletion will occur at this index
    @rear = -1 # rear < front for initial use case
  end

  def enqueue(data:)
    @rear += 1
    @queue[@rear] = data
  end

  def empty?
    front > rear
  end

  def dequeue
    queue_empty_error if empty?

    element = @queue[@front]
    @front += 1
    element
  end

  def display
    return queue_empty_error if empty?

    print ' Printing Queue elements :: '
    (front..rear).each do |index|
      print " #{queue[index]} "
    end
    print "\n"
  end

  # rear points to end of queue, and includes index
  # where last element of queue is present
  # front points to start of queue, and includes index
  # where first element of queue is present
  # rear - front
  #  = Number of elements between rear and
  #    front excluding front but front points to index
  #    where an element of queue is present
  #  = So we add 1
  # Size = rear - front + 1
  def size
    rear - front + 1
  end

  def clear
    @queue = []
    @front = 0
    @rear = -1
  end

  def peek
    first_element
  end

  def first_element
    queue_empty_error if empty?

    queue[front]
  end

  def last_element
    queue_empty_error if empty?

    queue[rear]
  end

  private

  def queue_empty_error
    puts ' Queue Empty Error'
    nil
  end
end

def test
  queue = QueueWithoutRubyMethods.new
  queue.enqueue(data: 5)
  queue.enqueue(data: 6)
  queue.enqueue(data: 7)
  queue.display
  puts " Queue Peek :: #{queue.peek}"
  puts " Queue Dequeue :: #{queue.dequeue}"
  puts " Queue Size :: #{queue.size}"
  puts " Queue Empty :: #{queue.empty?}"
  puts " Queue Dequeue :: #{queue.dequeue}"
  queue.display
  puts " Queue Dequeue :: #{queue.dequeue}"
  queue.display
end

test
