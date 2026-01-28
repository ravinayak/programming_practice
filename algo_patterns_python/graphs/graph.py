class Graph:
  def __init__(self, positive_flag=True, negative_flag=False, negative_cycle_flag=False, undirected_flag = False, undirected_cycle_flag = False, new_graph=False):
    if not new_graph:
      self.prep_graph_with_edges(positive_flag, negative_flag, negative_cycle_flag, undirected_flag, undirected_cycle_flag, new_graph=False)
    else:
      self.vertices = []
      self.edges = []
      self.adj_list = {}
      self.positive_flag = False
      self.negative_flag = False
      self.negative_cycle_flag = False
      self.undirected_flag = False
      self.undirected_cycle_flag = False
    
  def prep_graph_with_edges(self, positive_flag, negative_flag, negative_cycle_flag, undirected_flag, undirected_cycle_flag, new_graph):
    self.vertices = [1, 2, 3, 4, 5, 6, 7, 8]
    self.positive_flag = positive_flag
    self.negative_flag = negative_flag
    self.negative_cycle_flag = negative_cycle_flag
    self.undirected_flag = undirected_flag
    self.undirected_cycle_flag = undirected_cycle_flag
    self.prepare_adj_list()
    self.edges = self.prepare_edges()
    self.print_graph()
  
  def prepare_edges(self):
    edges = []
    for node, edge_list in self.adj_list.items():
      for neighbor, weight in edge_list:
        edges.append((node, neighbor))
    
    return edges

  def prepare_adj_list(self):
    if self.undirected_flag:
      if self.undirected_cycle_flag:
        self.prepare_undirected_cycle()
      else:
        self.prepare_undirected_non_cycle()
      return

    if self.positive_flag:
      self.prepare_positive_adj_list()
      return
    
    if self.negative_flag:
      self.prepare_negative_adj_list()
      return
    
    if self.negative_cycle_flag:
      self.prepare_negative_cycle_adj_list()
      return
        
  def prepare_undirected_cycle(self):
    self.vertices = [1, 2, 3, 4, 5, 6, 7]
    self.adj_list = {
			1: [
				[2, 1], [3, 5]
			],
			2: [
				[4, 3]
			],
			3: [
				[5, 8]
			],
			4: [
				[6, 9]
			],
			5: [
				[7, 7]
			],
			6: [
				[7, 8]
			],
			7: [
				[5, 7]
			]
		}
    
  def prepare_undirected_non_cycle(self):
    self.vertices = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12]
    self.adj_list = {
			1: [
				[2, 5], [3, 4]
			],
			2: [
				[4, 2], [8, 9]
			],
			3: [
				[5, 8], [12, 4]
			],
			4: [
				[9, 13]
			],
			5: [
				[11, 16], [6, 7]
			],
			6: [
				[10, 13]
			]
		}

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
    elif self.negative_cycle_flag:
      msg = '---------------Graph with -ve Weights + Cycle - Directed ------------------------------'
    elif self.undirected_flag:
      if self.undirected_cycle_flag:
        msg = '---------------Graph with +ve Weights - Undirected + Non Cycle --------------------------------'
      else:
        msg = '---------------Graph with +ve Weights - Undirected + Cycle --------------------------------'
    
    self.process_adj_list(msg)