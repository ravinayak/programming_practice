# frozen_string_literal: true

# Implement stack
#
class Stack
  attr_accessor :stack

  def initialize
    @stack = []
  end

  # Push element on to stack
  # @param [Integer] data
  # @return [NIL]
  #
  def push(data:)
    stack.push(data)
  end

  # Pop element from stack
  # @return [Integer|nil]
  #
  def pop
    if empty?
      puts 'Stack is Empty'
      return nil
    end
    stack.pop
  end

  # Returns element at top of stack without removing it
  # @return [Integer|nil]
  #
  def peek
    stack.last
  end

  # Size of stack
  # @return [Integer]
  #
  def size
    stack.size
  end

  # Returns true if stack is empty
  # @return [Boolean]
  #
  def empty?
    stack.empty?
  end

  # Display all elements in stack
  #
  def display
    puts "Stack :: #{stack.inspect}"
  end
end

# st = Stack.new
# st.push(data: 1)
# st.push(data: 2)
# st.push(data: 3)
# st.display
# puts "Peek :: #{st.peek}"
# puts "Pop :: #{st.pop}"
# puts "Pop :: #{st.pop}"
# st.display
