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
# In other constants - TENS_BETWEEN_20_AND_HUNDRED, THOUSANDS, the constant Zero
# is kept for Indexing Purposes

BELOW_TWENTY = %w[Zero One Two Three Four Five Six Seven Eight Nine Ten Eleven
                  Twelve Thirteen Fourteen Fifteen Sixteen Seventeen Eighteen Nineteen].freeze
# In TENS_BETWEEN_20_AND_HUNDRED, Zero and Ten are kept simply for correct indexing, this constant
# is ONLY used for conversion to english word for 20 <= number < 100
# Say we have 21, divide by 10 + remainder of divide by 10 => We will index into
# this constant and above constant to get the english words
# At index 2 (in the constant TENS_BETWEEN_20_AND_HUNDRED), we should have Twenty (num/10 = 2),
# at index 1 (in the constant BELOW_TWENTY) we should have One (num % 10 = 1)
# 21 => Twenty One

TENS_BETWEEN_20_AND_HUNDRED = %w[Zero Ten Twenty Thirty Forty Fifty Sixty
                                 Seventy Eighty Ninty].freeze
# Zero is kept for indexing purpose
# 1121 => One Thousand => (1121/1000 = 1) => At index 1, we should have Thousand, so
# keep zero

THOUSANDS = %w[Zero Thousand Million Billion].freeze

# @param [Integer] num
# @param [Array<String>] below_twenty
# @param [Array<String>] tens_between_20_and_100
# @return [String]
#
def convert_to_english_util(num:, below_twenty:, tens_between_20_and_100:)
  result = ''
  # We compare with 20 but divide by 10 in the next condition to get the right index for
  # english word representation
  if num < 20
    # num = 0 => At index 0 in BELOW_TWENTY, we have Zerop
    # num = 19 => At index 19 in BELOW_TWENTY, we have Nineteen
    # num works as index in BELOW_TWENTY array to give us the English word
    result = below_twenty[num]
  elsif num < 100
    # Ex: 45 => 45/10 = 4 => tens_between_20_and_100[4] = Forty + 45 % 10 = 5 => below_twenty[5] = " " + Five
    # Forty + " " + Five = Forty Five
    result = tens_between_20_and_100[num / 10] + (num % 10 != 0 ? " #{below_twenty[num % 10]}" : '')
  elsif num < 1000
    # Ex: 115 =
    #  1. 115/100 = 1 => below_twenty [1] = One + " " + Hundred = One Hundred
    #  2. num_remainder = 115 % 100 => 15
    #      => In Step 1, we have already got the Hundred Amount (One), we have to find the english translation
    #       for remainder - i.e. tens part
    #      => To get tens part => we divide by 100 and get the remainder of division, this gives us "tens part"
    #      => To convert 'tens part' into english words, we recursively call the routine convert_to_english_util
    #          with 15 as num
    # 3. 15 < 20 => below_twenty [15] = Fifteen
    # 5. One Hundred Fifteen

    # Ex: 985 =
    #  1. 985/100 = 9 => below_twenty [9] = Nine + " " + Hundred = Nine Hundred
    #  2. num_remainder = 985 % 100 => 85
    #      => In Step 1, we have already got the Hundred Amount (Nine), we have to find the english translation
    #       for remainder - i.e. tens part
    #      => To get tens part => we divide by 100 and get the remainder of division, this gives us "tens part"
    #      => To convert 'tens part' into english words, we recursively call the routine convert_to_english_util
    #          with 85 as num
    # 3. 85 > 20 but 85 < 100 => tens_between_20_and_100 [85/10=8] = Eighty
    #      + (85 % 10 !=0 ? " " + below_twenty[85 % 10 = 5] = " " + Five) = Eighty Five
    # 4. Nine Hundred Eighty Five

    result = "#{below_twenty[num / 100]} Hundred " +
             # It is important to call this utility in recursion, this will handle the use case when number in ten's
             # place is between 0 and 20. The logic below without using recursion will give incorrect result
             (if (num % 100).zero?
                ''
              else
                " #{convert_to_english_util(num: num % 100, below_twenty:, tens_between_20_and_100:)}"
              end)

    # The following logic is incorrect and will give incorrect result
    # num_remainder = num % 100
    # result += (num_remainder / 10 != 0 ? " #{tens_between_20_and_100[num_remainder / 10]}" : '') +
    #           (num_remainder % 10 != 0 ? " #{below_twenty[num_remainder % 10]}" : '')
    # Consider following use case
    # Ex: num = 115
    # num_remainder = 115 % 100 = 15 = One Hundred Ten Five
    # We must call the recrusive helper method to convert tens part to english. Manual conversion by looking
    # up in tens array will give incorrect results for number (tens part) < 20 since it ignores the
    # < 20 comparison and tries to convert directly using tens constant
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
                                       tens_between_20_and_100: TENS_BETWEEN_20_AND_HUNDRED) +
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
    { num: 1_234_567, english: 'One Million Two Hundred Thirty Four Thousand Five Hundred Sixty Seven' },
    { num: 12_115, english: 'Twelve Thousand One Hundred Fifteen' },
    { num: 12_000, english: 'Twelve Thousand' },
    { num: 900, english: 'Nine Hundred' },
    { num: 12_000_000, english: 'Twelve Million' }
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
