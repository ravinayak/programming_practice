
from collections import deque
from graph import Graph

def bfs_algo(graph, source_node, destination_node):
	queue = deque[tuple[int, int]]([(source_node, 0)])  # Store (node, level) tuples
	visited = {source_node}
	while queue:
		node, level = queue.popleft()

		visited.add(node)

		if node == destination_node:
			return [node, level]

		for neighbor, _weight in graph.adj_matrix[node]:
			# CRITICAL: Check visited BEFORE adding to queue
			# Without this check:
			# 1. Nodes in cycles would be added infinitely, causing infinite loops
			# 2. Queue would grow exponentially, causing memory issues
			# 3. Same node processed at multiple levels, giving incorrect results
			# 
			# Unlike Dijkstra's (which uses min-heap and checks visited at extraction),
			# BFS uses a regular queue, so we must mark visited at discovery to prevent
			# cycles and ensure each node is processed exactly once
			if neighbor not in visited:
				visited.add(neighbor)
				queue.append((neighbor, level + 1))  # Increment level for neighbors

	return [None, None]
       
graph = Graph()
for source_node, destination_node in [[1, 4], [2, 8], [3, 7], [1, 5], [1, 8]]:
	node, level = bfs_algo(graph, source_node, destination_node)
	print(f'Source Node :: {source_node}, Destination Node :: {destination_node}, Shortest Distance :: {level}')

  