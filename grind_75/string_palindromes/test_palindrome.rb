# frozen_string_literal: true

# This function checks if a string is palindrome without using
# reverse method, many interviewers ask for such implementation
# Easiest way to check if a string is a Palindrome is to check
# 	str == str.reverse

# @param [STring] str
# @return [Boolean]
def test_for_palindrome?(str:)
  # Base Case
  return true if str.empty? || str.length == 1

  return even_len_str_palindrome?(str:) if str.length.even?

  odd_len_str_palindrome?(str:) if str.length.odd?
end

# Test for Palindrome using reverse method
# @param [String] str
# @return [Boolean]
def test_palindrome_using_reverse?(str:)
  # Base Case: str is empty length or has a length of 1
  return true if str.empty? || str.length == 1

  end_idx = str.length - 1
  start_idx = 0

  while start_idx <= end_idx
    return false unless str[start_idx] == str[end_idx]

    start_idx += 1
    end_idx -= 1
  end

  true
end

# Algorithm: For an even length string, to check for palindrome
# input_str = "abba" => len = 4, we start at mid
#   => mid = (str.length / 2) - 1 = 1
#   => If length is n, mid = floor((n - 1) / 2)
#   => mid element is actually a pair [floor((n - 1)/ 2), floor((n - 1)/ 2) + 1]
#   => For n = 4, mid = [arr[1], arr[2]]
# To check for string to be a Palindrome, we have to compare characters at the
# following indices
#   1. (mid), (mid + 1)       => Diff between index1, index2 = 1 = 1 + 0 * 2
#   2. (mid - 1), (mid + 2)    => Diff between index1, index2 = 3 = 1 + 1 * 2
#   3. (mid - 2), (mid + 3)    => Diff between index1, index2 = 5 = 1 + 2 * 2
#   4. (mid - 3), (mid + 4)   => Diff between index1, index2 = 7 = 1 + 3 * 2
# Step 1: Start at mid = (x), i = 0
# Step 2: index_to_compare = x + (1 + i * 2)
# Step 3: if arr[x] != arr[index_to_compare] return false
# Step 4: i += 1
# Step 5: x -= 1
# Step 6: End of Iteration: Return true

# Returns if even length string is palindrome
# @param [String] str
# @return [Boolean]
def even_len_str_palindrome?(str:)
  # Actual calculation should be Math.floor((str.length - 1)/ 2)
  mid = (str.length / 2) - 1
  t = 0
  mid.downto(0).each do |i|
    k = i + (1 + t * 2)
    return false unless str[i] == str[k]

    t += 1
  end

  # Elements at required indices are equal
  true
end

# Algorithm: For an even length string, to check for palindrome
# input_str = "abdba" => len = 5, we start at mid
#   => mid = (str.length / 2)
#   => Because it has odd length, the string will be split in 2 equal halves around "mid"
#   => We dont have to compare 'mid', because it does not pair with any other element
#   => If length is n, mid = Math.floor(n/2)
#   => mid = Math.floor(n/2) = (n/2) in ruby because Ruby will give only the integer part
#   => mid element is actually a single element = arr[mid]
#   => For n = 5, mid = (5/2) = 2
# To check for string to be a Palindrome, we have to compare characters at the
# following indices
#    1. (mid - 1), (mid + 1)    => Diff between index1, index2 = 2 = 1 * 2
#    2. (mid - 2), (mid + 2)    => Diff between index1, index2 = 4 = 2 * 2
#    3. (mid - 3), (mid + 3)   => Diff between index1, index2 = 6 = 3 * 2
# Step 1: Start at mid = (x), i = 1
# Step 2: index_to_compare = x + (i * 2)
# Step 3: if arr[x] != arr[index_to_compare] return false
# Step 4: i += 1
# Step 5: x -= 1
# Step 6: End of Iteration: Return true

# Returns if odd length string is palindrome
# @param [String] str
# @return [Boolean]
def odd_len_str_palindrome?(str:)
  mid = str.length / 2
  t = 1

  (mid - 1).downto(0).each do |i|
    k = i + t * 2
    return false if str[i] != str[k]

    t += 1
  end

  true
end

def input_arr
  [
    {
      str: 'abcddcba',
      output: true
    },
    {
      str: 'abcba',
      output: true
    },
    {
      str: 'abcdeedcba',
      output: true
    },
    {
      str: 'tbcdeedcba',
      output: false
    },
    {
      str: 'abcbt',
      output: false
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    result = test_for_palindrome?(str: input_hsh[:str])
    res_reverse = test_palindrome_using_reverse?(str: input_hsh[:str])
    print "\n String :: #{input_hsh[:str]}, Expected :: #{input_hsh[:output]}, "
    print " Result :: #{result}, Result using Reverse :: #{res_reverse} \n"
  end
  print "\n"
end

test
