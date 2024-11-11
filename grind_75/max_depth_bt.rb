require_relative '../algo_patterns/data_structures/binary_tree'
# Given the root of a binary tree, return its maximum depth.

# A binary tree's maximum depth is the number of nodes along the longest
# path from the root node down to the farthest leaf node.

# This problem is same as finding height of a tree

def max_height(node:)

  height_path_hsh = { max_height: 0, path: [] }
  node_hsh = {}
  max_height_util(node:, height_path_hsh:, node_hsh:)
  
  [height_path_hsh[:max_height], height_path_hsh[:path]]
end

def max_height_util(node:, height_path_hsh:, node_hsh:)
  return 0 if node.nil?

  left_height = max_height_util(node: node.left, height_path_hsh:, node_hsh:)
  right_height = max_height_util(node: node.right, height_path_hsh:, node_hsh:)

  height = [left_height, right_height].max + 1

  node_hsh[node_key(node:)] = [left_height, right_height]

  return height unless height_path_hsh[:max_height] < height
  
  path = []
  is_left = left_height > right_height ? true : false
  collect_path(node:, node_hsh:, path:, is_left:)

  height_path_hsh[:max_height] = height
  height_path_hsh[:path] = path

  height
end

def collect_path(node:, node_hsh:, path:, is_left:)
  return path if node.nil?

  path << node.data unless is_left

  left_height, right_height = node_hsh[node_key(node:)]

  if left_height > right_height
    collect_path(node: node.left, node_hsh:, path:, is_left:)
  else
    collect_path(node: node.right, node_hsh:, path:, is_left:)
  end

  path << node.data if is_left

  path
end

def node_key(node:)
  [node.left&.data, node.data, node.right&.data]
end

def test
  bt1 = BinaryTree.new(data: 100)
  arr1 = [60, 47, 45, 50, 48, 65, 70, 80, 75, 73, 110, 105, 125, 135, 140, 145, 150, 155, 160]
  arr1.each do |data|
    bt1.insert(data:)
  end

  bt2 = BinaryTree.new(data: 50)
  arr2 = [40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80]
  arr2.each do |data|
    bt2.insert(data:)
  end

  bt3 = BinaryTree.new(data: 100)
  arr3 = [60, 47, 45, 50, 48, 66, 65, 64, 63, 62, 61, 70, 80, 75, 73, 72, 110,
          105, 125]
  arr3.each do |data|
    bt3.insert(data:)
  end

  [bt1, bt2, bt3].each do |bt|
    height, paths = max_height(node: bt.root)
    puts " Height :: #{height}, Path :: #{paths.inspect}"
  end
end

test
