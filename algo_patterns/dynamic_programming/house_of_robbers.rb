# frozen_string_literal: true

# House of Robbers is a problem where robbers can rob only non adjacent houses,
# An array of numbers is given where index of number in array represents the
# sequential position of house on a street (like 1st house, 2nd house, 3rd house)
# Actual number in the array represents the amount of money which is available in
# the house to rob
#

# @param [Array] arr
# @return [Integer] max_amount
#
def house_of_robbers(arr:)
  max_amount_to_rob = []
  max_amount_to_rob << arr[0]
  max_amount_to_rob << arr[1]

  counter = 2

  while counter < arr.length
    max_amount_to_rob[counter] =
      [arr[counter] + max_amount_to_rob[counter - 2], max_amount_to_rob[counter - 1]].max
    counter += 1
  end
  max_amount_to_rob.last
end

input_arr = [[1, 2, 3, 1], [5, 8, 9, 16, 59, 25, 45]]
input_arr.each do |arr|
  puts "Given input Arr :: #{arr}"
  puts " Maximum amount which can be robbed :: #{house_of_robbers(arr:)}"
end
