# frozen_string_literal: true

require_relative 'adjacency_matrix'
require_relative '../graph'
# Union Find Implementation
# Algorithm: Core idea is to start with all vertices as belonging
# to their own sets with the vertex being its own parent. For each
# edge which exists in the Undirected Graph, we do a union of the
# vertices in the edge. This allows us to merge vertices which are
# connected into the same set by making one vertex as the parent
# of the other. At this time, it also performs Path Compression
# which allows us to retrieve values faster for future operations

# Graph Connectivity:
# Once we have processed all edges in a Graph, we have created
# trees where all nodes that are connected belong to a set and
# have One Element (vertex) as their root/representative. Vertices
# which are not connected will be in different sets, their
# parents (root) will be different. This way we can find graph
# connectivity or connected components in a Graph. Components
# which are not connected will be in Disjoint Sets

# Detection of Cycles:
# If there exists a cycle in the Graph, as we process edges in the
# Graph, we shall be compressing their parent paths, which means
# all vertices which are in the same set will end up having same
# root for the vertices which belong to same set. If there is a
# cycle, one of the edges will lead to a use case where find(u)
# and find(v) for edge (u,v) will give the same root meaning
# vertices in the same set are connected to each other creating
# a cycle
# Run the algorithm for this graph to gain more clarity
# A -- B
# |    |
# D -- C

# Union-Find (Disjoint Set Union) is primarily designed for cycle
# detection in undirected graphs. The reason it works well for
# undirected graphs is that the relationship between nodes is
# symmetric—if two nodes are connected by an edge, they must belong
# to the same connected component, and a cycle can be detected if
# two nodes in the same connected component are connected again.

# However, for directed graphs, the relationships between nodes are
# asymmetric (one-way edges), and the simple union-find approach does
# not naturally handle the complexity of directed edges and their
# order.

# Time Complexity

# • Find: With path compression, the time complexity of Find is
# nearly constant, O(α(n)), where α is the inverse Ackermann function,
# which grows very slowly and is practically constant for all real-world
# inputs.
# • Union: With union by rank or size, the union operation also
# takes O(α(n)).

# Thus, both Find and Union are nearly constant in practice, and the overall
# time complexity for m operations on n elements is O(m \* α(n)).

# In practice, the time complexity is almost linear, meaning the time it takes
# to perform m operations on n elements is approximately O(m), because the α(n)
# term is so small that it behaves like a constant in real-world cases

# "m" operations of Union Find on "n" elements => O(m) time => Linear Time

# Class to implement UnionFind data structure
# rubocop:disable Naming/VariableName
class UnionFind
  attr_accessor :parent, :rank

  # @param [Integer] size
  def initialize(size:)
    # Creates an array of size - 1 with elements in the array as
    # values ranging from 0 through size - 1
    # [0, 1, 2, 3, 4, .... size - 1]
    @parent = (0...size).to_a
    # Initialize Rank Array with 0 value for all elements
    @rank = Array.new(size, 0)
  end

  def find(x:)
    # x is the root of set, or this is an initial use case where
    # each element forms its own set with the element being its
    # own parent
    return x if parent[x] == x

    # Path Compression, parent[x] now points directly to the
    # root of the set to which it belongs to speed up future
    # lookups and is crucial for the algorithm to work correctly
    # 1 => 2 => 3 becomes 1 => 2
    parent[x] = find(x: parent[x])
    parent[x]
  end

  def union(x:, y:)
    rootX = find(x:)
    rootY = find(x: y)

    # If roots of both x and y are same, they belong to the same
    # set and have already been merged (unionized). So we can
    # return
    return if rootX == rootY

    # rootX has higher rank than rootY, we make rootY the subtree
    # of rootX => Flatten trees to keep it shallow and improve
    # performance
    if rank[rootX] > rank[rootY]
      parent[rootY] = rootX
    elsif rank[rootX] < rank[rootY]
      parent[rootX] = rootY
    else
      # Both have same ranks, we arbitrarily make one element as the
      # parent of another, and increase its rank. This is necessary
      # because one element is now the parent of another and hence
      # its depth has increased. For future unions, this provides us
      # with the ability to decide which tree should be a subtree of
      # another
      parent[rootY] = rootX
      rank[rootX] += 1
    end
  end

  def self.cycle_detection_undirected_graph(graph:)
    adj_matrix = graph.adj_matrix
    vertices = graph.vertices

    edges = AdjacencyMatrix.process_vertex_array(adj_matrix:, vertices:)
    uf = UnionFind.new(size: vertices.length)

    # For each edge in the graph, we try to find roots of vertices which
    # form the edge, if the roots are same, they belong to the same set
    # and we have a found an edge between 2 vertices in a connected
    # component of the graph, which clearly means there is a CYCLE
    # Algorithm works by merging connected vertices in graph into a single
    # set. Since the vertices are connected, they belong to the SAME SET,
    # hence we perform UNION OPERATION on them
    # Edge (u, v) => "u" is connected to "v"
    edges.each do |edge|
      u, v = edge
      return true if uf.find(x: u) == uf.find(x: v)

      uf.union(x: u, y: v)
    end

    # If for no edge we could find two vertices that have an edge
    # such that their roots are same, it implies that there is
    # no cycle in undirected graph
    false
  end
end
# rubocop:enable Naming/VariableName

def cycle_check_undirected_graph
  adj_matrix = {
    0 => [1, 3],
    1 => [2, 0],
    2 => [1, 3, 5],
    3 => [4, 2, 0],
    4 => [3],
    5 => [2]
  }
  vertices = [0, 1, 2, 3, 4, 5]
  Graph.new(vertices:, adj_matrix:)
end

def test
  uf = UnionFind.new(size: 5) # Create a union-find for 5 elements (0 to 4)

  # Perform union operations
  uf.union(x: 0, y: 1)
  uf.union(x: 2, y: 3)
  uf.union(x: 1, y: 2)
  uf.union(x: 3, y: 4)

  # Check the connected components using find
  puts uf.find(x: 0)  # Outputs 0 (root of the set containing 0)
  puts uf.find(x: 3)  # Outputs 0 (after unions, 3 is connected to 0)
  puts uf.find(x: 4)  # Outputs 0 (since 4 is connected to 0 through 3)
  puts uf.parent.inspect
  puts uf.rank.inspect

  graph = cycle_check_undirected_graph
  cycle_check = UnionFind.cycle_detection_undirected_graph(graph:)
  puts "Cycle Should Exist :: #{cycle_check}"
end

# test
