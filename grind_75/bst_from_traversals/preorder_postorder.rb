# frozen_string_literal: true

require_relative '../../algo_patterns/data_structures/binary_tree_node'
require_relative '../../algo_patterns/data_structures/binary_tree'
# PreOrder/PostOrder can only be used to construct BT if the original
# BT whose PreOrder/PostOrder traversals are given is a Complete BT
# meaning every node has either 2 children or 0 children

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

def bt_from_postorder_preorder(preorder:, postorder:)
  return nil if preorder.empty? || postorder.empty? || preorder.size != postorder.size

  build_bt_postorder_preorder(preorder:, postorder:)
end

def build_bt_postorder_preorder(preorder:, postorder:)
  return nil if preorder.empty? || postorder.empty?

  # To avoid Infinite Recursion, because of how Ruby handles array slicing with -1
  return BinaryTreeNode.new(data: preorder[0], left: nil, right: nil) if preorder.size == 1

  root_data = preorder[0]
  # Because this is a full/complete BT, the node immediately next to it must be NIL or the
  # root node of left subtree. If this node is nil, right node must also be nil, since it
  # can only have 2 children, or 0 children
  # Preorder => Root Left Right
  left_subtree_root_data = preorder[1]
  # In Postorder traversal, this node will be the last node in left subtree. Every node after
  # this node will be part of the right subtree except root at the end
  # Postorder => Left Right Root
  left_subtree_root_index_postorder = postorder.index(left_subtree_root_data)

  # Avoid bugs / Infinite Loops
  return nil if left_subtree_root_index_postorder.nil?

  # We include this index in the array because the element at this index is also a part of the
  # left subtree and is the last element in the left subtree
  left_postorder = postorder[0..left_subtree_root_index_postorder]
  right_postorder = postorder[(left_subtree_root_index_postorder + 1)..(postorder.size - 2)]

  # For the preorder array, we do not know how many elements starting from index "1" form a part
  # of the left subtree, hence we use size found above to calculate this array
  left_preorder = preorder[1..left_postorder.size]
  right_preorder = preorder[(left_postorder.size + 1)..]

  node = BinaryTreeNode.new(data: root_data)
  node.left = build_bt_postorder_preorder(preorder: left_preorder, postorder: left_postorder)
  node.right = build_bt_postorder_preorder(preorder: right_preorder, postorder: right_postorder)

  node
end

def test
  postorder = [35, 45, 40, 55, 60, 50, 80, 90, 85, 115, 135, 125, 110, 75]
  preorder = [75, 50, 40, 35, 45, 60, 55, 110, 85, 80, 90, 125, 115, 135]

  root = bt_from_postorder_preorder(preorder:, postorder:)
  bt = BinaryTree.new
  bt.root = root
  bt.in_order_traversal
end

test
