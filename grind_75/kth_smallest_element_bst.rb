# frozen_string_literal: true

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

# 4. Finding kth largest element when we have stored "left_subtree_size"
#    for every node where "left_subtree_size" is the total count of nodes
#    in the left subtree of node
#      a. Without maintaining the total count of nodes (or a combination
#         of right subtree size), and only having the left_subtree_size, we
#         cannot directly calculate the k-th largest element in a Binary
#         Search Tree(BST) efficiently. Here’s why:
#      b. Why left_subtree_size Alone Isn’t Sufficient:
#          1. The k-th largest element is related to the number of elements in
#             the right subtree or the total number of elements in the tree.
#          2. The left_subtree_size only gives information about the number of
#             nodes in the left subtree, which is useful for finding the
#             k-th smallest element, but doesn’t help much for the k-th largest
#             element without additional information.
#  5. Solutions for finding kth largest element in BST:
#      1. left_subtree_size is stored for each node in BST: We must store the
#         total number of nodes in BST along with "left_subtree_size"
#         if we want to find "kth" largest element in BST
#      2. OrderStatistics can be used to find "kth" largest element in BST
#         => 1. In a tree with 10 nodes,
#         a. 1st largest element
#              = 10th smallest element
#         b. 2nd largest element
#             = 9th smallest element
#         c. 3rd largest element
#             = (10 - 3 + 1)th smallest element
#         d. kth smallest element
#             = (n - k + 1)th largest element
#        => kth largest element = (n -k + 1) smallest element in BST
#        => 2. Logical Explanation:
#            a. "kth" largest element => (n - k) nodes smaller than this element in BST
#            b. Number of nodes smaller than "kth" largest element
#             = (k+1)th largest element .. (n)th largest element
#             = In the range outlined above, both start/end elements are
#               included in the range
#             = (Remember number of steps to take from "x" to "y" excluding
#               "x" is "y-x", including "x" is "y -x + 1")
#             = (n) - (k + 1) + 1
#             = n - k
#          c. If 1 nodes is smaller than a given node, it is 2nd smallest
#           element in BST
#             => "n - k" nodes smaller
#             => (n - k + 1)th smallest element in BST
#     3. Using Reverse InOrderTraversal:
#         Normal InOrder Traversal gives us the data of nodes in BST in Ascending Order, we
#         can perform Reverse Inorder Traversal to arrange elements in Descending Order, and
#         find the kth largest element in BST using this Approach. The logic is exactly the
#          same.
#          a. 1st largest element = 1st element in Descending Sorted Order = 0th element in array
#          b. kth largest element = (k-1)th element in array
# 6. If we frequently find both "kth" smallest and "kth" largest elements in BST, we should store
#      a. left_subtree_size
#      b. total number of nodes in the BST = n
#      This will allow us to use OrderStatistics and keep Time Complexity LOW for both operations
#  7. If we frequently find only "kth" smallest or "kth" largest element in BST, we should store
#      a. kth largest  element => right_subtree_size
#      b. kth smallest element => left_subtree_size
#  8. In "kth" largest element in BST using right_subtree_size the condition will be ALMOST SAME

# Binary Tree Node with Order Stats Information
class BinaryTreeNodeOrderStats
  attr_accessor :data, :left, :right, :left_subtree_size, :right_subtree_size

  def initialize(data:, left: nil, right: nil)
    @data = data
    @left = left
    @right = right
    @left_subtree_size = 0
    @right_subtree_size = 0
  end
end

# BinaryTree which maintains OrderStats
class BinaryTreeOrderStats
  attr_accessor :root, :total_count

  def initialize(data: nil)
    @root = BinaryTreeNodeOrderStats.new(data:)
    @total_count = data.nil? ? 0 : 1
  end

  def insert(data:)
    @total_count += 1
    if root.data.nil?
      @root.data = data
      return root
    end
    rec_insert_util(node: root, data:)
  end

  private

  def rec_insert_util(node:, data:)
    # Create a new node, because we have found the correct position
    # in the tree to insert given data. This data will be assigned
    # to a leaf node whose left_subtree_size will be 0 by default
    # and correctly so, since there are no nodes in the left subtree
    # of a leaf node
    return BinaryTreeNodeOrderStats.new(data:) if node.nil?

    if data <= node.data
      # Recurse left, until we reach leaf position, create a node,
      # assign it to the left node and keep recursing up
      node.left = rec_insert_util(node: node.left, data:)
      # Since we are creating a new leaf node in the left subtree
      # we should increase the left_subtree_size of all nodes
      # for which we have traverse in the left by 1
      node.left_subtree_size += 1
    else
      # We are recursing in the right subtree of a node, since this
      # node will be added to the right subtree and NOT LEFT SUBTREE
      # we do not increase the left subtree size of given node
      node.right = rec_insert_util(node: node.right, data:)
      node.right_subtree_size += 1
    end
    # Return node
    node
  end
end

# Find kth smallest element
class KSmallestElement
  def find_kth_element(bt:, k:)
    root = bt.root
    total_count = bt.total_count
    kth_largest = find_k_largest_inorder(root:, k:)
    kth_largest_left_st_size = find_k_larget_order_stats_using_left_subtree_size(node: root, k:, total_count:)
    kth_largest_right_st_size = find_k_larget_order_stats(node: root, k:)

    kth_smallest = find_k_smallest_inorder(root:, k:)
    kth_smallest_left_st_size = find_k_smallest_order_stats(node: root, k:)

    {
      k_largest: {
        inorder: kth_largest,
        left_subtree_size: kth_largest_left_st_size,
        right_subtree_size: kth_largest_right_st_size
      },
      k_smallest: {
        inorder: kth_smallest,
        left_subtree_size: kth_smallest_left_st_size
      }
    }
  end

  private

  def find_k_smallest_inorder(root:, k:)
    return nil if root.nil? || k.negative?

    # Array elements are nil by default when we
    # have not assigned any value to the index
    in_order_arr = []
    stack = []
    in_order(root:, stack:, k:, in_order_arr:)

    # If we try to find 12th smallest element in a BST with 10
    # nodes, we should return nil
    in_order_arr[k - 1].nil? ? nil : in_order_arr[k - 1]
  end

  def find_k_largest_inorder(root:, k:)
    return nil if root.nil? || k.negative?

    # Array elements are nil by default when we
    # have not assigned any value to the index
    in_order_arr = []
    stack = []
    reverse_in_order(root:, stack:, k:, in_order_arr:)

    # If we try to find 12th smallest element in a BST with 10
    # nodes, we should return nil
    in_order_arr[k - 1].nil? ? nil : in_order_arr[k - 1]
  end

  def find_k_smallest_order_stats(node:, k:)
    # If a node has "k" elements in its left subtree, position
    # of node in the tree rooted at that node is "k + 1" smallest
    # element
    # Only if this node is on the leftmost subtree rooted at root,
    # position of the node will be "k + 1" smallest in the whole
    # tree, else its position will be relative to the tree rooted
    # at that node
    if node.left_subtree_size + 1 == k
      node.data
    elsif node.left_subtree_size + 1 < k
      # kth smallest element is in the Right Subtree rooted at node
      # node.left_subtree_size + 1 elements already exist in the left
      # subtree including the node,
      # hence kth smallest element in the right subtree will be
      # 	= k - (node.left_subtree_size + 1)
      find_k_smallest_order_stats(node: node.right, k: k - (node.left_subtree_size + 1))
    else
      # kth smallest element is in the left subtree rooted at node
      find_k_smallest_order_stats(node: node.left, k:)
    end
  end

  def find_k_larget_order_stats(node:, k:)
    # If a node has "k" elements in its right subtree, position
    # of node in the tree rooted at that node is "k + 1" largest
    # element
    # Only if this node is on the rightmost subtree rooted at root,
    # position of the node will be "k + 1" largest in the whole
    # tree, else its position will be relative to the tree rooted
    # at that node
    if node.right_subtree_size + 1 == k
      node.data
    # kth largest element in tree is not present in the right subtree
    # hence we recurse left
    elsif node.right_subtree_size + 1 < k
      # k + 1 elements already exist in the right subtree including
      # the node,
      # hence kth largest element in the left subtree
      # will be = k - (node.right_subtree_size + 1)
      find_k_larget_order_stats(node: node.left,
                                k: k - (node.right_subtree_size + 1))
    else
      # kth largest element is in the right subtree rooted at node
      find_k_larget_order_stats(node: node.right, k:)
    end
  end

  def find_k_larget_order_stats_using_left_subtree_size(node:, k:, total_count:)
    # kth largest = (n - k + 1)th smallest element in BST
    k_smallest = total_count - k + 1
    find_k_smallest_order_stats(node:, k: k_smallest)
  end

  def in_order(root:, stack:, k:, in_order_arr: [])
    curr = root
    # Current can become nil while there are elements in stack
    # when we reach a leaf node. We must continue processing
    # in such a case, only when stack is empty and current is
    # also nil, we have a use case where we have reached a leaf
    # node and also processed all elements in the tree, meaning
    # we have processed the last node in the tree
    while curr || !stack.empty?
      while curr
        stack.push(curr)
        curr = curr.left
      end
      curr = stack.pop
      in_order_arr.push(curr.data)
      # If in_order_arr contains "k" elements, we have found kth smallest
      # element, we can stop processing and return - Optimization
      return if in_order_arr.size == k

      curr = curr.right
    end
  end

  # DEfault In Order => Ascending Order
  # Reverse In Order => Descending Order
  def reverse_in_order(root:, stack:, k:, in_order_arr: [])
    curr = root
    while curr || !stack.empty?
      while curr
        stack.push(curr)
        # Because we want result to be in Descending Order, we traverse
        # right
        curr = curr.right
      end
      curr = stack.pop
      in_order_arr.push(curr.data)
      # If in_order_arr contains "k" elements, we have found kth largest
      # element, we can stop processing and return - Optimization
      return if in_order_arr.size == k

      curr = curr.left
    end
  end
end

def test
  bt = BinaryTreeOrderStats.new
  arr = [100, 60, 47, 45, 50, 48, 65, 63, 62, 61, 70, 80, 75, 73, 110, 105, 125]
  arr.each do |data|
    bt.insert(data:)
  end

  kth_element_obj = KSmallestElement.new
  k = 7
  result = kth_element_obj.find_kth_element(bt:, k:)

  print "\n\n Array with kth smallest elements listed in Ascending order, 1th = 1st smallest:: \n"
  arr.sort.each_with_index do |element, index|
    print " #{index + 1}: #{element}"
    print ', ' unless index == arr.length - 1
    print "\n" if index == arr.length - 1
  end
  print "\n Array with kth largest elements listed in Descending order, 1th = 1st largest:: \n"
  arr.sort { |a, b| b <=> a }.each_with_index do |element, index|
    print " #{index + 1}: #{element}"
    print ', ' unless index == arr.length - 1
    print "\n" if index == arr.length - 1
  end
  print "\n 7th largest element should be :: 73"

  kth_largest_hsh = result[:k_largest]
  kth_smallest_hsh = result[:k_smallest]

  print "\n #{k}th largest Inorder :: #{kth_largest_hsh[:inorder]}, "
  print " #{k}th largest using left subtree size :: #{kth_largest_hsh[:left_subtree_size]}, "
  print " #{k}th largest using right subtree size :: #{kth_largest_hsh[:right_subtree_size]}"
  print "\n\n 7th smallest element should be :: 62"
  print "\n #{k}th Smallest Inorder :: #{kth_smallest_hsh[:inorder]}, "
  print " #{k}th Smallest using left subtree size :: #{kth_smallest_hsh[:left_subtree_size]}\n\n"
end

test
