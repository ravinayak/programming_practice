# Hungarian Algorithm Dry Run and Explanation

## Overview

The Hungarian (Munkres) algorithm solves the **assignment problem**: finding the minimum-cost perfect matching between rows and columns of a cost matrix. It guarantees an optimal solution in polynomial time.

**Key Concepts:**

- **Starred zeros (★)**: Represent current assignments (mask = 1)
- **Primed zeros (')**: Temporary markers for potential augmenting paths (mask = 2)
- **Covering**: Rows/columns that are "locked" during path exploration
- **Augmenting path**: A path that increases the number of assignments

---

## Algorithm Steps Summary

1. **Step 0**: Pad matrix to make it square
2. **Step 1**: Row reduction (subtract row minimums)
3. **Step 2**: Column reduction (subtract column minimums)
4. **Step 3**: Star independent zeros (initial greedy matching)
5. **Step 4**: Cover columns with starred zeros
6. **Step 5-6**: Main loop - find augmenting paths or adjust matrix
7. **Step 7**: Extract final assignments

---

## Detailed Dry Run

### Input Matrix

Let's use a 3×3 cost matrix that will require path augmentation:

```
Original Cost Matrix:
     C0  C1  C2
R0 [ 4   2   5 ]
R1 [ 3   1   4 ]
R2 [ 5   3   6 ]
```

**Goal**: Find minimum-cost assignment where each row is assigned to exactly one column and each column to exactly one row.

---

### Step 0: Pad Matrix (if needed)

Our matrix is already 3×3, so no padding needed.

```
n = 3
cost = [[4, 2, 5],
        [3, 1, 4],
        [5, 3, 6]]
```

---

### Step 1: Row Reduction

Subtract the minimum value of each row from all entries in that row. This creates at least one zero per row.

**Row 0**: min = 2 → subtract 2

```
[4, 2, 5] → [2, 0, 3]
```

**Row 1**: min = 1 → subtract 1

```
[3, 1, 4] → [2, 0, 3]
```

**Row 2**: min = 3 → subtract 3

```
[5, 3, 6] → [2, 0, 3]
```

**Result after Step 1:**

```
     C0  C1  C2
R0 [ 2   0   3 ]
R1 [ 2   0   3 ]
R2 [ 2   0   3 ]
```

**Why this works**: We're subtracting constants from rows, which doesn't change the relative costs. The optimal assignment remains the same.

---

### Step 2: Column Reduction

Subtract the minimum value of each column from all entries in that column.

**Column 0**: min = 2 → subtract 2

```
[2, 2, 2] → [0, 0, 0]
```

**Column 1**: min = 0 → subtract 0 (no change)

```
[0, 0, 0] → [0, 0, 0]
```

**Column 2**: min = 3 → subtract 3

```
[3, 3, 3] → [0, 0, 0]
```

**Result after Step 2:**

```
     C0  C1  C2
R0 [ 0   0   0 ]
R1 [ 0   0   0 ]
R2 [ 0   0   0 ]
```

**Why this works**: Similar to row reduction - we're preserving relative costs while creating zeros.

---

### Step 3: Star Independent Zeros

Greedily star zeros that don't conflict with existing stars. A zero can be starred only if:

- Its row has no starred zero
- Its column has no starred zero

**Process:**

1. Check (0,0): row 0 uncovered, col 0 uncovered → **STAR** ★

   - `mask[0][0] = 1`
   - `row_cover[0] = True`, `col_cover[0] = True`

2. Check (0,1): row 0 covered → skip
3. Check (0,2): row 0 covered → skip
4. Check (1,0): col 0 covered → skip
5. Check (1,1): row 1 uncovered, col 1 uncovered → **STAR** ★

   - `mask[1][1] = 1`
   - `row_cover[1] = True`, `col_cover[1] = True`

6. Check (1,2): row 1 covered → skip
7. Check (2,0): col 0 covered → skip
8. Check (2,1): col 1 covered → skip
9. Check (2,2): row 2 uncovered, col 2 uncovered → **STAR** ★
   - `mask[2][2] = 1`
   - `row_cover[2] = True`, `col_cover[2] = True`

**Result after Step 3:**

```
Mask Matrix (★ = starred):
     C0  C1  C2
R0 [ ★   0   0 ]
R1 [ 0   ★   0 ]
R2 [ 0   0   ★ ]
```

**Current assignments**: (0,0), (1,1), (2,2)

**Reset covers:**

```
row_cover = [False, False, False]
col_cover = [False, False, False]
```

---

### Step 4: Cover Columns with Starred Zeros

Cover every column that contains a starred zero. This marks which columns already have assignments.

**Columns with stars**: C0 (star at R0), C1 (star at R1), C2 (star at R2)

```
col_cover = [True, True, True]
```

**Check**: `sum(col_cover) = 3 = n` → **Complete matching found!**

Wait, but let's use a different example where we need path augmentation...

---

## Example Requiring Path Augmentation

Let's use a matrix that doesn't yield a complete matching after Step 3:

### New Input Matrix

```
Original Cost Matrix:
     C0  C1  C2
R0 [ 1   4   5 ]
R1 [ 5   7   6 ]
R2 [ 3   2   1 ]
```

---

### Step 0: Pad Matrix

Already 3×3, no padding needed.

---

### Step 1: Row Reduction

**Row 0**: min = 1

```
[1, 4, 5] → [0, 3, 4]
```

**Row 1**: min = 5

```
[5, 7, 6] → [0, 2, 1]
```

**Row 2**: min = 1

```
[3, 2, 1] → [2, 1, 0]
```

**Result:**

```
     C0  C1  C2
R0 [ 0   3   4 ]
R1 [ 0   2   1 ]
R2 [ 2   1   0 ]
```

---

### Step 2: Column Reduction

**Column 0**: min = 0 → no change
**Column 1**: min = 1 → subtract 1
**Column 2**: min = 0 → no change

**Result:**

```
     C0  C1  C2
R0 [ 0   2   4 ]
R1 [ 0   1   1 ]
R2 [ 2   0   0 ]
```

---

### Step 3: Star Independent Zeros

**Process:**

1. (0,0): row 0 uncovered, col 0 uncovered → **STAR** ★

   - `mask[0][0] = 1`
   - Cover row 0, col 0

2. (1,0): row 1 uncovered, but col 0 covered → skip
3. (1,1): row 1 uncovered, col 1 uncovered → **STAR** ★

   - `mask[1][1] = 1`
   - Cover row 1, col 1

4. (2,0): col 0 covered → skip
5. (2,1): col 1 covered → skip
6. (2,2): row 2 uncovered, col 2 uncovered → **STAR** ★
   - `mask[2][2] = 1`
   - Cover row 2, col 2

**Result:**

```
Mask Matrix:
     C0  C1  C2
R0 [ ★   0   0 ]
R1 [ 0   ★   0 ]
R2 [ 0   0   ★ ]
```

**Reset covers:**

```
row_cover = [False, False, False]
col_cover = [False, False, False]
```

---

### Step 4: Cover Columns with Starred Zeros

All columns have stars, so:

```
col_cover = [True, True, True]
sum(col_cover) = 3 = n
```

Actually, this also gives a complete matching. Let me use a better example...

---

## Better Example: Path Augmentation Required

### Input Matrix

```
Original Cost Matrix:
     C0  C1  C2
R0 [ 1   2   3 ]
R1 [ 2   4   6 ]
R2 [ 3   6   2 ]
```

---

### Step 1: Row Reduction

**Row 0**: min = 1 → [0, 1, 2]
**Row 1**: min = 2 → [0, 2, 4]
**Row 2**: min = 2 → [1, 4, 0]

**Result:**

```
     C0  C1  C2
R0 [ 0   1   2 ]
R1 [ 0   2   4 ]
R2 [ 1   4   0 ]
```

---

### Step 2: Column Reduction

**Column 0**: min = 0 → no change
**Column 1**: min = 1 → subtract 1
**Column 2**: min = 0 → no change

**Result:**

```
     C0  C1  C2
R0 [ 0   0   2 ]
R1 [ 0   1   4 ]
R2 [ 1   3   0 ]
```

---

### Step 3: Star Independent Zeros

**Process:**

1. (0,0): uncovered → **STAR** ★

   - `mask[0][0] = 1`
   - Cover row 0, col 0

2. (0,1): row 0 covered → skip
3. (0,2): row 0 covered → skip
4. (1,0): col 0 covered → skip
5. (1,1): row 1 uncovered, col 1 uncovered → **STAR** ★

   - `mask[1][1] = 1`
   - Cover row 1, col 1

6. (2,0): col 0 covered → skip
7. (2,1): col 1 covered → skip
8. (2,2): row 2 uncovered, col 2 uncovered → **STAR** ★
   - `mask[2][2] = 1`
   - Cover row 2, col 2

**Result:**

```
Mask Matrix:
     C0  C1  C2
R0 [ ★   0   0 ]
R1 [ 0   ★   0 ]
R2 [ 0   0   ★ ]
```

Again complete... Let me create a scenario that actually needs augmentation:

---

## Example That Requires Path Augmentation

Let's manually construct a scenario where Step 3 doesn't give a complete matching:

### After Step 2 (we'll start here with a specific state):

```
Cost Matrix:
     C0  C1  C2
R0 [ 0   1   0 ]
R1 [ 0   0   1 ]
R2 [ 1   0   0 ]
```

### Step 3: Star Independent Zeros

**Process:**

1. (0,0): uncovered → **STAR** ★

   - Cover row 0, col 0

2. (0,2): row 0 covered → skip
3. (1,0): col 0 covered → skip
4. (1,1): row 1 uncovered, col 1 uncovered → **STAR** ★

   - Cover row 1, col 1

5. (2,0): col 0 covered → skip
6. (2,1): col 1 covered → skip
7. (2,2): row 2 uncovered, col 2 uncovered → **STAR** ★

**Result:**

```
Mask Matrix:
     C0  C1  C2
R0 [ ★   0   0 ]
R1 [ 0   ★   0 ]
R2 [ 0   0   ★ ]
```

Still complete... Let me use a matrix that actually creates an incomplete matching:

---

## Real Path Augmentation Example

### Input Matrix

```
Original Cost Matrix:
     C0  C1  C2
R0 [ 4   1   3 ]
R1 [ 2   0   5 ]
R2 [ 3   2   2 ]
```

---

### Step 1: Row Reduction

**Row 0**: min = 1 → [3, 0, 2]
**Row 1**: min = 0 → [2, 0, 5]
**Row 2**: min = 2 → [1, 0, 0]

**Result:**

```
     C0  C1  C2
R0 [ 3   0   2 ]
R1 [ 2   0   5 ]
R2 [ 1   0   0 ]
```

---

### Step 2: Column Reduction

**Column 0**: min = 1 → subtract 1
**Column 1**: min = 0 → no change
**Column 2**: min = 0 → no change

**Result:**

```
     C0  C1  C2
R0 [ 2   0   2 ]
R1 [ 1   0   5 ]
R2 [ 0   0   0 ]
```

---

### Step 3: Star Independent Zeros

**Process:**

1. (0,1): uncovered → **STAR** ★

   - `mask[0][1] = 1`
   - Cover row 0, col 1

2. (1,1): row 1 uncovered, but col 1 covered → skip
3. (2,0): row 2 uncovered, col 0 uncovered → **STAR** ★

   - `mask[2][0] = 1`
   - Cover row 2, col 0

4. (2,1): col 1 covered → skip
5. (2,2): row 2 covered → skip

**Result:**

```
Mask Matrix:
     C0  C1  C2
R0 [ 0   ★   0 ]
R1 [ 0   0   0 ]
R2 [ ★   0   0 ]
```

**Current assignments**: (0,1), (2,0)
**Missing assignment**: Row 1 has no star!

**Reset covers:**

```
row_cover = [False, False, False]
col_cover = [False, False, False]
```

---

### Step 4: Cover Columns with Starred Zeros

Columns with stars: C1 (star at R0), C0 (star at R2)

```
col_cover = [True, True, False]
sum(col_cover) = 2 < 3 = n
```

**Not complete!** We need to find an augmenting path.

---

### Step 5-6: Main Loop - Finding Augmenting Path

**Iteration 1:**

**Find uncovered zero:**

- Check (0,0): row 0 uncovered, col 0 covered → skip
- Check (0,1): col 1 covered → skip
- Check (0,2): row 0 uncovered, col 2 uncovered → **FOUND** (0,2)

**Prime the zero:**

```
mask[0][2] = 2  (prime)
```

**Check if row 0 has a star:**

- `find_star_in_row(0)` → column 1 has a star
- **CASE 1**: Row has a star - Building alternating path

**Extend path:**

- Cover row 0 (mark as explored)
- Uncover column 1 (free it up for potential reassignment)

```
row_cover[0] = True
col_cover[1] = False
```

**Current state:**

```
Mask:
     C0  C1  C2
R0 [ 0   ★   ' ]
R1 [ 0   0   0 ]
R2 [ ★   0   0 ]

Covers:
row_cover = [True, False, False]
col_cover = [True, False, False]
```

**Find next uncovered zero:**

- Check (1,0): row 1 uncovered, col 0 covered → skip
- Check (1,1): row 1 uncovered, col 1 uncovered → **FOUND** (1,1)

**Prime the zero:**

```
mask[1][1] = 2  (prime)
```

**Check if row 1 has a star:**

- `find_star_in_row(1)` → None (no star)
- **CASE 2**: No star in row - **AUGMENTING PATH FOUND!**

---

### Path Augmentation - Detailed Explanation

**Current path:** We have primed zeros at (0,2) and (1,1), and a star at (0,1).

**Build the augmenting path:**

1. **Start with the primed zero that has no star in its row:**

   - Path = [(1,1)] ← This is our starting point (primed)

2. **Find a star in column 1 (column of last path element):**

   - `find_star_in_column(1)` → row 0 has a star at (0,1)
   - Add star to path: Path = [(1,1), (0,1)]

3. **Find a prime in row 0 (row of the star we just added):**

   - `find_prime_in_row(0)` → column 2 has a prime at (0,2)
   - Add prime to path: Path = [(1,1), (0,1), (0,2)]

4. **Find a star in column 2:**
   - `find_star_in_column(2)` → None
   - **Path ends here!**

**Final augmenting path:**

```
Path = [(1,1)', (0,1)★, (0,2)']
```

**Visual representation:**

```
     C0  C1  C2
R0 [ 0   ★   ' ]  ← Star at (0,1), Prime at (0,2)
R1 [ 0   '   0 ]  ← Prime at (1,1) - START
R2 [ ★   0   0 ]  ← Star at (2,0)

Path: (1,1)' → (0,1)★ → (0,2)'
```

---

### Flipping Stars and Primes

**The flip operation:**

- Primes (2) → Stars (1) = **new assignments**
- Stars (1) → Unmarked (0) = **remove old assignments**

**Before flipping:**

```
Path = [(1,1)', (0,1)★, (0,2)']
```

**After flipping:**

```
(1,1): 2 → 1  (prime becomes star - NEW ASSIGNMENT!)
(0,1): 1 → 0  (star becomes unmarked - REMOVE ASSIGNMENT)
(0,2): 2 → 1  (prime becomes star - NEW ASSIGNMENT!)
```

**Result:**

```
Mask Matrix:
     C0  C1  C2
R0 [ 0   0   ★ ]  ← New star at (0,2)
R1 [ 0   ★   0 ]  ← New star at (1,1)
R2 [ ★   0   0 ]  ← Existing star at (2,0)
```

**New assignments**: (0,2), (1,1), (2,0)
**We went from 2 assignments to 3 assignments!** ✅

---

### Clean Up After Augmentation

1. **Reset all covers:**

```
row_cover = [False, False, False]
col_cover = [False, False, False]
```

2. **Remove all remaining primes:**

   - No primes left (they were all flipped)

3. **Re-cover columns with starred zeros:**
   - C0: has star at R2 → cover
   - C1: has star at R1 → cover
   - C2: has star at R0 → cover

```
col_cover = [True, True, True]
sum(col_cover) = 3 = n
```

**Complete matching achieved!** ✅

---

### Step 7: Extract Final Assignments

Scan the mask matrix for starred zeros (mask = 1):

```
Assignments:
- (0, 2): Row 0 → Column 2
- (1, 1): Row 1 → Column 1
- (2, 0): Row 2 → Column 0
```

**Return:** `[(0, 2), (1, 1), (2, 0)]`

---

## Understanding the Matrix Adjustment (Step 6)

If no uncovered zero exists, we need to create new zeros. Here's how:

### Example Scenario

Suppose we have:

```
Cost Matrix:
     C0  C1  C2
R0 [ 1   0   2 ]
R1 [ 0   3   1 ]
R2 [ 2   1   0 ]

Mask (after some steps):
     C0  C1  C2
R0 [ 0   ★   0 ]
R1 [ ★   0   0 ]
R2 [ 0   0   ★ ]

Covers:
row_cover = [True, True, False]
col_cover = [True, False, True]
```

**Find uncovered zero:**

- All zeros are either in covered rows or covered columns
- No uncovered zero exists!

**Matrix adjustment:**

1. Find minimum in uncovered cells:

   - Uncovered: (2,1) = 1
   - `min_uncovered = 1`

2. Adjust matrix:
   - Add `min_uncovered` to covered rows (R0, R1)
   - Subtract `min_uncovered` from uncovered columns (C1)

**Result:**

```
     C0  C1  C2
R0 [ 2   0   3 ]  (added 1 to row)
R1 [ 1   0   2 ]  (added 1 to row)
R2 [ 2   0   0 ]  (unchanged row, but col 1 subtracted 1)
```

**New zero created at (2,1)!** This allows the algorithm to continue.

**Why this preserves optimality:**

- We add the same value to all covered rows
- We subtract the same value from all uncovered columns
- The relative differences between assignments remain unchanged
- We're just "shifting" the cost structure

---

## Key Insights

### 1. Why Zeros Matter

- The algorithm works entirely with zeros because:
  - Zeros represent "free" assignments (no additional cost)
  - After row/column reduction, the optimal assignment must use zeros
  - We're finding a matching using only zero-cost edges

### 2. Covering Mechanism

- **Covered rows**: Being explored in current path
- **Covered columns**: Already have assignments (starred zeros)
- **Uncovered cells**: Available for new assignments

### 3. Augmenting Paths

- An augmenting path alternates between:
  - Primed zeros (candidates)
  - Starred zeros (current assignments)
- Flipping increases assignments by exactly 1
- The path must start and end with primed zeros

### 4. Matrix Adjustment

- When no zeros are available, we create them
- The adjustment preserves optimality by maintaining relative costs
- Eventually, new zeros appear and the algorithm continues

---

## Algorithm Complexity

- **Time Complexity**: O(n³) for an n×n matrix
- **Space Complexity**: O(n²) for storing the cost matrix and masks

---

## Summary

The Hungarian algorithm elegantly solves the assignment problem by:

1. **Reducing the matrix** to create zeros while preserving optimality
2. **Greedily matching** zeros to form initial assignments
3. **Finding augmenting paths** to improve the matching when incomplete
4. **Adjusting the matrix** to create new zeros when needed
5. **Repeating** until a complete matching is found

The algorithm guarantees an optimal solution and is widely used in operations research, computer vision, and resource allocation problems.
