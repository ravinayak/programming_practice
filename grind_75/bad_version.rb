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
  # This are edge cases for which no bad version exists
  return puts "All versions are good" if num < 1 || num < bad || bad < 1

  # We implement binary search to minimize the number of calls to
  # api for detecting bad version
  high = num
  low = 1
  mid = nil

  # Binary Search for bad version
  # In the binary search implementation remember to
  #    use <= and not <
  # There is a use case possible where low = high, and the element
  # at this position happens to satifsy the condition. In that use
  # case if low < high is used, we will not get the result.
  # However, for this problem statement we can use low < high 
  # if we update high in the condition
  #    call_to_api(curr_version: mid, bad:)
  #      high = mid
  # Keeping low <= high to keep it uniform with binary search
  while low <= high
    mid = low + (high - low) / 2
    # If current version at mid is bad, either this is the 1st bad
    # version or the 1st bad version is in the 1st half of the
    # array. This is because all versions after the mid (bad version)
    # are surely bad
    # Hence we search in the 1st half of the array to find 1st
    # bad version
    # At some point in this search, both low and high will converge
    # to a mid point which will be the 1st bad version
    #
    if call_to_api(curr_version: mid, bad:)
      # [low, mid] => Search in the 1st half of array
      high = mid - 1
    else
      # [mid, high] => Search in the 2nd half of array
      low = mid + 1
    end
  end

  # Return the 1st bad version. Typically we return the element found
  # at mid position, but here we want to return the 1st bad element
  # In the code above, the loop may terminate with low > high, in this
  # case, element at mid may not be the bad version but element at low
  # will always be the 1st bad version
  low
end

# Api to return whether vesion is bad or not
# @param [Integer] curr_version
# @param [Integer] bad
# @return [Booolean]
#
def call_to_api(curr_version:, bad:)
  # This is because if current version is greater than bad version
  # it is surely bad
  curr_version >= bad
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
