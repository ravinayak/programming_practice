from sre_parse import NEGATE
from graph import Graph
from typing import Dict

def find_path(precedessor: Dict, source_node: int, destination_node: int):
  path = []
  node = destination_node
  
  while node != source_node:
    path.append(node)
    node = precedessor[node]
    
  path.append(source_node)
  path.reverse()
  
  path = ' -> '.join([str(node) for node in path])
  return path

def detect_negative_cycle(graph: Graph, distance: Dict, inf: float):
	for node, edge_list in graph.adj_list.items():
		if distance[node] == inf:
			continue

		for edge in edge_list:
			neighbor, weight = edge
			if distance[neighbor] > distance[node] + weight:
				return True

	return False
  
	
 
def bellman_ford(graph: Graph, source_node: int, destination_node: int):
	num_vertices = len(graph.vertices)
	inf = float('inf')
	predecessor = {}
	distance = { node: inf for node in graph.vertices }
	distance[source_node] = 0

	for k in range(0, num_vertices - 1):
		for node, edge_list in graph.adj_list.items():
			if distance[node] == inf:
				continue
			for edge in edge_list:
				neighbor, weight = edge
				if distance[neighbor] > distance[node] + weight:
					distance[neighbor] = distance[node] + weight
					predecessor[neighbor] = node
  

	if detect_negative_cycle(graph, distance, inf):
		return { 'distance': None, 'path': None, 'cycle': True }
  
	if distance[destination_node] == inf:
		return { 'distance': inf, 'path': [], 'cycle': False }
  
	path = find_path(predecessor, source_node, destination_node)
	return { 'distance': distance[destination_node], 'path': path, 'cycle': False }


graph = Graph(positive_flag = False, negative_flag = True)
for source_node, destination_node in [[1, 4], [2, 8], [3, 7], [1, 5], [1, 8]]:
	response_dict = bellman_ford(graph, source_node, destination_node)
	distance, path, cycle = response_dict.values()
	
	if cycle == True:
		print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, No Shortest distance exists, cycle detected')
	else:
		print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, Shortest Distance :: {distance}')
		print(f'Path :: {path}')
  
print('\n\n')
graph = Graph(positive_flag=False, negative_flag=False, negative_cycle_flag=True)
response_dict = bellman_ford(graph, 1, 8)
distance, path, cycle = response_dict.values()
if cycle == True:
		print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, No Shortest distance exists, cycle detected')