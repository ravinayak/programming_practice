from graph import Graph

class UnionFind:
  def __init__(self, graph: Graph):
    self.graph = graph
    self.parent = { vertex: vertex for vertex in self.graph.vertices }
    self.rank = { vertex: 0 for vertex in self.graph.vertices }
    
  def find(self, u: int):
    if self.parent[u] == u:
      return u
    
    self.parent[u] = self.find(self.parent[u]) # path compression
    return self.parent[u]
  
  def union(self, u: int, v: int):
    rootX = self.find(u)
    rootY = self.find(v)
    
    if rootX == rootY:
      return  # Already in the same set
    
    if self.rank[rootX] == self.rank[rootY]:
      self.parent[rootY] = rootX
      self.rank[rootX] += 1
    elif self.rank[rootX] > self.rank[rootY]:
      self.parent[rootY] = rootX
      # Don't increment rank when attaching smaller tree to larger
    else:
      self.parent[rootX] = rootY
      # Don't increment rank when attaching smaller tree to larger
      
  def detect_cycle(self):
    for u, v in self.graph.edges:
      if self.find(u) == self.find(v):
        return True
      else:
        self.union(u, v)
  
    return False
        
# Union Find detects [1, 3] and [3, 1] as a cycle, for an undirected graph, there should be only edge
# from one vertex to another, another edge from the vertex back to original vertex would imply a cycle
# Ex: 1 -- 2 -- 3 => edges = [ [1, 2], [2, 3]] AND NOT edges = [ [1, 2], [2, 3], [2, 1], [3, 1]]
# [1, 2] and [2, 1] means 1 -- 2 -- 1 which is a cycle.
# An undirected edge should be represented ONLY ONCE in an edge list for an undirected graph

graph = Graph(positive_flag = False, undirected_flag = True, undirected_cycle_flag = False)
uf = UnionFind(graph)
print(f'This graph should NOT have Cycles, Result of Union Find :: {uf.detect_cycle()}')
print()

graph = Graph(positive_flag = False, undirected_flag = True, undirected_cycle_flag = True)
uf = UnionFind(graph)
print(f'This graph should have Cycles, Result of Union Find :: {uf.detect_cycle()}')