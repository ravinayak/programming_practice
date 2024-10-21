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
3. Inorder: Left, Root, Right
4. Level Order: Every 1st element of a subtree is its root

Summary:

1. All traversal combinations except level order traversal combination can use left_inorder size to calculate the left/right
   subtrees for the other traversal type
   a. Preorder + Inorder
   b. Postorder + Inorder
   c. Preorder + Postorder

   => In all these combinations, we can use left_inorder.size to calculate left subtree for the other traversal type
   How to Construct BT from traversal combinations:

   root_data = preorder[0]
   root_data_index_inorder = inorder.index(root_data)

   left_inorder = inorder[0..(root_data_index_inorder - 1)]
   right_inorder = inorder[(root_data_index_inorder + 1)..]

   left_preorder = preorder[1..(left_inorder.size)]
   right_preorder = preorder[(left_inorder.size + 1)..]

2. We can also calculate left/right preorder using alternate ways such as left_subtree_max value or through selection
   of elements which are present in left_inorder but those are expensive operations. Using size allows us to
   prepare left_preorder array in O(1) time

3. Inorder + Level Order Traversal => This cannot be solved using left_inorder.size and needs us to explicitly select
   elements from left_inorder to prepare left_level_order

To construct a tree from any traversal, the core idea is to Recursively build left subtree, right subtree, and root of
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
7. Alternate ways to calculate left_preorder, right_preorder when inorder is given:
   1. For the last element in left_inorder, find its index in preorder
      All elements in preorder from 1..left_inorder_last_index are in left_preorder
      => This is expensive because we have to scan through elements in
      preorder to find the index of last element in left_inorder = O(n)
      Code:
      left_preorder_max_index = preorder.index(left_inorder.last)
      left_preorder = preorder[1..left_preorder_max_index]
      right_preorder = preorder[(left_preorder_max_index + 1)..]
   2. Iterate over each element in preorder array and check if it is included
      in left/right inorder arrays
      => This is expensive =>
      O(n): Iteration over preorder elements
      For each element in iteration above,
      O(n): Find if element is included in inorder array
      => O(n) \* O(n) = O(n^2)
      Code:
      left_preorder = preorder.select { |element| left_inorder.include?(element) }
      right_preorder = preorder.select { |element| right_inorder.include?(element) }
