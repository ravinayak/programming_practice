# frozen_string_literal: true

# Given an array nums of size n, return the majority element.

# The majority element is the element that appears more than ⌊n / 2⌋ times.
# You may assume that the majority element always exists in the array

# Boyer-Moore Voting Algorithm can be used to find the majority element
# where majority element is defined as the element which appears more than
# [n/ 2] times in the array

# Time Complexity: O(n)
# Space Complexity: O(1)

# Initialize a candidate variable to keep track of the potential majority element
# and a count variable to track its count.
# Iterate through the array:
# 1. If count is 0, set the candidate to the current element.
# 2. If the current element is the same as candidate, increment count.
# 3. Otherwise, decrement count.
# 4. If count = 0, and we are at an iteration in the array we set this element to
#    the new candidate
# 5. The candidate at the end of the iteration will be the majority element.

# The logic behind this is that if there is a majority element, resetting the
# candidate when the count is zero does not affect the final outcome because
# the true majority element, by definition, occurs more than ⌊n / 2⌋ times,
# so it will still be the candidate by the end of the array.

# Majority element will occur than ⌊n / 2⌋ times, this implies that if we
# pair majority element with non-majority element, there will be say 'x'
# pairs, and there will be at least one more occurrence of majority element
# If we consider count+=1 as setting, and count-=1 as cancelling, then, for
# each pair of majority/non-majority element, there will be equal amount
# of setting/cancellation. At the end however, there will be 1 more setting
# than cancellation of majority element where majority element will be set
# to candidate, and thus we will be able to find the Majority Element. Resetting
# candidate when count=0 does not impact finding majority element due to pair
# effect

# @param [Array<Integer>] input_arr
# @return [Array<Integer, Integer>] count, majority element
#
def find_majority_element(input_arr:)
  return [0, nil] if input_arr.empty?

  return [1, input_arr[0]] if input_arr.length == 1

  candidate = nil
  count = 0

  input_arr.each do |element|
    candidate = element if count.zero?

    count += 1 if element == candidate

    count -= 1 if element != candidate
  end
  # Count the actual occurrences of the candidate
  actual_count = input_arr.count(candidate)

  # Return actual number of occurrences and candidate element
  [actual_count, candidate]
end

def test
  arr = [
    { input_arr: [1, 2, 1, 3, 1], candidate: 1, count: 3 },
    { input_arr: [3, 2, 3], candidate: 3, count: 2 },
    { input_arr: [2, 2, 1, 1, 1, 2, 2], candidate: 2, count: 4 }
  ]

  arr.each do |input_arr_hsh|
    res_candidate = input_arr_hsh[:candidate]
    input_arr = input_arr_hsh[:input_arr]
    res_count = input_arr_hsh[:count]
    input_arr_hsh[:candidate]
    count, candidate = find_majority_element(input_arr:)

    print "\nInput Array :: #{input_arr.inspect}, Expected Count :: #{res_count}, "
    print "Expected Candidate:: #{res_candidate}\n"
    puts "Result => Count :: #{count}, Candidate :: #{candidate}"
  end
end

test
