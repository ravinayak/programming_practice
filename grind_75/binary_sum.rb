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
# the same rules
#  Adding "1110", "11011011" can be tricky because 1st string has 4 digits
# while 2nd string has 8 digits. Beyond 4 digits, if there is no carry, we
# can simply append the remaining part of 2nd string. If there is carry, we
# can continue to perform binary math assuming 1st string has 0 in its digit
# place without affecing the result

# Binary Sum is essential a sum of three digits:
# a. char of string 1  b. char of string 2  c. carry

# Explanation:
#    
#    carry:             0/1    0/1    0/1    0/1    0/1    0/1    0/1    0/1
#    char(string 1):     0      0      0      0      0      0      0      0
#    char(string 2):     1      1      0      1      1      0      1      1
# We have initialized 1st 4 digits as "0" for string 1, and carry can be 0/1
# We perform a 3-way sum of these digits according to the rules defined above

# 
# @param [String] binary_str1
# @param [String] binary_str2
# @return [String]
#
def binary_sum(binary_str1:, binary_str2:)


end
