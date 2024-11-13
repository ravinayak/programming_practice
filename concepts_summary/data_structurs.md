Stack

1. Implement Stack using array and index
2. index = -1
3. index += 1, then Increment index before pushing any element onto stack
4. index == -1 => Stack is Empty
5. element_at_top => arr[index]
6. stack_index = index,
   - while stack_index >=0
   - print arr[stack_index]
   - stack_index -= 1

Queue

1. Impelement Queue using arr, front, rear
2. rear = -1 (just like index in Stack), front = 0
3. Add elements at rear, delete elements from front
4. rear += 1, then Add element in queue (just like stack)
5. rear < front => Queue is Empty (Remember rear = -1, front = 0 for initialization when Queue is Empty)
6. Print elements, (just like stack, remember rear <=> index, rear is Equivalent to Index)
7. queue_rear = rear
   - whlile queue_rear <= front
   - print arr[queue_rear]
   - queue_rear += 1
8. Peek => Element at front of Queue
   - Here, front maps to Index, Because front maintains the front of queue - First in First Out
   - First => Front, Last => Rear
