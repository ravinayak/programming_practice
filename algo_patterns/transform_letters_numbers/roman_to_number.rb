# frozen_string_literal: true

# Normal roman letters are written from largest to smallest, i.e. in Non-Increasing Order
# Two consecutive values may be equal, or previous larger than next (Because two consecutive
# values can be equal, we say Non-Increasing Order over Decreasing Order)
# largest to smallest
# Always think: XXV = 25
# NOTE: Only for a subtractive pair, we have smallest to largest such as IX (Increasing Order)
# Converts roman letters to numbers

ROMAN_LETTER_NUM_HSH = {
  'I' => 1,
  'V' => 5,
  'X' => 10,
  'L' => 50,
  'C' => 100,
  'D' => 500,
  'M' => 1000,
  'IV' => 4,
  'IX' => 9,
  'XL' => 40,
  'XC' => 90,
  'CD' => 400,
  'CM' => 900
}.freeze

LETTERS_TO_PREPEND = %w[I X C].freeze

# To Remember, the order we can use following Abbreviation:
# IVF => Pregnancy => IVX
# LC => Leave Certificate (For college admissions)
# DM => District Magistrate
ROMAN_LETTER_NUM_HSH_ALT = {
  'I' => 1,
  'V' => 5,
  'X' => 10,
  'L' => 50,
  'C' => 100,
  'D' => 500,
  'M' => 1000
}.freeze

# @param [String] roman_str
# @return [Integer] result
#
def convert_roman_to_num(roman_str:)
  result = 0
  roman_letters_arr = roman_str.chars
  len = roman_letters_arr.length
  index = 0

  while index < len
    letter = roman_letters_arr[index]
    if sub_pairs?(index:, len:, roman_letters_arr:)
      index, result = *process_subtractive_pairs(index:, roman_letters_arr:, result:)
    else
      result += ROMAN_LETTER_NUM_HSH[letter]
      index += 1
    end
  end

  result
end

# Converts subtractive pairs to number
# @param [String] roman_str
# @param [Array] roman_letters_arr
# @param [Integer] result
# @return [Array] index/result
#
def process_subtractive_pairs(index:, roman_letters_arr:, result:)
  result += ROMAN_LETTER_NUM_HSH[roman_letters_arr[index] + roman_letters_arr[index + 1]]
  index += 2

  [index, result]
end

# Evaluates if subtractive pair exists for given pair of letters
# @param [Integer] index
# @param [Integer] len
# @param [Array] roman_letters_arr
# @return [Boolean]
#
def sub_pairs?(index:, len:, roman_letters_arr:)
  LETTERS_TO_PREPEND.include?(roman_letters_arr[index]) && index != len - 1 &&
    ROMAN_LETTER_NUM_HSH.key?(roman_letters_arr[index] + roman_letters_arr[index + 1])
end

# Simpler method to transform roman letter to number
# @param [String] roman_str
# @return [Integer]
#
def simpler_roman_to_num(roman_str:)
  index = 0
  result = 0
  len = roman_str.length

  while index < len
    current_val = ROMAN_LETTER_NUM_HSH_ALT[roman_str[index]]

    # Subtractive pairs are always formed only when current roman letter has a smaller value
    # than the next roman letter. Normal roman letters are written from largest to smallest
    # Only for a subtractive pair, we have smallest to largest
    #
    # Check for index bound with length of array
    if index + 1 < len && ROMAN_LETTER_NUM_HSH_ALT[roman_str[index + 1]] > current_val
      # Current value must be subtracted from result, so that in next iteration when we
      # add the roman number value (subtractive pair number is deducted to give the right answer)
      # Ex: CM (1st iteration => result = -100, 2nd iteration => -100 + 1000 = 900)
      # Subtractive pair => number from 1st roman letter must be subtracted from next roman letter
      # with which the subtractive pair is formed
      #
      result -= current_val
    else
      result += current_val
    end

    index += 1
  end

  result
end
roman_str = 'III'
num = convert_roman_to_num(roman_str:)
num1 = simpler_roman_to_num(roman_str:)
puts "Input Roman Str :: #{roman_str} \t \t Conversion to number :: #{num}  -- #{num1}}"

roman_str = 'LVIII'
num = convert_roman_to_num(roman_str:)
num1 = simpler_roman_to_num(roman_str:)
puts "Input Roman Str :: #{roman_str} \t \t Conversion to number :: #{num}  -- #{num1}}"

roman_str = 'MCMXCIV'
num = convert_roman_to_num(roman_str:)
num1 = simpler_roman_to_num(roman_str:)
puts "Input Roman Str :: #{roman_str} \t \t Conversion to number :: #{num}  -- #{num1}}"
