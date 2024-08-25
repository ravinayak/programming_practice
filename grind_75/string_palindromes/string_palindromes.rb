# frozen_string_literal: true

# Find all palindromes in a string
# For a string, every substring which can be formed by
# combining its characters in the same order as they
# are present in a string, if substring is a palindrome
# include it in the result

# @param [String] str
# @param [Array<String>] result
#
def find_all_palindromes(str:)
  result = {}

  (0...str.length).each do |start_idx|
    # Every single letter in string str is a valid palindrome
    # We assign string as value to this char as key in hash
    result[str[start_idx]] = str[start_idx]

    (start_idx...str.length).each do |end_idx|
      # For this start_idx, we skip the character if it is same
      # as the character at start_idx. This is because we have
      # already put single letter characters into hash
      next if start_idx == end_idx

      # form a substring by including characters from start_idx
      # to end_idx including end_idx
      substr = str[start_idx..end_idx]

      # 1. Hash should not include substring as a key: This
      #    ensures we avoid duplicates
      # 2. substring should be a valid palindrome
      result[substr] = substr if
        substr == substr.reverse && !result.key?(substr)
    end
  end

  # return values/keys in hash which are valid palindromes
  result.keys
end

def test
  str = 'abacdfgdcaba'
  expected_res = %w[a aba b c d f g]
  res = find_all_palindromes(str:)

  puts "Input Str :: #{str}"
  puts "Expected Result :: #{expected_res}, Result :: #{res}"
end

test
