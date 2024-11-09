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
