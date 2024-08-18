# frozen_string_literal: true

require_relative '../heap/max_binary_heap'
# frozen_string_literal: true

# Ruby does not allow usage of instance variables (@A) or constants as default values for
# method arguments directly
# Class implements Priority Queue which can hold objects and is based on max heap
#
class PriorityQueue
  class << self
    # Build Priority Queue from an array of n object hashes, each of which must
    # contain a key - "key", the object hash can contain other keys as well
    # Time Complexity: O(n)
    # @param [Array] arr
    # @param [Integer] n
    # @return [Array]
    #
    def build_priority_queue(arr:, n:)
      arr_updated = prepare_arr_for_heap(arr:)
      index = n / 2

      while index >= 1
        arr = build_priority_queue_helper(arr: arr_updated, i: index, heap_size: n)
        index -= 1
      end

      arr
    end

    # Insert a new object hash in Priority Queue as a key
    # @param [Integer] obj_hash
    # @param [Array] arr
    # @param [Integer] heap_size
    # @return [Array]
    #
    def insert_key(obj_hash:, arr:, heap_size:)
      priority_queue_arr = prepare_arr_for_heap(arr:)

      new_heap_size = heap_size + 1
      priority_queue_arr[new_heap_size] = obj_hash

      index = new_heap_size
      priority_queue_arr = float_node_up_until_root(index:, arr: priority_queue_arr)

      priority_queue_arr[1..new_heap_size]
    end

    # Extract max element from a Priority Queue
    # @param [Array] arr
    # @param [Integer] heap_size
    # @return [Integer]
    #
    def extract_max(arr:, heap_size:)
      arr_updated = prepare_arr_for_heap(arr:)
      exchange_nodes(i: heap_size, index_to_exchange: 1, arr: arr_updated)

      max_element = arr_updated[heap_size]
      new_heap_size = heap_size - 1
      arr_updated = build_priority_queue_helper(arr: arr_updated, i: 1, heap_size: new_heap_size)

      [max_element, arr_updated[1..new_heap_size], new_heap_size]
    end

    private

    # Compare node with its parent until we find a parent that has value greater than or equal
    # to key of node or we reach root
    # @param [Integer] index
    # @param [Array] arr
    # @return [Array]
    #
    def float_node_up_until_root(index:, arr:)
      while index > 1 && arr[parent(i: index)][:key] < arr[index][:key]
        exchange_nodes(i: index, index_to_exchange: parent(i: index), arr:)
        index = parent(i: index)
      end

      arr
    end

    # Helper method to implement build Priority Queue
    # @param [Array] arr
    # @param [Integer] i
    # @param [Integer] heap_size
    # @return [Array]
    #
    def build_priority_queue_helper(arr:, i:, heap_size:)
      left = left(i:)
      right = right(i:)

      # index "i" is a valid index within binary heap. However, left or right
      # child of "i" maybe outside heap size
      #
      largest = if left <= heap_size && arr[left][:key] > arr[i][:key]
                  left
                else
                  i
                end

      largest = right if right <= heap_size && arr[right][:key] > arr[largest][:key]

      if largest != i
        exchange_nodes(i:, index_to_exchange: largest, arr:)
        build_priority_queue_helper(arr:, i: largest, heap_size:)
      end

      # return Array arr which is a valid max heap
      arr
    end

    # Prepares Arr, heap_size and returns an array which contains
    # those values. Shifts all elements of array by 1, so that index
    # of array starts at 1, and not 0
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

    # Left child of node at index "i" in Priority Queue
    # @param [Integer] i
    # @return [Integer]
    #
    def left(i:)
      2 * i
    end

    # Right child of node at index "i" in Priority Queue
    # @param [Integer] i
    # @return [Integer]
    #
    def right(i:)
      2 * i + 1
    end

    # Parent of node at index "i" in Priority Queue
    # @param [Integer] i
    # @return [Integer]
    #
    def parent(i:)
      i / 2
    end
  end
end

# sorted_arr = [1, 25, -35, -50, 75, 120, 5]
# arr_index = 0
# objs = []
# sorted_arr.each_with_index do |element, index|
# 	objs << { arr_index:, element_index: index, key: element }
# end

# pq = PriorityQueue.build_priority_queue(arr: objs, n: objs.length)
# obj_hash = { arr_index: 0, element_index: 15, key: 125}

# pq = PriorityQueue.insert_key(obj_hash:, arr: pq.compact, heap_size: pq.compact.size)
# puts "Extract Max :: #{PriorityQueue.extract_max(arr: pq, heap_size: pq.size)}"
