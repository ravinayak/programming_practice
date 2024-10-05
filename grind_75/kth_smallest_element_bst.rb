# Given the root of a binary search tree, and an integer k,
# return the kth smallest value (1-indexed) of all the values
# of the nodes in the tree.

# Example 1:
# Input: root = [3,1,4,null,2], k = 1
# Output: 1

# Example 2:
# Input: root = [5,3,6,2,4,null,null,1], k = 3
# Output: 3

# Algorithm: To find the kth smallest element in a BST, we can
# follow any of the 2 strategies listed below:

# 1. If it is not a frequently occuring problem to find the kth
# smallest element in BST, we can perform an Inorder Traversal
# of the Binary Tree, (k-1)th element in the array will be the
# kth smallest element in BST (arrays are 0 index based)
#   => 0th element is 1st smallest element in BST
#   => 1st element is 2nd smallest element in BST
# 2. If it is a frequently occuring problem, and the BST has
# regular updates, the BST would change frequently. In such a 
# case we would have to perform InOrder Traversal everytime we
# wish to find kth smallest element 
#   => To perform InOrder Traversal, we have to traverse the entire
#   leftsubtree before we can start storing nodes in an array. 
#     a. Smallest element is the last node in the leftmost subtree
#     b. Number of Nodes traversed is > "k"
#     c. O(n) in worst case each time]
#     d. If we find "kth" smallest element in BST "m" times
#        => m * O(n)
# 3. Use OrderStatistics which can speed up the operation for us
#   => 1. Store Size of Left Subtree at each Node
#   => 2. Size of Left Subtree
#         = Number of Nodes below current node in left subtree of node
#         = Current Node is excluded from the count of number of nodes
#   => 3. At most, we have to traverse "k" nodes to find "kth" smallest
#         element in BST
#   => 4. "m" times = m * O(k)
# 4. OrderStatistics can be used to find "kth" largest element in BST
#   => 1. In a tree with 10 nodes,
#     a. 1st largest element 
#        = 10th smallest element
#     b. 2nd largest element
#         = 9th smallest element
#     c. 3rd largest element 
#         = (10 - 3 + 1)th smallest element
#     d. kth smallest element
#         = (n - k + 1)th largest element
#   => kth largest element = (n -k + 1) smallest element in BST
#   => 2. Logical Explanation:
#    a. "kth" largest element
#        => (n - k) nodes smaller than this element in BST
#    b. Number of nodes smaller than "kth" largest element
#       = (k+1)th largest element .. (n)th largest element
#       = In the range outlined above, both start/end elements are
#         included in the range
#       = (Remember number of steps to take from "x" to "y" excluding
#         "x" is "y-x", including "x" is "y -x + 1")
#       = (n) - (k + 1) + 1
#       = n - k
#    c. If 1 nodes is smaller than a given node, it is 2nd smallest
#       element in BST
#       => "n - k" nodes smaller 
#       => (n - k + 1)th smallest element in BST
#   		=> 3. In a tree with 10 nodes,
#    a. 1st largest element 
#      = (n - 1)th element in InOrder Traversal since arrays are 0 index
#    b. 2nd largest element
#      = (n - 1 - 1)th element in InOrder Traversal
#      = 1 index behind (n - 1)th element
#    c. 3rd largest element
#      = (n - 1 - 2)th element in InOrder Traversal
#      = 2 indices behind (n - 1)th element
#    d. kth largest element
#      = (n - 1 - (k - 1)) = (n - 1 - k + 1)
#      = (k - 1) indices behind (n - 1)th element
#      = (n - k)th element in InOrder Traversal
#    e. 1st largest element = (n - 1)th element in InOrder
#      => kth largest element = (k - 1) indices behind (n - 1)th element
#      => So we take (k - 1) steps behind from (n - 1)th index
#      => (n - 1) - (k - 1) = n - 1 - k + 1 = n - k
#      => (n - k)th index in Inorder Traversal
#      => (n - k)th element in Array of InOrder Traversal
# 5. We can also store right_subtree_size in the BST to calculate "kth" largest
# element but it would be redundant if we are storing left_subtree_size
# 6. Only 1 of 
#     a. left subtree size
#     b. right subtree size
#   should be stored in the BST
#   => Using any of the above 2, we can caculate both kth largest and kth smallest element
# 7. Depending upon the frequency of which type of element we are finding, we should
#   store left/right subtree size
#     => kth smallest element => left subtree size
#     => kth largest element => right subtree size


