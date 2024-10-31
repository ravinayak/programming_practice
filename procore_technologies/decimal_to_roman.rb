ROMAN_LETTER_MAPPING_TUPLES = [
  ['M', 1000],
  ['CM', 900],
  ['D', 500],
  ['CD', 400],
  ['C', 100],
  ['XC', 90],
  ['L', 50],
  ['XL', 40],
  ['X', 10],
  ['IX', 9],
  ['V', 5],
  ['IV', 4],
  ['I', 1]
]

def decimal_to_roman(num:)
  return nil if num.nil?

  # Roman Letter Strings are always written from highest to lowest
  # i.e MDC => 1000 then 500 then 100, not other way around, the
  # only exception to this rule is when we have a Subtractive Pair
  # such as IX => 1 then 10
  # Hence, we iterate from highest value in the Array to lowest value
  # We arrange the letters in Array as [roman_strings, value] tuples
  # from Highest decimal value to lowest Decimal value
  # Since a Hash does not have any guaranteed order for keys arrangement
  # we use Arrays. Although Ruby does support an ordering of keys in
  # Hash, it is NOT Typical of Hash Data Structure, and hence we use
  # Arrays
  # Arrays are INDEX BASED, and hence guarantee an ORDERING of
  # [roman_str, value] TUPLES
  result = ''
  ROMAN_LETTER_MAPPING_TUPLES.each do |roman_str_tuple|
    roman_str, value = roman_str_tuple
    while num >= value
      result += roman_str
      num -= value
    end
  end
  # return result
  result
end

def decimal_roman_str_arr
  [
    {
      output: 'MCMXCIV',
      num: 1994
    },
    {
      output: 'III',
      num: 3
    },
    {
      output: 'VIII',
      num: 8
    },
    {
      output: 'IX',
      num: 9
    },
    {
      output: 'X',
      num: 10
    },
    {
      output: 'CM',
      num: 900
    },
    {
      output: 'MCD',
      num: 1400
    },
    {
      output: 'MDCL',
      num: 1650
    },
    {
      output: 'MDCLIX',
      num: 1659
    },
    {
      output: 'LVIII',
      num: 58
    },
    {
      output: nil,
      num: nil
    }
  ]
end

def test
  decimal_roman_str_arr.each do |decimal_roman_str_hsh|
    num, output = decimal_roman_str_hsh.values_at(:num, :output)
    print "\n Decimal Num     :: #{num}"
    print "\n Expected Output :: #{output}"
    print "\n Result          :: #{decimal_to_roman(num:)}"
    print "\n"
  end
  print "\n"
end

test
