class BinaryMaxHeap
  attr_accessor :heap_size, :arr

  def initialize
    @arr = [nil]
    @heap_size = 0
  end

  def build_max_heap(input_arr:)
    @heap_size = input_arr.length
    @arr = prepare_arr(arr: input_arr)
    n = heap_size / 2
    n.downto(1).each do |index|
      max_heapify(arr:, index:, heap_size:)
    end
  end

  def max_heapify(arr:, index:, heap_size:)
    max_heapify_util(arr:, index:, heap_size:)
  end

  def heapsort(input_arr:)
    build_max_heap(input_arr:)
    while heap_size > 1
      swap_nodes(arr:, index: 1, index_to_exchange: heap_size)
      @heap_size -= 1
      max_heapify_util(arr:, index: 1, heap_size:)
    end
    @arr[1..]
  end

  def insert(key:)
    @heap_size += 1
    @arr[heap_size] = key
    float_node_up_until_root(arr:, index: heap_size)
  end

  def increase_key(index:, new_key:)
    @arr[index] = new_key
    float_node_up_until_root(arr:, index:)
  end

  def decrease_key(index:, new_key:)
    @arr[index] = new_key
    max_heapify_util(arr: @arr, index:, heap_size:)
  end

  def extract_max
    top_element = @arr[1]
    swap_nodes(arr:, index: 1, index_to_exchange: heap_size)
    @heap_size -= 1
    max_heapify(arr:, index: 1, heap_size:)

    top_element
  end

  def max_element
    return nil if @heap_size.zero?

    @arr[1]
  end

  private

  def float_node_up_until_root(arr:, index:)
    return if index <= 1 || arr[parent(index:)] >= arr[index]

    while index > 1
      break if arr[parent(index:)] >= arr[index]

      swap_nodes(arr:, index:, index_to_exchange: parent(index:))
      index = parent(index:)

    end
  end

  def max_heapify_util(arr:, index:, heap_size:)
    return arr if index < 1 || index > heap_size

    left_child = left_child_node(index:)
    right_child = right_child_node(index:)

    largest = if left_child <= heap_size && arr[left_child] > arr[index]
                left_child
              else
                index
              end

    largest = right_child if right_child <= heap_size && arr[right_child] > arr[largest]
    if largest != index
      swap_nodes(arr:, index:, index_to_exchange: largest)
      max_heapify_util(arr:, index: largest, heap_size:)
    end

    arr
  end

  def swap_nodes(arr:, index:, index_to_exchange:)
    temp = arr[index_to_exchange]
    arr[index_to_exchange] = arr[index]
    arr[index] = temp
  end

  def left_child_node(index:)
    2 * index
  end

  def right_child_node(index:)
    2 * index + 1
  end

  def parent(index:)
    (index / 2)
  end

  def prepare_arr(arr:)
    updated_arr = [nil]
    index = 1
    arr.each do |element|
      updated_arr[index] = element
      index += 1
    end
    updated_arr
  end
end

def test
  max_binary_heap = BinaryMaxHeap.new

  # max_binary_heap.insert(key: 50)
  # print "\n Inserting 50 element in Heap :: #{max_binary_heap.arr.inspect}\n"

  # max_binary_heap.insert(key: 100)
  # print "\n Inserting 100 element in Heap :: #{max_binary_heap.arr.inspect}\n"

  # max_binary_heap.insert(key: 200)
  # print "\n Inserting 100 element in Heap :: #{max_binary_heap.arr.inspect}\n"

  # arr = [1, 300, -50, 100, -200, -250, 19, 57, 65, 500, -350, -550, -600, 1900, 2100]
  # max_binary_heap.heapsort(input_arr: arr)
  # puts "Sorted Array :: #{max_binary_heap.arr[1..]}"

  arr1 = [2000, 1800, 100, 1700, 1600, 1500, 1850, 500, 600, 700, 650, 1000, 500, 1700, 1800, -50, 75, 400, 500, 10, -110]
  max_binary_heap.build_max_heap(input_arr: arr1)
  puts " Build Max Heap:: #{max_binary_heap.arr.inspect}"
  max_binary_heap.heapsort(input_arr: arr1)
  puts " Sorted Array :: #{max_binary_heap.arr[1..]}"

  arr3 = [2000, 1800, 1850, 1700, 1600, 1500, 1800, 500, 600, 700, 650]
  max_binary_heap.build_max_heap(input_arr: arr3)
  print "\n\n Build Max Heap:: #{max_binary_heap.arr.inspect}"
  max_binary_heap.insert(key: 4500)
  print "\n Inserting 4500 element in Heap :: #{max_binary_heap.arr.inspect}"
  max_binary_heap.increase_key(index: 4, new_key: 5000)
  print "\n Increase key of 1700 to 5000 at index 4 in #{max_binary_heap.arr.inspect}"
  max_binary_heap.decrease_key(index: 4, new_key: 400)
  print "\n Decrease key of 1800 to 400 at index 4 in #{max_binary_heap.arr.inspect}"
  max_binary_heap.decrease_key(index: 2, new_key: 300)
  print "\n Decrease key of 4500 to 300 at index 2 in #{max_binary_heap.arr.inspect}"
  print "\n Max element extracted :: #{max_binary_heap.extract_max}"
  print "\n Post Extract Max :: #{max_binary_heap.arr[1..max_binary_heap.heap_size].inspect}"
  print "\n Max Element in Heap :: #{max_binary_heap.max_element}\n\n"
end

test
