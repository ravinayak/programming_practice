# frozen_string_literal: true

# Implement Queue class in Ruby
#
class Queue
  attr_accessor :queue

  def initialize
    @queue = []
  end

  # Add element to queue
  # @param [Integer] data
  # @return [Integer]
  #
  def enqueue(data)
    queue.push(data)
  end

  # Is Queue empty
  # @return [Boolean]
  #
  def empty?
    return true if queue.empty?

    false
  end

  # Remove element from queue
  # @return [Integer]
  #
  def dequeue
    if queue.empty?
      puts 'Queue is empty'
      nil
    else
      queue.shift
    end
  end

  # Peek method - Returns the 1st element in queue without removing it
  # @return [Integer|nil]
  #
  def peek
    return nil if queue.empty?

    queue.first
  end

  # Returns size of queue
  # @return [Integer]
  #
  def size
    queue.length
  end

  # Display elements in queue
  #
  def display
    puts "Queue :: #{queue.inspect}"
  end
end

queue = Queue.new
queue.enqueue(5)
queue.enqueue(6)
queue.enqueue(7)
queue.display
puts queue.peek
puts queue.dequeue
puts queue.size
puts queue.empty?
puts queue.dequeue
queue.display
puts queue.dequeue
queue.display
