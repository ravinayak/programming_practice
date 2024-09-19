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
    # Each time we call this function, it returns a set of elements from
    # the input_array which have not been used to create a set before
    # and which sum upto the given target.
    # Every set forms a subset and is collected in sets array to give us
    # all the "k" subsets of input_arr which have equal sum
    sets << set_adds_upto_target(input_arr:, visited:, target:)
  end

  [true, sets]
end

# Algorithm: Function below can be used to
# 1. Find partitions of array which have equal sum
# 2. Find subset of elements in current array which can add upto target
#      => In this case visited is not passed and is NIL, because we
#      => only need 1 set

# @param [Array<Integer>] input_arr
# @param [Hash | nil] visited
# @param [Integer] target
def set_adds_upto_target(input_arr:, target:, visited: nil)
  # Initialize dp array with target+1 values, so that dp can have elements
  # from "0" to "target"
  # dp[target] contains the boolean to indicate if there exists a set of
  # elements in the array which add upto target

  dp = Array.new(target + 1, false)
  # The idea behind dp[0] = true is that there is always a subset of the array
  # that sums to 0—that subset is the empty set. Since the empty set sums to 0,
  # dp[0] is initialized to true. This base case allows the algorithm to build up
  # solutions for higher sums by considering each element in the input array.
  # Initializing dp[0] is necessary to build the solution in DP array
  dp[0] = true

  # parent hash contains the element, and index of that element which forms the
  # set with other element to sum upto a specified target
  # If dp[j] = false => dp[j - element] = true => parent[j] = element, index
  # This is because [element, parent[dp[j-element]] sum upto j
  # dp[0] = 0 => Consider element in array: 3, j = 3
  #    => dp[3] = dp[j - element] = dp[3 - 3] = dp[0] = true
  #  parent[3] = 3 because we can use element "3" to achieve the sum "3"
  # This is useful in backtracking to obtain the set of elements in input_arr
  # which add upto given target
  parent = {}

  input_arr.each_with_index do |element, index|
    # If element at specified index has been considered in any previously
    # calculated set, it should not be used again, since we want to find
    # sets formed from different elements in array, i.e. disjoint sets
    # element > target => element cannot be used since we ONLY CONSIDER
    # positive numbers
    next if (visited && visited[index]) || element > target

    # We go down from target to 1, it is CRUCIAL because if we go up from
    # 1 to target, the same element can be considered more than once when
    # forming SETS,
    # Consider element = 5, j = 15
    #   => Iterating from 1..target => 1..15 =>
    #    => dp[5] will be evaluated 1st, then dp[10]
    #    => dp[5] = true; j = 10 => dp[10] = dp[j - element] = dp[5] = true
    #    => In this case, for dp[10], we are using dp[5] which means we
    #       are using the element "5" twice in the set which is INCORRECT
    #    => Iterating from target..1 => 15..1 =>
    #    => dp[10] will be evaluated 1st, then dp[5]
    #    => j = 10 => dp[10] = dp[j - element] = dp[10 - 5] = dp[5] = false
    #    => This is because dp[5] is set to false and has not been evaluated yet
    target.downto(1).each do |j|
      # CRUCIAL => dp[j - element] will try to access an index which is -ve
      # if j < element and give an array out of index bounds error
      next if j < element

      # dp[j] is not set, and can be set using element, and parent[dp[j-element]]
      # In this case, we set parent of "j" to current element and index
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
  # As long as target_sum > 0, we keep processing because
  # when we reach 0 and we must reach 0 (when we find all elements in set)
  # we should stop iteration
  while target_sum.positive?
    # Push parent of target_sum key, mark its index as visited
    arr << parent[target_sum][:element]
    visited[parent[target_sum][:index]] = true if visited
    # Target sum is reduced by the element which was used in the set to
    # add upto it. We shall check parent of the remainder of the sum
    # because it is next element in the set
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
