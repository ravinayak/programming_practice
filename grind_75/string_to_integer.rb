# frozen_string_literal: true

# Implement the myAtoi(string s) function, which converts a string to a
# 32-bit signed integer.

# The algorithm for myAtoi(string s) is as follows:

# Whitespace: Ignore any leading whitespace (" ").

# Signedness: Determine the sign by checking if the next character is '-' or '+',
# assuming positivity if neither present.

# Conversion: Read the integer by skipping leading zeros until a non-digit character
# is encountered or the end of the string is reached. If no digits were read, then the
# result is 0.

# Rounding: If the integer is out of the 32-bit signed integer range [-231, 231 - 1], then
# round the integer to remain in the range. Specifically, integers less than -231 should be
# rounded to -231, and integers greater than 231 - 1 should be rounded to 231 - 1.
# Return the integer as the final result.

# Example 1:
# Input: s = "42"
# Output: 42
# Explanation:

# The underlined characters are what is read in and the caret is the current reader position.
# Step 1: "42" (no characters read because there is no leading whitespace)
#          ^
# Step 2: "42" (no characters read because there is neither a '-' nor '+')
#          ^
# Step 3: "42" ("42" is read in)
#            ^
# Example 2:

# Input: s = " -042"
# Output: -42
# Explanation:

# Step 1: "   -042" (leading whitespace is read and ignored)
#             ^
# Step 2: "   -042" ('-' is read, so the result should be negative)
#              ^
# Step 3: "   -042" ("042" is read in, leading zeros ignored in the result)
#                ^
# Example 3:
# Input: s = "1337c0d3"
# Output: 1337
# Explanation:

# Step 1: "1337c0d3" (no characters read because there is no leading whitespace)
#          ^
# Step 2: "1337c0d3" (no characters read because there is neither a '-' nor '+')
#          ^
# Step 3: "1337c0d3" ("1337" is read in; reading stops because the next character is a non-digit)
#              ^
# Example 4:
# Input: s = "0-1"
# Output: 0
# Explanation:

# Step 1: "0-1" (no characters read because there is no leading whitespace)
#          ^
# Step 2: "0-1" (no characters read because there is neither a '-' nor '+')
#          ^
# Step 3: "0-1" ("0" is read in; reading stops because the next character is a non-digit)
#           ^
# Example 5:
# Input: s = "words and 987"
# Output: 0
# Explanation:
# Reading stops at the first non-digit character 'w'.

# Algorithm: To convert a string to integer with the above requirements, steps are
# Step 1: Trim the string for all leading empty whitespaces
# Step 2: Check for sign +/- at the 1st Index, if present, increment Index
# Step 3: Read the 1st character at Index, if it is non-digit, return 0 and break
# Step 4: If it is 0, add it to result
# Step 5: At every step multiple result by 10 and add the digit from next iteration
# Step 6: If we encounter any leading 0s, they will automatically be taken care of
#    => Result will be 0 in the beginnig, so adding leading 0s and * 10 will only give 0
#    => If any 0s are encountered in the mid, they will be added to the result, and when
#       multiplied by 10, they will increment 10s position which they should
# Step 7: If any non-digit is encountered, break from the loop
# Step 8: Multiply result by sign (+1/-1)
# Step 9: Return result

# @param [String] input_str
# @param [no_digit_found] Integer
# @return [Integer]
def atoi(input_str:, no_digit_found:)
  index = 0
  result = 0
  sign = 1
  str_trimmed = input_str.strip

  # If the string is empty after trimming, return 0
  return 0 if str_trimmed.empty?

  if str_trimmed[index] == '+' || str_trimmed[index] == '-'
    sign = -1 if str_trimmed[index] == '-'
    index += 1
  end

  digits_found = false

  (index...str_trimmed.length).each do |i|
    break if str_trimmed[i] < '0' || str_trimmed[i] > '9'

    digits_found = true
    result *= 10
    int_val = str_trimmed[i].ord - '0'.ord
    result += int_val
  end

  # If no digits are found, return 0
  return no_digit_found unless digits_found

  # Avoid un-necessary sign multiplication or range check when result = 0
  return 0 if result.zero?

  # Multiply with -1, if - sign was at 1st index or after leading whitespaces
  result *= sign

  # Range check for result
  result_in_range(result:)
end

# @param [Integer] result
# @return [Integer]
def result_in_range(result:)
  return (2**31) - 1 if result > (2**31) - 1

  return -(2**31) if result < -(2**31)

  result
end

def str_int_arr
  [
    {
      input_str: '42',
      output: 42
    },
    {
      input_str: ' -042',
      output: -42
    },
    {
      input_str: '1337c0d3',
      output: 1337
    },
    {
      input_str: ' 0-1',
      output: 0
    },
    {
      input_str: '000-123',
      output: 0
    },
    {
      input_str: 'www123',
      output: -1
    }
  ]
end

def test
  str_int_arr.each do |str_output|
    input_str = str_output[:input_str]
    output = str_output[:output]
    result = atoi(input_str:, no_digit_found: -1)

    print "\nInput Str :: #{input_str}, Output :: #{output}, Result :: #{result}"
  end
  print "\n\n"
end

test
