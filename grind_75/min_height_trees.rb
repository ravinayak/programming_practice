# frozen_string_literal: true

require_relative '../algo_patterns/data_structures/queue'

# A tree is an undirected graph in which any two vertices are
# connected by exactly one path. In other words, any connected
# graph without simple cycles is a tree.

# Given a tree of n nodes labelled from 0 to n - 1, and an array
# of n - 1 edges where edges[i] = [ai, bi] indicates that there is
# an undirected edge between the two nodes ai and bi in the tree,
# you can choose any node of the tree as the root. When you select
# a node x as the root, the result tree has height h. Among all
# possible rooted trees, those with minimum height (i.e. min(h))
# are called  minimum height trees (MHTs).

# Return a list of all MHTs' root labels. You can return the answer
# in any order.

# The height of a rooted tree is the number of edges on the longest
# downward path between the root and a leaf.

# Algorithm: In this use case, root selection such that the height of
# tree is minimum requires us to select Central Node in the tree
# Even Num of nodes (in tree) => 2 roots
# Odd  Num of nodes (in tree)  => 1 root
# We process this by using a Topological Style algorithm where we trim
# Leaves in the tree, and for every leaf node trimmed, we decrement the
# indegree of neighbors. If any neighbor becomes leaf node, we repeat the
# process
# Process edges to construct an adjacency matrix for vertices in tree,
# and also prepare in_degree hash which maintains in_degree for each vertex
# Process leaf nodes levelwise, and add new level of Leaves.
# Queue and level order traversal of leaf nodes, until the queue size is > 2
# When queue has a size of 1, or 2, we have found the roots
# NOTE: Because this is a tree (connected), it is actually an undirected
# connected graph. Undirected means for every Undirected edge in edges array,
# there will be 2 sets of edges, say edges = [[2, 3]]
# => 2-3, 3-2, adj_mat[2] << 3, adj_mat[3] << 2
# Because this is an undirected graph, the edge exists both ways, although it
# is mentioned only once (Undirected Edge)
def min_height_roots(n:, edges:)
  return [] if edges.empty? || n < 1

  vertices = []
  in_degree = Hash.new(0)
  adj_mat = Hash.new { |h, k| h[k] = [] }
  n.times do |index|
    vertices[index] = index
    in_degree[index] = 0
  end
  roots = []

  edges.each do |edge|
    u, v = edge
    # Unidrected Edge implies that the edge will exist both ways for u, v
    adj_mat[u] << v
    adj_mat[v] << u
    in_degree[u] += 1
    in_degree[v] += 1
  end

  queue = Queue.new
  vertices.each { |vertex| queue.enqueue(data: vertex) if in_degree[vertex] == 1 }

  # Nodes in tree = even => 2 roots
  # Nodes in tree = odd => 1 root
  while queue.size > 2
    # Determine size of queue so that we process all leaf nodes found so far at
    # that level, and process leaf nodes found at another level in next
    # iteration
    level_size = queue.size

    level_size.times do
      vertex = queue.dequeue

      adj_mat[vertex]&.each do |neighbor|
        # Current vertex is being trimmed, hence all its neighbors that have an
        # edge coming from this vertex shall have their in_degree reduced by 1
        in_degree[neighbor] -= 1
        # If any neighbor becomes a leaf node, it should be enqueued for trimming
        queue.enqueue(data: neighbor) if in_degree[neighbor] == 1
      end
    end
  end
  roots << queue.dequeue until queue.empty?

  # Return roots
  roots
end

def input_arr
  [
    {
      n: 4,
      edges: [[1, 0], [1, 2], [1, 3]],
      output: [1]
    },
    {
      n: 6,
      edges: [[3, 0], [3, 1], [3, 2], [3, 4], [5, 4]],
      output: [3, 4]
    }
  ]
end

def test
  input_arr.each do |input_hsh|
    roots = min_height_roots(n: input_hsh[:n], edges: input_hsh[:edges])
    print "\n Edges :: #{input_hsh[:edges].inspect}, n :: #{input_hsh[:n]}"
    print "\n Output :: #{input_hsh[:output].inspect}"
    print "\n Roots  :: #{roots.inspect}\n"
  end
end

test
