class Node:
  def __init__(self, key, val):
    self.key = key
    self.val = val
    self.next = self.previous = None
    
class LRUCache:
  def __init__(self, capacity):
    self.cap = capacity
    self.left, self.right = Node(0, 0), Node(0, 0)
    self.left.next, self.right.previous = self.right, self.left
		self.cache = {}

	def remove(self, node):
   prev_node, next_node = node.previous, node.next
   prev_node.next, next_node.previous = next_node, prev_node
   node.next, node.previous = None
   
  def insert(self, node):
    prev_node, next_node = self.right.previous, self.right
    node.next, node.previous = next_node, prev_node
    prev_node.next = next_node.previous = node
    
  def get(self, key):
    if key not in self.cache:
      return -1
    
    self.remove(self.cache[key])
    self.insert(self.cache[key])
    return self.cache[key].val
  
  def put(self, key, val):
    if key in self.cache:
      self.remove(self.cache[key])
      
    self.cache[key] = Node(key, val)
    self.insert(self.cache[key])
    
    if len(self.cache) > self.cap:
      lru = self.left.next
      self.remove(lru)
      self.cache.pop(lru.key)
      

  