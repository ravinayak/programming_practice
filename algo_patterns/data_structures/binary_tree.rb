# frozen_string_literal: true

require_relative 'binary_tree_node'
require_relative 'stack'

# Class implements BinaryTree
# - Insert Node in BinaryTree
# - Search for data in BinaryTree
# - Traversal of a node in BinaryTree
# -		1. Inorder  2. PreOrder  3. PostOrder (With Recursion and without Recursion)
# - Delete a node from BinaryTree
#
class BinaryTree
  attr_accessor :root

  def initialize(data: nil)
    @root = BinaryTreeNode.new(data:) unless data.nil?
  end

  # Inserts data in BinaryTree
  # @param [Integer] data
  # @return [BinaryTreeNode] root
  #
  def insert(data:)
    return self.root = BinaryTreeNode.new(data:) if root.nil?

    recursive_insert(node: root, data:)
  end

  # Search data in BinaryTree
  # @param [Integer] data
  # @return [Hash] BinaryTreeNode, data
  #
  def search(data:)
    return { node: nil, result: false } if root.nil?

    recursive_search(node: root, data:)
  end

  # Pre-order Traversal
  #
  def pre_order_traversal
    return puts 'Tree is empty' if root.nil?

    puts '********************* Pre Order Traversal of Binary Tree *********************'
    rec_pre_order_traversal(node: root)
    puts "\n******************************************************************************"
  end

  # Post-order Traversal
  #
  def post_order_traversal
    return puts 'Tree is empty' if root.nil?

    puts '********************* Post Order Traversal of Binary Tree ********************'
    rec_post_order_traversal(node: root)
    puts "\n******************************************************************************"
  end

  # In-order Traversal
  #
  def in_order_traversal
    return puts 'Tree is empty' if root.nil?

    puts '********************* In Order Traversal of Binary Tree **********************'
    rec_in_order_traversal(node: root)
    puts "\n******************************************************************************"
  end

  # In Order Non Recursive Traversal
  #
  def non_rec_in_order_traversal
    curr = root
    st = Stack.new
    puts '********** Non Recursive In Order Traversal ***********************************'
    # It is extremely important to check both stack not being empty and current not being
    # nil. This is because there will be many times in this traversal when stack becomes
    # empty but there is still a current node which needs to be processed. Consider the
    # use case when entire subtree of root along with root has been traversed. At this
    # point the stack is empty because the last node in it - root has been popped, and
    # current = current.right, which means current is set to the right child of root
    # and the entire right subtree has NOT BEEN PROCESSED. If we use !stack.empty? and not
    # curr, entire right subtree will not be processed
    while curr || !st.empty?
      # Before pushing onto stack, we want to validate that current is NOT NIL
      # Entire left subtree of current is pushed onto Stack, alongwith the current node
      while curr
        st.push(data: curr)
        curr = curr.left
      end
      # We have reache a node which does not have any left, or its entire left subtree has
      # been processed, hence pop it and print its data
      curr = st.pop
      print " #{curr.data} "
      # Since entire left subtree has been processed, we move to the right subtree of current
      curr = curr.right
    end
    puts "\n******************************************************************************"
  end

  # Pre Order Non Recursive Traversal
  #
  def non_rec_pre_order_traversal
    st = Stack.new
    st.push(data: root)
    puts '********** Non Recursive Pre Order Traversal *********************************'
    until st.empty?
      curr = st.pop
      print " #{curr.data} "
      st.push(data: curr.right) if curr.right
      st.push(data: curr.left)	if curr.left
    end
    puts "\n******************************************************************************"
  end

  # Post Order Non Recursive Traversal
  #
  def non_rec_post_order_traversal
    st1 = Stack.new
    st2 = Stack.new
    st1.push(data: root)
    puts '********** Non Recursive Post Order Traversal ********************************'
    prep_stack_for_traversal(st1, st2) until st1.empty?

    print_elements_post_order(st2) until st2.empty?

    puts "\n******************************************************************************"
  end

  def non_rec_only_code_post_order
    st1 = Stack.new
    st2 = Stack.new
    current = root
    st1.push(data: current)
    # Stack st1 is used to simply determine the correct order in which elements
    # should be pushed onto Stack st2 for printing. Hence once it is empty, we
    # can break from it
    until st1.empty?
      current = st1.pop
      # Stack 2 maintains the correct order in which data of nodes should be printed
      # Clearly, it should contain node, node.left, node.right in this order:
      # a. node.left
      # b. node.right
      # c. node
      # Nodes are popped from Stack st1, and pushed into Stack st2, so right node of
      # current must remain on top of st1, so that it is processed 1st, and pushed
      # onto Stack st2. When the entire subtree of current has been processed and
      # pushed onto stack st2, we will process left subtree of current and push onto
      # stack st2
      # This is reverse of what we do in Pre-Order traversal in which left must remain
      # on top of stack, so we push node.right and then node.left
      # Pre-Order: Order of pushing onto Stack
      # a. node.right
      # b. node.left
      # Post-Order: Order of pushing onto Stack
      # a. node.left
      # b. node.right
      # Pre-order is easier to remember, so remember that Post is reverse of Pre for
      # pushing and Post requires 2 stacks
      # In Pre-Order as well, we pop from stack, in Post we push this onto another Stack
      # whereas in Pre-Order, we print the nodes data, and push its right, left children
      # in that order
      st2.push(data: current)
      st1.push(data: current.left) if curr.left
      st1.push(data: current.right) if curr.right
    end

    # Stack st2 is used for printing all the elements by popping them off the stack
    # It contains elements in the correct order, so we just have to pop them and
    # print them
    until st2.empty?
      current = st2.pop
      print current.data
    end
  end

  private

  # Push elements onto stack 2 and stack 1
  # @param [Stack] st1
  # @param [Stack] st2
  #
  def prep_stack_for_traversal(st1, st2)
    curr = st1.pop
    st2.push(data: curr)
    st1.push(data: curr.left) if curr.left
    st1.push(data: curr.right) if curr.right
  end

  # Pop and print elements from stack2
  # @param [Stack] st2
  #
  def print_elements_post_order(st2)
    curr = st2.pop
    print " #{curr.data} "
  end

  # Pre-Order Traversal - Recursive
  # @param [BinaryTreeNode] node
  #
  def rec_pre_order_traversal(node:)
    return if node.nil?

    print " #{node.data} "
    rec_pre_order_traversal(node: node.left)
    rec_pre_order_traversal(node: node.right)
  end

  # Post-Order Traversal - Recursive
  # @param [BinaryTreeNode] node
  #
  def rec_post_order_traversal(node:)
    return if node.nil?

    rec_post_order_traversal(node: node.left)
    rec_post_order_traversal(node: node.right)
    print " #{node.data} "
  end

  # In-Order Traversal - Recursive
  # @param [BinaryTreeNode] node
  #
  def rec_in_order_traversal(node:)
    return if node.nil?

    rec_in_order_traversal(node: node.left)
    print " #{node.data} "
    rec_in_order_traversal(node: node.right)
  end

  # Recursive Searche for data in BinaryTree
  # @param [BinaryTreeNode] node
  # @param [Integer] data
  # @return [Hash] BinaryTreeNode, data
  #
  def recursive_search(node:, data:)
    return { node: nil, result: false } if node.nil?

    return { node:, result: true } if node.data == data

    return recursive_search(node: node.left, data:) if node.data > data

    recursive_search(node: node.right, data:)
  end

  # Recursively inserts data in BinaryTree following left/right depending upon if
  # data is greater than data on node
  # @param [BinaryTreeNode] node
  # @param [Integer] data
  # @return [BinaryTreeNode]
  #
  def recursive_insert(node:, data:)
    return BinaryTreeNode.new(data:) if node.nil?

    if node.data >= data
      node.left = recursive_insert(node: node.left, data:)
    else
      node.right = recursive_insert(node: node.right, data:)
    end

    node
  end
end

# bt = BinaryTree.new(data: 75)
# arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78]
# arr.each do |data|
#   bt.insert(data:)
# end

# bt.in_order_traversal
# bt.non_rec_in_order_traversal

# bt.pre_order_traversal
# bt.non_rec_pre_order_traversal

# bt.post_order_traversal
# bt.non_rec_post_order_traversal

# puts bt.search(data: 35)
# puts bt.search(data: 78)
# puts bt.search(data: 85)
# puts bt.search(data: 129)
