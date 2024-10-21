require_relative '../data_structures/queue'
require_relative '../graphs/graph'

def bfs_cycle_undirected_graph?(graph:)
  visited_edges, visited_vertices, in_degree, queue = initial_setup

  prep_in_degree_hsh(graph:, in_degree:, visited_edges:)

  zero_degree_vertices = in_degree.select { |_k, v| v.zero? }.keys

  zero_degree_vertices.each do |v|
    queue.enqueue(data: [v, -1])
  end

  until queue.empty?
    # Parent and current_vertex dequeued. Since in an un-directed graph
    # we can have a symmetrical edge from a vertex 'u' to 'v', and we
    # are using the concept of sorting to avoid symmetrical edges from
    # creating false in-degrees for vertices, we cannot use the concept
    # of processed_count to determine if there is a cycle
    # consider this graph: 1 - 2 - 3 - 4 - 1 => here we shall process
    # all vertices and detect no cycle with the above code setup
    # We must use the concept of Parent to determine cycles
    curr_vertex, parent = queue.dequeue
    next if visited_vertices[curr_vertex]

    visited_vertices[curr_vertex] = true

    graph.adj_matrix[curr_vertex]&.each do |neighbor|
      next if visited_vertices[neighbor] && neighbor == parent

      # If we visited a neighbor again and it is not the parent of
      # current_vertex, this means clearly there is a CYCLE
      return true if visited_vertices[neighbor] && neighbor != parent

      queue.enqueue(data: [neighbor, curr_vertex])
    end
  end

  false
end

def initial_setup
  visited_edges = {}
  visited_vertices = {}
  in_degree = Hash.new(0)
  queue = Queue.new

  [visited_edges, visited_vertices, in_degree, queue]
end

def prep_in_degree_hsh(graph:, in_degree:, visited_edges:)
  # To prevent [u, v] and [v, u] edges from creating
  # an in_degree for u, and v both, we sort every
  # edge and store it in visited_edges hash such that
  # a symmetrical pair is only counted 1nce when
  # calculating in_degree hash
  # 1 - 2 - 3 => in_degree[1] = 0, in_degree[2] = 1,
  # in_degree[3] = 1
  # If we allow all edges (symmetrical) to be counted
  # we shall end up with an in_degree such that no
  # vertex will have 0 for in_degree
  graph.adj_matrix.each_pair do |u, neighbor_arr|
    next if neighbor_arr.nil? || neighbor_arr.empty?

    neighbor_arr.each do |neighbor|
      key = [u, neighbor].sort
      next if visited_edges[key]

      # Sort [u, v] edge and store it in edges hash
      # which have been visited
      visited_edges[key] = true
      in_degree[neighbor] += 1
    end
  end

  # It is NECESSARY and ABSOLUTELY CRITICAL that we iterate over
  # all the vertices and set a key in in_degree hash for a vertex
  # if the vertex is not present in the hash. Any vertex which has
  # 0 in_degree will not have any edge coming to it from other
  # vertices, and hence such a vertex WILL NOT BE PRESENT in the
  # adjacency matrix of any other vertex (since adjacency matrix)
  # only contains vertices to which there are edges going from
  # the current vertex. In Iteration over adjacency matrix, this
  # vertex will not be included in the in_degree hash and we shall
  # never be able to initialize queue. We must iterate over all the
  # vertices to find if the vertex IS NOT PRESENT in in_degree hash
  # and in such a case, we SHALL SET in_degree for that vertex as 0
  graph.vertices.each do |vertex|
    next if in_degree.key?(vertex)

    in_degree[vertex] = 0
  end
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
    graph = Graph.new(vertices:, adj_matrix:)
    res = bfs_cycle_undirected_graph?(graph:)

    print "\n Input Vertices :: #{vertices.inspect}, "
    print "Adj Matrix :: #{adj_matrix.inspect}"
    print "\n Expected Output :: #{output}, Res :: #{res} \n \n"
  end
end

test
