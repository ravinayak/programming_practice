# frozen_string_literal: true

require_relative '../graph'
# Strongly connected component in a graph is a Maximal
# subset of vertices in the graph where each vertex
# is connected to every other vertex in that subset
# If vertex "u" and vertex "v" belong to a SCC, then
#   a. u -> v => Path from u to v => we can reach v from u
#   b. v -> u => Path from v to u => we can reach u from v
#
# Consider the graph below:
#
#   0 → 1 → 2 → 0
#       ↓
#       3 → 4 → 5 → 3
#
# In the above graph, we have 2 SCCs => [0, 1, 2], [3, 4, 5]
# 0 -> 1 -> 2 -> 0
# These form a cycle, because there is a
#  cycle, every node is reachable from every other node
# When we run Tarjans algo, this will happen
# INTENTIONALLY LEFT OUT processing of node 3 as neighbor of
# node 1 to keep it simple
#
# Step 1:
#  a. indices[0] = 0, low_links[0] = 0, Node 0 visited
#  b. index = 1
#  c. stack = [0], in_stack = { 0: true }
#  d. Iterate over adj_matrix[0] (= [1]), only 1 node
#  e. node 1 has not been visited, DFS on it
#
# Step 2:
#  a. indices[1] = 1, low_links[1] = 1, Node 1 visited
#  b. index = 2
#  c. stack = [0, 1], in_stack = { 0: true, 1: true }
#  d. Iterate over adj_matrix[1] (= [2]), only 1 node
#  e. node 2 has not been visited, DFS on it
#
# Step 3:
#  a. indices[2] = 2, low_links[1] = 2, Node 2 visited
#  b. index = 3
#  c. stack = [0, 1, 2], in_stack = { 0: true, 1: true, 2: true }
#  d. Iterate over adj_matrix[2] (= [0]), only 1 node
#  e. node 0 has been visited, so DO NOT DFS ON IT
#    => This is where MAGIC HAPPENS
#    => low_links[0] = [low_links[0], indices[2]].min = [0, 2].min = 0
#    Thus we set the low_links value of 0 to 0, every node to which
#    we will backtrack will now use this value to set the low_links
#    for them to this value. Thus every node which forms a part of SCC
#    are set same low_link values
#
# Step 4: Backtrack to Node 2
#    low_links[2] = [low_links[2], low_links[0]].min = [2, 0].min = 0
# Step 5: Backtrack to Node 1
#    low_links[1] = [low_links[1], low_links[2]].min = [1, 0].min = 0
# Step 6: Backtrack to Node 0
#  a. We have iterated over adjacency list of Node 0
#  b. We move to the other part of code where we check for current
#     node being root of SCC, low_links[node] = indices[node]
#  c. At this time,
#      => stack = [0, 1, 2], in_stack = { 0: true, 1: true, 2: true }
#      => scc << 2, scc << 1, scc << 0; scc = [2, 1, 0]
#      => when node 0 is popped, we break
#      => @sccs << [2, 1, 0], we have found a SCC

# Time Complexity: O(V+E)
# Tarjans algo is very fast because it visits each node and each vertex
# only once. When we iterate over adjacency matrix of any vertex, we
# mark each neighbor as visited by recording its discovery time in
# indices hash, if this vertex is encountered again in another edge
# it will not be visited again
# Visit each vertex once, Visit each edge once
# O(V+E)

# Class implements Tarjan Algorithm
class TarjanAlgo
  attr_accessor :graph, :index, :indices, :stack, :in_stack, :low_links, :sccs

  def initialize(graph:)
    @graph = graph
    # Global index to track discovery time of current node
    # This is just a fancy term being used in algorithm
    # to refer to the current depth of recursion
    @index = 0
    # Hash to keep track of discovery time of each node
    # Maintains tracking of nodes which have been visited
    @indices = {}
    # Hash to keep track of low_link values for each node
    @low_links = {}
    # Stack to maintain set of currently set of visited
    # nodes
    @stack = []
    # Hash to maintain nodes which are currently in stack
    @in_stack = {}
    # Array to hold SCCs
    @sccs = []
  end

  # Find all the strongly connected components in given
  # directed graph
  def find_sccs
    # Perform DFS on each unvisited node
    dfs
    # Determine array which holds list of strongly connected
    # components
    sccs
  end

  # Perform DFS on every visited node
  def dfs
    graph.vertices.each do |vertex|
      # If nodes has not been visited, its discovery
      # time is not recorded yet
      strongly_connected(node: vertex) if indices[vertex].nil?
    end
  end

  # Determines which nodes in graph form a Strongly
  # Connected Component
  def strongly_connected(node:)
    # Initialize node to required values
    strongly_connected_initialization(node:)

    # Iterate over adjacency matrix of current
    # node to perform DFS on each unvisited node
    iterate_over_adj_matrix(node:)

    # If current node is the root of SCC, populate
    # scc and push it into sccs
    # Found a list of nodes that form SCC
    populate_scss(node:)

    # Return the list of Strongly Connected Components
    sccs
  end

  private

  # @param [Integer] node
  # @return [void]
  def strongly_connected_initialization(node:)
    # Initially both discovery time and low_links values
    # for node are set to the initial discovery time of
    # the node
    @indices[node] = @index
    @low_links[node] = @index
    # Increment the Global Discovery time, as next time
    # when this method is called, recursion depth will
    # be increased by 1
    @index += 1
    # Push node onto stack, and mark it as present in
    # the set of nodes which are currently being visited
    @stack.push(node)
    @in_stack[node] = true
  end

  # @param [Integer] node
  # @return [void]
  def iterate_over_adj_matrix(node:)
    graph.adj_matrix[node].each do |neighbor|
      # If neighbor has not been visited, its discovery
      # time has not been recorded yet
      if indices[neighbor].nil?
        strongly_connected(node: neighbor)
        # If neighbor is being visited for the 1st time
        # in current recursion, we recursively perform
        # DFS on it, and in this use case we use
        # low_links values of node and neighbor
        @low_links[node] = [@low_links[node], @low_links[neighbor]].min
      # If neighbor has been visited, it must be in stack
      # of currently visited nodes
      elsif in_stack[neighbor]
        # If neighbor has been visited in current recursion
        # it means we have found a cycle in the graph, where
        # current set of nodes form a strong SCC. In this case
        # we set the low_link value of node to the minimum of
        # current low_link value of node and discovery time of
        # neighbor
        # This is used because the indices hash will always contain
        # a higher value of discovery time for neighbor as compared
        # to low_links value for node, setting the low_links value
        # of node to existing value of low_links for the node
        # In effect, when we backtrack to previous node, since it
        # has been visited, and its neighbors low_links value is
        # set to a lower value, the low_links value for the neighbor
        # will be set to low_links value for the node in previous
        # recursion, this will happen recursively for all nodes
        # that form a cycle or form a part of SCC
        # Thus we can pop off all the nodes from stack until the
        # node and this will give us all the nodes which form a
        # SCC
        @low_links[node] = [@low_links[node], @indices[neighbor]].min
      end
    end
  end

  # @param [Integer] node
  def populate_scss(node:)
    # if low_links value for node is same as discovery time for the
    # node, then this node forms root of SCC. All nodes in stack
    # upto this node form SCC. If they are not equal, then that
    # node is not the root of SCC
    return unless low_links[node] == indices[node]

    scc = []
    loop do
      node_popped = stack.pop
      # Mark the node as no longer in current set of visited nodes
      in_stack[node_popped] = false
      scc << node_popped
      # if the node being popped is same as root of SCC, we have
      # found all nodes which form SCC, so, break from the loop
      break if node == node_popped
    end

    # Push the array of nodes which form SCC into array of
    # SCC in graph
    @sccs << scc
  end
end

def graph
  vertices = [0, 1, 2, 3, 4, 5]
  adj_matrix = {
    0 => [1],
    1 => [2, 3],
    2 => [0],
    3 => [4],
    4 => [5],
    5 => [3]
  }
  Graph.new(vertices:, adj_matrix:)
end

def test
  res = TarjanAlgo.new(graph:).find_sccs
  puts "Strongly Connected Components :: #{res.inspect}"
end

test
