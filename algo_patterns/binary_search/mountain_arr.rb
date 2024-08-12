# frozen_string_literal: true

# This is a mountain array problem where there is a peak element in the array whose value is higher than
# all other elements in the array. To the left of the peak, elements are arranged in ascending order
# and to the right of the peak, elements are arranged in descending order
# @param [Array] arr
# @return [Integer] index
#
def find_peak_in_mountain_arr(arr)
  low = 0
  high = arr.length - 1

  # When low = high, we reach the index of peak element in the array
  # A simple test to validate that this is the peak element is to compare
  # the element with its neighbors. Both left and right neighbors of peak
  # element will be less than the peak element
  #
  while low < high
    mid = (low + high) / 2

    # We are in ascending part of the array, all elements on right of mid will be greater, and hence peak element
    # will be in the right
    if arr[mid] < arr[mid + 1]
      # low,mid is in ascending part of the array, we must search in the next part of the array i.e. mid+1 to high
      low = mid + 1
    else
      # mid+1,high is in descending part of the array, where arr[mid] > arr[mid+1], we must search from low,mid
      high = mid
    end
  end
  low # or high
end

arr = [
  [0, 2, 4, 7, 6, 3, 1],
  [1, 4, 10, 13, 14, 24, 69, 100, 99, 79, 78, 67, 36],
  [24, 69, 100, 99, 79, 78, 67, 26, 19]
]

arr.each do |input_arr|
  index = find_peak_in_mountain_arr(input_arr)
  puts "Peak element is at index #{index} -- Value :: #{input_arr[index]}"
end
