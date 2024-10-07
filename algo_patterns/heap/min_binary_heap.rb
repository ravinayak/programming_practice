# frozen_string_literal: true

# Min Heap Implementation
class MinBinaryHeap
  attr_accessor :arr, :heap_size

  def initialize(arr:, heap_size:)
    @arr = prep_arr(arr:)
    @heap_size = heap_size
  end

  def root_element
    arr[1]
  end
  
  def self.build_min_heap(arr:, heap_size:)
    min_heap = MinBinaryHeap.new(arr:, heap_size:)

    index = heap_size / 2

    while index >= 1
      min_heap.min_heapify(arr: min_heap.arr, i: index, heap_size:)
      index -= 1
    end

    min_heap
  end

  def insert_key(key:)
    return insert_when_empty(key:) if arr.empty?

    return insert_when_size_one(key:) if arr.size == 1

    @heap_size += 1
    @arr[heap_size] = key

    float_node_till_root(arr:, i: heap_size)
  end

  def extract_min
    min_element = arr[1]
    swap_nodes(arr:, i: 1, index_to_exchange: heap_size)
    @heap_size -= 1

    min_heapify(arr:, i: 1, heap_size:)
    min_element
  end

  def min_heapify(arr:, i:, heap_size:)
    left = left_child(i:)
    right = right_child(i:)

    smallest = if left <= heap_size && arr[left] < arr[i]
                 left
               else
                 i
               end

    smallest = right if right <= heap_size && arr[right] < arr[smallest]

    if smallest != i
      swap_nodes(arr:, i:, index_to_exchange: smallest)
      min_heapify(arr:, i: smallest, heap_size:)
    end

    arr
  end

  def empty?
    heap_size == 0
  end

  private

  def insert_when_empty(key:)
    @arr = [nil, key]
    @heap_size += 1
  end

  def insert_when_size_one(key:)
    @arr << key
    @heap_size += 1
  end

  def float_node_till_root(arr:, i:)
    while i > 1 && arr[i] < arr[parent(i:)]
      swap_nodes(arr:, i:, index_to_exchange: parent(i:))
      i = parent(i:)
    end
  end

  def left_child(i:)
    i * 2
  end

  def right_child(i:)
    i * 2 + 1
  end

  def parent(i:)
    (i / 2)
  end

  def swap_nodes(arr:, i:, index_to_exchange:)
    temp = arr[i]
    arr[i] = arr[index_to_exchange]
    arr[index_to_exchange] = temp
  end

  def prep_arr(arr:)
    updated_arr = []
    index = 1

    arr.each do |element|
      updated_arr[index] = element
      index += 1
    end
    updated_arr
  end
end

def test
  arr = [1, 5, 7, -5, 3, 19, 25, -100, -25, -34]
  min_heap = MinBinaryHeap.build_min_heap(arr:, heap_size: arr.length)

  min_heap.insert_key(key: -150)
  puts " Root element should be -150 :: #{min_heap.arr[1]}"

  min_element = min_heap.extract_min
  puts " Minimum element extracted should be -150 :: #{min_element}"

  puts " Root element should be -100 :: #{min_heap.arr[1]}"

  min_heap = MinBinaryHeap.build_min_heap(arr: [], heap_size: 0)
  puts " Empty Min Heap :: #{min_heap.arr}, Size :: #{min_heap.heap_size}"
end

# test
