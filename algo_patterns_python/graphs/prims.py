from heapq import heappush, heappop
from graph import Graph
from run_algos import RunAlgos

# Prims algorithm requires that the undirected graph has representations for edges
# in the adjacency list of both vertices, for ex: A - B
# adj_list['A'] = [['B', 5]], adj_list['B'] = [['A', 5]]
# This is crucial because in prims algorithm, when we reach any vertex, it should have
# all the edges to other vertices, so that we can make the greedy choice of least weight vertex
# correctly, if there is no vertex from B to A because we mentioned the edge only once, we
# shall not be able to select that edge when we reach 'B'
def prims(graph: Graph):
    mst_set = set()
    mst_edges = []
    min_cost = 0
    
    min_heap = []
    start_vertex = graph.vertices[0]
    # Do not specify any edge, use None because this is a randomly selected vertex and the edge
    # with this vertex is meant to be discarded
    key_vertex_edge_tuple = (0, start_vertex, None)
    # Do not use dictionary because dictionaries cannot be compared when keys have equal values
    # and 2 or more edges can have same weights in a graph
    heappush(min_heap, key_vertex_edge_tuple)
    
    while min_heap:
        heap_elements_tuple = heappop(min_heap)
        cost, vertex, edge = heap_elements_tuple
        # Skip a vertex if it is included in a MST set
        if vertex in mst_set:
            continue
		# We should not use cost !=0 check here because many edges in the graph may have 0 weights
		# and in such cases legitimate edges will end up getting discarded
        if edge is not None:
            min_cost += cost
            mst_edges.append(edge)
            
        mst_set.add(vertex)
        for neighbor_wt_list in graph.adj_list.get(vertex, []):
            if len(neighbor_wt_list) == 0:
                continue
            neighbor, wt = neighbor_wt_list
            if neighbor in mst_set:
                continue
            # Edge should be [vertex, neighbor] because we are at the vertex "vertex", and exploring
            # the edge to "neighbor". Direction (although MST is for undirected graphs) should be retained
            # for accuracy
            key_vertex_edge_tuple = (wt, neighbor, [vertex, neighbor])
            heappush(min_heap, key_vertex_edge_tuple)
                
    return { 'mst_edges': mst_edges, 'min_cost': min_cost }
  
run_algos = RunAlgos()
run_algos.run_mst_algos(prims)
                                                                                                          