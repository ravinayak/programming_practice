# frozen_string_literal: true

require_relative '../data_structures/list'
# Merge 2 sorted lists without creating a new list by splicing one list
#
# @param [LinkedList] list1
# @param [LinkedList] list2
# @return [LinkedList]
#
def merge_sorted_lists(list1:, list2:)
  index_list1 = index_list2 = 0

  while index_list1 < list1.list.length && index_list2 < list2.list.length
    if list1.list[index_list1].data > list2.list[index_list2].data
      list1.insert_element(index: index_list1, element: list2.list[index_list2].data)
      index_list2 += 1
    end
    index_list1 += 1
  end
  # Append any elements left in list2.
  # List1 contains elements inserted into it from List1, if we have reached end of list2 but not list1
  # we are good, because all elements from list2 must have been inserted into list1 at proper indices,
  # list1 is the final merged list

  while index_list2 < list2.list.length
    list1.insert_element(index: index_list1, element: list2.list[index_list2].data)
    index_list1 += 1
    index_list2 += 1
  end

  list1
end

input_arr_one = [1, 3, 5, 6, 17, 38]
input_arr_two = [2, 4, 7, 9, 11, 15, 16, 24, 26, 32, 45, 50, 55]
puts "Given Input Array 1 :: #{input_arr_one}"
puts "Given Input Array 2 :: #{input_arr_two}"
list1 = List.new(input_arr: input_arr_one)
list2 = List.new(input_arr: input_arr_two)
list1.traverse_list
list2.traverse_list
merge_sorted_lists(list1:, list2:)
puts "\n\n Sorted List "
list1.traverse_list
