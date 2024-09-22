# frozen_string_literal: true

# Define Standard Errors
class InvalidTokenError < StandardError; end
class InsufficientOperandError < StandardError; end
class InvalidExpressionError < StandardError; end
class DivideByZeroError < StandardError; end

# Algorithm: '5 1 2 + 4 * + 3 -' is the Reverse Polish Notation
# or Postfix expression
# Step 1: Scan string from left to right
# Step 2: If operand, push onto stack
# Step 3: If operator, pop stack and perform operation
#   => Top goes right => When we encounter an operator, we pop
#   => stack, top element is 2nd operand, element below top
#   => is 1st operand
#   => operand_one operator operand_two = 2 - 5
#   => 2 = operand_one (below top), 5 = operand_two (top)
#   => 2 (left) - 5 (right) = top goes right => top = operand_two
#   => operand_one comes 1st, then operator, then operand_two (2nd)
#
# RPN Evaluator Class
class RPNEvaluator
  ARITHMETIC_OPERATORS = %w[+ - * / ^].freeze
  TRIGONOMETRIC_OPERATORS = %w[sin cos tan].freeze
  ALLOWED_OPERATORS = ARITHMETIC_OPERATORS + TRIGONOMETRIC_OPERATORS

  # This regex pattern matches numeric values:
  # ^ - Start of the string
  # [-+]? - Optional sign (+ or -)
  # \d* - Zero or more digits
  # \.? - Optional decimal point
  # \d+ - One or more digits
  # $ - End of the string
  # value = 1 matches
  #   => [No +/-, \d* - consider 0 digits, \.? - consider 0 decimal, \d+ = 1] = 1
  # value = 12 matches
  #   => [No +/-, \d* - consider 1 digit(=1), \.? - consider 0 decimal, \d+ = 2] = 12
  # value = 1.2 matches
  #   => [No +/-, \d* - consider 1 digit(=1), \.? - consider 1 decimal (.), \d+ = 2] = 1.2
  NUMERIC_PATTERN = /^[+-]?\d*\.?\d+/

  attr_accessor :stack

  def initialize
    @stack = []
  end

  # @param [String] expression
  # @return [Integer]
  def evaluate(expression:)
    tokenize(expression:).each do |token|
      process_token(token:)
    end

    validate_result

    stack.pop
  end

  private

  def validate_result
    raise InvalidExpressionError, 'Expression Invalid' if stack.size != 1
  end

  # @param [string] expression
  # @return [Array]
  def tokenize(expression:)
    expression.split(' ')
  end

  # @param [String] token
  # @return [Integer]
  def process_token(token:)
    return process_numeric_token(token:) if numeric_token?(token:)

    return process_operator_token(token:) if operator_token?(token:)

    raise InvalidTokenError, 'Unknown Token'
  end

  # @param [String] token
  # @return [Boolean]
  def process_numeric_token(token:)
    stack.push(token.to_f)
  end

  # @param [String] token
  # @return [NIL]
  def process_operator_token(token:)
    return process_trigonometric_operation(operator: token) if
      trigonometric_operator?(operator: token)

    return process_arithmetic_operation(operator: token) if
      arithmetic_operator?(operator: token)

    raise InvalidExpressionError, 'Unknown operator'
  end

  # @param [String] operator
  def process_trigonometric_operation(operator: token)
    operand = stack.pop
    raise InsufficientOperandError, 'Insufficient Operands' unless operand

    result = evaluate_trigonometric_operation(operator:, operand:)
    stack.push(result)
  end

  def evaluate_trigonometric_operation(operator:, operand:)
    radians = degrees_to_radians(degrees: operand)

    case operator

    when 'sin'
      Math.sin(radians)
    when 'cos'
      Math.cos(radians)
    when 'tan'
      Math.tan(radians)
    end
  end

  # @param [String] operator
  def process_arithmetic_operation(operator: token)
    operand_two = stack.pop
    operand_one = stack.pop

    raise InsufficientOperandError, 'Insufficient Operands' unless
      operand_one && operand_two

    result = evaluate_arithmetic_operation(operator:, operand_one:, operand_two:)
    stack.push(result)
  end

  # @param [String] operator
  # @param [String] operand_one
  # @param [String] operand_two
  def evaluate_arithmetic_operation(operator:, operand_one:, operand_two:)
    case operator

    when '+'
      operand_one + operand_two
    when '^'
      operand_one**operand_two
    when '-'
      operand_one - operand_two
    when '*'
      operand_one * operand_two
    when '/'
      raise DivideByZeroError, 'Divide by Zero' if operand_two.zero?

      operand_one / operand_two
    end
  end

  # @param [String] token
  # @return [Boolean]
  def numeric_token?(token:)
    NUMERIC_PATTERN.match?(token.to_s)
  end

  # @param [String] token
  # @return [Boolean]
  def operator_token?(token:)
    ALLOWED_OPERATORS.include?(token)
  end

  # @param [String] operator
  # @return [Boolean]
  def trigonometric_operator?(operator:)
    TRIGONOMETRIC_OPERATORS.include?(operator)
  end

  # @param [String] operator
  # @return [Boolean]
  def arithmetic_operator?(operator:)
    ARITHMETIC_OPERATORS.include?(operator)
  end

  # @param [String] degrees
  # @return [String]
  def degrees_to_radians(degrees:)
    degrees * Math::PI / 180
  end
end

# Test cases for the RPNEvaluator class
# This code will run only when the file is executed directly and not when the
# class is imported into another module
if __FILE__ == $PROGRAM_NAME
  def run_tests
    evaluator = RPNEvaluator.new

    puts "Test 1 (Simple addition): #{evaluator.evaluate(expression: '13 24 +') == 37}"
    puts "Test 2 (Complex mixed operators): #{evaluator.evaluate(expression: '5 1 2 + 4 * + 3 -') == 14}"
    puts "Test 3 (Multiplication and addition): #{evaluator.evaluate(expression: '2 3 14 + *') == 34}"
    puts "Test 4 (Power operation): #{evaluator.evaluate(expression: '3 5 ^') == 243}"
    trig_sin = evaluator.evaluate(expression: '90 sin').round(10) == Math.sin(Math::PI / 2).round(10)
    puts "Test 5 (Trigonometric function - sin): #{trig_sin}"
    trig_cos = evaluator.evaluate(expression: '60 cos').round(10) == Math.cos(Math::PI / 3).round(10)
    puts "Test 6 (Trigonometric function - cos): #{trig_cos}"
    trig_tan = evaluator.evaluate(expression: '45 tan').round(10) == Math.tan(Math::PI / 4).round(10)
    puts "Test 7 (Trigonometric function - tan): #{trig_tan}"
    puts "Test 8 (Negative number handling): #{evaluator.evaluate(expression: '-31 4 *') == -124}"
    puts "Test 9 (Division): #{evaluator.evaluate(expression: '125 5 /') == 25}"
    exp_exp = evaluator.evaluate(expression: '14 4 -3 ^ *') == 14 * 4**-3
    puts "Test 10 (Complex negative exponent): #{exp_exp}"
  end

  run_tests
end
