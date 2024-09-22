# frozen_string_literal: true

require 'minitest/autorun'
require_relative 'rpn_evaluator'

# Test class for Reverse Polish Evaluator Class
# Minitest is a testing framework for Ruby that provides a complete
# suite of testing facilities. It's known for its simplicity and ease
# of use, offering a straightforward syntax for writing tests
# Minitest::Test is the base class for unit tests in Minitest, providing
# methods for assertions and test organization
# By inheriting from Minitest::Test, this class gains access to all the
# testing capabilities provided by Minitest
class RPNEvaluatorTest < Minitest::Test
  def setup
    @evaluator = RPNEvaluator.new
  end

  def test_simple_addition
    assert_equal 3, @evaluator.evaluate(expression: '1 2 +')
  end

  def test_complex_expression
    assert_equal 14, @evaluator.evaluate(expression: '5 1 2 + 4 * + 3 -')
  end

  def test_trigonometric_functions
    # This line tests the sine function in the RPNEvaluator
    # It asserts that the sine of 90 degrees is approximately equal to 1
    # The 'assert_in_delta' method is used because floating-point calculations can have small rounding errors
    # It checks if the result is within 0.0001 of the expected value (1)
    # This allows for a small margin of error in the calculation
    assert_in_delta 1, @evaluator.evaluate(expression: '90 sin'), 0.0001
    assert_in_delta(-1, @evaluator.evaluate(expression: '180 cos'), 0.0001)
    assert_in_delta 1, @evaluator.evaluate(expression: '45 tan'), 0.0001
  end

  def test_exponentiation
    assert_equal 125, @evaluator.evaluate(expression: '5 3 ^')
  end

  def test_division
    assert_equal 5, @evaluator.evaluate(expression: '15 3 /')
  end

  def test_multiplication
    assert_equal 300, @evaluator.evaluate(expression: '30 10 *')
  end

  def test_invalid_expression
    assert_raises(InvalidExpressionError) { @evaluator.evaluate(expression: '14 12 3 +') }
  end

  def test_unknown_token
    assert_raises(InvalidTokenError) { @evaluator.evaluate(expression: '51 62 $') }
  end

  def test_insufficient_operands
    assert_raises(InsufficientOperandsError) { @evaluator.evaluate(expression: '181 +') }
  end
end
