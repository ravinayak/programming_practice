# PriorityQueue Max Heap
class PriorityQueueMaxHeap
  attr_accessor :arr, :heap_size

  def initialize
    @arr = [nil]
    @heap_size = 0
  end

  def build_priority_queue(input_arr:)
    @heap_size = input_arr.length
    @arr = prepare_arr(input_arr:)

    n = @heap_size / 2
    n.downto(1).each do |index|
      max_heapify(arr:, index:, heap_size:)
    end
  end

  def extract_max
    top_element = arr[1]
    arr[1], arr[heap_size] = arr[heap_size], arr[1]
    @heap_size -= 1
    max_heapify(arr:, index: 1, heap_size:)
    top_element
  end

  def insert(object_hsh:)
    @heap_size += 1
    @arr[heap_size] = object_hsh
    float_node_till_root(index: heap_size)
  end

  def increase_key(index:, new_key:)
    @arr[index][:key] = new_key
    float_node_till_root(index:)
  end

  def decrease_key(index:, new_key:)
    @arr[index][:key] = new_key
    max_heapify(arr:, index:, heap_size:)
  end

  def heapsort(input_arr: nil)
    build_priority_queue(input_arr:) if input_arr

    index = heap_size
    while index > 1
      arr[index], arr[1] = arr[1], arr[index]
      index -= 1
      max_heapify(arr:, index: 1, heap_size: index)
    end
  end

  def max_heapify(arr:, index:, heap_size:)
    return if index < 1 || index > heap_size

    left_child = left_child_index(index:)
    right_child = right_child_index(index:)

    largest = if left_child <= heap_size && arr[left_child][:key] > arr[index][:key]
                left_child
              else
                index
              end

    largest = right_child if right_child <= heap_size && arr[right_child][:key] > arr[largest][:key]

    if largest != index
      arr[largest], arr[index] = arr[index], arr[largest]
      max_heapify(arr:, index: largest, heap_size:)
    end
  end

  def float_node_till_root(index:)
    return if index <= 1 || arr[parent(index:)][:key] > arr[index][:key]

    # Critical to check index > 1 before accessing parent(index:) because
    # if index = 1, parent(index:) = 0 and arr[0] is nil, no [:key] exists
    # which will cause error
    while  index > 1 && arr[parent(index:)][:key] < arr[index][:key]
      arr[parent(index:)], arr[index] = arr[index], arr[parent(index:)]
      index = parent(index:)
    end
  end

  def parent(index:)
    (index / 2)
  end

  def left_child_index(index:)
    (2 * index)
  end

  def right_child_index(index:)
    (2 * index) + 1
  end

  def prepare_arr(input_arr:)
    arr = [nil]
    input_arr.each_with_index do |element, index|
      arr[index + 1] = element
    end

    arr
  end

  def display
    return if empty?

    index = 1
    print "\n Objects in Heap :: "
    while index <= heap_size
      print "#{arr[index]}, "
      index += 1
    end
    print "\n"
  end

  def empty?
    heap_size.zero?
  end
end

def test
  objs_arr = []
  [100, 200, -4, 0, 50].each do |i|
    objs_arr << { element: i, key: i }
  end
  pq = PriorityQueueMaxHeap.new
  pq.build_priority_queue(input_arr: objs_arr)

  print "\n Objects inserted into Priority Queue :: #{objs_arr.inspect}"
  pq.display
  pq.insert(object_hsh: { element: -5, key: 1000 })
  print "\n \n Inserting element with key 1000"
  pq.display
  max_element = pq.extract_max
  print "\n \n Max Element extracted :: #{max_element}"
  pq.display
  print "\n Increasing Key of index 3 to 300 :: #{pq.increase_key(index: 3, new_key: 300)}"
  pq.display
  print "\n Decreasing Key of index 2 to -8 :: #{pq.decrease_key(index: 2, new_key: -8)}"
  pq.display
  pq.heapsort
  pq.display
  print "\n\n"
end

# test
