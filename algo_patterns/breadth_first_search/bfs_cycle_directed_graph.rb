require_relative '../data_structures/queue'
require_relative '../graphs/graph'

def bfs_cycle_directed_graph?(graph:)
  visited = {}
  processed_count = 0
  in_degree = Hash.new(0)
  queue = Queue.new

  graph.adj_matrix.each_pair do |_vertex, neighbor_arr|
    next if neighbor_arr.nil? || neighbor_arr.empty?

    neighbor_arr.each do |neighbor|
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

  zero_degree_vertices = in_degree.select { |_key, value| value.zero? }.keys

  zero_degree_vertices.each do |vertex|
    queue.enqueue(data: vertex)
  end

  until queue.empty?
    current_vertex = queue.dequeue
    next if visited[current_vertex]

    visited[current_vertex] = true
    processed_count += 1

    graph.adj_matrix[current_vertex]&.each do |neighbor|
      next if visited[neighbor]

      in_degree[neighbor] -= 1
      queue.enqueue(data: neighbor) if in_degree[neighbor].zero?
    end
  end

  processed_count != graph.vertices.size
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
    graph = Graph.new(vertices:, adj_matrix:)
    res = bfs_cycle_directed_graph?(graph:)

    print "\n Vertices :: #{vertices}, Adj Matrix :: #{adj_matrix.inspect}"
    print "\n Expected Output :: #{output}, Cycle in Graph :: #{res}\n\n"
  end
end

test
