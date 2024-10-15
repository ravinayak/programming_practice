**Backtracking**

1. Combinations Sum:
   a. start: index => Duplicates are allowed
   b. start: index + 1 => Duplicates are NOT ALLOWED
2. Subsets:
   a. start: index + 1
3. Permutations:
   a. start = start + 1
4. In both Subsets, and Combinations problem, we iterate over
   elements of array, and recursively call the routine where
   we pass "start" to begin Iteration in Next Recrusion with
   respect to "index" of current Iteration.
   This is because we want to combine element at current index
   with element at subsequent indices in the array
5. Permutations:
   a. start = start + 1
   We iterate over elements of array in next Recursion by starting
   from next start position in next level of Recursion
   We swap elements at "start", "index" positions, and generate all
   possible combinations with the next "start".
   start = start + 1 ensures that in next iteration, only those
   elements are swapped which have not been swapped before to generate
   combinations
