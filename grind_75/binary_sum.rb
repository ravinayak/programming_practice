# frozen_string_literal: true

# Given two binary strings a and b, return their sum as a binary string.

# Example 1:
# Input: a = "11", b = "1"
# Output: "100"

# Example 2:
# Input: a = "1010", b = "1011"
# Output: "10101"

# This problem could potentially be solved using a hash which contains
# a mapping of binary math and map the result. However, this is quite
# complex. An easier solution would be to use the division/modulo by 2
# The concept is:
# 1. Binary Math can use the concept that if we divide by 2, we get the
# binary digit as modulo
#  2. Quotient is the carry even if we are using a "carry"
# Explanation:
#    a. carry: 0
#      1 + 0 + 0 = 1 => num = 1 % 2 = 1, carry = 1/2 = 0 = (same as 1)
#      0 + 1 + 0 = 1 => num = 1 % 2 = 1, carry = 1/2 = 0 = (same as 1)
#      1 + 1 + 0 = 2 => num = 2 % 2 = 0, carry = 2/2 = 1 = (same as 10)
#    b. carry: 1
#      1 + 0 + 1 = 2 => num = 2 % 2 = 0, carry = 2/2 = 1 = (same as 10)
#      0 + 1 + 1 = 2 => num = 2 % 2 = 0, carry = 2/2 = 1 = (same as 10)
#      1 + 1 + 1 = 3 => num = 3 % 2 = 1, carry = 3/2 = 1 = (same as 11)
# Here, num is the result of binary sum => i.e. binary digit and carry
# has usual meaning

# We also do not have to deal with which string is shorter and which string
# is longer when performing a binary sum if we use carry !=0 condition and
# simply use the non-available character of shorter string as 0,following
# the same rules. There is also a use case where both strings run out of
# length, and carry != 0, in this case, we can continue adding strings
# assuming they have 0 as digit, and use the sum identified above as
# result to append to output string

#  Adding "1110", "11011011" can be tricky because 1st string has 4 digits
# while 2nd string has 8 digits. Beyond 4 digits, if there is no carry, we
# can simply append the remaining part of 2nd string. If there is carry, we
# can continue to perform binary math assuming 1st string has 0 in its digit
# place without affecing the result

# Binary Sum is essential a sum of three digits:
# a. char of string 1  b. char of string 2  c. carry

# Also the strings must be added started from LSB, which means that the
# string should be reversed, or we should use index from last in iteration

# Explanation:
#
#    carry:             0/1    0/1    0/1    0/1    0/1    0/1    0/1    0/1
#    char(string 1):     0      0      0      0      0      0      0      0
#    char(string 2):     1      1      0      1      1      0      1      1
# We have initialized 1st 4 digits as "0" for string 1, and carry can be 0/1
# We perform a 3-way sum of these digits according to the rules defined above

#
# @param [String] binary_str_one
# @param [String] binary_str_two
# @return [String]
#
def binary_sum(binary_str_one:, binary_str_two:)
  index_str_one = binary_str_one.length - 1
  index_str_two = binary_str_two.length - 1
  carry = 0
  result = ''

  # Perform a 3-way sum of binary digits unless both strings run out and carry
  # is not 0. Use or condition to ensure the 3-way sum is performed, using and
  # would only result in addition until the shorter string length
  while index_str_one >= 0 || index_str_two >= 0 || carry != 0
    bit_one = index_str_one.negative? ? 0 : binary_str_one[index_str_one].to_i
    bit_two = index_str_two.negative? ? 0 : binary_str_two[index_str_two].to_i

    total = bit_one + bit_two + carry

    carry = total / 2 # Remember that binary is 0, 1 which % 2
    bit_res = total % 2

    # Preprend the bit_res (binary number obtained as sum) to result instead of
    # appending to result. Essentially this adds result of each step as MSB in
    # a higher index position as compared to previous result, i.e. we go from
    # left to right
    # Ex: Consider 010 + 101 =>
    #  a. result = '1' + '' = '1' => chars at index 0 added, preprended to ''
    #  b. result = '1' + '1' = '11' => chars at index 1 dded, prepended to '1'
    #  c. result = '11' + '1' = '111' => chars at index 2 dded, prepended to '11'
    # If we appended, we would have to reverse the string. This is because we
    # are adding chars from the end of string, and result at each step is LSB
    # in iteration.
    # Appending => LSB to MSB => Reverse to get correct order => MSB to LSB
    # Prepending => MSB to LSB => Correct Order
    result = bit_res.to_s + result

    # Decrement indexes
    index_str_one -= 1
    index_str_two -= 1
  end

  # Return the result
  result
end

def test
  binary_arr = [
    { binary_str_one: '11', binary_str_two: '1', result: '100' },
    { binary_str_one: '1010', binary_str_two: '1011', result: '10101' },
    { binary_str_one: '1110', binary_str_two: '11111011', result: '100001001' }
  ]

  binary_arr.each do |binary_hsh|
    binary_str_one = binary_hsh[:binary_str_one]
    binary_str_two = binary_hsh[:binary_str_two]
    output = binary_hsh[:result]
    res = binary_sum(binary_str_one:, binary_str_two:)

    puts "Input Strings => str1 :: #{binary_str_one}, str2 :: #{binary_str_two}"
    puts "Expected Ouput :: #{output}, Result :: #{res}"
  end
end

test
