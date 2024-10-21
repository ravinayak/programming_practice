# Construct Binary Tree from PreOrder and InOrder Traversals
# Algorithm is specified in the markdown file

# frozen_string_literal: true

require_relative '../../algo_patterns/data_structures/binary_tree_node'
require_relative '../../algo_patterns/data_structures/binary_tree'
# Time Complexity: O(n) =>
# a. Each element of both arrays has to be processed at least once to
#    form the binary tree
# b. We have to find index of root element in inorder array, Set/Hash cannot
#    be used because inorder array changes with every recursive call, and
#    indices of elements change. Pre-Processing of inorder to prepare a Hash/Set
#    to improve lookup will give incorrect results
#       => inorder array is not sorted, so we cannot use BinarySearch
#       => O(n) [Linear Scan to find index] * n (recursive calls) = n * O(n) = O(n^2)
# c. Total TC: O(n) + O(n^2) = O(n^2)

# Space Complexity: O(n)
# a. "n" nodes to store data + left, right pointers in BT
# b. "n" elements Max in 4 arrays
#        => (left, right inorder + left/right pre-order/post-order/level) = 4 * O(n)
# c. "n" Max Depth of Recursion Tree
# e. 2 * O(n) + 4 * O(n) + O(n) = O(n)

# @param [Array<Integer>] inorder
# @param [Array<Integer>] preorder
# @return [BinaryTreeNode] root
def build_bt_from_preorder_inorder(inorder:, preorder:)
  # Base Case: If size of these 2 arrays is not same, or one of the arrays is empty
  return nil if inorder.empty? || preorder.empty? || inorder.size != preorder.size

  bt_from_preorder_inorder(inorder:, preorder:)
end

# @param [Array<Integer>] inorder
# @param [Array<Integer>] preorder
# @return [BinaryTreeNode] root
def bt_from_preorder_inorder(inorder:, preorder:)
  return nil if inorder.empty? || preorder.empty?

  # To prevent recursion infinite loop because of how Ruby handles arrays with -1
  return BinaryTreeNode.new(data: inorder[0], left: nil, right: nil) if inorder.size == 1

  root_data = preorder[0]
  root_data_index_inorder = inorder.index(root_data)
  # Edge case
  return nil if root_data_index_inorder.nil?

  left_inorder = inorder[0..(root_data_index_inorder - 1)]
  right_inorder = inorder[(root_data_index_inorder + 1)..]

  # Alternate ways to calculate left_preorder
  # 1. For the last element in left_inorder, find its index in preorder
  #    All elements in preorder from 1..index are in left_preorder
  #    => This is expensive because we have to scan through elements in
  #       preorder to find the index of last element in left_inorder = O(n)
  #    Code:
  #     left_preorder_max_index = preorder.index(left_inorder.last)
  #     left_preorder = preorder[1..left_preorder_max_index]
  #     right_preorder = preorder[(left_preorder_max_index + 1)..]
  # 2. Iterate over each element in preorder array and check if it is included
  #    in left/right inorder arrays
  #    => This is expensive =>
  #       O(n): Iteration over preorder elements
  #       For each element in iteration above,
  #         O(n): Find if element is included in inorder array
  #    => O(n) * O(n) = O(n^2)
  #   Code:
  #     left_preorder = preorder.select { |element| left_inorder.include?(element) }
  #     right_preorder = preorder.select { |element| right_inorder.include?(element) }

  # This is the best method because it has TC of O(1) to calculate left/right preorder
  left_preorder = preorder[1..(left_inorder.size)]
  right_preorder = preorder[(left_inorder.size + 1)..]

  node = BinaryTreeNode.new(data: root_data)
  node.left = bt_from_preorder_inorder(inorder: left_inorder, preorder: left_preorder)
  node.right = bt_from_preorder_inorder(inorder: right_inorder, preorder: right_preorder)

  node
end

def test
  inorder = [35, 40, 45, 50, 55, 60, 75, 78, 80, 85, 90, 110, 115, 125, 130, 135]
  preorder = [75, 50, 40, 35, 45, 60, 55, 110, 85, 80, 78, 90, 125, 115, 135, 130]

  root = build_bt_from_preorder_inorder(inorder:, preorder:)
  bt = BinaryTree.new
  bt.root = root
  bt.in_order_traversal
end

test
