# frozen_string_literal: true

require_relative 'priority_queue'
# frozen_string_literal: true

# Merge k sorted arrays - sorted in descending order
# 1.   Insert the largest element from each array into a Priority Queue. This should
#      contain array_index (array from which the element came),
#      element_index (index of element in the array) and the actual element
#  2.  Until the heap is empty
#        a.   Extract the maximum element from priority queue and insert into merged array
#        b.   Find the array from which this element came. If there are more elements in this array
#            insert the next largest element from this array into priority queue
#        c.  Repeat

# @param [Array<Array>] k_sorted_arrs
# @return [Array]
#
def merge_k_sorted_arrays(k_sorted_arrs:)
  pq_arr = []
  merged_arr = []

  k_sorted_arrs.each_with_index do |sorted_arr, sorted_arr_index|
    obj_hash = { arr_index: sorted_arr_index, element_index: sorted_arr.length - 1, key: sorted_arr.last }
    pq_arr = PriorityQueue.insert_key(obj_hash:, arr: pq_arr, heap_size: pq_arr.size)
  end

  until pq_arr.empty?

    max_element_hsh, pq_arr, heap_size = *PriorityQueue.extract_max(arr: pq_arr, heap_size: pq_arr.size)
    arr_index, element_index, element = max_element_hsh.values_at(:arr_index, :element_index, :key)
    merged_arr << element

    next unless element_index.positive?

    obj_hash = { arr_index:, element_index: element_index - 1, key: k_sorted_arrs[arr_index][element_index - 1] }
    pq_arr = PriorityQueue.insert_key(obj_hash:, arr: pq_arr, heap_size:)
    heap_size + 1 # since we inserted a key, heap_size should increase by 1
  end

  merged_arr
end

k_sorted_arrs = [[10, 15, 20, 25], [1, 11, 13, 14, 25, 100], [-5, 6, 7, 9, 12, 90]]
puts k_sorted_arrs.inspect
puts merge_k_sorted_arrays(k_sorted_arrs:).inspect
