from graph import Graph

class RunAlgos:
	def run_program(self, algo_fn):
		graph = Graph(positive_flag = False, negative_flag = True)
		for source_node, destination_node in [[1, 4], [2, 8], [3, 7], [1, 5], [1, 8]]:
			response_dict = algo_fn(graph, source_node, destination_node)
			distance, path, cycle = response_dict.values()
			
			if cycle == True:
				print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, No Shortest distance exists, cycle detected')
			else:
				print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, Shortest Distance :: {distance}')
				print(f'Path :: {path}')
			
		print('\n\n')
		graph = Graph(positive_flag=False, negative_flag=False, negative_cycle_flag=True)
		response_dict = algo_fn(graph, 1, 8)
		distance, path, cycle = response_dict.values()
		if cycle == True:
				print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, No Shortest distance exists, cycle detected')