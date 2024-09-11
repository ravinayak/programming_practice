# frozen_string_literal: true

require_relative 'union_find'
# Kruskals algorithm is a GREEDY Algorithm which selects
# the edge with least possible weight at every iteration
# so long as adding edge to existing set of edges does
# not create a CYCLE
# It is used to determine MST (Minimum Spanning Tree), a
# set of EDGES which connects all the vertices together
# and has the LEAST POSSIBLE TOTAL EDGE WEIGHT
# This is extremely important in determining shortest path
# from one machine (host) to destination machine (remote)
# in Internet (network). Host Machine and Destination
# machine may be connected with different ROUTERS in internet
# and the lenght of paths across this routers may vary. We
# can easily construct a GRAPH, and use MST to determine the
# shortest path from host to destination

# Since Kruskals algorithm uses GREEDY APPROACH, it tries to
# find a set of edges with LEAST POSSIBLE TOTAL EDGE WEIGHT,
# it must sort these EDGES in non-decreasing order 1st, and
# select an edge with least possible weight at every step of
# the Iteration

# MST ensures that for V vertices, there are V-1 edges

# Why V-1 Edges?
# •  Initially, each vertex is in its own set, so we have V sets
#   (one per vertex).
# •  Each time we add an edge between two different sets
#   (i.e., Union(u, v)), the number of sets decreases by 1 because
#   we merge the two sets.
# •  To fully connect V vertices in a tree structure, we need exactly
#   V-1 edges.
# •  Therefore, after adding V-1 edges, all the vertices are connected
#   into a single set, and the MST is complete.

# Union-Find Ensures Exactly V-1 Edges:
# •  The Union-Find mechanism only allows edges to be added if they
#   connect different sets (i.e., they do not form a cycle).
# •  Once we’ve added V-1 edges, all vertices are in the same set, and
#   the MST is complete. Adding any more edges would form cycles, so we stop.
# •  In the code, we can optionally stop early once we have added V-1 edges.

# Algorithm Steps:

# 1. Sort all edges in the graph by their weight in non-decreasing
#       order.
# 2. Initialize the MST as an empty set.
# 3. Iterate over the sorted edges:
#     • For each edge (u, v), check if adding this edge forms a cycle
#       using the Union-Find (Disjoint Set Union) data structure.
#     • If it doesn’t form a cycle, add it to the MST.
# 4. Repeat until the MST contains exactly V-1 edges (where V is the
#   number of vertices).

# Time Complexity:

#  • Sorting the edges takes O(E log E), where E is the number of edges.
#  • The Union-Find operations take O(V + E) using path compression and
#    union by rank
#      => 2 operations of Union Find for every Edge E, every operation of
#           Union Find takes constant time
#      => E edges => O(1) for every operation => O(E)
#      => O(V + E) ~ O(E)
#  •  Overall time complexity: O(E log E).

# Kruskal algorithm expects edges to be Tuples of [u, v, w], where
# (u, v) represents edge from "u" to "v" with a weight of "w"

# Graph class with vertices and edges
class Graph
  attr_accessor :edges, :vertices

  def initialize(edges:, vertices:)
    @edges = edges
    @vertices = vertices
  end
end

def kruskals_algo(graph:)
  n = graph.vertices.length

  mst = []
  uf = UnionFind.new(size: n)

  sorted_edges = graph.edges.sort_by { |edge| edge[2] }
  sorted_edges.each do |edge|
    u, v = edge
    # If adding an edge creates a cycle, it is skipped. Only
    # if vertices "u" and "v" belong to different sets, i.e
    # disjoint sets, they are added to MST
    next if uf.find(x: u) == uf.find(x: v)

    mst << edge
    uf.union(x: u, y: v)
  end

  mst
end

def graph
  edges = [
    [0, 1, 10], # Edge between vertex 0 and 1 with weight 10
    [0, 2, 6],
    [0, 3, 5],
    [1, 3, 15],
    [2, 3, 4]
  ]

  vertices = [0, 1, 2, 3]
  [edges, vertices, Graph.new(vertices:, edges:)]
end

def test
  edges, vertices, g = graph
  puts " Input Edges :: #{edges.inspect}, Vertices :: #{vertices.inspect}"
  puts " MST :: #{kruskals_algo(graph: g)}"
end

test
