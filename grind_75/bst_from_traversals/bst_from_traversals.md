**Summary**

- **Valid Combinations for constructing a unique binary tree:**
  1. Preorder + Inorder
  2. Postorder + Inorder
  3. Inorder + Level-order
  4. Preorder + Postorder (but only for full binary trees)
- **Invalid Combinations (in general) that cannot uniquely reconstruct a tree:**
  1. Preorder + Postorder (for non-full binary trees)
  2. Preorder + Level-order
  3. Postorder + Level-order
  4. Level-order alone
- **Remember, we want to construct Binary Trees, it is not necessarily Binary Search Tree**
  1. As long as every node has 2 children which is required for Binary Tree, we can construct BT
  2. Left, Right children may or may not obey the rules of BST
  3. Traversal Orders are for Binary Tree, which may or may not be BST

**Why certain combinations work and others do not work?**
Critical Information:

1. PreOrder: Root, Left, Right
2. PostOrder: Left, Right, Root
3. Level Order: Every 1st element of a subtree is its root

How to Construct BT from traversal combinations:

To construct a tree from any traversal, the core idea is to \_Recursively build left subtree, right subtree, and root of
the left, right subtrees

1. Preorder Traversal + Inorder Traversal =>
   Preorder: 1st element is the root
   Inorder => Find the root, everything to left is Left subtree
   Inorder => Find the root, everything to the right is Right subtree
   Left Inorder => inorder[0, Index of root in Inorder - 1]
   Right Inorder => inorder[Index of root in Inorder + 1, -1]
   Left Pre-Order => [1, Left_Inorder.size]
   Right Pre-Order => [Left_Inorder.size + 1, -1]
   root_node = TreeNode.new(preorder[0])
   root_node.left = Using Left_Inorder, Left Pre-Order, construct Left Subtree
   root_node.right = Using Right_Inorder, Right Pre-Order, construct Right Subtree

2. Postorder Traveral + Inorder Traversal
   Postorder: last element is the root
   Inorder => Find the root, everything to left is Left subtree
   Inorder => Find the root, everything to the right is Right subtree
   Left Inorder => [0, Index of root in Inorder - 1]
   Right Inorder => [Index of root in Inorder + 1, -1]
   Left Post-Order => [0, Left_Inorder.size - 1]
   Right Post-Order => [Left_Inorder.size, -1]
   root_node = TreeNode.new(postorder[-1])
   root_node.left = Using Left_Inorder, Left Post-Order, construct Left Subtree
   root_node.right = Using Right_Inorder, Right Post-Order, construct Right Subtree

3. Inorder + Level Order =>
   Level Order => 1st element of level order is always the root
   Inorder => Find the root, everything to left is Left subtree
   Inorder => Find the root, everything to the right is Right subtree
   Left Inorder => [0, Index of root in Inorder - 1]
   Right Inorder => [Index of root in Inorder + 1, -1]
   Left_LevelOrder => level_order.reduce([]) { |acc, element| acc << element if left_inorder.include?(element) }
   Right_LevelOrder => level_order.reduce([]) { |acc, element| acc << element if right_inorder.include?(element) }
   root_node = TreeNode.new(preorder[0])
   root_node.left = Using Left_Inorder, Left_LevelOrder, construct Left Subtree
   root_node.right = Using Right_Inorder, Right_LevelOrder, construct Right Subtree

4. In all the above traverals, we can clearly see the left, right subtrees calculation for Inorder is exactly same
   Left/Right subtree calculation changes for pre-order, post-order, level-order
5. For all other combinations, there is never enough information to find left, right subtrees. Consider
   PreOrder + Postorder => We know root, but dont know left/right subtrees
   PreOrder + LevelOrder => Root is identified, but no way to split in left/right subtrees
6. PreOrder + PostOrder => This can be used to construct BT but only if it is a Full Binary Tree which means every
   node must have 2 children or 0 children
   Preorder => 1st element is the root
   Preorder => For a full Binary Tree, next element in pre-order must be the left child, Root -> Left -> Right
   Postorder => Find the index of the left child in Postorder, this will be the last left child in PostOrder
   => This is because in PosOrder Left -> Right -> Root, the 1st left child of Root is the root of left subtree
   => And in Postorder, we will process all the nodes in left subtree b4 we print this nodes data, thus this node
   is the last node of left subtree
   Left_child_post_order_index = Index of element at index 1 in Preorder = (Root of left subtree), (Last node of left subtree in Post Order)
   Left_subtree_size = Left_child_post_order_index + 1 (Array count start from 0, so we add 1), if index is 5, num of elements = 6 (0..5)
   left_subtree_preorder = [1, left_subtree_size]
   right_subtree_preorder = [left_subtree_size + 1, -1]
   left_subtree_postorder = [0, left_child_post_order_index]
   right_subtree_postorder = [left_child_post_order_index + 1, -1 (exclude root which is at -1)]
   root_node = TreeNode.new(preorder[0])
   root_node.left = Using left_subtree_preorder, left_subtree_postorder, construct Left Subtree
   root_node.right = Using right_subtree_preorder, right_subtree_postorder, construct Right Subtree
