from bellman_ford import bellman_ford
from djikstras_algo import djikstras_algo
from collections import defaultdict
from graph import Graph

class JohnsonsAlgo:
	def __init__(self, graph: Graph):
		self.original_graph = graph
		self.new_graph = Graph(positive_flag = False, new_graph = True)
		self.new_vertex = max(self.original_graph.vertices) + 1

	def reweight_graph(self, h):
		for u, vertex_weight_tuple_list in self.new_graph.adj_list.items():
			if u == self.new_vertex:
				continue
			new_vertex_weight_tuple_list = []
			for v, w in vertex_weight_tuple_list:
				new_weight = w + h[u] - h[v]
				new_vertex_weight_tuple_list.append([v, new_weight])
			self.new_graph.adj_list[u] = new_vertex_weight_tuple_list
    
	def run_djikstras(self):
		distance = defaultdict(lambda: defaultdict(lambda: float('inf')))
		for u in self.original_graph.vertices:
			for v in self.original_graph.vertices:
				if u == v:
					distance[u][v] = 0
				else:
					distance_destination, _distance_dict, _path, _cycle = djikstras_algo(self.new_graph, u, v).values()
					distance[u][v] = distance_destination

		return distance

	def run_bellman_ford(self):
		_distance_destination, h, _path, cycle = bellman_ford(self.new_graph, self.new_vertex, self.new_graph.vertices[1]).values()
		return [h, cycle]

	def adjust_shortest_paths(self, all_pairs_shortest_paths: dict, h: dict):
		for u in self.original_graph.vertices:
			for v in self.original_graph.vertices:
				if all_pairs_shortest_paths[u][v] == None or all_pairs_shortest_paths[u][v] == float('inf'):
					continue
				else:
					all_pairs_shortest_paths[u][v] = all_pairs_shortest_paths[u][v] + h[v] - h[u]
    
		return all_pairs_shortest_paths

	def prep_new_graph(self):
		vertices = self.original_graph.vertices
		
		vertex_weight_list = []
		for u in vertices:
			vertex_weight_list.append([u, 0])
			self.new_graph.vertices.append(u)
		self.new_graph.vertices.append(self.new_vertex)

		new_adj_list = defaultdict(list)
		for u, vertex_weight_tuple_list in self.original_graph.adj_list.items():
			for v, w in vertex_weight_tuple_list:
				new_adj_list[u].append([v, w])
		self.new_graph.adj_list = new_adj_list
		self.new_graph.adj_list[self.new_vertex] = vertex_weight_list

	def run_johnson(self):
		# Step 1: Prepare a new Graph with a new vertex added to the graph, there are edges of weight 0
		# from this vertex to all other vertices in the graph
		self.prep_new_graph()

		# Step 2: Run Bellman Ford Algorithm on the new Graph, source and destination can be arbitrary
		# nodes, this would give us a distance dictionary
		h, cycle = self.run_bellman_ford()
		if cycle == True:
			return { 'distance_destination': None, 'distance': None, 'path': [], 'cycle': True}

		# Step 3: Re-weight the graph edge weights. Distance dictionary obtained from above step will be
		# be used to convert all negative edge weights to positive edge weights.
		self.reweight_graph(h)

		# Step 4: Run Djikstras algorithm from each node in the original graph to all other nodes in the
		# graph. This would give us the All Pairs shortest paths
		all_pairs_shortest_paths = self.run_djikstras()
  
		# Step 5: Re-adjust the distance hash obtained above by including the value that was deducted in Step 3 
		all_pairs_shortest_paths = self.adjust_shortest_paths(all_pairs_shortest_paths, h)
		return { 'distance_destination': None, 'distance': all_pairs_shortest_paths, 'path': None, 'cycle': False }


def run_program():
	graph1 = Graph(positive_flag = False, negative_flag = True)
	graph2 = Graph(positive_flag=False, negative_flag=False, negative_cycle_flag=True)

	for graph in [graph1, graph2]:
		_distance_destination, distance, _path, cycle = JohnsonsAlgo(graph).run_johnson().values()
		if cycle == True:
			print(f'No Shortest distance exists, cycle detected')
		else:
			for u in graph.vertices:
				for v in graph.vertices:
					print(f'Source Node :: {u}, Destination Node :: {v}, Shortest Distance :: {distance[u][v]}')
		print('\n\n')
  
run_program()