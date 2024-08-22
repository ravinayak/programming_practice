# frozen_string_literal: true

# You are given an array prices where prices[i] is the price of a given stock on the ith day.

# You want to maximize your profit by choosing a single day to buy one stock and choosing a
# different day in the future to sell that stock.

# Return the maximum profit you can achieve from this transaction. If you cannot achieve any
# profit, return 0.

# This algorithm uses a modified Sliding Window pattern / Kadane's Algorithm
# We keep track of the minimum price of stock recorded so far, and the maximum profit possible.
# Even if we find a price which is lower than the current minimum, we would not be able to
# make more profit, since we would have to go back in time to sell it on the day where we
# recorded maximum profit, which is NOT POSSIBLE
# Hence we proceed with the current minimum price of stock, and move ahead in array to record
# profits. If profit exceeds maximum_profit recorded so far, we update the maximum_profit to
# new value
#

# @param [Array<Integer>] prices
# @return [Hash] purchase_price/sell_price/maximum_profit
#
def best_time_to_buy_sell_stock(prices:)
  # covers Edge cases of 0, or 1 elements
  return { purchase_price: nil, sell_price: nil, max_profit: 0 } if prices.length < 2

  # max_profit is initialized to -ve maximum to ensure that it always evaluates
  # to current profit in 1st iteration
  max_profit_hsh = { purchase_price: nil, sell_price: nil, max_profit: -Float::INFINITY }

  # Initialize min price to max value in Ruby, so it always initializes to price in
  # 1st iteration
  min_price = prices[0]

  (1...prices.length).each do |index|
    curr_price = prices[index]
    curr_profit = curr_price - min_price

    # Order of current_profit and min_price evaluation is important. If we reverse this
    # order, we will end up evaluating min_price 1st and curr_profit 2nd. In a use case
    # where, current price is less than min_price, this will give us a curr_profit based
    # on a transaction where we purchase/sell on same day. This would be incorrect since
    # problem statement clearly specifies that we must record profit by purchasing on one
    # day and selling on a different day in future
    # In this case, where we return 0 if there is no profit, it may not seem important but
    # if losses are allowed (meaning profit < 0), this would give an incorrect answer
    # Ex: [7, 3, 5, 1, 6, 4], when we reach "1" at index 3, min_price is 3
    #		if we reverse order, profit will be 0 (min_price will be 1, and profit = 1 - 1)
    #		if we follow correct order, profit will be -2 (min_price will be 3, and profit = 1 - 3)
    min_price_prev = min_price
    min_price = [min_price, curr_price].min

    # If max_profit is less than the current profit (current sell price - current min price)
    # we must update max_profit to this value. It also implies that the sell price would be
    # current price, and purchase price would be min price for maximizing profit
    next unless max_profit_hsh[:max_profit] < curr_profit

    max_profit_hsh[:sell_price] = curr_price
    # Important to record min_price_prev because this was the price at which stock was sold
    # to book current profit
    max_profit_hsh[:purchase_price] = min_price_prev
    max_profit_hsh[:max_profit] = curr_profit
  end

  max_profit_hsh[:max_profit] = 0 if (max_profit_hsh[:max_profit]).negative?

  max_profit_hsh
end

# Displays output
# @param [Array] prices
#
def display_output(prices:)
  max_profit_hsh = best_time_to_buy_sell_stock(prices:)
  max_profit, purchase_price, sell_price =
    max_profit_hsh.values_at(:max_profit, :purchase_price, :sell_price)

  result = "Maximum Profit => Purchase Price :: #{purchase_price}, "
  result += "Sell Price :: #{sell_price}, Max Profit :: #{max_profit}"
  puts "Input Prices Array :: #{prices.inspect} \t \t #{result}"
end

prices = [7, 1, 5, 3, 6, 4]
display_output(prices:)

prices = [7, 3, 5, 1, 6, 4]
display_output(prices:)

prices = [7, 6, 4, 3, 1]
display_output(prices:)

# Example 1:

# Input: prices = [7,1,5,3,6,4]
# Output: 5
# Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
# Note that buying on day 2 and selling on day 1 is not allowed because you must buy before you sell.
# Example 2:

# Input: prices = [7,6,4,3,1]
# Output: 0
# Explanation: In this case, no transactions are done and the max profit = 0.
