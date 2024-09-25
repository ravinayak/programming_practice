# frozen_string_literal: true

require_relative '../../algo_patterns/data_structures/binary_tree_node'
require_relative '../../algo_patterns/data_structures/binary_tree'
# Algorithm: Described in the markdown file
# Time Complexity: O(n) => Each element of both arrays has to be processed at least once
# Space Complexity: O(n) => "n" nodes to store data + left, right pointers

# @param [Array<Integer>] inorder
# @param [Array<Integer>] level
# @return [BinaryTreeNode] root
def build_bt_inorder_level(inorder:, level:)
  # Base Case: If size of these 2 arrays is not same, or one of the arrays is empty
  return nil if inorder.empty? || level.empty? || inorder.size != level.size

  bt_from_inorder_level(inorder:, level:)
end

# @param [Array<Integer>] inorder
# @param [Array<Integer>] level
# @return [BinaryTreeNode] root
def bt_from_inorder_level(inorder:, level:)
  # Base Case of Recursion: Return nil when any of the arrays is empty
  return nil if inorder.empty? || level.empty?

  # Ruby's handling of arrays will cause recursion to become infinitely
  # nested when index_root_data_in_inorder = 0
  # arr[0..-1] results in entire array
  # arr[0..-1] = arr[0..arr.length - 1] = arr
  # This implies that we will keep getting a one element array and keep
  # having this function called Recursively in an Infinite Loop
  # When either of the arrays has only 1 element, we create a Node and
  # return it,
  # 1. Processing of left/right subtrees can be skipped
  # 2. Prevents Infinite Recursion

  return BinaryTreeNode.new(data: inorder[0], left: nil, right: nil) if inorder.size == 1

  root_data = level[0]
  index_root_data_in_inorder = inorder.index(root_data)

  # Add this to prevent issues if the root_data is not found in inorder
  return nil if index_root_data_in_inorder.nil?

  left_inorder = inorder[0..(index_root_data_in_inorder - 1)]
  right_inorder = inorder[(index_root_data_in_inorder + 1)..(-1)]

  # Faster Lookup
  left_inorder_set = Set.new(left_inorder)
  right_inorder_set = Set.new(right_inorder)

  # Since these elements are processed in order, the relative order amongst elements in level
  # order traversal is maintained. We only select those elements which are included in left_inorder
  # but we process level array in order, so the relative order of left/right subtree elements is
  # maintained
  # When using a condition inside reduce block, like below, we must return acc in all cases, else
  # we shall have nil for certain iterations where the condition is NOT Satisfied
  # left_inorder.include?(element) returns false, nil will be returned, and acc will become nil
  # left_level = level.reduce([]) { |acc, element| acc << element if left_inorder.include?(element) }

  # Accumulate left and right level elements in their respective order
  left_level = level.reduce([]) { |acc, element| left_inorder_set.include?(element) ? acc << element : acc }
  right_level = level.select { |element| right_inorder_set.include?(element) }

  # Create Root Node and assign it left/right subtrees
  node = BinaryTreeNode.new(data: root_data)
  node.left = bt_from_inorder_level(inorder: left_inorder, level: left_level)
  node.right = bt_from_inorder_level(inorder: right_inorder, level: right_level)

  # Return node
  node
end

def test
  inorder = [35, 40, 45, 50, 55, 60, 75, 78, 80, 85, 90, 110, 115, 125, 130, 135]
  level = [75, 50, 110, 40, 60, 85, 125, 35, 45, 55, 80, 90, 115, 135, 78, 130]

  root = build_bt_inorder_level(inorder:, level:)
  bt = BinaryTree.new
  bt.root = root
  bt.in_order_traversal
end

test
