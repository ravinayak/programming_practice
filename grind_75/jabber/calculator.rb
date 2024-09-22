# frozen_string_literal: true

# Calculator Class Implementation
class Calculator
  attr_accessor :value

  def new
    Calculator.allocate
  end

  # Methods to calculate zero, one, two,..., nine

  def zero
    apply_operation(number: 0)
  end

  def one
    apply_operation(number: 1)
  end

  def two
    apply_operation(number: 2)
  end

  def three
    apply_operation(number: 3)
  end

  def four
    apply_operation(number: 4)
  end

  def five
    apply_operation(number: 5)
  end

  def six
    apply_operation(number: 6)
  end

  def seven
    apply_operation(number: 7)
  end

  def eight
    apply_operation(number: 8)
  end

  def nine
    apply_operation(number: 9)
  end

  def ten
    apply_operation(number: 10)
  end

  # Operations

  def plus
    @operation = :+
    self
  end

  def minus
    @operation = :-
    self
  end

  def multiply
    @operation = :*
    self
  end

  def divide
    @operation = :/
    self
  end

  def apply_operation(number:)
    begin
      if @operation
        result = @value.send(@operation, number)
        puts "Output :: #{result}"
        @operation = nil
        @value = nil
      else
        @value = number
      end
    rescue StandardError => e
      puts "An exception occurred :: #{e.message}"
    end
    self
  end
end

Calculator.new.one.plus.nine
Calculator.new.nine.minus.ten
Calculator.new.eight.multiply.seven
Calculator.new.nine.divide.three
Calculator.new.one.divide.zero
