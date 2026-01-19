class Graph:
  def __init__(self, positive_flag=True, negative_flag=False, negative_cycle_flag=False):
    self.vertices = [1, 2, 3, 4, 5, 6, 7, 8]
    self.positive_flag = positive_flag
    self.negative_flag = negative_flag
    self.negative_cycle_flag = negative_cycle_flag
    self.prepare_adj_list()
    self.print_graph()

    
  def prepare_adj_list(self):
    if self.positive_flag:
      self.prepare_positive_adj_list()
      return
    
    if self.negative_flag:
      self.prepare_negative_adj_list()
      return
    
    if self.negative_cycle_flag:
      self.prepare_negative_cycle_adj_list()
      return

  def prepare_positive_adj_list(self):
    self.adj_list = {
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
  
  def prepare_negative_adj_list(self):
    self.adj_list = {
			1: [
				[3, -6], [2, -3], [5, -2]
			],
			2: [
				[4, 2], [3, 4], [6, 2]
			],
			3: [
				[4, -8], [6, 2]
			],
			4: [
				[5, 9], [7, 3], [6, 1], [8, 3]
			],
			5: [
				[6, 3]
			],
			7: [
			[8, 5]
			]
		}

  def prepare_negative_cycle_adj_list(self):
    self.adj_list = {
			1: [
				[3, -6], [2, -3], [5, -2]
			],
			2: [
				[4, 2], [3, 4], [6, 2]
			],
			3: [
				[4, -8], [6, 2], [1, -6]
			],
			4: [
				[5, 9], [7, 3], [6, 1], [8, 3]
			],
			5: [
				[6, 3]
			],
			7: [
			[8, 5]
			]
		}
        
  def process_adj_list(self, msg: str):
    print(msg)
    for node, neighbor_weight_arr in self.adj_list.items():
      for neighbor, weight in neighbor_weight_arr:
        print(f'{node} -- [{weight}] --> {neighbor}')
    print('--------------------------------------------------------------------------------')
        

  def print_graph(self):
    if self.positive_flag:
      msg = '---------------Graph with +ve Weights - Undirected ------------------------------'
    elif self.negative_flag:    
      msg = '---------------Graph with -ve Weights - Directed ------------------------------'
    else:
      msg = '---------------Graph with -ve Weights + Cycle - Directed ------------------------------'
    
    self.process_adj_list(msg)