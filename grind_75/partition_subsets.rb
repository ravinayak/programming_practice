# frozen_string_literal: true

# Given an integer array nums, return true if you can partition the array into
# two subsets such that the sum of the elements in both subsets is equal or
# false otherwise.

# Example 1:
# Input: nums = [1,5,11,5]
# Output: true
# Explanation: The array can be partitioned as [1, 5, 5] and [11].

# Example 2:
# Input: nums = [1,2,3,5]
# Output: false
# Explanation: The array cannot be partitioned into equal sum subsets.

# NOTE: Classical problem in CS
# This is a classic problem in computer science where we have to find if for a
# given set of elements, there exists a subset of elements which can add upto
# a given target.
# When we are given a problem to partition an array into two subsets such that
# the sum of the elements in both subsets is equal, basically we are being
# asked the same question in another form. An array can be divided into "k"
# sets such that the sum of each set is equal ONLY when the sum of elements in
# the array is exactly divisible by "k". In this case, we have to find in iteration
# a set of elements (which have not been used in previously generated sets) such
# that sum of elements in the set is = total_sum / k. This is the same problem now
# as the classic problem, find a subset of elements from the set that add upto
# given target

# @param [Array<Integer>] input_arr
# @param [Integer] k
# @return [Array]
def partition_into_k_subsets(input_arr:, k:)
  arr_sum = input_arr.sum

  return [false, nil] if (arr_sum % k) != 0

  target = arr_sum / k
  visited = {}

  sets = []
  (0...k).each do |_i|
    sets << set_adds_upto_target(input_arr:, visited:, target:)
  end

  [true, sets]
end

# @param [Array<Integer>] input_arr
# @param [Hash | nil] visited
# @param [Integer] target
def set_adds_upto_target(input_arr:, target:, visited: nil)
  dp = Array.new(target + 1, false)
  dp[0] = true
  parent = {}

  input_arr.each_with_index do |element, index|
    next if (visited && visited[index]) || element > target

    target.downto(1).each do |j|
      next if j < element

      if !dp[j] && dp[j - element]
        parent.merge!({ j => { element:, index: } })
        dp[j] = true
      end
    end
  end

  generate_set(target_sum: target, visited:, parent:)
end

# @param [Integer] target_sum
# @param [Hash] visited
# @param [Hash] parent
def generate_set(target_sum:, visited:, parent:)
  arr = []
  while target_sum.positive?
    arr << parent[target_sum][:element]
    visited[parent[target_sum][:index]] = true if visited
    target_sum -= parent[target_sum][:element]
  end
  arr
end

def input_arr
  [
    {
      input_arr: [1, 5, 5, 11],
      ouput: true,
      k: 2,
      sets: [[1, 5, 5], [11]]
    },
    {
      input_arr: [1, 2, 3, 5],
      k: 2,
      output: false,
      sets: nil
    },
    {
      input_arr: [1, 5, 7, 8, 5, 9, 4, 13],
      output: true,
      k: 4,
      sets: [[1, 5, 7], [8, 5], [9, 4], [13]]
    }
  ]
end

def test
  print "\n Partition Array into Sets => \n"
  input_arr.each do |input_hsh|
    input_arr = input_hsh[:input_arr]
    output = input_hsh[:output]
    sets = input_hsh[:sets]
    k = input_hsh[:k]

    res_output, res_sets = partition_into_k_subsets(input_arr:, k:)
    print "\n Input Arr :: #{input_arr.inspect}"
    print "\n Output :: #{output}, Res Output :: #{res_output}"
    print "\n Sets :: #{sets.inspect}, Res Sets :: #{res_sets.inspect} \n"
  end

  input_arr = [1, 3, 5, 11]
  target = 9
  res_sets = set_adds_upto_target(input_arr:, target:)
  print "\n Set contains a subset which adds upto target => \n"
  print "\n Input Arr :: #{input_arr.inspect}, target :: #{target}"
  print "\n Sets :: #{res_sets} \n"
end

test
