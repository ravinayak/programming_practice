# frozen_string_literal: true

# Class for Graph
class Graph
  attr_accessor :vertices, :adj_matrix

  def initialize(vertices:, adj_matrix:)
    @vertices = vertices
    @adj_matrix = adj_matrix
  end

  # Create a Sample Undirected Graph
  def self.connected_undirected_graph
    # 0 ---- 1
    # |      | \
    # |      |  \
    # 4 ---- 3 -- 2

    adj_matrix = {
      0 => [1, 4],
      1 => [0, 2, 3],
      2 => [1, 3],
      3 => [1, 2, 4],
      4 => [0, 3]
    }
    vertices = [0, 1, 2, 3, 4]

    Graph.new(vertices:, adj_matrix:)
  end

	# Create a Sample Unconnected Undirected Graph
	def self.disconnected_undirected_graph
    # 0 ---- 1
    # |      |
    # |      |
    # 4 ---- 3  2

    adj_matrix = {
      0 => [1, 4],
      1 => [0, 3],
      3 => [1, 4],
      4 => [0, 3]
    }
    vertices = [0, 1, 2, 3, 4]

    Graph.new(vertices:, adj_matrix:)
  end
end
