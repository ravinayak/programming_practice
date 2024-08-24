# frozen_string_literal: true

# Convert numbers into english words. Algorithm to convert numbers into English
# words works by breaking the number into chunks of thousands. This is because
# numbers are expressed in English language in chunks of thousands.

# Algorithm works as follows:
#  1. Divides the number into chunks of thousands from left to right
#  2. Convert 1st chunk (< 1000) into English word, holds the result: To accomplish
#     this, it uses the remainder of division by 1000 for conversion
#  3. Finds the appropriate representation for number for thousand if > 1000: To
#     accomplish this, it uses the quotient of division by 1000. Remainder has
#     already been converted, quotient is now again divided by 1000 to get the
#     remainder which is converted into English word. But this step would require
#     a mention of "thousand" like "thousand", "million", "billion" etc
#  4. To find the appropriate string (for thousand), it uses an index to find the
#     right string in an array of thousand
#  5. Repeat steps 3, 4 until num becomes 0

# Say we have 12,52,789 =>
#    One million two hundred fifty two thousand seven hundred eighty nine

# This is almost a problem whose solution should be more/less crammed up

# In all these constants, Zero is always included, for the 1st constant it makes
# logical sense because it represents english words for numbers < 20

BELOW_TWENTY = %w[Zero One Two Three Four Five Six Seven Eight Nine Ten Eleven
                  Twelve Thirteen Fourteen Fifteen Sixteen Seventeen Eighteen Nineteen].freeze
# In this case, Zero and Ten are kept simply for correct indexing, this constant
# is used for conversion to english word for 20 <= number < 100
# This constant (as we shall see in the example below) is also used for finding english
# translation of number in tens place (i.e. for remainder of division by 100)
# Say we have 21, divide by 10 + remainder of divide by 10 => We will index into
# this constant and above constant to get the english words
# At index 2 (in the constant arr below), we should have Twenty (num/10 = 2),
# at index 1 (in below_twenty constant arr) we should have One (num % 10 = 1)
# 21 => Twenty One

TENS_AND_BETWEEN_20_AND_HUNDRED = %w[Zero Ten Twenty Thirty Forty Fifty Sixty
                                 Seventy Eighty Ninty].freeze
# Zero is kept for indexing purpose
# 1121 => One Thousand => (1121/1000 = 1) => At index 1, we should have Thousand, so
# keep zero

THOUSANDS = %w[Zero Thousand Million Billion].freeze

# @param [Integer] num
# @param [Array<String>] below_twenty
# @param [Array<String>] tens_and_between_20_and_100
# @return [String]
#
def convert_to_english_util(num:, below_twenty:, tens_and_between_20_and_100:)
  result = ''
  # We compare with 20 but divide by 10 in the next condition to get the right index for
  # english word representation
  if num < 20
    result = below_twenty[num]
  elsif num < 100
    # Ex: 45 => 45/10 = 4 => tens_and_between_20_and_100[4] = Forty + 45 % 10 = 5 => below_twenty[5] = " " + Five
    # Forty + " " + Five = Forty Five
    result = tens_and_between_20_and_100[num / 10] + (num % 10 != 0 ? " #{below_twenty[num % 10]}" : '')
  elsif num < 1000
    # Ex: 985 =
    #  1. 985/100 = 9 => below_twenty [9] = Nine + " " + Hundred = Nine Hundred
    #  2. num_remainder = 985 % 100 => 85
    #      => In Step 1, we have already got the Hundred Amount (Nine), we have to find the english translation
    #       for remainder - i.e. tens part
    #      => To get tens part => we divide by 100 and get the remainder of division, this gives us "tens part"
    #      => To convert 'tens part' into english words, we have to use 10 as division number
    # 3. 85 / 10 => " " + tens_and_between_20_and_100[85/10=8] = " " + Eighty
    # 4. 85 % 10 => " " + below_twenty[85%10 = 5] = " " + Five
    # 5. Nine Hundred Eighty Five
    result = "#{below_twenty[num / 100]} Hundred"
    num_remainder = num % 100
    # num_remainder here can be any number between 0 and 99, but it will be in tens place and no hundred's place
    # We use the constant in this case to find the appropriate english word for the tens place if present
    # Hence, the constant tens_and_between_20_and_100 is used for two use cases:
    # 1. When number is between 20 and 100
    # 2. When we want to find the english word for remainder of division by 100, i.e. number in tens place
    # Hence named as tens and between_20_and_100
    result += (num_remainder / 10 != 0 ? " #{tens_and_between_20_and_100[num_remainder / 10]}" : '') +
              (num_remainder % 10 != 0 ? " #{below_twenty[num_remainder % 10]}" : '')
  end

  result
end

def convert_to_english(num:)
  result = ''
  index = 0
  # To understand this code better, do the conversion with 12,252,789
  # Iteration 1:
  #    index = 0, result = '', num = 12,252,789
  #     => num % 1000 = 789
  #     => result = Seven Hundred Eighty Nine + ("") + ("") = Seven Hundred Eighty Nine
  #  Iteration 2:
  #    index = 1, result = 'Seven Hundred Eighty Nine', num = 12,252
  #     => num % 1000 = 252
  #     => result = Two Hundred Fifty Two + ( index = 1 > 0 ? ' ' + THOUSANDS[1] = 'Thousand') +
  #                    (result.empty? ? " " + result = 'Seven Hundred Eighty Nine')
  #     => result = Two Hundred Fifty Two Thousand Seven Hundred Eighty Nine
  # Iteration 3:
  #    index = 2, result 'Two Hundred Fifty Two Thousand Seven Hundred Eighty Nine', num = 12
  #     => num % 1000 = 12
  #     => result = Twelve + (index = 2 > 0 ? ' ' + THOUSANDS[2] = 'Million') +
  #                    (result.empty? ? " " + result)
  #     => result = Twelve Million Two Hundred Fifty Two Thousand Seven Hundred Eighty Nine
  # num = num /1000 = 12 /1000 = 0, index = 5
  # At this stage, the while does not run, and no more calculations are performed, result is returned
  #
  while num.positive?
    # Divide the number in chunks of 1000s
    if num % 1000 != 0
      # rubocop:disable Naming/VariableNumber
      result = convert_to_english_util(num: num % 1000,
                                       below_twenty: BELOW_TWENTY,
                                       tens_and_between_20_and_100: TENS_AND_BETWEEN_20_AND_HUNDRED) +
               (index.positive? ? " #{THOUSANDS[index]}" : '') + (result.empty? ? '' : " #{result}")
      # rubocop:enable Naming/VariableNumber
    end

    # Get the quotient to find the multiple of 1000
    num /= 1000
    # Increment index by 1 to index correctly into the THOUSANDS array
    index += 1
  end

  result
end

def test
  english_translation = 'Twelve Million Two Hundred Fifty Two Thousand Seven Hundred Eighty Five'
  nums_translations = [
    { num: 12_252_785, english: english_translation },
    { num: 123, english: 'One Hundred Twenty Three' },
    { num: 12_345, english: 'Twelve Thousand Three Hundred Forty Five' },
    { num: 1_234_567, english: 'One Million Two Hundred Thirty Four Thousand Five Hundred Sixty Seven' }
  ]
  nums_translations.each do |num_english_hsh|
    num = num_english_hsh[:num]
    english = num_english_hsh[:english]
    puts "Num :: #{num}, Converted to English :: #{convert_to_english(num:)}"
    puts "Num :: #{num}, Expected English     :: #{english}"
  end
end

test

# Example 1:
# Input: num = 123
# Output: "One Hundred Twenty Three"

# Example 2:
# Input: num = 12345
# Output: "Twelve Thousand Three Hundred Forty Five"

# Example 3:
# Input: num = 1234567
# Output: "One Million Two Hundred Thirty Four Thousand Five Hundred Sixty Seven"
