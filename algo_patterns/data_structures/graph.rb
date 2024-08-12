require_relative '../data_structures/stack'
# Graph implementation in Ruby through Adjacency Matrix
#
class Graph
	
	attr_accessor :adj_matrix

	def initialize
		@adj_matrix = {}
	end

	# Adds Edge to adjacency matrix for vertex
	# @param [Integer] vertex
	# @param [Integer] neighbor
	#
	def add_edge(vertex:, neighbor:)
		self.adj_matrix[vertex] ||= []
		self.adj_matrix[vertex] << neighbor
		# There will also be an edge from neighbor to vertex if it is an undirected graph
		self.adj_matrix[neighbor] ||= []
		self.adj_matrix[neighbor] << vertex
	end

	# Perform DFS recursive
	# @param [Integer] vertex
	# @param [Hash] visited
	#
	def dfs_recursive(vertex:, visited: {})
		return if visited[vertex]

		print " #{vertex} "
		visited[vertex] = true

		adj_matrix[vertex].each do |neighbor|
			# if we check for whether the vertex has been visited or not before calling recursive dfs, it will cause
			# many adjacent vertices to be skipped
			#
			dfs_recursive(vertex: neighbor, visited:)
		end
	end

	# Perform Non Recursive DFS
	# @param [Integer] vertex
	#
	def dfs_non_recursive(vertex:)
		st = Stack.new
		st.push(data: vertex)
		visited = {}
		until st.empty?
			graph_vertex = st.pop
			next if visited[graph_vertex]

			print " #{graph_vertex} "
			visited[graph_vertex] = true

			# reverse is added here simply to keep the output consistent with the recursive call of DFS, since in DFS recursive call
			# the 1st neighbor is pushed onto recursive stack and printed.
			# If we do not reverse the adjacency matrix for graph_vertex, the 1st neighbor will be pushed as 2nd element, and 2nd neighbor
			# (assuming it has only 2 neighbors) will be pushed as 1st element on stack and 2nd neighbor will be printed 1st. When we reverse
			# 1st neighbor will be pushed last on stack and its value will be printed, which is consistent with recursive DFS call
			#
			adj_matrix[graph_vertex].reverse.each do |neighbor|
				st.push(data: neighbor) unless visited[neighbor]
			end
		end
	end

	# Print Adjacency Matrix for graph
	def print_adj_matrix
		puts "Adjacency Matrix :: #{adj_matrix.inspect}"
	end
end

# Example usage:
graph = Graph.new
graph.add_edge(vertex: 1, neighbor: 2)
graph.add_edge(vertex: 1, neighbor: 3)
graph.add_edge(vertex: 2, neighbor: 4)
graph.add_edge(vertex: 3, neighbor: 4)
graph.add_edge(vertex: 4, neighbor: 5)

graph.print_adj_matrix
puts "DFS (iterative) starting from vertex 1:"
graph.dfs_recursive(vertex: 1)
puts
graph.dfs_non_recursive(vertex: 1)
puts