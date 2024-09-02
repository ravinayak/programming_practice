# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/stack'
# You are given an array of strings tokens that represents an arithmetic
# expression in a Reverse Polish Notation.

# Evaluate the expression. Return an integer that represents the value of
# the expression.

# Note that:

# The valid operators are '+', '-', '*', and '/'.
# Each operand may be an integer or another expression.
# The division between two integers always truncates toward zero.
# There will not be any division by zero.
# The input represents a valid arithmetic expression in a reverse polish
# notation.
# The answer and all the intermediate calculations can be represented in
# a 32-bit integer.

# Example 1:
# Input: tokens = ["2","1","+","3","*"]
# Output: 9
# Explanation: ((2 + 1) * 3) = 9

# Example 2:
# Input: tokens = ["4","13","5","/","+"]
# Output: 6
# Explanation: (4 + (13 / 5)) = 6

# Example 3:
# Input: tokens = ["10","6","9","3","+","-11","*","/","*","17","+","5","+"]
# Output: 22
# Explanation: ((10 * (6 / ((9 + 3) * -11))) + 17) + 5
# = ((10 * (6 / (12 * -11))) + 17) + 5
# = ((10 * (6 / -132)) + 17) + 5
# = ((10 * 0) + 17) + 5
# = (0 + 17) + 5
# = 17 + 5
# = 22

# Algorithm: Reverse Polish Notation is actually Postfix Notation. To solve
# this problem, we use a stack and push every operand onto stack. When we
# encounter any operator, we pop 2 elements from stack, perform the
# required operation (if it is a binary operator), and push the result onto
# stack.
# In Polish Notation, always remember that the operator is applied to
# operands in a particular sequence
# Ex: ["6", "2", "/"] => 6 / 2
# Ex: ["6", "2", "+"] => 6 + 2
# Ex: ["6", "2", "-"] => 6 - 2
# Order of determining operators is important because it can change the
# result of operation
# Ex: ["6", "2", "+"] => [6, 2] in Stack
#    => 1st element popped from stack => Right operand (Oprerand after operator)
#    => 2nd element popped from stack => Left Operand (Operand before operator)
# Left Operand, Operator, Right Operand (applied in this sequence)
# 2nd Element popped from stack, Operator, 1st element popped from stack

# For Postfix expression,
# 2nd Pop, Operator, 1st Pop
# 1st Pop goes right
# 2nd Pop goes left
# L2 Operator R1 => Left (2nd Pop) Operator Right (1st Pop)

# For division, problem statement has some rules:
# 1. division by 0 is not allowed, if a or b = 0, result = 0
# 2. division is always done with result truncating towards 0, this means
#    that we discard the fractional part and only include the whole number

# @param [Array] input_arr
# @return [Integer] result
#
def evaluate_rp_notation(input_arr:)
  return nil if input_arr.empty?

  allowed_operators = %w[+ - * /]
  st = Stack.new
  result = nil

  input_arr.each do |element|
    unless allowed_operators.include?(element)
      st.push(data: element.to_i)
      next
    end

    right_operand = st.pop
    left_operand = st.pop

    # In Ruby, when we use a case statement, only "when" that matches is
    # executed. Rest of "when" are not executed, so we do not have to use
    # any explicit break, this will cause to break out of the loop which
    # contains case/when statement
    case element

    when '+'
      result = left_operand + right_operand
    when '-'
      result = left_operand - right_operand
    when '*'
      result = left_operand * right_operand
    when '/'
      if right_operand.zero? || left_operand.zero?
        result = 0
      else
        result = left_operand / right_operand
      end
    end
    st.push(data: result)
  end

  # Return result
  result
end

def test
  input_arr_hsh = [
    {
      input_arr: ['2', '1', '+', '3', '*'],
      output: 9
    },
    {
      input_arr: ['4', '13', '5', '/', '+'],
      output: 6
    },
    {
      input_arr: ['10', '6', '9', '3', '+', '-11', '*', '/', '*', '17', '+', '5', '+'],
      output: 22
    }
  ]

  input_arr_hsh.each do |input_hsh|
    print "\n Input Arr :: #{input_hsh[:input_arr]}"
    print "\n Expected Res :: #{input_hsh[:output]}, "
    print "Result :: #{evaluate_rp_notation(input_arr: input_hsh[:input_arr])}\n\n"
  end
end

test
