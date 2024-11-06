# frozen_string_literal: true

# If there are more than two denominations, say denominations = [d1, d2, ..., dk]
# In this general version:

# 	•	We loop through each amount up to n.
# 	•	For each amount, we try all possible denominations and calculate the minimum number of stamps.

# Complexity Analysis for Generalized Function

# 	•	Time Complexity:  O(n * k) , where  k  is the number of denominations.
# 	•	For each amount up to n, we consider each denomination, so the algorithm iterates  n * k  times in the worst case.
# 	•	Space Complexity:  O(n) , for the dp array.

def postage_stamps(amount:, denominations:)
  return nil if edge_case?(amount:, denominations:)

  denomination_min = denominations.min
  return [1, [denomination_min]] if amount == denomination_min

  selections = {}
  denomination_selections = []
  dp = Array.new(amount + 1, Float::INFINITY)

  # Base Case
  dp[0] = 0

  (1..amount).each do |amount_to_create|
    denominations.each do |denomination_amount|
      next if amount_to_create < denomination_amount

      new_denomination_sum = dp[amount_to_create - denomination_amount] + 1
      next if dp[amount_to_create] <= new_denomination_sum

      dp[amount_to_create] = dp[amount_to_create - denomination_amount] + 1
      selections[amount_to_create] = denomination_amount
    end
  end

  dp[amount] = dp[amount] == Float::INFINITY ? -1 : dp[amount]

  return [dp[amount], []] if dp[amount] == -1

  base_amount = amount
  while base_amount.positive?
    denomination_selections << selections[base_amount]
    base_amount -= selections[base_amount]
  end

  [dp[amount], denomination_selections]
end

def edge_case?(amount:, denominations:)
  return true if amount.nil? || amount.negative? || denominations.nil? || denominations.empty?

  denomination_min = denominations.min

  true if amount < denomination_min
end

def input_arr
  [
    {
      denominations: [3, 5],
      amount: 7,
      expected_result: -1,
      denomination_selections: []
    },
    {
      denominations: [3, 5],
      amount: 38,
      expected_result: 8,
      denomination_selections: [3, 5, 5, 5, 5, 5, 5, 5]
    },
    {
      denominations: [2, 3, 5],
      amount: 28,
      expected_result: 6,
      denomination_selections: [3, 5, 5, 5, 5, 5]
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    denominations, amount, expected_result, expected_demoninations =
      input_hsh.values_at(:denominations, :amount,
                          :expected_result, :denomination_selections)
    result, denomination_selections = postage_stamps(amount:, denominations:)
    print "\n\n Amount :: #{amount}, Denominations :: #{denominations}"
    print "\n Expected Result :: #{expected_result}"
    print "\n Actual Result   :: #{result}"
    print "\n Denominations Expected :: #{expected_demoninations}"
    print "\n Denominations Selected :: #{denomination_selections}"
    print "\n Result and Denominations Match :: "
    print "#{expected_demoninations == denomination_selections}, #{result == expected_result}"
    print "\n"
  end
  print "\n"
end

test
