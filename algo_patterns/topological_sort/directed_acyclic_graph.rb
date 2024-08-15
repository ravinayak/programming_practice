# frozen_string_literal: true

# Topological sort of graph
class DirectedAcyclicGraph
  attr_accessor :vertices, :adj_matrix

  def initialize(vertices:)
    @vertices = vertices
    # Hash.new([]) doesn't work here because it would use the same array
    # for all keys, leading to unintended shared state. The current
    # approach creates a new array for each new key, avoiding this issue.
    @adj_matrix = Hash.new { |hsh, key| hsh[key] = [] }
  end

  # Adds an edge to DAG
  # @param [String] vertex
  # @param [String] neighbor
  #
  def add_edge(vertex:, neighbor:)
    @adj_matrix[vertex] << neighbor
  end

  # Implements Topological sorting for graph
  # @return [Array]
  #
  def topological_sort
    puts adj_matrix.inspect
    visited = {}
    # stack is the data structure conceptually but we implement it as an array in Ruby
    # we push elements onto this stack and reverse the stack when returning topological
    # sort order
    #
    stack = []

    vertices.each do |vertex|
      tp_sort_util(vertex:, visited:, stack:) unless visited[vertex]
    end

    stack.reverse
  end

  private

  # Utility to implement topological sort for DAG
  # @param [String] vertex
  # @param [Hash] visited
  # @param [Stack] stack
  # @return NIL
  #
  def tp_sort_util(vertex:, visited:, stack:)
    return if visited[vertex]

    visited[vertex] = true

    adj_matrix[vertex].each do |neighbor|
      tp_sort_util(vertex: neighbor, visited:, stack:) unless visited[neighbor]
    end

    stack.push(vertex)
  end
end

# Create a graph with vertices 'A', 'B', 'C', 'D', 'E', 'F'
graph = DirectedAcyclicGraph.new(vertices: %w[A B C D E F])

# Add edges to the graph
graph.add_edge(vertex: 'A', neighbor: 'C')
graph.add_edge(vertex: 'B', neighbor: 'C')
graph.add_edge(vertex: 'B', neighbor: 'D')
graph.add_edge(vertex: 'C', neighbor: 'E')
graph.add_edge(vertex: 'D', neighbor: 'F')
graph.add_edge(vertex: 'E', neighbor: 'F')

# Perform topological sort
sorted_order = graph.topological_sort
puts "Topological Sort: #{sorted_order.join(', ')}"

# Topological Sort: B, D, A, C, E, F
# Actual Linear Ordering possible is
#           ------------->
#        B -> D   A -> C -> E -> F
#               ------------------->
# In order to reach end goal of F, we must complete the following tasks in sequence:
#       a. Complete B
#       b. Complete D
#       c. Complete A
#       d. Complete C (B is a dependency but it is already completed in Step a)
#       e. Complete E
#       f. Complete F (D is a dependency but it is already completed in Step b)
