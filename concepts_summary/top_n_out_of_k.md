1. If we are given a list of "i" items such as [i1, i2, i3, i4, i5, i6, i7, .........., ii], each item has a value
   associated with a key which is common to all items, say each item has a key "k" and a value for that key "vi",
   We can represent this as an array tuple:
   [ [i1, v1], [i2, v2], [i3, v3], [i4, v4], [i5, v5], [i6, v6], [i7, v7], .......[ii, vi] ]
   Out of these "i" items, we want to select top "n" items, where these top "n" items have the higest value for key "k"
   such that
   Value of key "p" for (i1, i2, i3, ..., in) > Value of key "p" for (Rest all items)
   To find these top "n" items, we have to iterate over each element at least once to find the value for key "k", but
   how can we compare it with the rest items to ensure it is amongst the top "n" items.
   Minimum Time Complexity = O(i), number of items = i
   We can implement this Efficiently with minimum Time Complexity and Space Complexity using Min-Heap

   1. **Step 1**: Insert the first `n` items from the `i` items into a min-heap along with their key values.
   2. **Step 2**: For every `n+1` item, compare the value of the key of that element with the value of the key for the minimum element (root).
      - Set `index = n + 1`
      - While `index < input.length`:
      1. If the value of key `k` for `input[index]` is greater than the value of key `k` of the root element of the min-heap:
         - Extract the root from the min-heap.
         - Insert `input[index]` into the min-heap.
      2. Increment `index` by 1: `index += 1`
   3. The min-heap at the end contains the top `n` items with the maximum values of key `k`.

Why Min-heap and why not max-heap?

Say, we use Max Heap, it will maintain a root element with the maximum value of key amongst all "n" items

1. Value of key (k) for input[index] > Value of key (k) of root element of Max-heap: In this case, input[index]
   element should be amongst the top "n" items, but which item from max-heap should we remove. We cannot remove
   root because it has a value of key "k" greater than all the other "n-1" items. We want to remove the element
   from these "n" items which has least value of key "k" such that we have "n" items with maximum value of key "k"
   including the input[index]
2. Value of key (k) for input[index] < Value of key (k) of root element of Max-heap: In this case, we cannot
   say definitively about whether this input[index] element should be amongst the top "n" items, this is because
   although it has a value of key "k" < Value of key "k" for root, it may have a value of key which is greater than
   the other "n-1" items, and in such a case, it should be in the Max-Heap. Not only can we not say anything about
   whether this element should be in the Max-heap, we also cannot say anything about which element should be removed
   from the Max-Heap
3. Min-heap solves this problem for us. We know that if value of key "k" for input[index] > Value of key "k" for root
   then this input[index] element should be amongst the top "n" items. We also know that root has the minimum value of
   key "k" amongst all the "n" items, hence it should be replaced with an item that has a greater value of key "k".
   We can not only definitively say we should remove, we also know which element to remove from the Max-heap
4. If value of key "k" for input[index] < value of key "k" for root of min-heap, we know that the value of key "k"
   for input[index] is less than all the "n" items in min-heap, hence, min-heap currently has the top "n" items
   amongst all the elements found so far including input[index]. We can skip processing and move to the next element

Summary:

1. Select "n" items from a list of "k" items which have the greatest value => Min Heap
2. Select "n" items from a list of "k" items which have the smallest value => Max Heap
3. Top - Highest "n" out of k => Min Heap
4. Top - Lowest "n" out of k => Max Heap
5. Reverse the intuition for heap for higest/lowest => high would imply intuitively Max Heap but use Min heap
