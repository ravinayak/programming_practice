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
    begin
      raise StandardError, 'Stack is Empty' if empty?
    rescue StandardError => e
      puts e.inspect
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

def test
  st = Stack.new
  st.push(data: 1)
  st.push(data: 2)
  st.push(data: 3)
  st.display
  puts "Peek :: #{st.peek}"
  puts "Pop :: #{st.pop}"
  puts "Pop :: #{st.pop}"
  puts "Pop :: #{st.pop}"

  # puts "All elements removed from stack, should be empty :: \n #{st.display}"
  # Line above prints the following output:
  # Stack :: []
  # All elements removed from stack, should be empty ::
  # st.display output is printed before printing the line given in puts

  # The reason why st.display is called first and the statement is printed second in
  # code is due to the behavior of puts and the Ruby method call st.display.

  # Understanding Ruby Execution
  # 1. Method Call Execution:
  #     a. When you write puts "All elements removed from stack, should be empty :: \n #{st.display}",
  #        Ruby first needs to evaluate the interpolation #{st.display} inside the string.
  #     b. To do this, Ruby calls the display method on the st object.
  # 2. Method display Output:
  #     a. The display method prints Stack :: #{stack.inspect} to the console.
  #     b. This output is immediately printed when the method is called.
  # 3. String Interpolation:
  #     a. After the display method is called, it returns nil (because puts inside display returns nil).
  #     b. The interpolation #{st.display} is replaced with nil in the original puts statement.
  # 4. Final puts Execution:
  #     a. The puts then prints the final interpolated string
  #        "All elements removed from stack, should be empty :: \n " to the console.
  #     b. This results in the display method output being printed first, followed by the rest of your
  #        puts statement.
  puts 'All elements have been removed from Stack, and so it should be empty as displayed below ::'
  st.display
  st.pop
end

# test
