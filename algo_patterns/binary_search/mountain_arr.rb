# frozen_string_literal: true

# In your implementation of the peak finding algorithm for a mountain array,
# the reason why we are returning low and setting high = mid (instead of high = mid - 1)
# relates to how the binary search is conducted in this particular case and how we narrow
# down the search space. Let’s go over each part in detail:

# 1. Why Do We Return low?

# The logic of the algorithm ensures that at the end of the binary search, the low pointer
# and the high pointer will both converge on the peak element of the array. Here’s why:

#   •  When the loop terminates (i.e., when low == high), both low and high will be pointing
#   to the same index.
#   •  This index is guaranteed to be the peak because the conditions in the loop ensure that
#   the search space is reduced in such a way that it eventually converges on the peak.
#   •  Therefore, returning either low or high gives us the index of the peak element. Since
#   they are the same at the end, returning low works correctly.

# 2. Why Do We Set high = mid Instead of high = mid - 1?

# This is a crucial point. The reason why we set high = mid (instead of high = mid - 1) is
# because the current middle element (mid) could still be the peak.

# Explanation:

#   •  If arr[mid] > arr[mid + 1], it means we are in the descending part of the mountain array.
#   This implies that there is a peak somewhere to the left of or at mid.
#   •  Therefore, we cannot discard mid by setting high = mid - 1, because it is possible that
#   mid is the peak itself.
#   •  For example, if mid is the peak, we would miss it if we set high = mid - 1.
#   •  Instead, by setting high = mid, we keep mid in the search space, ensuring that if it is
#   the peak, we will find it.

# Compare with Ascending Case:

#   •  On the other hand, when arr[mid] < arr[mid + 1], it means we are in the ascending part of
#   the array, and the peak must be somewhere to the right of mid. Hence, we safely discard mid
#   by setting low = mid + 1 because the peak cannot be at mid in this case.

# Why Do We Use low < high Instead of low <= high?

#   •  The condition low < high ensures that we only perform the loop while low and high are
#   distinct. The moment low equals high, the loop terminates, and we know that low (or high)
#   is pointing to the peak.
#   •  Since low and high will converge on the peak index, there’s no need to use low <= high
#   (which would complicate the handling of mid).
#   •  If we use low <= high, loop will never terminate and keep running in an infinite loop
#   when low and high converge to the same position at mid. In this case, we would have to
#   use an extra condition to check if we reached low = high and return on that condition
#       # If mid is the peak element, return mid
#       if (mid == 0 || arr[mid] > arr[mid - 1]) && (mid == arr.length - 1 || arr[mid] > arr[mid + 1])
#         return mid

#       # If we are in the ascending part of the array
#       elsif arr[mid] < arr[mid + 1]
#         low = mid + 1  # Search the right part of the array (exclude mid)

#       # If we are in the descending part of the array
#      else
#       high = mid - 1  # Search the left part of the array (exclude mid)
#     end

# This is a mountain array problem where there is a peak element in
# the array whose value is higher than all other elements in the array.
# To the left of the peak, elements are arranged in ascending order
# and to the right of the peak, elements are arranged in descending order
# @param [Array] arr
# @return [Integer] index
#
def find_peak_in_mountain_arr(arr)
  # Base cases: if arr is empty of arr has a length of 1
  return nil if arr.empty?

  return arr[0] if arr.length == 1

  low = 0
  high = arr.length - 1

  # When low = high, we reach the index of peak element in the array
  # A simple test to validate that this is the peak element is to compare
  # the element with its neighbors. Both left and right neighbors of peak
  # element will be less than the peak element
  #
  # In this code, both low and high converge to the peak element, which is
  # found at mid, in this case low = high. We must not use
  # low <= high, or we shall end up in Inifinite Recursion, as low and high
  # will converge and become equal at the peak element
  while low < high
    mid = (low + high) / 2

    # We are in ascending part of the array, all elements on right of mid will
    # be greater, and hence peak element will be in the right
    if arr[mid] < arr[mid + 1]
      # low,mid is in ascending part of the array, we must search in the next part
      # of the array i.e. mid+1 to high
      low = mid + 1
    else
      # mid+1,high is in descending part of the array, where arr[mid] > arr[mid+1],
      # we must search from low,mid
      high = mid
    end
  end
  low # or high
end

# When duplicates are allowed in the array, find the mountain of the array
# The above solution assumes that elements in the array are all distinct, where
# all elements on the left of PEAK element are less than the PEAK Element, and
# all elements on the right of PEAK element are also less than the PEAK element
# Elements in array on left of PEAK element => Ascending Order
# Elements in array on right of PEAK element => Descending Order
# This does not apply if we have duplicates in the array. If we calculate a "mid"
# where arr[mid] == arr[mid + 1], we have reached an element which is a duplicate
# At this point, we CANNOT DECIDE whether we are in the Ascending/Descending
# part of the array. Basically, we have reached a Plateau, 3 use cases are possible:
# a. Plateau is at the PEAK, in this case, we have found the PEAK, once we establish
#    the left, right boundaries of the PlATEAU, we can find its mid element and
#    return this as the PEAK
# b. Plateau is not at the PEAK, right end of PLATEAU (i.e where elements are no
#    longer Duplicates, is an ascending array, i.e. arr[i] < arr[i+1]), in this
#    case, we use the same logic as before, we search in the ascending portion
#    skipping the "mid" element => low = i + 1
# c. Plateau is not at the PEAK, right end of PLATEAU is in descending part of the
#    array, here we search for the left end of the PLATEAU, this represents the
#    descending part of the array. We find the left end of the PLATEAU, say "i",
#    low..i represents descending part of the array, we do same as before
#       => high = i, inlcude "i", because it could be the peak
#
# @param [Array<Integer>] arr
# @return [Integer|nil]
def find_peak_in_mountain_arr_duplicates(arr)
  # Base cases: if arr is empty of arr has a length of 1
  return nil if arr.empty?

  return arr[0] if arr.length == 1

  low = 0
  high = arr.length - 1

  # When low = high, we reach the index of peak element in the array
  # A simple test to validate that this is the peak element is to compare
  # the element with its neighbors. Both left and right neighbors of peak
  # element will be less than the peak element
  #
  # In this code, both low and high converge to the peak element, which is
  # found at mid, in this case low = high. We must not use
  # low <= high, or we shall end up in Inifinite Recursion, as low and high
  # will converge and become equal at the peak element
  while low < high
    mid = low + (high - low) / 2

    # We check if mid + 1 is accessible, and we compare elements at mid with
    # mid + 1 to find if they are not duplicates.
    # The 1st condition to check is to ensure that mid, mid+1 which is typically
    # used to decide ascending/descending part of array are not duplicates
    # If they are not duplicates we can use the normal logic for finding peak
    # element as non-duplicates
    if mid + 1 <= arr.length - 1 && arr[mid] != arr[mid + 1]
      if arr[mid] < arr[mid + 1]
        low = mid + 1
      else
        high = mid
      end
    else
      # Potential peak or plateau
      # Check if it's a true peak or just a plateau in the ascending part
      left = mid
      right = mid

      # Expand left as long as elements are equal
      left -= 1 while left.positive? && arr[left - 1] == arr[mid]

      # Expand right as long as elements are equal
      right += 1 while right < arr.length - 1 && arr[right + 1] == arr[mid]

      # Check if this plateau is the peak
      # left == 0 || arr[left - 1] < arr[left] checks the condition when
      # PLATEAU is at the peak, and also a special condition when the PLATEAU
      # has reached leftmost element of the array
      # i.e index = 0 (no element to compare on the left)
      # right == arr.length - 1 || arr[right] > arr[right + 1] checks
      # the condition when PLATEAU is at the peak and a special condition
      # when the PLATEAU has reached rightmost element of the array,
      # i.e index = arr.length - 1 (no element to compare on the right)
      if (left.zero? || arr[left - 1] < arr[left]) &&
         (right == arr.length - 1 || arr[right] > arr[right + 1])
        return (left + right) / 2
      # Ascending part of the array on right of index "right"
      elsif right < arr.length - 1 && arr[right] < arr[right + 1]
        # If not the peak, continue searching to the right
        low = right + 1
      else
        # Descending part of the array on "left" of index "left"
        # At this point, left contains the maximum element in the
        # descending part of the array and could be the PEAK, so
        # high = left, we search in this part of the array
        high = left
      end
    end
  end

  low # or high, since low == high at this point
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

arr_one = [
  [0, 2, 2, 4, 4, 5, 7, 7, 8, 8, 9, 9, 5, 3, 2, 0],
  [1, 4, 10, 13, 14, 24, 69, 69, 79, 70, 65, 55, 45, 35, 25, 15, 5],
  [24, 69, 100, 99, 79, 78, 67, 26, 19],
  [1, 2, 2, 2, 3, 4, 4, 5, 5, 5, 6, 7, 9, 10, 25, 25, 25, 15, 10, 10, 8, 8, 5, 3, 2],
  [45, 23, 21, -5],
  [0, 20, 25, 45]
]

arr_one.each do |input_arr|
  index = find_peak_in_mountain_arr_duplicates(input_arr)
  puts "Peak element is at index #{index} -- Value :: #{input_arr[index]}"
end
