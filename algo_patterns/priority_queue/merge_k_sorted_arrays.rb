# frozen_string_literal: true

require_relative 'priority_queue'
require_relative 'priority_queue_max_heap'
# frozen_string_literal: true

# Merge k sorted arrays - sorted in descending order
# 1. Insert the largest element from each array into a Priority Queue. This should
# contain array_index (array from which the element came),
# element_index (index of element in the array) and the actual element
# 2. Until the heap is empty
#   a. Extract the maximum element from priority queue and insert into merged array
#   b. Find the array from which this element came. If there are more elements in this array
#      insert the next largest element from this array into priority queue
#   c. Repeat

# If elements are sorted in Descending Order, we have to find the max element at each step when traversing from
# index 0 to length of array, hence, we use Max Heap
# If elements are sorted in Ascending Order, we have to find the min element at each step when traversing from
# index 0 to length of array, hence we use Min Heap

def merge_k_sorted_arrays_simple(k_sorted_arrs:)
  pq = PriorityQueueMaxHeap.new
  merged_arr = []

  k_sorted_arrs.each_with_index do |sorted_arr, arr_index|
    object_hsh = { key: sorted_arr[0], element_index: 0, arr_index: }
    pq.insert(object_hsh:)
  end

  until pq.empty?
    element_hsh = pq.extract_max
    element, element_index, arr_index = element_hsh.values_at(:key, :element_index, :arr_index)
    merged_arr << element

    arr = k_sorted_arrs[arr_index]
    new_index = element_index + 1
    next if new_index >= arr.length

    object_hsh = { key: arr[new_index], element_index: new_index, arr_index: }
    pq.insert(object_hsh:)
  end

  merged_arr.reverse # In Ascending Order
end

k_sorted_arrs = [[25, 20, 15, 10], [100, 25, 14, 13, 11, 1], [90, 12, 9, 7, 6, -5]]
puts k_sorted_arrs.inspect
puts merge_k_sorted_arrays_simple(k_sorted_arrs:).inspect
