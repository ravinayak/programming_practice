# frozen_string_literal: true

# Find duplicate elements in an array

# Iterate over the array, maintain count of each element
# in the array, if the count increases more than 1, we
# have found a duplicate, return this element

# @param [Array<Integer>] input_arr
# @return [Ineger]
#
def find_duplicate(input_arr:)
  return nil if input_arr.empty? || input_arr.length == 1

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
  duplicate
end

arr = [[1, 2, 1, 2, 3, 4, 5, 5, 6, 5], [1, 2, 3], [], [1]]

arr.each do |input_arr|
  duplicate = find_duplicate(input_arr:)
  duplicate = 'NIL' if duplicate.nil?
  puts "Input Arr :: #{input_arr.inspect}, duplicate :: #{duplicate}"
end
