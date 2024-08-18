Topological sort is implemented so that we convert a directed acyclic graph into linear arrangement
of nodes and their connections. This is done to achieve an ordering where we can follow a sequence
to complete tasks so we can complete a desired event (assuming event contains multiple tasks)

Topological sorting produces serveral mini topological orders within the DAG and combines them
into one using a stack

A directed edge from node A to node B represents a dependency of node A on node B. In layman terms
it means task at node A must be completed before we can complete task at node B

Topology is the arrangement of nodes and their connections in a graph

Topological sort can only be implemented for DAG:

1. This is because in Undirected Graph, we would not know
   the dependency, we would not know which node is dependent on which node, since there is no directed edge. Hence,
   there can be no linear arrangement of nodes which should be completed in a sequence to complete an event

2. If a graph has cycles, there will be no way to determine an order. This is because to establish
   an order, we must have a node which should be the last node. In a cycle, there will not be any
   last node, and hence no order can be established

https://www.youtube.com/watch?v=i9Uo7B1WiEE&list=PL7g1jYj15RUOjoeZAJsWjwV8XUo9r0hwc&index=17
