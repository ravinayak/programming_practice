require_relative '../algo_patterns/data_structures/binary_tree'

# frozen_string_literal: true
# Serialization is the process of converting a data structure or object
# into a sequence of bits so that it can be stored in a file or memory buffer,
# or transmitted across a network connection link to be reconstructed later
# in the same or another computer environment.

# Design an algorithm to serialize and deserialize a binary tree. There is
# no restriction on how your serialization/deserialization algorithm should
# work. You just need to ensure that a binary tree can be serialized to a
# string and this string can be deserialized to the original tree structure.

# Clarification: The input/output format is the same as how LeetCode
# serializes a binary tree. You do not necessarily need to follow this
# format, so please be creative and come up with different approaches
# yourself.

# Example 1:
# Input: root = [1,2,3,null,null,4,5]
# Output: [1,2,3,null,null,4,5]

# Example 2:
# Input: root = []
# Output: []
	
# Algorithm: We serialize the Binary Tree as Full Binary Tree
# or Complete Binary Tree. If left/right nodes of a node are nil
# they are stored as '#', and if the node has any data (integer),
# that data is serialized as a string.
# It is easy to deserialize such a string because immediately
# next to any data, we shall be storing left node (since it is
# a Complete Full Binary Tree), we shall always have a Left child
# and a Right child even if they are NIL.
# Pre-Order Traversal: Root - Left - Right
# Problem that occurs when we are given only PreOrder Traversal
# of a Binary Tree is that certain Nodes may not have left/right
# child, and in such case we do not know if the next element in
# PreOrder Traversal is left/right child
# Even in case of a Complete Binary Tree where a node must have
# 2 children or NO children, this problem occurs, and we need
# at least one more traversal of tree (such as PostOrder) to
# determine the size of left/right subtree
# A Full Complete Binary Tree has 2 children for every node, and
# since we represent NIL nodes as '#', they ensure that every node
# has 2 children. Using this, we can re-construct Binary Tree from
# PreOrder Traversal
# The problem that can happen in recursion is that value of "index"
# can return back to its original value in recursion if we use a
# variable. We must use a hash, such that if the value of index used
# to access any element in array of characters (made from splitting
# PreOrder Traversal Serialized String on space) is changed in any
# Level of Recursion, that value Stays Changed. This is critical to
# ensure that we access only those characters in Array which have
# NOT BEEN PROCESSED before

# BinaryTreeNode Class
class BinaryTreeNode
  attr_accessor :data, :left, :right

  def initialize(data: nil, left: nil, right: nil)
    @data = data
    @left = left
    @right = right
  end
end

# Serialize a Binary Tree, deserialize it to reconstruct
class SerializeDeSerializeBT
  attr_accessor :serialized_bt

  NIL_CHAR = '#'

  def serialize_bt(root:)
    serialize_bt = ''
    @serialized_bt = pre_order_serialize_bt(node: root, serialize_bt:).strip

    # Return the value of serialized string representation of BinaryTree
    @serialized_bt
  end

  def deserialize_bt(input_serialized_bt: nil)
    if input_serialized_bt.nil?
      serialized_bt_str = @serialized_bt
    else
      serialized_bt_str = input_serialized_bt
    end

    index_hsh = { index: 0 }
    data_arr = serialized_bt_str.split(' ').map do |data_str|
      if data_str != NIL_CHAR
        data_str.to_i
      else
        data_str
      end
    end
    deserialize_pre_order_bt(data_arr:, index_hsh:)
  end

  private

  def deserialize_pre_order_bt(data_arr:, index_hsh:)
    # If node is nil we increase the index to process '#'
    # and return nil
    if data_arr[index_hsh[:index]] == NIL_CHAR
      index_hsh[:index] += 1
      return nil
    end

    # If node is NOT NIL, a new node is created with data on
    # node, index is incremented. Because a hash is used, index
    # increments persist across Recursion. Elements in array
    # which have been processed are not processed again
    node = BinaryTreeNode.new(data: data_arr[index_hsh[:index]])
    index_hsh[:index] += 1

    # When NIL node is encountered, it returns from the recursion
    # and assigns it to node.left or node.right. And the node
    # with left/right subtree is returned to Previous Recursion
    # where it is assigned as left/right child of node
    # This way the entire tree is built (both left/right subtrees)
    # when we reach back at root in recursion. And Finally we
    # return Root
    node.left = deserialize_pre_order_bt(data_arr:, index_hsh:)
    node.right = deserialize_pre_order_bt(data_arr:, index_hsh:)

    node
  end

  def pre_order_serialize_bt(node:, serialize_bt:)
    # serialize_bt is a string which appends data on nodes and a '#'
    # if node is nil, this value is returned from the recursion only
    # when node is nil
    # serialize_bt is called with right node in recursion and the value
    # for this string is returned and assigned back to the string
    # in previous string where the node was called with left/right
    # In this way, the entire binary tree is processed and serialized
    # string is generated
    if node.nil?
      serialize_bt += "#{NIL_CHAR} "
      return serialize_bt
    end

    serialize_bt += "#{node.data} "

    serialize_bt = pre_order_serialize_bt(node: node.left, serialize_bt:)
    pre_order_serialize_bt(node: node.right, serialize_bt:)
  end
end

def binary_tree
  bt = BinaryTree.new(data: 75)
  arr = [50, 40, 35, 45, 110, 60, 85, 125, 115, 55, 90, 135, 130, 80, 78, 128]
  # Here we have taken 1st binary tree and deliberately inserted 128 at the end to increase
  # height of rightmost subtree by 1, to fail it the balance criterion. Height of tree
  # increases by 1 to 6
  arr.each do |data|
    bt.insert(data:)
  end

  # Return binary tree
  bt
end

def test
  bt = binary_tree
  serialize_bt = SerializeDeSerializeBT.new
  serialized_str_val = serialize_bt.serialize_bt(root: bt.root)

  print "\n Original Binary Tree - Traversed in PreOrder \n"
  bt.pre_order_traversal
  print "\n Serialized String of Binary Tree :: #{serialized_str_val}"
  print "\n\n Deserializing the string representation of Binary Tree \n"
  bt1 = BinaryTree.new
  bt_deserialized = serialize_bt.deserialize_bt(input_serialized_bt: serialized_str_val)
  bt1.root = bt_deserialized
  bt1.pre_order_traversal
  print "\n"
end

test
