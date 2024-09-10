# frozen_string_literal: true

# AdjacencyMatrix class to convert adjacency matrix to
# prepare edges array from adjacency matrix
class AdjacencyMatrix
  # if adjacency matrix is given as an array for each
  # vertex, where we have an array for each vertex
  # which contains all the vertices it is connected
  # to, for ex:
  #	0 => [1, 2, 3] => 0 is connected to vertex 1, 2, 3
  # vertex 0 has 3 edges, each to vertex 1, 2, 3
  # Same vertex will appear twice since undirected
  # graph has symmetry, for ex:
  # edge from vertex 0 to vertex 1 will appear in both
  # 0 => [1,....]
  # 1 => [0,....]
  # To avoid duplicate edges, we use a simple strategy
  # that if neighbor > vertex, only then we add edge
  # this eliminates duplicate edges, for each symmetrical
  # pair, only the pair with (i, j) where i > j will be
  # added as an edge from "i" to "j" and not for the pair
  # (j, i) which will also exist
  # For Self loops, we can avoid by checking
  # vertex != neighbor
  def self.process_vertex_array(adj_matrix:, vertices:)
    edges = []

    vertices.each do |vertex|
      adj_matrix[vertex].each do |neighbor|
        edges << [vertex, neighbor] if vertex > neighbor && vertex != neighbor
      end
    end

    # return edges array
    edges
  end

  # if adjacency matrix is given as a 2D matrix where
  # for each vertex (i,j), if there exists an edge
  # between "i" and "j", adj_matrix[i][j] = 1, else 0
  # In this case, due to symmetry of edges in undirected
  # graph, if there is an edge (i, j),
  # adj_matrix[i][j] = 1
  # adj_matrix[j][i] = 1
  # To avoid duplicate edges, we only consider upper triangle
  # of the adjacency matrix, since lower triangle will be a
  # Mirror Reflection of the upper triangle (due to symmetry)
  # Upper Triangle means upper part of the diagonal in the
  # adjacency matrix
  # (i, j) represents an edge between vertex i, and vertex j
  # Number of Rows = Number of Columns = Number of vertices
  #       C     O     L     U
  #       0     1     2     3
  #      -------------------------
  #   R   0     X     X     X
  #   O   1     0     X     X     
  #   W   2           0     X
  #   S   3                  0
  #
  # Since (vertex, vertex) can not have any edge, we will not
  # consider these pairs.
  #  All cells marked X constitute upper part of the diagonal
  # Cells in the lower part of the diagonal will be Mirror
  # Reflection of the Upper part of the diagonal
  #
  def self.process_vertex_0_1s(adj_matrix:)
    edges = []

    # n represents number of vertices in the graph
    n = adj_matrix.length

    # Only Upper part of the diagonal, i.e (0, 1), (0, 2)
    # are considered, Lower part of the diagonal (1, 0) are
    # not considered
    (0...n).each do |i|
      (i + 1...n).each do |j|
        edge << [i, j] if adj_matrix[i][j] == 1
      end
    end

    # Return Edges Array
    edges
  end
end
