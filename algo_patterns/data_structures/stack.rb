# Class Stack - Implements stack using array and index
class Stack
  attr_accessor :arr, :index

  def initialize
    @arr = []
    @index = -1
  end

  def empty?
    index == -1
  end

  def push(data:)
    @index += 1
    @arr[index] = data
  end

  def pop
    return nil if empty?

    top_element = element_at_top
    @index -= 1
    top_element
  end

  def element_at_top
    @arr[index]
  end

  def peek
    element_at_top
  end

  def size
    # Precautionary measure although when empty, index = -1
    # and will add upto 0 to give correct answer
    return 0 if empty?

    # Since arrays are zero index based, if there is 1 element
    # index = 0
    index + 1
  end

  def display
    return if empty?

    stack_index = index
    while stack_index >= 0
      print "#{arr[stack_index]} "
      stack_index -= 1
    end
  end
end

def test
  st = Stack.new
  st.push(data: 1)
  st.push(data: 2)
  st.push(data: 3)
  st.push(data: 100)
  print "\nDisplaying Stack elements :: "
  st.display
  puts
  puts "Size :: #{st.size}"
  puts "Peek :: #{st.peek}"
  puts "Pop :: #{st.pop}"
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
  puts
  puts "Stack Pop :: #{st.pop}"
end

test
