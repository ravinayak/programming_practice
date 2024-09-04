# frozen_string_literal: true

# Detect a cycle in directed graph using DFS
# 8 -> 9
# ↓
# 1 -> 2 -> 3 -> 7
# ↓ ↙
# 4 -> 5 -> 6
# In this directed graph, suppose we:

# 1. Start at vertex 1, DFS will end at vertex 6, In this case
#     we have processed vertex 1. Vertex 1 should be marked as
#     visited in the recursive DFS call itself
# 2. However, when we reach vertex 8 while iterating over vertices
#     we will again visit vertex 1 and vertex 4. These vertices
#     have already been processed and marked visited. Since there is
#     an edge from vertex 8 to vertex 1, when we perform DFS on
#     vertex 8, we shall end up visiting vertex 1 again. If we use
#     "visited" hash to detect cycle it will lead to False Positives.
#     Although vertex 1 has been visited b4, this does not mean there
#     is a cycle in the graph (as clearly seen in the graph above)
#        => Encountering a vertex which has been visited again does
#           not mean there is a cylce in the graph
# 3. visited alone cannot be used to detect cycles in graph. If a
#     vertex has many incoming edges to it, it will be visited again
#     in DFS, and there may not be any cycles.
# 4.  We must use recusion_hash to mark nodes which have been visited
#     during DFS recursion. Presence of a cycle guarantees that there
#     will be at least 1 node in recursive hash that will be visited
#     again (at least once more) during recursive DFS
# 5.  Recursion hash maintains all the nodes which are encountered
#     during certain recursion. When recursion ends for that node,
#     i.e when we return from the recursion for that node, we mark the
#     node as false in recursion_stack. Thus when we return back to
#     node in iteration of vertices, we have processed all the Edges
#     from that node, recursion_hash will be empty.
# 6. When we should we mark a node as visited, should we mark it the
#     beginning of iteration over nodes for processing all the edges
#     or should we mark the node as visited in the DFS recursive call
#     If we mark the node as visited in beginning of Iteration and not
#     in recursive call, we will run into an issue where if this node
#     is present in the adjacency list of another vertex to which an
#     edge exists from current node in DFS, we may end up performing
#     a DFS on that node again. This can lead to multiple DFS recursive
#     calls for the same node which is a wastage of resource/time, and
#     in the worst case, if there is a cycle, it can lead to INFINITE
#     RECURSION
#        => Mark node as visited in DFS recursive call itself to avoid
#           infinite recursion in the worst case, and to avoid processing
#           same node in > 1 recursive DFS calls. Any node which is
#           being processed in DFS should not be processed again.

def detect_cycle_directed_graph_dfs(vertices:, adj_matrix:)
  visited = {}
  recursion_hsh = {}

  vertices.each do |vertex|
    # If vertex has not been visited, we shall perform a DFS on this
    # vertex, if vertex has been visited we shall skip the iteration
    # We may perform DFS on a vertex when we call cycle_check?, even
    # before it is called in this iteration, we would have already
    # processed all the nodes in its adjacency matrix. Since this
    #	node has already been processed, we should not process it again
    next if visited[vertex]

    return true if cycle_check?(vertex:, adj_matrix:, visited:, recursion_hsh:)
  end

  false
end

def cycle_check?(vertex:, adj_matrix:, visited:, recursion_hsh:)
  # If a node does not have any adjacency matrix, it means we have
  # reached a node which does not have any outgoing edge, and hence
  # there cannot be a cycle
  if adj_matrix[vertex].nil?
    recursion_hsh[vertex] = false
    return false
  end

  # Mark this node as visited => avoid DFS on node again, and validate
  #	if this node is present in the recursion hash. If node is found
  # again in recursion hash during DFS, this means there is a cycle
  visited[vertex] = true
  recursion_hsh[vertex] = true

  # Iterate over the adjacency matrix
  adj_matrix[vertex].each do |neighbor|
    return true if !(visited[neighbor]) && cycle_check?(vertex: neighbor, adj_matrix:, visited:, recursion_hsh:)

    return true if recursion_hsh[neighbor]
  end

  # Since we have finished recursion for the given vertex in current call,
  # we mark is as false
  recursion_hsh[vertex] = false

  # No cycle was detected in current recursion
  false
end

# Test the method
def test
  graph_arr = [
    {
      vertices: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      adj_matrix: {
        1 => [2, 4],
        2 => [3],
        3 => [7],
        4 => [5],
        5 => [6],
        8 => [1, 9]
      },
      output: 'false'
    },
    {
      vertices: [1, 2, 3, 4, 5, 6, 7, 8, 9],
      adj_matrix: {
        1 => [4],
        2 => [1, 3],
        3 => [7],
        4 => [5],
        5 => [2, 6],
        8 => [1, 9]
      },
      output: 'true'
    }
  ]

  graph_arr.each do |graph|
    vertices = graph[:vertices]
    adj_matrix = graph[:adj_matrix]
    output = graph[:output]
    res = detect_cycle_directed_graph_dfs(vertices:, adj_matrix:)

    print "\n Vertices :: #{vertices}, Adj Matrix :: #{adj_matrix.inspect}"
    print "\n Expected Output :: #{output}, Cycle in Graph :: #{res}\n\n"
  end
end

test
