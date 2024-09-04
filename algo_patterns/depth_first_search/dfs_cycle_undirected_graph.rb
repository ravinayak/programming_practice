# frozen_string_literal: true

# In Undirected graph, there is no direction. We maintain recursion_hash
# because in Directed Graph, because there are definite paths in the
# direction of edges which we can take, and visited alone is NOT
# Enough to detect cycles.
# 1. In Undirected Graph, there is an edge without direction, visited
#    alone is enough to detect Cycle, however it needs an adjustment
# 2. Consider this ex:    1 ----- 2
#    When we iterate over the neighbors of 1, we go to 2 but at 2
#    1 is also the neighbor. Since there are no directions, we can
#    go in any direction. However 1 would be marked as visited and
#    if we use visited alone to detect cycles, this would give
#    False Positives. We have to keep track of the Parent Element
#    whenever we descend to any Node
# 3. For start vertex, parent = -1, for every other node, it is the
#    node from which we have descended into recursion (i.e neighbor)
#      => 1 --- 2 => Vertex = 2, parent = 1
#      => At 2, we see 1 as the neighbor, however it is visited and
#         at this time, we check if 1 is the parent
#      => If neighbor = parent (when neighbor has been visited), it
#         clearly means that we have visited the parent before and come
#         to current node from parent. Parent happens to be the neighbor
#         of the current node and this is a case of Backtrack. There is
#          no Cycle
# 4. If neighbor != parent and visited[neighbor] = true
#      => we have recursed to a node whose neighbor has been visited
#         before in the current recursion and this neigbor is not the
#         parent of node (i.e it is not a case of backtrack from node
#         to parent and vice-versa)
#      => This is a use case of cycle. Only if there is a cycle, we
#         shall visit a node again in recursion NOT FROM ITS PARENT
# 5. Consider ex:
#              1 ---- 2 ----- 3
#              |     /
#              |  /
#              4
#    DFS Recursion:
#      a. Step 1: Start at vertex 1, go to vertex 4 (visited[1], visited[4] = true)
#      b. Step 2: At vertes 4, go to vertex 2 (visited[2] = true)
#      c. Step 3: At vertex 2, neighbor = 1 but it has been visited
#            => [ neighbor = 1, parent = 2]
#            => visited[1] = true but neighbor != parent (1 != 2)
#      d. This means we started at node "x" in recursion, and we have reached this
#         node again in recursion, but not because it is an undirected graph and
#         we can go in any direction on an edge, so we end up going back to same
#         node from where we came. This means we have encountered a cycle
#

# @param [Array<Integer>] vertices
# @parma [Hash[key => Array<Integer>]] adj_matrix
# @return [Boolean]
#
def cycle_check_undirected_graph_dfs(vertices:, adj_matrix:)
  visited = {}
  vertices.each do |vertex|
    next if visited[vertex]

    return true if cycle_check?(vertex:, adj_matrix:, visited:, parent: -1)
  end

  false
end

def cycle_check?(vertex:, adj_matrix:, visited:, parent:)
  # we should not return false from here if adj_matrix[vertex].nil?
  # This is because visited[vertex] = true will not be set for that
  # vertex
  visited[vertex] = true

  adj_matrix[vertex]&.each do |neighbor|
    # If neighbor has not been visited, we should perform a DFS on this node
    # visited[neighbor] = true => node has already been processed in DFS
    if !visited[neighbor]
      return true if cycle_check?(vertex: neighbor, adj_matrix:, visited:, parent: vertex)
      # neighbor != parent check should only be called when neighbor has been visited, the
      # condition should be in else logic, if you check for neighbor != parent for non-visited
      # nodes, it will always return true
    elsif neighbor != parent
      # We are not backtracking on the edge in opposite direction, and yet we
      # have found a node that has been visited before => Cycle
      return true
    end
  end

  # No Cycle found
  false
end

# test
def test
  graph_arr = [
    {
      vertices: [1, 2, 3, 4],
      adj_matrix: {
        1 => [2, 4],
        2 => [1, 3],
        4 => [1]
      },
      output: 'false'
    },
    {
      vertices: [1, 2, 3, 4],
      adj_matrix: {
        1 => [2, 4],
        2 => [1, 3],
        4 => [1, 2]
      },
      output: 'true'
    }
  ]

  graph_arr.each do |graph|
    vertices = graph[:vertices]
    adj_matrix = graph[:adj_matrix]
    output = graph[:output]
    res = cycle_check_undirected_graph_dfs(vertices:, adj_matrix:)

    print "\n Input Vertices :: #{vertices.inspect}, "
    print "Adj Matrix :: #{adj_matrix.inspect}"
    print "\n Expected Output :: #{output}, Res :: #{res} \n \n"
  end
end

test
