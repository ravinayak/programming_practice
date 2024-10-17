# frozen_string_literal: true

# Letter Combinations of Phone Numbers

# Given a string containing digits from 2-9 inclusive, return all
# possible letter combinations that the number could represent.
# Return the answer in any order.

# A mapping of digits to letters (just like on the telephone buttons)
# is given below. Note that 1 does not map to any letters.

# Algorithm: In order to convert a string of digits to possible
# combinations of letters, we use Backtracking where we Retrieve
# all the possible letters for a digit, and for each letter, we
# increment the index and call a routine recursively with this
# letter concatenated to path (string). When the path string becomes
# equal to digits length, we push into result array, and backtrack
# to previous recursive call to try combination with the next letter
# for the digit

# This is a typical backtracking problem similar to permutations problem
# with the difference that we dont want to generate all permutations for
# given array elements, but permutations for given letters for a digit,
# and so swapping will not work, we have to use an external variable to
# keep track of all the permutations being generated

# @param [String] digits
# @return [Array<String>]

DIGIT_TO_CHAR = {
  '2' => %w[a b c],
  '3' => %w[d e f],
  '4' => %w[g h i],
  '5' => %w[j k l],
  '6' => %w[m n o],
  '7' => %w[p q r s],
  '8' => %w[t u v],
  '9' => %w[w x y z]
}.freeze

def letter_combs_for_phone_nums(digits:)
  return [] if digits.empty?

  # Two variations of result because
  # Solution 1 uses path string to generate combinations of letters
  # Soltuion 2 uses letter_comb_arr to generate combinations of letters
  result = []
  result_arr = []
  path = ''
  letter_comb_arr = []
  start = 0

  backtrack_letter_combs_phone_num(result:, result_arr:, path:, letter_comb_arr:, start:, digits:)
  [result, result_arr]
end

# @param [Array<String>] result
# @param [Array<String>] result_arr
# @param [String] path
# @param [Array<Chars>] letter_comb_arr
# @param [Integer] start
# @param [String] digits
def backtrack_letter_combs_phone_num(result:, result_arr:, path:, letter_comb_arr:, start:, digits:)
  if start == digits.length
    result << path
    result_arr << letter_comb_arr.join('')
    return
  end

  curr_digit = digits[start]
  possible_letters = DIGIT_TO_CHAR[curr_digit]

  # Unlike permutations, there are no array elements we have to iterate over, instead we have to
  # generate all possible combinations of letters, hence, we iterate over possible letters and
  # increase index to get possible letters for next digit while changing the current letter for
  # digit
  possible_letters.each do |letter|
    letter_comb_arr.push(letter)
    # Because we are only concatenating letter to path, its value is not changed when we return back
    # in recursion, it stays the same as before, hence we do not have to pop/mutate it
    # In case of array, we push the current letter in current recursion, hence we have to pop it
    backtrack_letter_combs_phone_num(result:, result_arr:, path: path + letter,
                                     letter_comb_arr:, start: start + 1, digits:)
    letter_comb_arr.pop
  end
end

def input_arr
  [
    {
      digits: '23',
      output: %w[ad ae af bd be bf cd ce cf]
    },
    {
      digits: '',
      output: []
    },
    {
      digits: '2',
      output: %w[a b c]
    }

  ]
end

def test
  input_arr.each do |input_hsh|
    digits = input_hsh[:digits]
    output = input_hsh[:output]
    res, res_arr = letter_combs_for_phone_nums(digits:)

    print "\n Digits  :: #{digits}"
    print "\n Output  :: #{output.inspect} \n"
    print "\n Res     :: #{res.inspect} \n "
    print "\n Res Arr :: #{res_arr.inspect}"
    print "\n"
  end
end

test
