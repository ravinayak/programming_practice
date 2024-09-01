# frozen_string_literal: true

require_relative '../algo_patterns/priority_queue/priority_queue'
# Given an array of points where points[i] = [xi, yi] represents a point
# on the X-Y plane and an integer k, return the k closest points to the
# origin (0, 0).

# The distance between two points on the X-Y plane is the Euclidean
# distance (i.e., √(x1 - x2)2 + (y1 - y2)2).

# You may return the answer in any order. The answer is guaranteed to be
# unique (except for the order that it is in).

# Example1
# Input: points = [[1,3],[-2,2]], k = 1
# Output: [[-2,2]]
# Explanation:
# The distance between (1, 3) and the origin is sqrt(10).
# The distance between (-2, 2) and the origin is sqrt(8).
# Since sqrt(8) < sqrt(10), (-2, 2) is closer to the origin.
# We only want the closest k = 1 points from the origin, so the answer is
# just [[-2,2]].

# Example 2:
# Input: points = [[3,3],[5,-1],[-2,4]], k = 2
# Output: [[3,3],[-2,4]]
# Explanation: The answer [[-2,4],[3,3]] would also be accepted.

# Algorithm: When k << n, O(n * log k) < O(k * log n)
# This is because (log x) grows at a much slower rate than (x)
#  => k * log n => smaller * small number => small
#  => n * log k => larger * much much smaller number => Very Small

# Using this idea, we maintain a max heap of "k" points where key is
# Euclidean distance, and the "k" max-heap is built from the 1st "k"
# points. For every new point, we check
#  a. If its key is greater than the root, (its Euclidean distance is
#     greater than the max distance of k points found so far), so it
#     cannot be in the k closest points to origin, and we ignore it
#  b. If its key is less than the root, its Euclidean distance is
#     less than the root, so it is closer to origin than root. We
#     replace root with this new point, and call max-heapify to
#     re-arrange the max heap
# At the end this max-heap will contain "k" nodes which have least
# Euclidean distance to origin, and hence k closes points to origin

# @param [Array<Array<Integer, Integer>>] points
# @param [Integer] k
# @return [Array<Array<Integer, Interger>>]
#
def k_closest_points_to_origin(points:, k:)
  obj_hsh_arr = []

  (0...k).each do |index|
    point = points[index]
    euclidean = (point[0] * point[0]) + (point[1] * point[1])
    obj_hsh_arr << { point:, key: euclidean }
  end

  n = obj_hsh_arr.length
  pq = PriorityQueue.new
  pq.build_priority_queue(arr: obj_hsh_arr, n:)

  (k...points.length).each do |index|
    max_distance = pq.max_element_in_priority_queue[:key]
    point = points[index]
    point_euclidean = (point[0] * point[0]) + (point[1] * point[1])
    next if point_euclidean > max_distance

    pq.extract_max
    obj_hash = { point:, key: point_euclidean }
    pq.insert_key(obj_hash:)
  end

  pq.arr.reduce([]) { |acc, point_hsh| acc << point_hsh[:point] }
end

def test
  points_arr = [
    {
      points: [[1, 3], [-2, 2]],
      k: 1,
      output: [[-2, 2]]
    },
    {
      points: [[3, 3], [5, -1], [-2, 4]],
      k: 2,
      output: [[3, 3], [-2, 4]]
    }
  ]

  points_arr.each do |point_hsh|
    points = point_hsh[:points]
    k = point_hsh[:k]
    output = point_hsh[:output]

    res = k_closest_points_to_origin(points:, k:)

    print "\n Input Point :: #{points.inspect}, k :: #{k}"
    print "\n Expected :: #{output.inspect}, "
    print " Result :: #{res}\n\n"
  end
end

test
