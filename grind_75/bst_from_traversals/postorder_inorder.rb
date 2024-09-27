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
# @param [Array<Integer>] postorder
# @return [BinaryTreeNode] root
def build_bt_from_postorder_inorder(inorder:, postorder:)
  # Base Case: If size of these 2 arrays is not same, or one of the arrays is empty
  return nil if inorder.empty? || postorder.empty? || inorder.size != postorder.size

  bt_from_postorder_inorder(inorder:, postorder:)
end

# @param [Array<Integer>] inorder
# @param [Array<Integer>] postorder
# @return [BinaryTreeNode] root
def bt_from_postorder_inorder(inorder:, postorder:)
  return nil if inorder.empty? || postorder.empty?

  # To prevent recursion infinite loop because of how Ruby handles arrays with -1
  return BinaryTreeNode.new(data: inorder[0], left: nil, right: nil) if inorder.size == 1

  root_data = postorder[-1]
  root_data_index_inorder = inorder.index(root_data)
  # Edge case
  return nil if root_data_index_inorder.nil?

  left_inorder = inorder[0..(root_data_index_inorder - 1)]
  right_inorder = inorder[(root_data_index_inorder + 1)..]

  left_postorder = postorder[0..(left_inorder.size - 1)]
  right_postorder = postorder[(left_inorder.size)..(postorder.size - 2)]

  node = BinaryTreeNode.new(data: root_data)
  node.left = bt_from_postorder_inorder(inorder: left_inorder, postorder: left_postorder)
  node.right = bt_from_postorder_inorder(inorder: right_inorder, postorder: right_postorder)

  node
end

def test
  inorder = [35, 40, 45, 50, 55, 60, 75, 78, 80, 85, 90, 110, 115, 125, 130, 135]
  postorder = [35, 45, 40, 55, 60, 50, 78, 80, 90, 85, 115, 130, 135, 125, 110, 75]

  root = build_bt_from_postorder_inorder(inorder:, postorder:)
  bt = BinaryTree.new
  bt.root = root
  bt.in_order_traversal
end

test
