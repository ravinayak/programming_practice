# frozen_string_literal: true

# You are a product manager and currently leading a team to develop a
# new product. Unfortunately, the latest version of your product fails
# the quality check. Since each version is developed based on the
# previous version, all the versions after a bad version are also bad.

# Suppose you have n versions [1, 2, ..., n] and you want to find out the
# first bad one, which causes all the following ones to be bad.

# You are given an API bool isBadVersion(version) which returns whether
# version is bad. Implement a function to find the first bad version.
# You should minimize the number of calls to the API.

# Input: n = 5, bad = 4
# Output: 4
# Explanation:

# call isBadVersion(3) -> false
# call isBadVersion(5) -> true
# call isBadVersion(4) -> true
# Then 4 is the first bad version.

# Find 1st bad version
# @param [Integer] num
# @return [Integer | nil]
#
def find_first_bad_version(num:, bad:)
  # We implement binary search to minimize the number of calls to
  # api for detecting bad version
  high = num
  low = 1
  mid = nil

  # Binary Search for bad version
  # In the binary search implementation remember to
  #    use <= and not <
  # There is a use case possible where low = high, and the element
  # at this position happens to satifsy the condition. In this use
  # case if low < high is used, we will not get the result.
  while low <= high
    mid = (low + high) / 2
    # If current version at mid is bad, this is the first starting
    # bad version
    # If current version at mid is NOT bad, all elements before it
    # are surely not bad, so the 1st bad must be in 2nd half of
    # array => [mid, high]
    return mid if call_to_api(curr_version: mid, bad:)

    low = mid
  end
end

# Api to return whether vesion is bad or not
# @param [Integer] curr_version
# @param [Integer] bad
# @return [Booolean]
#
def call_to_api(curr_version:, bad:)
  return true if curr_version == bad

  false
end

def test
  arr = [
    { num: 5, bad: 4, output: 4 },
    { num: 1, bad: 1, output: 1 }
  ]
  arr.each do |num_hsh|
    num = num_hsh[:num]
    bad = num_hsh[:bad]
    output = num_hsh[:output]
    print "Input Elements => Num :: #{num}, Bad :: #{bad}, "
    print "Output :: #{find_first_bad_version(num:, bad:)}, "
    print "Expected Output :: #{output} \n"
  end
end

test
