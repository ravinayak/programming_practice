# Given a string s representing a valid expression, implement
# a basic calculator to evaluate it, and return the result of
# the evaluation.

# NOTE: You are not allowed to use any built-in function which
# evaluates strings as mathematical expressions, such as eval().

# Example 1:
# Input: s = "1 + 1"
# Output: 2

# Example 2:
# Input: s = " 2-1 + 2 "
# Output: 3

# Example 3:
# Input: s = "(1+(4+5+2)-3)+(6+8)"
# Output: 23

# Algorithm: The algorithm works as follows:
# 1. Parse the current input
# 2. curr_num = 0, curr_res = 0, sign = 1
# 3. Initialize sign = 1 assuming +ve sign unless we find a unary - sign
# 4. If it is a digit, curr_num = curr_num * 10 + digit
# 5. If it is an operator, it can be +, -, (, )
# 6. Whenever we encounter an operator in [+, -, (], we multiply sign with curr_num to
#    get the correct representation of curr_num
# 7. Remember the sign corresponds to curr_num
#    1 + ( 2 - 3) => sign = 1, curr_num = 0,
#    a. 1st iteration we find 1 => curr_num = curr_num * 0 + digit = 1
#    b. 2nd iteration we find + => curr_res = curr_res + sign * curr_num
#    c. Here sign corresponds to sign of curr_num, so we multiply with it to get
#    signed representation of curr_num
#    d. When we use curr_num to calculate curr_res, we reset curr_num = 0 because it
#    has been processed
# 8. When we encounter operator "(", we reset everything by pushing current state to
#    stack
#    a. 1 + ( 2 - 3)
#    b. 2nd iteration =>  curr_res = 0 + 1 * 1 = 1
#    c. sign = 1 of curr_res
#    d. curr_res = 1
#    e. stack.push(curr_res)
#    f. stack.push(sign)
#    g. Reset sign = 1, curr_res = 0, because we are going to start evaluating a new
#    expression
# 9. When we encounter operator ")", we perform the operation to compute result of
#    expression inside parentheses and also pop stack to compute result of previous
#    expression before opening parentheses
#    Popping stack and computing previous result is necessary because ")" marks the end
#    of all expressions until its existence
#    If there is an opening parentheses, there must have been some expression before it
#    (a + b) is not valid input, 2 + (a * b) is valid input
#    ")" => End of everything before ")" => Compute result of all results before ")"
# 10. At the end, there could be curr_res and curr_num which have not been processed yet,
#    hence we process one last even when we have processed the entire string. This is
#    because,
#      curr_res = Evaluated only when we see an operator or ")"
#         1 - (4 - 2) - 5:
#     a. State when "4" is evaluated: stack = [1, -1], curr_num = 4, curr_res = 0
#     b. When we encounter -, we evaluate curr_num by multiplying it with sign which
#     corresponds to it to get signed representation of curr_num
#       => curr_res = curr_res + sign * curr_num = 0 + 4 * 1 = 4, curr_num = 0, sign = -1
#     c. When we encounter 2, curr_num = 2
#     d. When we encounter ")",
#        => curr_res = curr_res + sign * curr_num = 4 + 2 * -1 = 4 - 2 = 2
#        => curr_num = 0
#        => We process stack, [1, -1]
#        => curr_res = curr_res * stack.pop (sign in stack corresponds to sign before parentheses)
#        => curr_res = 2 * -1 = -2
#        => curr_res += stack.pop => curr_res = curr_res + 1 = -2 + 1 = -1
#     e. When we encounter "-" sign, we process it
#        => sign = -1, curr_num = 0, curr_res = -1
#        => curr_res += sign * curr_num => curr_res = -1 + -1 * 0 = -1, sign = -1
#    f. When we encounter "5", we process it to get, curr_num = 5
#    g. String has finished, but curr_res and curr_num have not been processed, hence we
#    evaluate even when string has finished
#    h. curr_res = curr_res + sign * curr_num = -1 + (-1) * 5 = -1 - 5 = -6
def basic_calculator(input_str:)
  curr_res = 0
  curr_num = 0
  sign = 1
  stack = []

  input_str.chars.each do |input_char|
    # If input_str is an empty space, we simply skip it
    next if input_char.strip == ''

    # /\d+/ is unnecessary because we are processing individual characters and hence we should
    # check for only single digit
    if input_char =~ /\d/
      # This is necessary to parse digits like 123
      # 1 => curr_num = 0 * 10 	+ 1 = 1
      # 2 => curr_num = 1 * 10 	+ 2 = 12
      # 3 => curr_num = 12 * 10 + 3 = 123
      curr_num = curr_num * 10 + input_char.to_i
    elsif input_char == '+'
      # Process curr_num by converting it into its
      # signed representation by multiplying with the
      # sign which corresponds to curr_num
      curr_res += sign * curr_num
      # Reset curr_num, allocate sign for next operation
      curr_num = 0
      sign = 1
    elsif input_char == '-'
      curr_res += sign * curr_num
      curr_num = 0
      sign = -1
    elsif input_char == '('
      # sign, curr_res pushed onto stack to save state
      # before parentheses
      # order of pushing is important because we process in the
      # same order when we pop from stack
      stack.push(curr_res)
      stack.push(sign)

      # Reset curr_res and sign
      curr_res = 0
      sign = 1
    elsif input_char == ')'
      # 1st process the curr_num
      curr_res += sign * curr_num
      # Reset curr_num
      curr_num = 0
      # Pop elements from stack and process them with
      # curr_res
      curr_res *= stack.pop
      curr_res += stack.pop
      # Although not required, we still reset sign because
      # logically it makes sense
      # sign value carried over from previous operation has no
      # effect because we have reset curr_num to 0 which
      # neutralizes '-' sign
      sign = 1
    end
  end

  curr_res += sign * curr_num

  # Return curr_res
  curr_res
end

def input_arr
  [
    {
      input_str: '1 + 1',
      output: 2
    },
    {
      input_str: ' 2-1 + 2 ',
      output: 3
    },
    {
      input_str: '(1+(4+5+2)-3)+(6+8)',
      output: 23
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    res = basic_calculator(input_str: input_hsh[:input_str])
    print "\n\n Input string    :: #{input_hsh[:input_str]}"
    print "\n Expected Output :: #{input_hsh[:output]}"
    print "\n Result          :: #{res} \n"
  end
  print "\n"
end

test
