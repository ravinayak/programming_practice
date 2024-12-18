# frozen_string_literal: true

# You are given an integer array coins representing coins of different
# denominations and an integer amount representing a total amount of money.

# Return the fewest number of coins that you need to make up that amount.
# If that amount of money cannot be made up by any combination of the coins
# return -1.

# You may assume that you have an infinite number of each kind of coin.

# Example 1:
# Input: coins = [1,2,5], amount = 11
# Output: 3
# Explanation: 11 = 5 + 5 + 1

# Example 2:
# Input: coins = [2], amount = 3
# Output: -1

# Example 3:
# Input: coins = [1], amount = 0
# Output: 0

# Algorithm: Coin Change problem is solved using Dynamic Programming Technique, we
# have an alternative where we can use Greedy Approach but this strategy can give
# us wrong, Incorrect Answers
# DP is guaranteed to give us the correct answer if such an answer exists. It is
# based on the premise that we calculate the smallest number of coins needed for
# every amount upto "amount", and we update this for every coin. At the end of
# iteration, dp[amount] gives us the minimum number of coins needed for "amount"
# When amount = 0, dp[0] = 0, this is because no coins are needed for "0" amount
# For every coin available to us in the coins array, we know that "amount + 1"
# can never be the answer, this is because even for the smallest coin "1", the
# maximum number of coins needed is "amount". We initialilze dp array for every
# amount starting from ["1", "amount"] to this value - "amount + 1" since this
# is a max value, and enables us to avoid using "Inifinity" values which would
# require a lot of storage space
# We iterate over each coin in the coins array, and update dp[amount] for every
# amount starting from "1" to "amount", based on comparison. If the current coin
# can be used to generate "amount", it is compared to the number of coins used
# previously to generate "amount", if this is less than the previous number in
# dp[i], we update it. Many times it may not be possible to generate the amount
# using current coin either. For ex: coins = [2, 3, 5], amount = 17, In this
# use case we cannot use coin "2" to generate an amount, say "5". dp[5] will
# continue to have the same value as before
#    dp[i] = [ dp[i], dp[i - coin] ].min
# Because dp[i] values are generated starting from "0" upto "amount", we always
# have dp[i - coin] (previous value in dp array) available to us. It is either
# a value which was generated by using previous coins or "amount + 1", if no
# coin can be used to generate the amount. We execute this for every coin, and
# at the end, we have dp[amount] which is the minimum number of coins needed
# to generate the amount from available coins

# @param [Array<Integer>] coins
# @param [Integer] amount
# @return [Array<Integer>]
def coin_change(coins:, amount:)
  # Creates an array of size "amount + 1", with each element in the array
  # initialized to "amount + 1" (represents Inifinity)
  dp = Array.new(amount + 1, amount + 1)

  # Initialize to 0
  dp[0] = 0

  # Iterate over each coin in the array to use the coin to genereate amount
  coins.each do |coin|
    # Iterate over each amount starting from "1" to target amount "amount"
    # to find the minimum number of coins needed to generate that amount
    # using current coin. It compares existing value in dp array with
    # possible new value using current coin
    (1..amount).each do |i|
      # if "i - coin" is -ve, arr[-2] = nil, in this case the current coin
      # cannot be used to generate the amount, hence we skip this use case
      next unless i >= coin

      # dp[i] => Current minimum number of coins needed to generate "i"
      # dp[i - coin] => We use 1 coin of current coin, so amount would be
      # i - coin. DP builds solutions incrementally, so previous values
      # would be available starting from 0
      dp[i] = [dp[i], dp[i - coin] + 1].min
    end
  end

  res_coins = {}
  # if the amount could not be generated using any of the coins, it would
  # still be "amount + 1", in this case we return -1, else we return the
  # final answer
  res_coins[:min_num_coins] = dp[amount] == amount + 1 ? -1 : dp[amount]

  # To find the actual coins used to generate the amount, we use the coin_hsh
  return res_coins if res_coins[:min_num_coins] == -1

  res_coins[:coins] = []
  target_amount = amount

  # When target_amount == 0, the condition in "if" clause will never be
  # satisfied, and this causes an infinite loop
  while target_amount.positive?
    # Start from the highest coin, there could be a number of coins which
    # could satisfy the condition, use the greatest value of coin to start
    # and break once it is found, we ensure that we have found valid coin
    # for the solution. Explanation given below
    coins.sort.reverse.each do |coin|
      # target_amount >= coin => coin can be used to generate target_amount
      # dp[target_amount] == dp[target_amount - coin] + 1
      #  => current coin was used to generate amount, and the subtracted value
      #  of "target_amount - coin" is the remaining amount to be generated
      #  Because this coin was used, total number of minimum coins would
      #  dp[target_amount - coin] + 1
      next unless target_amount >= coin && dp[target_amount] == dp[target_amount - coin] + 1

      res_coins[:coins] << coin
      target_amount -= coin
      break # Multiple coins could satisfy this condition
    end
  end

  # Return the hash
  res_coins
end

# test
def test
  coin_arr = [
    {
      coins: [1, 2, 5],
      amount: 11,
      output: 3
    },
    {
      coins: [2],
      amount: 3,
      output: 0
    },
    {
      coins: [1],
      amount: 0,
      output: 0
    }
  ]

  coin_arr.each do |coin_hsh|
    coins = coin_hsh[:coins]
    amount = coin_hsh[:amount]
    output = coin_hsh[:output]
    res_coins = coin_change(coins:, amount:)

    print "\n\n Coins Array :: #{coins.inspect}, Target Amount :: #{amount}"
    print "\n Expected Output :: #{output}, "
    print "Minimum Number of coins :: #{res_coins[:min_num_coins]}, "
    print "Coins used :: #{res_coins[:coins].inspect}\n\n"
  end
end

test

# Let’s say the coins are [1, 2, 5] and the target amount is 11.

# The DP table would look like this:

# Amount	0	1	2	3	4	5	6	7	8	9	10	11
# dp	0	1	1	2	2	1	2	2	3	3	2	3
# The minimum number of coins to make amount 11 is 3.
# Now, let’s backtrack to find which coins were used.
# Backtracking without Breaking the Loop:
# If we don't break the loop, here's what might happen during the backtracking
# process when target_amount = 11:

# coins = [1, 2, 5]  # Coins are sorted in ascending order
# Start with target_amount = 11.
# Loop through coins.each do |coin|:
# Coin 1: Check if dp[11] == dp[11 - 1] + 1 → dp[11] == dp[10] + 1 → 3 == 2 + 1.
# This is true. So, we know that coin = 1 could be part of the solution. But,
# if we don’t break, we’ll keep checking other coins.
# Coin 2: Check if dp[11] == dp[11 - 2] + 1 → dp[11] == dp[9] + 1 → 3 == 3 + 1.
# This is false. We move on to the next coin.
# Coin 5: Check if dp[11] == dp[11 - 5] + 1 → dp[11] == dp[6] + 1 → 3 == 2 + 1.
# This is true. So, coin = 5 is also a valid coin that could be part of the solution.
# Without breaking the loop, even after finding that coin = 1 is a valid choice,
# you continue checking the other coins.

# Another way to solve the problem

# def coin_change(coins:, amount:)
#   return { min_num_coins: -1, coins: [] } if amount.nil? || coins.nil? || coins.empty? || amount.zero?

#   dp = Array.new(amount + 1, amount + 1)
#   dp[0] = 0

#   (1..amount).each do |target_amount|
#     coins.each do |coin|
#       next if coin > target_amount
#       next if dp[target_amount - coin] == amount + 1

#       dp[target_amount] = [dp[target_amount], dp[target_amount - coin] + 1].min
#     end
#   end
#   res_coins = { min_num_coins: nil, coins: [] }
#   res_coins[:min_num_coins] = dp[amount] == amount + 1 ? -1 : dp[amount]

#   return res_coins if res_coins[:min_num_coins] == -1

#   target_amount = amount
#   while target_amount.positive?
#     coins.sort.reverse.each do |coin|
#       next if coin > target_amount || dp[target_amount] != dp[target_amount - coin] + 1

#       res_coins[:coins] << coin
#       target_amount -= coin
#       break
#     end
#   end
#   res_coins
# end
