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
    visited = {}
    # stack is the data structure conceptually but we implement it as an array in Ruby
    # we push elements onto this stack and reverse the stack when returning topological
    # sort order
    #
    stack = []

    vertices.each do |vertex|
      tp_sort_util(vertex:, visited:, stack:) unless visited[vertex]
    end

    # if we implement stack as an array, reversing a stack is same as popping all elements
    # from stack one by one and collecting them in a new array
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

    # Mark the node as visited as soon as we see it, any node which has been
    # seen once should be marked as visited because in Topological sort order
    # every node appears / must appear only once. We want to determine the
    # order amongst all nodes enlisting each node exactly once
    visited[vertex] = true

    # In Topological sort every node which appears after a set of nodes requires
    # that A subset of nodes before it must be completed before the allocated node
    # can be completed. This subset may include all the nodes before it or only
    # a subset of nodes before it depending upon the dependencies outlined in DAG
    # The subset of nodes may also be empty meaning we may not need to complete
    # any nodes before it

    # Ex: A B C E =>
    #   1. To complete B we may need to complete A
    #   2. To complete C we may need to complete B, or A, or AB
    #   3. To complete E we may need to complete C, or B, or A, or BC, or ABC
    #   4. It is possible that we may not need to complete any nodes as well
    #   5. So to complete C, we may not need to complete any of B, or A, or AB
    # Consider a DAG => Node A,  Node B, Node C where there are no edges
    # Here Topological Sort => C B A
    # But no node depends on any node before it

    # From the above explanation, we can clearly see that Dependent nodes must
    # appear after the nodes on which it depends in the topological sort which
    # means (from coding point of view), all dependent nodes (neighbors in
    # matrix of a vertex) must be pushed onto stack before the vertex can be
    # pushed onto stack

    # Process all the neighbors for a given vertex, because each neighbor is
    # dependent on this vertex. Since neighbors in a directed graph are basically
    # vertices which have incoming edges from the mentioned vertex. Once we have
    # pushed all the dependent vertices on stack, we can push the vertex on which
    # all those vertices depend
    # This is critical because independent node must remain closer to Top than
    # dependent nodes. When we pop nodes from stack, the independent node should
    # appear 1st, then the dependent nodes
    # Ex: A -> B -> C
    # Stack: C => C does not have any neighbors, so it should be pushed onto stack
    # Stack: C, B => Once B's neighbors have been processed, it is pushed onto stack
    # Stack: C, B, A => Once A's neighbors have been processed, it should be pushed onto stack
    # When we pop nodes from Stack, A will be popped 1st, then B, then C
    # Topological order => A, B, C
    #   => This is correct because B depends on A; C depends on B which depends on A
    #   => Dependent nodes, neighbors should be pushed 1st, and when all dependents
    #      have been processed, push the node on which those nodes depend
    #   => Gives us an order where => Independent Node, <Dependent Nodes>
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

graph = DirectedAcyclicGraph.new(vertices: %w[A B C D E F G])

# Add edges to the graph
graph.add_edge(vertex: 'A', neighbor: 'B')
graph.add_edge(vertex: 'B', neighbor: 'C')
graph.add_edge(vertex: 'B', neighbor: 'E')
graph.add_edge(vertex: 'C', neighbor: 'D')
graph.add_edge(vertex: 'C', neighbor: 'E')
graph.add_edge(vertex: 'C', neighbor: 'G')
graph.add_edge(vertex: 'E', neighbor: 'F')
graph.add_edge(vertex: 'E', neighbor: 'G')

# Perform topological sort
sorted_order = graph.topological_sort
puts "Topological Sort: #{sorted_order.join(', ')}"
