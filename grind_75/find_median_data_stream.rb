# frozen_string_literal: true

require_relative '../algo_patterns/heap/max_binary_heap'
require_relative '../algo_patterns/heap/min_binary_heap'
# The median is the middle value in an ordered integer list. If the
# size of the list is even, there is no middle value, and the median
# is the mean of the two middle values.

# For example, for arr = [2,3,4], the median is 3.
# For example, for arr = [2,3], the median is (2 + 3) / 2 = 2.5.
# Implement the MedianFinder class:

# MedianFinder() initializes the MedianFinder object.
# void addNum(int num) adds the integer num from the data stream to
# the data structure.
# double findMedian() returns the median of all elements so far.
# Answers within 10-5 of the actual answer will be accepted.

# Example 1:

# Input
# ["MedianFinder", "addNum", "addNum", "findMedian", "addNum", "findMedian"]
# [[], [1], [2], [], [3], []]
# Output
# [null, null, null, 1.5, null, 2.0]

# Explanation
# MedianFinder medianFinder = new MedianFinder();
# medianFinder.addNum(1);    // arr = [1]
# medianFinder.addNum(2);    // arr = [1, 2]
# medianFinder.findMedian(); // return 1.5 (i.e., (1 + 2) / 2)
# medianFinder.addNum(3);    // arr[1, 2, 3]
# medianFinder.findMedian(); // return 2.0

# Find Median class
class MedianFinder
  attr_accessor :max_heap, :min_heap, :arr

  def initialize
    @max_heap = MaxBinaryHeap.new
    @min_heap = MinBinaryHeap.new
    @arr = []
  end

  class << self
    def process_operations(operations_arr:, data_arr:)
      return [nil] if operations_arr.empty? || data_arr.empty? || operations_arr.size != data_arr.size

      output_arr = []
      median_finder = MedianFinder.new
      operations_arr.each_with_index do |operation, index|
        if operation == 'MedianFinder'
          output_arr << nil
          next
        end

        if operation == 'findMedian'
          output_arr << median_finder.find_median
          next
        end

        median_finder.arr << data_arr[index][0]
        output_arr << median_finder.add_num(data: data_arr[index][0])
      end

      # Return Output Arra
      output_arr
    end
  end

  def find_median
    return max_heap.root_element.to_f if (max_heap.heap_size + min_heap.heap_size).odd?

    (max_heap.root_element + min_heap.root_element) / 2.0.to_f
  end

  def add_num(data:)
    if max_heap.heap_size.zero?
      max_heap.insert_key(k: data)
      return nil
    end

    if data <= max_heap.root_element
      max_heap.insert_key(k: data)
    else
      min_heap.insert_key(key: data)
    end

    if min_heap.heap_size > max_heap.heap_size
      min_heap_root = min_heap.extract_min
      max_heap.insert_key(k: min_heap_root)
    elsif max_heap.heap_size > min_heap.heap_size + 1
      max_heap_root = max_heap.extract_max
      min_heap.insert_key(key: max_heap_root)
    end

    # Return nil
    nil
  end
end

def test
  operations_arr = %w[MedianFinder addNum addNum findMedian addNum findMedian addNum addNum addNum findMedian addNum
                      findMedian]
  data_arr = [[], [1], [2], [], [3], [], [19], [25], [17], [], [35], []]
  output = [nil, nil, nil, 1.5, nil, 2.0, nil, nil, nil, 10.0, nil, 17.0]

  print "\n\n Operations Arr :: #{operations_arr.inspect}"
  print "\n Data Arr :: #{data_arr.inspect}"
  print "\n Median Finder :: #{MedianFinder.process_operations(operations_arr:, data_arr:)}"
  print "\n Output        :: #{output.inspect}\n\n"
end

test
