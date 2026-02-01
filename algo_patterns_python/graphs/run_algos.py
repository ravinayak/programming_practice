from graph import Graph

class RunAlgos:
	def run_mst_algos(self, algo_fun):
		graph1 = Graph(positive_flag = False, undirected_flag = True, undirected_algo_flag = True)
		graph2 = Graph(positive_flag = False, undirected_flag = True, undirected_algo_cycle_flag = True)
		graph3 = Graph(positive_flag = True)
		for graph in [graph1, graph2, graph3]:
			prims_dict = algo_fun(graph)
			mst_edges, min_cost = prims_dict['mst_edges'], prims_dict['min_cost']
			print('**************************************************')
			print(f' MST -> Edges :: {mst_edges}, Min Cost :: {min_cost}')
			print('**************************************************\n')

	def run_program(self, algo_fn, val = 0):
		graph = Graph(positive_flag = False, negative_flag = True)
		for source_node, destination_node in [[1, 4], [2, 8], [3, 7], [1, 5], [1, 8]]:
			response_dict = algo_fn(graph, source_node, destination_node)
			distance_destination, distance, path, cycle = response_dict.values()
			
			if cycle == True:
				print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, No Shortest distance exists, cycle detected')
			else:
				print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, Shortest Distance :: {distance_destination}')
				print(f'Path :: {path}')
			
		print('\n\n')
		graph = Graph(positive_flag=False, negative_flag=False, negative_cycle_flag=True)
		response_dict = algo_fn(graph, 1, 8)
		distance_destination, distance, path, cycle = response_dict.values()
		if cycle == True:
				print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, No Shortest distance exists, cycle detected')