# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/stack'
# Given a string s containing just the characters '(', ')', '{', '}', '[' and ']',
# determine if the input string is valid.

# An input string is valid if:

# Open brackets must be closed by the same type of brackets.
# Open brackets must be closed in the correct order.
# Every close bracket has a corresponding open bracket of the same type.

# Use a stack and hash data structure

CHAR_HASH = {
  ')' => '(',
  '}' => '{',
  ']' => '['
}.freeze

# Algorithm is simple
#   1. Parse string character by character
#   2. If character is an opening tag, push onto stack and move to next iteration
#   3. If character is not an opeing tag, it can be a closing tag or just a character
#   4. If character is a closing tag,
#       => Check stack is empty => If empty, no opening tag for this closing tag =>
#             => Invalid => RETURN
#       => Pop stack => Check if value for closing tag in hash is same as popped element
#             => Not same => Invalid => RETURN
#   5. Move to next iteration
#   6. At the end, stack should be empty => Not Empty => Invalid => RETURN

# @param [String] input_str
# @return [Boolean]
#
def valid_parentheses?(input_str:)
  st = Stack.new
  index = 0

  while index < input_str.length
    input_char = input_str[index]

    # Increment Index at start to prevent infinite loop
    # NOTE: Good practice as we may forget later
    index += 1

    # Encountered an opening tag, push it onto stack
    if CHAR_HASH.values.include?(input_char)
      st.push(data: input_char)
      next
    end

    # input_char is a character other than a tag - not opening/closing tag
    next unless CHAR_HASH.keys.include?(input_char)

    # input_char is a closing tag
    closing_tag = CHAR_HASH[input_char]

    # If input_char is not one of the closing tags in hash keys, value will be nil
    # Raise an Argument Error if closing tag is not valid
    raise ArgumentError, 'Invalid Input: Unrecognized closing tag' if closing_tag.nil?

    # Encountered a closing tag but no opening tag exists because stack is empty
    return false if st.empty?

    stack_char = st.pop

    # This checks the order and same typeness of tags, every opening tag must have a
    # corresponding closing tag in the same order as opening tag.
    # If Closing tag encountered does not have a corresponding opening tag, they won't match
    #   => Invalid parentheses
    return false unless stack_char == closing_tag
  end

  # If all opening tags have closing tags - valid parentheses - stack should have popped
  # all elements and it should be emptyl. If not, we have more opening tags than closing
  # tags
  return false unless st.empty?

  # All cases covered, string has valid parentheses
  true
end

valid_str = 'Valid parentheses'

input_str = '()'
puts "Input String :: #{input_str.inspect} \t \t #{valid_str} :: #{valid_parentheses?(input_str:)}"

input_str = '()[]{}'
puts "Input String :: #{input_str.inspect} \t \t #{valid_str} :: #{valid_parentheses?(input_str:)}"

input_str = '(]'
puts "Input String :: #{input_str.inspect} \t \t #{valid_str} :: #{valid_parentheses?(input_str:)}"

input_str = '({abc[def]gh}ij)'
puts "Input String :: #{input_str.inspect} \t \t #{valid_str} :: #{valid_parentheses?(input_str:)}"

input_str = '({abc[def]gh}ij)))'
puts "Input String :: #{input_str.inspect} \t \t #{valid_str} :: #{valid_parentheses?(input_str:)}"

input_str = '({abc[def]gh)ij}'
puts "Input String :: #{input_str.inspect} \t \t #{valid_str} :: #{valid_parentheses?(input_str:)}"

input_str = '{abc[def]gh}ij}'
puts "Input String :: #{input_str.inspect} \t \t #{valid_str} :: #{valid_parentheses?(input_str:)}"
# Example 1:

# Input: s = "()"
# Output: true
# Example 2:

# Input: s = "()[]{}"
# Output: true
# Example 3:

# Input: s = "(]"
# Output: false
