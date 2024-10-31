# frozen_string_literal: true

ROMAN_LETTER_MAPPING = {
  'I' => 1,
  'V' => 5,
  'X' => 10,
  'L' => 50,
  'C' => 100,
  'D' => 500,
  'M' => 1000
}.freeze

def roman_to_decimal(roman_str:)
  result = 0
  return nil if roman_str.nil? || roman_str.empty?

  roman_str.chars.each_with_index do |roman_char, index|
    value = ROMAN_LETTER_MAPPING[roman_char]

    if index < roman_str.length - 1 && ROMAN_LETTER_MAPPING[roman_str[index + 1]] > ROMAN_LETTER_MAPPING[roman_str[index]]
      result -= value
    else
      result += value
    end
  end
  result
end

def roman_str_arr
  [
    {
      roman_str: 'MCMXCIV',
      output: 1994
    },
    {
      roman_str: 'III',
      output: 3
    },
    {
      roman_str: 'VIII',
      output: 8
    },
    {
      roman_str: 'IX',
      output: 9
    },
    {
      roman_str: 'X',
      output: 10
    },
    {
      roman_str: 'CM',
      output: 900
    },
    {
      roman_str: 'MCD',
      output: 1400
    },
    {
      roman_str: 'MDCL',
      output: 1650
    },
    {
      roman_str: 'MDCLIX',
      output: 1659
    },
    {
      roman_str: 'LVIII',
      output: 58
    },
    {
      roman_str: '',
      output: nil
    }
  ]
end

def test
  roman_str_arr.each do |roman_str_hsh|
    roman_str, output = roman_str_hsh.values_at(:roman_str, :output)
    print "\n Roman Str       :: #{roman_str}"
    print "\n Expected Output :: #{output}"
    print "\n Result          :: #{roman_to_decimal(roman_str:)}"
    print "\n"
  end
  print "\n"
end

test
