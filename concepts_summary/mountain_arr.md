In Mountain Array problem:

1. Without Duplicates
2. With Duplicates

3. Never use input_arr[mid - 1] because mid - 1 may cross index bounds, we do not use it in Binary Search
4. low < high AND NOT low <= high

- while low < high (and NOT low <= high used in Binary Search)
- while low <= high can be used in BinarySearch
  1.  Because arr[mid] == target is compared and we return arr[mid], so there is NO Chance of Infinite Recursion
  2.  In case of MountainArray, we do not compare because we do NOT have a target, and hence we do not have any Return,
      this can cause INFINITE RECURSION

3. For duplicates, we have to compare arr[mid] == arr[mid + 1], we have to skip duplicates

   - left = high = mid,
   - left -= 1 while arr[left - 1] == arr[mid], left > 0 (left - 1 will give index out of bounds error if left == 0)
   - right +=1 while arr[right + 1] == arr[mid], right < arr.length - 1 (right + 1 will give index out of bounds if right == arr.length - 1)
   - plateau of duplicates may contain peak element
   - peak element may be in right of plateau
   - peak element may be in left of plateau
   - plateau = arr[left, right] where arr[left] = arr[right] = arr[mid]

4. Always return low because low will contain the mountain peak element
