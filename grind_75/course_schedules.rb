# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'
# There are a total of numCourses courses you have to take, labeled
# from 0 to numCourses - 1. You are given an array prerequisites where
# prerequisites[i] = [ai, bi] indicates that you must take course bi
# first if you want to take course ai.

# For example, the pair [0, 1], indicates that to take course 0 you
# have to first take course 1.
# Return true if you can finish all courses. Otherwise, return false.

# Example 1:
# Input: numCourses = 2, prerequisites = [[1,0]]
# Output: true
# Explanation: There are a total of 2 courses to take.
# To take course 1 you should have finished course 0. So it is possible.

# Example 2:
# Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
# Output: false
# Explanation: There are a total of 2 courses to take.
# To take course 1 you should have finished course 0, and to take course 0
# you should also have finished course 1. So it is impossible.

# Kahn's Algorithm Explained
# Kahn's Algorithm is an algorithm to find a topological ordering of a directed
# graph.
# If a graph has a topological ordering, then it is a
# Directed Acyclic Graph (DAG),meaning there are no cycles.

# Steps of Kahn's Algorithm:

# 1. Initialize Data Structures:
# Adjacency List (graph): A dictionary where each key is a course, and the value is
# a list of courses dependent on it.
# Indegree Array (indegree): An array that counts the number of incoming edges
# (prerequisites) for each course.

# 2. Build the Graph and Compute Indegrees:
# For each prerequisite pair [a, b] in the prerequisites list:
# Add a to the adjacency list of b (graph[b].append(a)).
# Increment the indegree of a by 1 (indegree[a] += 1).

# 3. Initialize Queue:
# Create a queue (queue) and enqueue all courses with indegree 0
# (i.e., courses with no prerequisites).

# 4. Process the Queue:
# While the queue is not empty:
# Dequeue a course (course).
# This course can be taken as all its prerequisites have been met.
# For each course (neighbor) dependent on the dequeued course (course):
# Decrement the indegree of neighbor by 1 (indegree[neighbor] -= 1).
# If indegree[neighbor] becomes 0, enqueue neighbor
# (since all its prerequisites have been met).

# 5. Check for Cycles:
# Keep a count (visited) of how many courses you have processed.
# After processing, if visited equals numCourses, all courses can be taken
# (return True).
# If not all courses are processed (visited < numCourses), there is a cycle
# in the graph (return False).

# Algorithm: [0, 1] means we must take course 1 as pre-requisite for course 0
# In this case there will be a Directed Edge from course 1 -> course 0
# Edge is always from Pre-Requisite courses to dependent courses. Khan's
# algorithm is focused around the idea of Indegree calculation, where if the
# indegree of a node is 0, it means the node does not have any pre-requisites
# InDegree => Incoming Edges count => No Indegree => No Incoming Edge
# indegree (node > 0) => Incoming Edges (node > 1) => Node has Pre-requisties
# => Node is a dependent course
# => Edge direction if from Pre-requisite to Dependent course
# 1. Iterate over the pre-requisistes array and prepare an adjacent matrix
#    for each tuple in the array, [ai, bi] => adj[ai] << bi
# 2. Prepare an array of distinct courses, initialize an array of size
#     num_courses
# 3. Iterate over each course in the array, and calculate its indegree, store
#     the value in indegree_arr for each course
#  4. Find all courses in indegree_arr that have a value of 0 and enqueue them
# 5. Remove each course from queue, and for each course, reduce the indegree
#     for the dependent courses by 1
#      => Directed Edge from bi to ai => bi --> ai => adj[bi] << ai
#      => bi is the pre-requisite course (with an indegree of 0)
#      => adj[course deququed]: Iterate over each course in this list, and reduce
#         the indegree of each course by 1
# 6. If any course gets their indegree reduced to "0", enqueue the course
#  7. Keep processing until queue becomes empty
# 8. Iterate over indegree_arr to find any course with indegree > 0
#      => This implies that though we have taken all the pre-requisites, there
#         are still some courses which cannot be taken
#      => This is because the graph has a cylce where one course depends on
#         another

# Why do we not need visited hash to maintain nodes which have been visited?
# Since we only decrement the in-degree of a node when processing its predecessors,
# and a node is added to the queue only when its in-degree first reaches 0, a node
# cannot have its in-degree decrease back to 0 again after it has already been
# processed. There is no mechanism in the algorithm where the indegree of a node
# can be increased, therefore once a node indegree reaches 0, it cannot become 0
# again

# @param [Array<Array<Integer>>] pre_requisites
# @param [Integer] num_courses
# @return [Boolean]
#
def complete_course_schedule(pre_requisites:, num_courses:)
  return true if [0, 1].include?(num_courses)

  adj_matrix = Hash.new { |h, k| h[k] = [] }
  processed_count = 0
  queue = Queue.new
  in_degree = Hash.new(0)

  pre_requisites.each do |dependent_course, pre_requisite_course|
    adj_matrix[pre_requisite_course] << dependent_course
    in_degree[dependent_course] += 1
  end

  (0..num_courses).each do |course|
    queue.enqueue(data: course) if (in_degree[course]).zero?
  end

  until queue.empty?
    course = queue.dequeue
    processed_count += 1

    adj_matrix[course]&.each do |dependent_course|
      in_degree[dependent_course] -= 1
      queue.enqueue(data: dependent_course) if (in_degree[dependent_course]).zero?
    end
  end

  processed_count == num_courses
end

def test
  courses_arr = [
    {
      num_courses: 2,
      pre_requisites: [[1, 0]],
      output: 'true'
    },
    {	num_courses: 2,
      pre_requisites: [[1, 0], [0, 1]],
      output: 'false' }
  ]

  courses_arr.each do |course_hsh|
    num_courses = course_hsh[:num_courses]
    pre_requisites = course_hsh[:pre_requisites]
    output = course_hsh[:output]
    res = complete_course_schedule(pre_requisites:, num_courses:)

    print "\n Input Num of Courses :: #{num_courses}, "
    print "Pre-Requisite Courses :: #{pre_requisites}\n"
    print " Expected Output :: #{output}, Result :: #{res}\n\n"
  end
end

test
