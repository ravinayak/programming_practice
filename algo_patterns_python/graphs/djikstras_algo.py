from heapq import heappop, heappush
from graph import Graph

def find_path(predecessor, source_node, destination_node):
  node = destination_node
  path = []

  while node != source_node:
    path.append(node)
    node = predecessor[node]
    
  path.append(source_node)
  path.reverse()
  
  path = ' -> '.join([str(node) for node in path])
  return path

def djikstras_algo(graph: Graph, source_node: int, destination_node: int):
  min_heap = []

  inf = float('inf')
  distance = { node: inf for node in graph.vertices }
  distance[source_node] = 0
  predecessor = {}
  
  visited = set()

  heappush(min_heap, source_node)

  while min_heap:
    node = heappop(min_heap)
    
    if node == destination_node:
      path = find_path(predecessor, source_node, destination_node)
      return { 'distance_destination': distance[node], 'distance': distance, 'path': path, 'cycle': False }
    
    if node in visited:
      continue
    
    visited.add(node)
    for edge in graph.adj_list[node]:
      neighbor, weight = edge

      if distance[neighbor] < distance[node] + weight:
        continue
      
      distance[neighbor] = distance[node] + weight
      predecessor[neighbor] = node
      heappush(min_heap, neighbor)
    
    
  return  { 'distance_destination': None, 'distance': None, 'path': [], 'cycle': False }

graph = Graph()

for source_node, destination_node in [[1, 4], [2, 8], [3, 7], [1, 5], [1, 8]]:
  response_dict = djikstras_algo(graph, source_node, destination_node)
  _distance_destination, distance, path, cycle = response_dict.values()
  print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, Shortest Distance :: {distance}, Path :: {path}')