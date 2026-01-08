from heapq import heappop, heappush
from graph import Graph

def djikstras_algo(graph: Graph, source_node: int, destination_node: int):
  min_heap = []

  inf = float('inf')
  distance = { node: inf for node in graph.vertices }
  distance[source_node] = 0
  
  visited = set()

  heappush(min_heap, (0, source_node))

  while min_heap:
    weight, node = heappop(min_heap)
    
    if node == destination_node:
      return [node, distance[node]]
    
    if node in visited:
      continue
    
    visited.add(node)

    for neighbor, weight in graph.adj_matrix[node]:
      
      if distance[neighbor] < distance[node] + weight:
        continue
      
      distance[neighbor] = distance[node] + weight
      heappush(min_heap, (distance[neighbor], neighbor))
    
    
  return [None, None]

graph = Graph()

for source_node, destination_node in [[1, 4], [2, 8], [3, 7], [1, 5], [1, 8]]:
	node, level = djikstras_algo(graph, source_node, destination_node)
	print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, Shortest Distance :: {level}')