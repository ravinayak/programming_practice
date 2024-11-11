require_relative '../algo_patterns/data_structures/binary_tree'
# why is min_height calculation incorrect if we use height method?
# If we used the height approach for min_height (just changing max to min):
# def incorrect_min_height(node:)
#   return 0 if node.nil?

#   left_height = incorrect_min_height(node: node.left)
#   right_height = incorrect_min_height(node: node.right)
#   [left_height, right_height].min + 1  # Problem is here!
# end

# Consider:
#         1
#        /
#       2
#      /
#     3

# Let's trace what happens at each node:
#   At node 1:
#   left_height = 2 (from path through nodes 2->3)
#   right_height = 0 (from nil)
#   Returns min(2, 0) + 1 = 1 ❌ WRONG!
#   The problem is that it considers the nil path (height 0) as a valid
#   path to a leaf, but a nil path is not a valid path to a leaf node.
#   A leaf node must be an actual node without children.

# For height, a nil child correctly represents "no path" with height 0
# why is this correct for height calculation and we do not have to explicitly
# handle edge cases for nil left/right child

# For height, we're trying to find the longest path from root to any leaf.
# When we hit a nil node, returning 0 makes sense because:
# It represents the end of a path
# We're using max, so the nil (0) will naturally be ignored if there's any real
# path

def min_height_rec(node:)
  return 0 if node.nil?

  # Handle Single Child Cases explicitly,
  # We add 1 because 1 represents the node whose left/right child is nil
  # We find the min_height of left/right child and add 1 to get the min
  # height of the node
  return min_height_rec(node: node.left) + 1 if node.right.nil?
  return min_height_rec(node: node.right) + 1 if node.left.nil?

  left_height = min_height_rec(node: node.left)
  right_height = min_height_rec(node: node.right)
  [left_height, right_height].min + 1
end

def min_height_with_path(node:)
  height_path_hsh = { min_height: Float::INFINITY, node: nil, path: [] }
  node_hsh = {}
  min_height_rec_with_path(node:, height_path_hsh:, node_hsh:)
  [height_path_hsh[:height], height_path_hsh[:path]]
end

def min_height_rec_with_path(node:, height_path_hsh:, node_hsh:)
  return 0 if node.nil?

  # This code can be abstracted and simplified using handle_single_child method
  # but I am keeping it around for readability and understanding
  if node.left.nil?
    height = min_height_rec_with_path(node: node.left, height_path_hsh:, node_hsh:) + 1
    node_hsh[node_key(node:)] = [height, nil]
    return height if height_path_hsh[:min_height] <= height

    assign_collect_path(height:, node:, height_path_hsh:, node_hsh:)
    return height
  end

  if node.right.nil?
    height = min_height_rec_with_path(node: node.right, height_path_hsh:, node_hsh:) + 1
    node_hsh[node_key(node:)] = [nil, height]
    return height if height_path_hsh[:min_height] <= height

    assign_collect_path(height:, node:, height_path_hsh:, node_hsh:)
    return height
  end

  left_height = min_height_rec_with_path(node: node.left, height_path_hsh:, node_hsh:)
  right_height = min_height_rec_with_path(node: node.right, height_path_hsh:, node_hsh:)
  height = [left_height, right_height].min + 1

  node_hsh[node_key(node:)] = [left_height, right_height]

  return height if height_path_hsh[:min_height] <= height

  assign_collect_path(height:, node:, height_path_hsh:, node_hsh:)

  height
end

def assign_collect_path(height:, node:, height_path_hsh:, node_hsh:)
  path = []
  left_height, right_height = node_hsh[node_key(node:)]

  is_left = true if (left_height && !right_height) || (left_height && right_height && left_height <= right_height)
  collect_path(path:, node:, node_hsh:, is_left:)

  height_path_hsh[:height] = height
  height_path_hsh[:path] = path
end

def collect_path(path:, node:, node_hsh:, is_left:)
  return path if node.nil?

  path << node.data unless is_left

  left_height, right_height = node_hsh[node_key(node:)]

  if left_height && right_height
    if left_height < right_height
      collect_path(node: node.left, node_hsh:, path:, is_left:)
    else
      collect_path(node: node.right, node_hsh:, path:, is_left:)
    end
  elsif left_height && !right_height
    collect_path(node: node.left, node_hsh:, path:, is_left:)
  elsif right_height && !left_height
    collect_path(node: node.right, node_hsh:, path:, is_left:)
  end

  path << node.data if is_left

  path
end

def node_key(node:)
  [node.left&.data, node.data, node.right&.data]
end

def handle_single_child(node:, height_path_hsh:, node_hsh:, is_left:)
  height = min_height_rec_with_path(node:, height_path_hsh:, node_hsh:) + 1
  if is_left
    node_hsh[node_key(node:)] = [height, nil]
  else
    node_hsh[node_key(node:)] = [nil, height]
  end
  return height unless height_path_hsh[:min_height] > height

  assign_collect_path(height:, node:, height_path_hsh:, node_hsh:)
  height
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
    height, paths = min_height_with_path(node: bt.root)
    puts " Height :: #{height}, Path :: #{paths.inspect}"
  end
end

test
