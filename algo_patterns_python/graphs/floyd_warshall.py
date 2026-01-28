from graph import Graph
from run_algos import RunAlgos
from collections import defaultdict

def find_path(graph: Graph, source_node: int, destination_node: int, predecessor: dict, distance: dict):
  if distance[source_node][destination_node] == float('inf'):
    return 'No Path Exists '

  node = destination_node
  no_path_flag = False
  path = []
	
  while node != source_node:
    path.append(node)
    if node in predecessor[source_node]:
      node = predecessor[source_node][node]
    else:
      no_path_flag = True
      break
  
  if no_path_flag:
    return 'No Path Exists'

  path.append(source_node)
  path.reverse()
  
  path = ' -> '.join(str(node) for node in path)
  return path

def detect_negative_cycle(distance: dict, graph: Graph):
	for node in graph.vertices:
		if distance[node][node] < 0:
			return True
 
	return False

def initialize_predecessor(graph: Graph, inf: float, distance: dict):
  predecessor = { node: {} for node in graph.vertices }
  
  for i in graph.vertices:
    for j in graph.vertices:
      if i == j:
        distance[i][j] = 0
        # Predecessor represents the previous node on path from "i" to "j", since there is no path from
        # "i" to "i", there is no previous node on the path and hence it is set to None
        # Predecessor is meaningful only when there is an edge from "i" to "j", we set predecessor to i
        predecessor[i][j] = None # we can set it to "i" but it would be conceptually irrelevant
      elif distance[i][j] != inf:
        predecessor[i][j] = i
      else:
        predecessor[i][j] = None
        
  return predecessor

def floyd_warshall(graph: Graph, source_node: int, destination_node: int):
  inf = float('inf')
  distance = { node: defaultdict(lambda: inf ) for node in graph.vertices }
  
  for node, edge_list in graph.adj_list.items():
    for neighbor, weight in edge_list:
      distance[node][neighbor] = weight
  
  predecessor = initialize_predecessor(graph, inf, distance)
    
  for k in graph.vertices:
    for i in graph.vertices:
      for j in graph.vertices:
        if distance[i][k] == inf or distance[k][j] == inf:
          continue

        if distance[i][j] > distance[i][k] + distance[k][j]:
          distance[i][j] = distance[i][k] + distance[k][j]
          # This is crucial because the shortest path from "i" to "j" goes through "k",
          # Hence shortest path from "k" to "j" is the predecessor for path from "i" to "j"
          predecessor[i][j] = predecessor[k][j] if predecessor[k][j] is not None else k
          
  if detect_negative_cycle(distance, graph):
    return { 'distance_destination': None, 'distance': None, 'path': [], 'cycle': True }
  else:
    path = find_path(graph, source_node, destination_node, predecessor, distance)
    return { 'distance_destination': distance[source_node][destination_node], 'distance': distance, 'path': path, 'cycle': False }
  
run_algos = RunAlgos()
run_algos.run_program(floyd_warshall)
  