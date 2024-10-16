# frozen_string_literal: true

# Stack ImplementationWithoutUsingInBuiltRuby Methods
class StackWithoutRubyMethods
  attr_accessor :stack, :size

  # Size points to the index in arr where we are about
  # to insert elements, and is always 1 greater than
  # the actual size of array,
  # Only 1 element => size = 1 => Last element = stack[0]
  # Only 5 elements => size = 5 => Last element = stack[4]
  # top_element would be at stack[size - 1]
  # pop would also remove stack[size - 1]
  # Size points to an index which is greater than the index
  # of last element in stack
  def initialize
    @stack = []
    @size = 0
  end

  def push(data:)
    @stack[size] = data
    @size += 1
  end

  def empty?
    size.zero?
  end

  def pop
    return stack_empty_error if empty?

    root_element = stack[size - 1]
    @size -= 1
    root_element
  end

  def peek
    top_element
  end

  def top_element
    return stack_empty_error if empty?

    stack[size - 1]
  end

  def display
    return stack_empty_error if empty?

    print ' Displaying stack elements :: '
    (size - 1).downto(0).each do |index|
      print " #{stack[index]} "
    end
    print "\n"
  end

  private

  def stack_empty_error
    puts ' Stack Empty Error'
    nil
  end
end

def test
  st = StackWithoutRubyMethods.new
  st.push(data: 1)
  st.push(data: 2)
  st.push(data: 3)
  st.display
  puts " Peek :: #{st.peek}"
  puts " Pop :: #{st.pop}"
  puts " Pop :: #{st.pop}"
  puts " Pop :: #{st.pop}"
  puts ' All elements have been removed from Stack, and so it should be empty ::'
  st.display
  st.pop
end

test
