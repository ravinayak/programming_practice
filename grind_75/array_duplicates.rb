# frozen_string_literal: true

# Find duplicate elements in an array

# Iterate over the array, maintain count of each element
# in the array, if the count increases more than 1, we
# have found a duplicate, return this element

# @param [Array<Integer>] input_arr
# @return [Ineger]
#
def find_duplicate(input_arr:)
  if input_arr.empty? || input_arr.length == 1
    print "\n 1st Duplicate :: NIL"
    return
  end

  count_hsh = {}
  duplicate = nil

  input_arr.each do |elem|
    if count_hsh.key?(elem)
      duplicate = elem
      break
    else
      count_hsh[elem] = 1
    end
  end

  # Return duplicate
  print "\n 1st Duplicate :: #{duplicate.nil? ? 'NIL' : duplicate}"
  duplicate
end

def find_duplicates_using_hsh(arr:)
  count_hsh = {}
  duplicates = Set.new

  arr.each do |element|
    if count_hsh.key?(element)
      count_hsh[element] += 1
    else
      count_hsh[element] = 1
    end
  end

  arr.each do |element|
    duplicates.add(element) if !duplicates.include?(element) && count_hsh[element] > 1
  end

  print "\n Duplicates using Hash :: #{duplicates.to_a.inspect}"
  duplicates.to_a
end

def find_duplicates_using_sort(arr:)
  arr_sorted = arr.sort
  duplicates = Set.new
  (1...arr.length).each do |index|
    if !duplicates.include?(arr_sorted[index]) && arr_sorted[index] == arr_sorted[index - 1]
      duplicates.add(arr_sorted[index])
    end
  end

  print "\n Duplicates using Sort :: #{duplicates.to_a.inspect}"
  duplicates.to_a
end

arr = [[1, 2, 1, 2, 3, 4, 5, 5, 6, 5], [1, 2, 3], [], [1], [1, 2, 3, 4, 5, 1, 90, 87, 4]]

arr.each do |input_arr|
  print "\n Input Arr :: #{input_arr.inspect}\n"
  find_duplicate(input_arr:)
  find_duplicates_using_sort(arr: input_arr)
  find_duplicates_using_hsh(arr: input_arr)
  print "\n\n"
end
