**The MedianFinder class uses two heaps to efficiently maintain the median:**

- max_heap: Stores the smaller half of the numbers
- min_heap: Stores the larger half of the number

The design follows these key principles:

- max_heap will always have either equal or one more element than min_heap
- All elements in max_heap are smaller than or equal to all elements in min_heap
- By inserting the first element into max_heap, we establish a foundation where:
- For odd number of elements: the median is the root of max_heap
- For even number of elements: the median is the average of roots of both heaps

Insertion Algorithm:

1. If element <= top element of max_heap => Insert into max_heap, else insert into min_heap
2. If min_heap.size > max_heap.size => Extract top element from min_heap and insert into max_heap
3. elsif max_heap.size > min_heap.size + 1 => Extract top element from max_heap and insert into min_heap

=> Order of steps in Insertion Algorithm must be same as listed above

Here's a visualization:

max_heap (smaller half) min_heap (larger half)
[3] [4]
[2] [5]
[1] [6]

If we had put the first element in min_heap instead, we would need additional logic to move it to max_heap anyway to maintain the balance property, since we want max_heap to have equal or one more element than min_heap. This design makes finding the median O(1) time complexity:

- If total elements is odd: return max_heap.root
- If total elements is even: return average of max_heap.root and min_heap.root

Always remember that to find "k" minimum elements (such as "k" closest points to origin), we use a max heap and store the k points based on their distance as key,
and compare every element with the top element of max_heap, if the distance is < max_heap top element, we extract the max element and insert the point whose
distance is less

Minimum n things => Max Heap
Maximum n things => Min Heap

Max Heap => Smaller Half of numbers whose median is to be found
Min Heap => Greater Half of numbers whose median is to be found

**Merge k Sorted Arrays**

1. Sorted Arrays in Descending Order => Max Heap
2. Sorted Arrays in Ascending Order => Min heap
3. Algorithm:

Merge k sorted arrays - sorted in descending order

1. Insert the largest element from each array into a Priority Queue. This should
   contain array_index (array from which the element came),
   element_index (index of element in the array) and the actual element
2. Until the heap is empty
   a. Extract the maximum element from priority queue and insert into merged array
   b. Find the array from which this element came. If there are more elements in this array
   insert the next largest element from this array into priority queue
   c. Repeat
