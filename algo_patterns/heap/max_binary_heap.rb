# frozen_string_literal: true

# Ruby does not allow usage of instance variables (@A) or constants as default values for
# method arguments directly
# In this class, we use A as array because it implements the algorithm in Thomas Cormen
# book which uses A for array
# To keep it consistent with the algorithm implementation in the book, I have used A
# although it violates ruby syntax
#
# Class implements Binary Heap
class MaxBinaryHeap
  # Subtree rooted at children of node at index "i" -
  #		left(i), right(i)
  #	are valid max heaps, however, node at index "i" may be greater
  # than its children - left or right and thus may violate the max heap
  # property. This method fixes possible violation
  # param [Array] arr
  # @param [Integer] i
  # @return [Array]
  #
  def self.max_heapify(arr:, i:, heap_size:)
    arr_updated = prepare_arr_for_heap(arr:)
    max_heap = max_heapify_helper(arr: arr_updated, i:, heap_size:)
		max_heap[1..heap_size]
  end

  # Implement Heap Sort algorithm
  # Time Complexity: O(n * log n)
  # @param [Array] arr
  # @param [Integer] n
  # @return [Array]
  #
  def self.heapsort(arr:, n:)
		arr_updated = prepare_arr_for_heap(arr: arr)
		max_heap_arr = build_max_heap(arr: arr_updated, n:)

		index = n
    while index > 1
      max_heap_arr = heapsort_helper(arr: max_heap_arr, n: index)
      index -= 1
    end
    max_heap_arr[1..n]
  end

  # Build Max Heap from an array of n elements
  # Time Complexity: O(n)
  # @param [Array] arr
  # @param [Integer] n
  # @return [Array]
  #
  def self.build_max_heap(arr:, n:)
    index = n / 2

		while index >= 1
      arr = max_heapify_helper(arr:, i: index, heap_size: n)
      index -= 1
    end

    arr
  end

  # Helper method to implement max_heapify
  # @param [Array] arr
  # @param [Integer] i
  # @param [Integer] heap_size
  # @return [Array]
  #
  def self.max_heapify_helper(arr:, i:, heap_size:)
    left = left(i:)
    right = right(i:)

    # index "i" is a valid index within binary heap. However, left or right
    # child of "i" maybe outside heap size
    #
    largest = if left <= heap_size && arr[left] > arr[i]
                left
              else
                i
              end

    largest = right if right <= heap_size && arr[right] > arr[largest]

    if largest != i
			exchange_nodes(i:, largest:, arr:)
			max_heapify_helper(arr:, i: largest, heap_size:) 
		end

    # return Array arr which is a valid max heap
    arr
  end

  # Prepares Arr, heap_size and returns an array which contains
  # those values
  # @param [Array] arr
  # @param [Integer] n
  # @return [Array]
  #
  def self.prepare_arr_for_heap(arr:)
    arr_updated = [nil]
    arr.each_with_index do |element, index|
      arr_updated[index + 1] = element
    end
    arr_updated
  end

  # Helper method to implement heapsort
  # @param [Array] arr
  # @param [Integer] n
  # @return [Array]
  #
  def self.heapsort_helper(arr:, n:)
    exchange_nodes(i: 1, largest: n, arr:)
    new_heap_size = n - 1
		max_heapify_helper(arr:, i: 1, heap_size: new_heap_size)
  end

  # Exchanges nodes at index i with index_to_exchange
  # @param [Integer] i
  # @param [Array] arr
  # @param [Integer] largest
  #
  def self.exchange_nodes(i:, largest:, arr:)
    temp = arr[i]
    arr[i] = arr[largest]
    arr[largest] = temp
  end

  # Left child of node at index "i" in binary heap
  # @param [Integer] i
  # @return [Integer]
  #
  def self.left(i:)
    2 * i
  end

  # Right child of node at index "i" in binary heap
  # @param [Integer] i
  # @return [Integer]
  #
  def self.right(i:)
    2 * i + 1
  end

  # Parent of node at index "i" in binary heap
  # @param [Integer] i
  # @return [Integer]
  #
  def self.parent(i:)
    i / 2
  end
end

arr = [1, 300, -50, 100, -200, -250, 19, 57, 65, 500, -350, -550, -600, 1900, 2100]
puts "Sorted Array :: #{MaxBinaryHeap.heapsort(arr:, n: arr.length)}"

arr1 = [2000, 1800, 100, 1700, 1600, 1500, 1850, 500, 600, 700, 650, 1000, 500, 1700, 1800, -50, 75, 400, 500, 10, -110]
puts "Max Heapify :: #{MaxBinaryHeap.max_heapify(arr: arr1, i: 3, heap_size: arr1.length + 1)}"

arr2 = [2000, 1800, 1850, 200, 1600, 1500, 1800, 500, 600, 700, 650, 1000, 500, 1700, 100, -50, 75, 400, 500, 10, -110]
puts "Max Heapify :: #{MaxBinaryHeap.max_heapify(arr: arr2, i: 4, heap_size: arr2.length + 1)}"