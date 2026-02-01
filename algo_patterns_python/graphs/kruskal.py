from union_find import UnionFind
from run_algos import RunAlgos
from graph import Graph

# The core implementation of Kruskals algorithm depends on 
# UnionFind
def kruskals(graph: Graph):
    # Edges should be sorted for Kruskals algorithm
    sorted_edges_wts = sorted(graph.edges, key=lambda x: x[2])

    uf = UnionFind(graph)
    mst_edges = []
    min_cost = 0

    for edge_wt in sorted_edges_wts:
        u, v, wt = edge_wt
        
        # If 'u' and 'v' belong to same set, we must not choose this edge
        # as it will create a cycle, MST does not allow cycles
        if uf.find(u) == uf.find(v):
            continue
        else:
            uf.union(u, v)
            mst_edges.append([u, v])
            min_cost += wt
    
    return { 'min_cost': min_cost, 'mst_edges': mst_edges }

run_algos = RunAlgos()
run_algos.run_mst_algos(kruskals)