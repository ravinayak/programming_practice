# frozen_string_literal: true

# Given an array of integers, find the container which can fill most water
# Array of integers includes numbers which represent height of lines, the container
# is made with two lines and the x-axis

# @param [Array] heights_arr
# @return [Hash] container_hash
#
def find_max_container(heights_arr)
  sliding_window = { left: 0, right: heights_arr.length - 1 }
  max_area_container = { left: 0, right: 0 }
  max_area = 0
  while sliding_window[:left] < sliding_window[:right]
    right = sliding_window[:right]
    left = sliding_window[:left]
    # curr_width = right - left AND NOT right - left + 1
    # x1 = 0, x2 = 3 => curr_width = x2 - x1 = 3 - 0 = 3
    # 0 => 1 (width = 1), 1 => 2 (width = 1), 2 => 3 (width = 1)
    # 0, 1, 2, 3 form 3 pairs of consecutive vertices => (0, 1), (1, 2), (2, 3)
    # Hence width from index 0 to index 3 = 3
    # right - left = Number of steps needed to move from left + 1 to right including right
    # 3 - 0 = Number of steps needed to move to 3 from 0 excluding 0 = 3 pairs of vertices
    curr_area = [heights_arr[left], heights_arr[right]].min * (right - left)
    max_area = find_max_area(curr_area:, max_area:, max_area_container:,
                             sliding_window:)
    adjust_pointers(sliding_window:, heights_arr:)
  end
  puts "Maximum container area :: #{max_area} -- #{max_area_container.inspect}"
  puts
end

# Returns the maximum area out of given inputs
# @param [Integer] curr_area
# @param [Integer] max_area
# @param [Hash] max_area_container
# @param [Hash] sliding_window
# @return [Integer]
#
def find_max_area(curr_area:, max_area:, max_area_container:, sliding_window:)
  return max_area if max_area > curr_area

  max_area_container[:left] = sliding_window[:left]
  max_area_container[:right] = sliding_window[:right]
  curr_area
end

# Increases pointer_one or pointer_two depending upon which is greater
# @param [Hash] sliding_window
# @param [Array] heights_arr
# @return NIL
#
def adjust_pointers(sliding_window:, heights_arr:)
  # The logic for adjusting the pointers is correct:
  # 1. If the height at the left pointer is smaller than the height at the
  # right pointer, we move the left pointer to the right.
  # Otherwise (if the height at the right pointer is smaller or equal), we
  # move the right pointer to the left.
  # This approach is optimal because:
  # 1. The area is determined by the shorter of the two heights and the distance
  # between them.
  # By moving the pointer that points to the shorter height, we have a chance of
  # finding a taller height that could potentially increase the area.
  # If we moved the pointer with the taller height, we would be guaranteed to either
  # maintain or decrease the area (due to the width decreasing).

  if heights_arr[sliding_window[:left]] < heights_arr[sliding_window[:right]]
    sliding_window[:left] += 1
  else
    sliding_window[:right] -= 1
  end
end

arr = [[1, 8, 6, 2, 5, 4, 8, 3, 7], [2, 9, 11, 13, 15, 16, 8, 9, 55, 65], [1, 1]]

arr.each do |input_arr|
  find_max_container(input_arr)
end
