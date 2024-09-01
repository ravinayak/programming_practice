# frozen_string_literal: true

# Ruby does not allow usage of instance variables (@A) or constants as default values for
# method arguments directly
#
# Class implements Binary Heap
#
class MaxBinaryHeap
  class << self
    # Subtree rooted at children of node at index "i" -
    #		left(i), right(i)
    #	are valid max heaps, however, node at index "i" may be greater
    # than its children - left or right and thus may violate the max heap
    # property. This method fixes possible violation
    # param [Array] arr
    # @param [Integer] i
    # @return [Array]
    #
    def max_heapify(arr:, i:, heap_size:)
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
    def heapsort(arr:, n:)
      arr_updated = prepare_arr_for_heap(arr:)
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
    def build_max_heap(arr:, n:)
      # index = n/2 = 0 in this case, so no processing takes place
      return [nil, arr[0]] if n == 1

      index = n / 2

      while index >= 1
        arr = max_heapify_helper(arr:, i: index, heap_size: n)
        index -= 1
      end

      arr
    end

    # Insert a new key in max-heap
    # @param [Integer] k
    # @param [Array] arr
    # @param [Integer] heap_size
    # @return [Array]
    #
    def insert_key(k:, arr:, heap_size:)
      arr_updated = prepare_arr_for_heap(arr:)
      max_heap_arr = build_max_heap(arr: arr_updated, n: heap_size)

      heap_size += 1
      max_heap_arr[heap_size] = k

      index = heap_size
      max_heap_arr = float_node_up_until_root(index:, arr: max_heap_arr)

      max_heap_arr[1..heap_size]
    end

    # Increase key of a node
    # @param [Integer] i
    # @param [Integer] new_key
    # @param [Array] arr
    # @param [Integer] heap_size
    # @return [Array]
    #
    def increase_key(i:, new_key:, arr:, heap_size:)
      arr[i] = new_key
      arr_updated = float_node_up_until_root(index: i, arr:)

      arr_updated[1..heap_size]
    end

    # Decrease key of a node
    # @param [Integer] i
    # @param [Integer] new_key
    # @param [Array] arr
    # @param [Integer] heap_size
    # @return [Array]
    #
    def decrease_key(i:, new_key:, arr:, heap_size:)
      arr[i] = new_key
      arr_updated = max_heapify_helper(arr:, i:, heap_size:)

      arr_updated[1..heap_size]
    end

    # Extract max element from a max heap
    # @param [Array] arr
    # @param [Integer] heap_size
    # @return [Integer]
    #
    def extract_max(arr:, heap_size:)
      arr_updated = prepare_arr_for_heap(arr:)
      exchange_nodes(i: heap_size, index_to_exchange: 1, arr: arr_updated)

      max_element = arr_updated[heap_size]
      new_heap_size = heap_size - 1
      arr_updated = max_heapify_helper(arr: arr_updated, i: 1, heap_size: new_heap_size)

      [max_element, arr_updated[1..new_heap_size], new_heap_size]
    end

    private

    # Compare node with its parent until we find a parent that has value greater than or equal to node
    # or we reach root
    # @param [Integer] index
    # @param [Array] arr
    # @return [Array]
    #
    def float_node_up_until_root(index:, arr:)
      while index > 1 && arr[parent(i: index)] < arr[index]
        exchange_nodes(i: index, index_to_exchange: parent(i: index), arr:)
        index = parent(i: index)
      end

      arr
    end

    # Helper method to implement max_heapify
    # @param [Array] arr
    # @param [Integer] i
    # @param [Integer] heap_size
    # @return [Array]
    #
    def max_heapify_helper(arr:, i:, heap_size:)
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
        exchange_nodes(i:, index_to_exchange: largest, arr:)
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
    def prepare_arr_for_heap(arr:)
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
    def heapsort_helper(arr:, n:)
      exchange_nodes(i: 1, index_to_exchange: n, arr:)
      new_heap_size = n - 1
      max_heapify_helper(arr:, i: 1, heap_size: new_heap_size)
    end

    # Exchanges nodes at index i with index_to_exchange
    # @param [Integer] i
    # @param [Array] arr
    # @param [Integer] index_to_exchange
    #
    def exchange_nodes(i:, index_to_exchange:, arr:)
      temp = arr[i]
      arr[i] = arr[index_to_exchange]
      arr[index_to_exchange] = temp
    end

    # Left child of node at index "i" in binary heap
    # @param [Integer] i
    # @return [Integer]
    #
    def left(i:)
      2 * i
    end

    # Right child of node at index "i" in binary heap
    # @param [Integer] i
    # @return [Integer]
    #
    def right(i:)
      2 * i + 1
    end

    # Parent of node at index "i" in binary heap
    # @param [Integer] i
    # @return [Integer]
    #
    def parent(i:)
      i / 2
    end
  end
end

# arr = [1, 300, -50, 100, -200, -250, 19, 57, 65, 500, -350, -550, -600, 1900, 2100]
# puts "Sorted Array :: #{MaxBinaryHeap.heapsort(arr:, n: arr.length)}"

# arr1 = [2000, 1800, 100, 1700, 1600, 1500, 1850, 500, 600, 700, 650, 1000, 500, 1700, 1800, -50, 75, 400, 500, 10, -110]
# puts "Max Heapify :: #{MaxBinaryHeap.max_heapify(arr: arr1, i: 3, heap_size: arr1.length)}"

# arr2 = [2000, 1800, 1850, 200, 1600, 1500, 1800, 500, 600, 700, 650, 1000, 500, 1700, 100, -50, 75, 400, 500, 10, -110]
# puts "Max Heapify :: #{MaxBinaryHeap.max_heapify(arr: arr2, i: 4, heap_size: arr2.length)}"

# arr3 = [2000, 1800, 1850, 1700, 1600, 1500, 1800, 500, 600, 700, 650]
# puts "Insert new element 4500 in #{arr3.inspect} - convert into max heap :: "
# print "\t \t \t #{MaxBinaryHeap.insert_key(k: 4500, arr: arr3, heap_size: arr3.length)} \n"

# arr4 = [nil, 4500, 1800, 2000, 1700, 1600, 1850, 1800, 500, 600, 700, 650, 1500]
# puts "Increase key of 1700 to 5000 at index 4 in #{arr4[1..arr4.length].inspect}"
# print "\t \t \t #{MaxBinaryHeap.increase_key(i: 4, new_key: 5000, arr: arr4, heap_size: arr4.length)} \n"

# arr5 = [nil, 4500, 1800, 2000, 1700, 1600, 1850, 1800, 500, 600, 700, 650, 1500]
# puts "Decrease key of 1800 to 400 at index 2 in #{arr5[1..arr5.length].inspect}"
# print "\t \t \t #{MaxBinaryHeap.decrease_key(i: 2, new_key: 400, arr: arr5, heap_size: arr5.length)} \n"

# arr6 = [4500, 1800, 2000, 1700, 1600, 1850, 1800, 500, 600, 700, 650, 1500]
# puts "Extract max from binary heap :: #{arr6.inspect}"
# max_element, binary_heap = *MaxBinaryHeap.extract_max(arr: arr6, heap_size: arr6.length)
# print "\t \t \t #{max_element} \n"
# puts "Binary Heap post extraction ::#{binary_heap.inspect}"
