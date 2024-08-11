# Given an array of integers, find the container which can fill most water
# Array of integers includes numbers which represent height of lines, the container
# is made with two lines and the x-axis

# @param [Array] heights_arr
# @return [Hash] container_hash
#
def find_max_container(heights_arr)
	pointer_with_indices = { left: 0, right: heights_arr.length - 1 }
	max_area_container = { left: 0, right: 0 }
	max_area = 0
	while pointer_with_indices[:left] != pointer_with_indices[:right]
		right, left = pointer_with_indices[:right], pointer_with_indices[:left]
		curr_area =[heights_arr[left], heights_arr[right]].min * (right - left)
		max_area = find_max_area(curr_area: curr_area, max_area: max_area, max_area_container: max_area_container, pointer_with_indices: pointer_with_indices)
		adjust_pointers(pointer_with_indices:, heights_arr:)
	end
	puts "Maximum container area :: #{max_area} -- #{max_area_container.inspect}"
	puts
end

# Returns the maximum area out of given inputs
# @param [Integer] curr_area
# @param [Integer] max_area
# @param [Hash] max_area_container
# @param [Hash] pointer_with_indices
# @return [Integer]
#
def find_max_area(curr_area:, max_area:, max_area_container:, pointer_with_indices:)
	return max_area if max_area > curr_area

	max_area_container[:left] = pointer_with_indices[:left]
	max_area_container[:right] = pointer_with_indices[:right]
	curr_area
end

# Increases pointer_one or pointer_two depending upon which is greater
# @param [Hash] pointer_with_indices
# @param [Array] heights_arr
# @return NIL
#
def adjust_pointers(pointer_with_indices:, heights_arr:)
	if heights_arr[pointer_with_indices[:left]] < heights_arr[pointer_with_indices[:right]]
		pointer_with_indices[:left] += 1
	else
		pointer_with_indices[:right] -= 1
	end
end

arr = [[1, 8, 6, 2, 5, 4, 8, 3, 7], [2, 9, 11, 13, 15, 16, 8, 9, 55, 65]]

arr.each do |input_arr|
	find_max_container(input_arr)
end