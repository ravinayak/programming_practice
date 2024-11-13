LinkedList:

1. Define a node class which has (data: nil, next_node: nil), so that Node can be initialized without any data
2. Inserting/Removing data from linked list
   - prev = head
   - curr = head.next
   - while curr
   - This is critical because when we want to insert a node, or remove a node, we need a reference to the
     previous node, so that previous.next can point to the new node or the node which is after the node
     to be removed
3. Display/Search
   - curr = head.next and while curr
   - This is because we want to search for data only on nodes which are not nil
   - Display data on nodes which are not nil
4. Initialize head to an empty node with nil data, next as nil
