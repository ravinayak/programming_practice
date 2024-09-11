# frozen_string_literal: true

# Priority Queue implementaion of MinHeap
class PriorityQueueMinHeap
  attr_accessor :arr, :heap_size

  def initialize(arr:, heap_size:)
    @arr = prep_arr(arr:)
    @heap_size = heap_size
  end

  def self.build_priority_queue(arr:, heap_size:)
    pq_min_heap = PriorityQueueMinHeap.new(arr:, heap_size:)

    index = heap_size / 2

    while index >= 1
      pq_min_heap.min_heapify(arr: pq_min_heap.arr,
                              i: index, heap_size:)
      index -= 1
    end

    pq_min_heap
  end

  def insert_object(object:)
    return insert_when_empty(object:) if arr.empty?

    return insert_when_size_one(object:) if arr.size == 1

    @heap_size += 1
    @arr[heap_size] = object

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

    smallest = if left_child_compare?(left:, i:)
                 left
               else
                 i
               end

    smallest = right if right_child_compare?(right:, smallest:)

    if smallest != i
      swap_nodes(arr:, i:, index_to_exchange: smallest)
      min_heapify(arr:, i: smallest, heap_size:)
    end

    arr
  end

  def left_child_compare?(left:, i:)
    left <= heap_size && arr[left][:key] < arr[i][:key]
  end

  def right_child_compare?(right:, smallest:)
    right <= heap_size && arr[right][:key] < arr[smallest][:key]
  end

  def empty?
    heap_size.zero?
  end

  private

  def insert_when_empty(object:)
    @arr = [nil, object]
    @heap_size += 1
  end

  def insert_when_size_one(object:)
    @arr << object
    @heap_size += 1
  end

  def float_node_till_root(arr:, i:)
    while i > 1 && arr[i][:key] < arr[parent(i:)][:key]
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

# def test
#   objs_arr = []
#   [100, 200, -4, 0, 50].each do |i|
#     objs_arr << { element: i, key: i }
#   end
#   pq_min_heap =
#     PriorityQueueMinHeap.build_priority_queue(arr: objs_arr, heap_size: 5)

#   puts "Objects inserted into Priority Queue :: #{objs_arr.inspect}"
#   puts "Priority Queue :: #{pq_min_heap.arr.inspect}"
#   pq_min_heap.insert_object(object: { element: -5, key: -5 })
#   puts "Inserting element with key -5 :: #{pq_min_heap.arr[1]}"
#   min_element = pq_min_heap.extract_min
#   puts "Min Element extracted :: #{min_element}"
#   puts "Post Min Element Extraction :: #{pq_min_heap.arr.inspect}"
# end

# test
