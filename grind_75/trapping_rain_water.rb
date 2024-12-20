# frozen_string_literal: true

# Given n non-negative integers representing an elevation map where
# the width of each bar is 1, compute how much water it can trap
# after raining.

# Example 1:
# Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
# Output: 6
# Explanation: The above elevation map (black section) is represented
# by array [0,1,0,2,1,0,1,3,2,1,2,1]. In this case, 6 units of rain water
# (blue section) are being trapped.

# Example 2:
# Input: height = [4,2,0,3,2,5]
# Output: 9

# Algorithm: In order to trap rain water, we use Sliding Window Pattern
# 1. We initialize left/right pointers to 0, arr.length - 1 array
# 2. Initialization: left_max = input_arr[left], right_max = input_arr[right]
# 3. We calculate left_max and right_max at all indices by comparing elements in
# array with left_max and right_max
# 4. Water cannot be trapped at index 0, because there is a bar at 0 which
# stretches from 0 to width, there is no bar before index 0, X-axis where we
# plot the bars are not actual bars.
# 5. Same applies to bar at arr.length - 1, there is no bar beyond this bar. The
# bar extends from arr.length - 1 to width and there is no bar beyond this
# 6. Water can be trapped only if
# 	a. There is an area between bars
# 	b. There is a dip which means left_max < right_max, this calculates all the
# 	water that can be trapped between left and right bars
# 7. We calculate water which can be trapped at all indices and sum it up to
# calculate the total water which can be trapped
# 8. At index 0, we calculate left_max by incrementing left to 1 and comparing
# existing left_max with element at index 1
# 9. Water trapped at index 1 = Water trapped between index 1 and index 2
# 10. When left = right - 2, left is incremented to right - 1 to find left_max
# and water trapped is calculated based on this value
# 	At index left = right - 2
# 	left = right - 1
# 	water trapped = Water trapped between index right - 2 and right - 1
# 11. We must stop at left = right - 2, if we process when left = right - 1,
# 	left will be incremented by 1 and left = right
# 	At index left = right - 1
# 	left = right
# 	water trapped = Water trapped between index right - 1 and right
#   "right - 1" through "right" contains a bar, and there is no bar to the right of this bar
#    meaning this is the last bar, and therefore no water can be trapped at this index
# 	Hence while loop must have condition left < right - 1 and not left <= right

def trapping_rain_water(input_arr:, width:)
  # Base Case: If input_arr is empty or input_arr has only 1 element,
  # no water can be trapped
  return 0 if input_arr.empty? || input_arr.length == 1

  left = 0
  right = input_arr.length - 1
  left_max = input_arr[left]
  right_max = input_arr[right]
  water_trapped = 0

  # In this iteration, we calculate the water which will be trapped
  # at every index starting from 0
  # a. At index 0, it calculates water trapped between index 0 and 1 (bars at index 0 and bar at index 1)
  # b. At index 1, it calculates water trapped between index 1 and 2 (bars at index 1 and bar at index 2)
  # c. At index right - 2, it calculates water trapped between index right - 2 and right - 1
  # d. At index right - 1, it would calculate water trapped between index index right - 1 and right
  # e. "right - 1" through "right" contains a bar, and there is no bar to the right of this bar
  #    meaning this is the last bar, and therefore no water can be trapped at this index
  # f. Hence, we compare left < right - 1 and not right, so that left can only grow till right - 2
  # g. left < right => left can grow till right - 1, and we have seen at Step e, this would
  #    calculate water trapped for last bar which is incorrect
  while left < right - 1
    # if left_max < right_max => This is critical because it means that there is a bar towards the
    # right which can hold water in dips between Bars on left and Right in the dips, without a
    # higher bar on right, no water can be tapped between left to right.
    # if left_max > right_max => Water can ONLY be Tapped between bars on right and left_max in the
    # dips
    if left_max < right_max
      # Increment left to get the height of bar at current left, so we can find if there is a dip
      # between previous bar and current bar by finding left_max which is shown below in calculations
      left += 1
      # We increment left so that we can find the left_max by comparing existing left_max with
      # current left represented by input_arr[left]
      # a. left_max <= input_arr[left] => There is no dip between bars at left - 1, and left
      #    Hence no water can be trapped in this area. In this calculation, it is reflected
      #    by left_max = [left_max, input_arr[left]].max
      #     => left_max will be = input_arr[left] since left_max < input_arr[left]
      # b. left_max - input_arr[left] = 0 since left_max = input_arr[left]
      # c. Thus when current bar is greater in height, there is no dip and hence no water is
      #    trapped
      # d. left_max > input_arr[left] => There is a dip at current left and hence water can be
      #    trapped
      # e. left_max - input_arr[left] > 0 => Multiplied by width gives us the amount of water
      #    which can be trapped at left
      left_max = [left_max, input_arr[left]].max

      water_trapped += (left_max - input_arr[left]) * width
    else
      right -= 1
      right_max = [right_max, input_arr[right]].max

      water_trapped += (right_max - input_arr[right]) * width
    end
  end

  # Return water trapped
  water_trapped
end

def heights_arr
  [
    {
      input_arr: [0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1],
      output: 6
    },
    {
      input_arr: [4, 2, 0, 3, 2, 5],
      output: 9
    }
  ]
end

def test
  heights_arr.each do |input_hsh|
    print "\n\n Input - Heights Arr :: #{input_hsh[:input_arr]}"
    res = trapping_rain_water(input_arr: input_hsh[:input_arr], width: 1)
    print "\n Expected - #{input_hsh[:output]}, Res :: #{res}"
  end
  print "\n\n"
end

test
