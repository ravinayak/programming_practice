Binary Tree Traversals

1. Non Recursive Traversals:
   • Pre-Order: 1 Stack - Push root in stack - until stack.empty? - Pop current Node from stack, print it - Push right of current Node in stack - if !nil? - Push left of current Node in stack - if !nil?
   • In-Order: 1 Stack + current

- Push root in stack - current = root - while !stack.empty? || current - while current - Push current = node.left in stack - end - Pop node from stack - current = current.right
  • Post-Order: 2 Stacks
- Push root onto stack1
  - until stack1.empty?
  - node = stack1.pop
  - stack2.push(node)
  - stack2.push()

Order Statistics (kth smallest, kth largest):

1. Define Node class with left_subtree_size as an attribute initialized to 0, right_subtree_size initialized to 0
2. During Insert, if we traverse on the left, for every insert,

- node.left_subtree_size += 1
- We do not consider node.left.subtree_size because the ancestor's left_subtree_size is incremented by 1 for every node which is added to the left subtree

3. Same for node.right_subtree_size
4. To search for kth smallest node in BST, remember

- If node.left_subtree_size is "m", its place in the in-order traversal is "m + 1" in the entire tree data
- Comparison:
- if node.left_subtree_size + 1 == k (2 nodes in the left subtree => this node is 3rd in BST ordering)
  return node.data
  elsif node.left_subtree_size + 1 > k (traverse left)
  return search(node: node.left, k:, data:)
  else
  return search(node: node.right, k: k - (node.left_subtree_size + 1), data:)
  # Current node is at position, node.left_subtree_size + 1 in the order, hence we subtract this to find the kth smallest element
  end

5. We can also perform in-order traversal, prepare an array and find the kth smallest element in BST:

- In Order Traversal => kth smallest element in BST = element at index k - 1
- Reverse In Order Traversal => kth largest element in BST = element at index k - 1
  Reverse In Order
  => change the condition for stack to use curr.right instead of curr.left
  => recursive call: in_order(node.right), then arr << data, then in_order(node.left)
