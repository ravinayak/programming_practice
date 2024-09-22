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
#         => Vertices of Graph
# Step 2: We process each triplet in pairs, build adjacency matrix
#         for graph, and also set in_degree of each char
# Step 3: Select characters which have "0" in_degree to start with
#         These are characters which have no dependency, and come
#         1st in the word, hence we enqueue it in queue, start with
#         this char in results array
# Step 4: Until queue becomes empty,
#         a. dequeue and retrieve char
#         b. Iterate over adjacency matrix of this char
#         c. Reduce in-degree of each neighbor of this char, since we
#            are done with processing of the char, it has been included
#            in results array, all characters which come after it can
#            be used.
#        d. If in_degree of any neighbor becomes "0", we enqueue it
#           This char will be the next in order in secret string
#        e. At the end results array contains all the characters in order
# Step 5: result.join('')

# Class to recover secret string from triplets
class SecretString
  attr_accessor :graph, :triplets, :in_degree

  def initialize(triplets:)
    @graph = Graph.new(vertices: [])
    @triplets = triplets
    @in_degree = Hash.new(0)
  end

  def secret_string
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
        in_degree[v] += 1
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
  secret_string = SecretString.new(triplets:).secret_string
  puts "Secret String :: #{secret_string}, Expected :: whatisup"
end

test
