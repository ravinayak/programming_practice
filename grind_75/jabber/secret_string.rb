# frozen_string_literal: true

require_relative '../../algo_patterns/graphs/graph'
require_relative '../../algo_patterns/data_structures/queue'

# Algorithm: To recover secret string when we have been given
# triplets, we have to use Khan's style topological sort algorithm
# We process each tripet, [x, y, z]
#   => x comes b4 y, y comes b4 z
#   => x -> y, y -> z
#   => In terms of graph,
#   => y depends on x (for ordering, x must come before y)
#   => z depends on y (for ordering, y must come before z)
#   => y depends on x, z depends on y
#   => Edge from x -> y, Edge from y -> z
#   => Incoming edge shows dependency
#   => in_degree[y] = 1, in_degree[z] = 1
#   => adj_matrix[x] << y, adj_matrix[y] << z
# Step 1: Flatten triplets array, uniq on it, get unique chars
#   => Vertices of Graph
# Step 2: We process each triplet in pairs, build adjacency matrix
# for graph, and also set in_degree of each char
# Step 3: Select characters which have "0" in_degree to start with
# These are characters which have no dependency, and come
# 1st in the word, hence we enqueue it in queue, start with this char
# in results array
# Step 4: Until queue becomes empty,
#  a. dequeue and retrieve char
#  b. Iterate over adjacency matrix of this char
#  c. Reduce in-degree of each neighbor of this char, since we are done
#  with processing of the char, it has been included in results array,
#  all characters which come after it can be used.
#  d. If in_degree of any neighbor becomes "0", we enqueue it. This char
#  will be the next in order in secret string
#  e. At the end results array contains all the characters in order
# Step 5: result.join('')

# Class to recover secret string from triplets
class SecretString
  attr_accessor :graph, :in_degree, :triplets

  # We do not want to initialize triplets because we want to use the
  # same object of secretstring to recover string for multiple triplets
  # when we pass triplets to the method, it is assigned to instance variable
  # and is used to recover string
  # The object is not tied to any specific instance of triplets
  def initialize
    @graph = Graph.new(vertices: [])
    # This will initialize Hash with a value of 0 for all keys (chars)
    # by default but the problem is that when we prepare adjacency matrix
    # we would end up incrementing in_degree only for the neighbors of u
    # (u, v), in_degree of "u" will never be set if it was 0, it would 
    # never be included in the hash
    # Hence by using the following initialization, we cannot skip assigning
    # @in_degree[char] = 0, when we prepare vertices array
    # @in_degree = Hash.new { |h, k| h[k] = 0 }
    @in_degree = Hash.new(0)
  end

  def secret_string(triplets:)
    @triplets = triplets
    populate_vertices_arr
    prepare_adj_matrix_in_degree
    recover_secret_str
  end

  private

  def populate_vertices_arr
    triplets.flatten.uniq.each do |char|
      graph.vertices << char
      @in_degree[char] = 0
    end
  end

  def prepare_adj_matrix_in_degree
    triplets.each do |triplet|
      triplet.each_cons(2) do |u, v|
        graph.adj_matrix[u] << v
        @in_degree[v] += 1
      end
    end
  end

  def recover_secret_str
    queue = Queue.new
    result = []

    char_zero_in_degree.each do |ch|
      queue.enqueue(data: ch)
    end

    until queue.empty?
      char_dequeued = queue.dequeue
      result << char_dequeued

      graph.adj_matrix[char_dequeued].each do |neighbor|
        in_degree[neighbor] -= 1
        queue.enqueue(data: neighbor) if in_degree[neighbor].zero?
      end
    end

    # Join the characters in result
    result.join('')
  end

  def char_zero_in_degree
    in_degree.select { |_k, v| v.zero? }.keys
    # in_degree.keys.select { |k| in_degree[k] == 0 }
  end
end

def triplets
  [
    %w[t u p],
    %w[w h i],
    %w[t s u],
    %w[a t s],
    %w[h a p],
    %w[t i s],
    %w[w h s]
  ]
end

def test
  secret_string = SecretString.new.secret_string(triplets:)
  puts "Secret String :: #{secret_string}, Expected :: whatisup"
end

test

# why do we not need to use a visited hash to mark characters which
# have been processed from queue? Does queue and BFS ensure char
# is not processed twice?

# This question focuses on the implementation of the topological sort
# algorithm used in this SecretString class. Let's break down why a
# visited hash is not necessary in this case:

# 1. Queue and In-degree Mechanism:
# The algorithm uses a combination of a queue and an in-degree count
# for each character. This combination effectively prevents characters
# from being processed more than once.

# 2. In-degree as a Natural "Visited" Marker:
# When a character is first added to the queue, its in-degree is zero.
# After processing a character, we decrease the in-degree of its neighbors.
# A character is only added to the queue when its in-degree becomes zero.
# Once processed, a character's in-degree remains zero and it's never
# added to the queue again.

# 3. DAG (Directed Acyclic Graph) Nature:
# The problem assumes that the input represents a valid ordering, which
# implies a DAG structure. In a DAG, once a node (character) is processed,
# there's no way to reach it again.

# 4. Queue Behavior:
# Each character enters the queue exactly once when its in-degree becomes zero.
# It's then dequeued and processed once, and never re-enters the queue.

# Here's a simplified explanation of why each character is processed only once:

# a. A character enters the queue only when its in-degree becomes zero.
# b. Once processed, a character's in-degree remains zero.
# c. There's no way for a processed character to re-enter the queue.