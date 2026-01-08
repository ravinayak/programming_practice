class Graph:
  def __init__(self):
    self.vertices = [1, 2, 3, 4, 5, 6, 7, 8]
    self.prepare_adj_matrix()
    self.print_graph()
    
  def prepare_adj_matrix(self):
    self.adj_matrix = {
			1: [
				[2, 3], [3, 6], [5, 2]
      ],
			2: [
				[3, 4], [6, 2]
      ],
			3: [
				[4, 8], [6, 2], [1, 6]
     	],
			4: [
				[5, 9], [6, 1], [7, 3], [3, 8], [8, 3]
     	],
			5: [
				[4, 9], [6, 3], [1, 2]
     	],
			6: [
				[4, 1], [7, 4], [3, 2], [2, 2], [5, 3]
     	],
			7: [
				[4, 3], [6, 4], [8, 5]
			],
			8: [
				[7, 5], [4, 3]
			]
		}
    
  def print_graph(self):
    print('---------------------------------------------')
    for node, neighbor_weight_arr in self.adj_matrix.items():
      for neighbor, weight in neighbor_weight_arr:
        print(f'{node} -- {weight} --> {neighbor}')
    print('---------------------------------------------')
