def hungarian_algorithm(cost_matrix):
	"""
	Solve the assignment problem using the Hungarian (Munkres) algorithm.

	This algorithm finds a minimum-cost perfect matching between rows and columns
	of a cost matrix.

	Args:
			cost_matrix (List[List[float]]):
					A rectangular matrix where cost_matrix[i][j] is the cost of assigning
					row i to column j.

	Returns:
			List[Tuple[int, int]]:
					A list of (row_index, column_index) assignments representing the
					minimum-cost matching.
	"""

	# -------------------------------------------------------
	# STEP 0: Pad the matrix to make it square
	# -------------------------------------------------------
	n_rows = len(cost_matrix)
	n_cols = len(cost_matrix[0])
	n = max(n_rows, n_cols)

	# Copy matrix and pad with zeros
	cost = [row + [0] * (n - n_cols) for row in cost_matrix]
	cost += [[0] * n for _ in range(n - n_rows)]

	# -------------------------------------------------------
	# STEP 1: Row reduction
	# Subtract the minimum value of each row from all entries
	# in that row.
	# -------------------------------------------------------
	for i in range(n):
			row_min = min(cost[i])
			for j in range(n):
					cost[i][j] -= row_min

	# -------------------------------------------------------
	# STEP 2: Column reduction
	# Subtract the minimum value of each column from all entries
	# in that column.
	# -------------------------------------------------------
	for j in range(n):
			col_min = min(cost[i][j] for i in range(n))
			for i in range(n):
					cost[i][j] -= col_min

	# -------------------------------------------------------
	# Masks and covers
	#
	# mask[i][j]:
	#   0 = no marking
	#   1 = starred zero (part of current matching)
	#   2 = primed zero (candidate for augmenting path)
	# -------------------------------------------------------
	mask = [[0] * n for _ in range(n)]
	row_cover = [False] * n
	col_cover = [False] * n

	# -------------------------------------------------------
	# STEP 3: Star independent zeros
	# Star a zero if there is no other starred zero in its
	# row or column.
	# -------------------------------------------------------
	for i in range(n):
			for j in range(n):
					if cost[i][j] == 0 and not row_cover[i] and not col_cover[j]:
							mask[i][j] = 1  # star
							row_cover[i] = True
							col_cover[j] = True

	# Reset covers
	row_cover[:] = [False] * n
	col_cover[:] = [False] * n

	# -------------------------------------------------------
	# Helper Functions
	# -------------------------------------------------------
	def cover_starred_columns():
			"""
			Cover every column that contains a starred zero.
			"""
			for i in range(n):
					for j in range(n):
							if mask[i][j] == 1:
									col_cover[j] = True

	def find_uncovered_zero():
			"""
			Find the position of an uncovered zero in the cost matrix.

			Returns:
					(row, col) if found, otherwise None
			"""
			for i in range(n):
					if not row_cover[i]:
							for j in range(n):
									if cost[i][j] == 0 and not col_cover[j]:
											return i, j
			return None

	def find_star_in_row(row):
			"""
			Find the column index of a starred zero in the given row.
			"""
			for j in range(n):
					if mask[row][j] == 1:
							return j
			return None

	def find_star_in_column(col):
			"""
			Find the row index of a starred zero in the given column.
			"""
			for i in range(n):
					if mask[i][col] == 1:
							return i
			return None

	def find_prime_in_row(row):
			"""
			Find the column index of a primed zero in the given row.
			"""
			for j in range(n):
					if mask[row][j] == 2:
							return j
			return None

	# -------------------------------------------------------
	# STEP 4: Cover columns containing starred zeros
	# -------------------------------------------------------
	cover_starred_columns()

	# -------------------------------------------------------
	# STEP 5–6: Main algorithm loop
	# -------------------------------------------------------
	# CENTRAL IDEA:
	# Find a complete matching (one assignment per row/column) using zeros.
	# Strategy:
	#   1. Find uncovered zeros (potential new assignments)
	#   2. Build alternating paths to reassign existing matches
	#   3. When no zeros exist, adjust matrix to create new zeros
	#
	# The loop continues until all columns are covered (complete matching).
	# -------------------------------------------------------
	while sum(col_cover) < n:
			# OUTER LOOP: Continue until all n columns have assignments
			# sum(col_cover) counts how many columns are covered
			# When sum(col_cover) == n, we have a complete matching

			# Find an uncovered zero (zero in uncovered row AND uncovered column)
			# This represents a potential new assignment we can explore
			zero_pos = find_uncovered_zero()

			# INNER LOOP: Process uncovered zeros one by one
			# We keep finding and processing zeros until:
			#   - We find an augmenting path (increases assignments), OR
			#   - No more uncovered zeros exist (need to adjust matrix)
			while zero_pos:
					row, col = zero_pos
					
					# PRIME the zero: Mark it as a candidate for augmenting path
					# mask = 2 means "primed" (temporary marker, not yet in matching)
					mask[row][col] = 2

					# Check if this row already has a starred zero (existing assignment)
					starred_col = find_star_in_row(row)

					if starred_col is not None:
							# CASE 1: Row has a star - Building alternating path
							# We can't directly use this zero (row already assigned)
							# Instead, we "uncover" the starred column to explore reassigning it
							# This extends our alternating path: prime → star → (next prime)
							#
							# Example:
							#   Row 1 has star at column 0
							#   We find uncovered zero at (1, 2)
							#   Action: Cover row 1, uncover column 0
							#   This allows us to potentially reassign column 0 elsewhere
							row_cover[row] = True      # Mark row as being explored
							col_cover[starred_col] = False  # Free up the starred column

					else:
							# CASE 2: No star in row - AUGMENTING PATH FOUND!
							# This means we can increase the number of assignments!
							# An augmenting path starts with an unassigned (primed) zero
							# and ends at an unassigned position
							# ---------------------------------------------------
							# STEP 5: Construct an augmenting path
							# ---------------------------------------------------
							
							# Start building the path with our primed zero
							path = [(row, col)]

							# Build alternating path: prime → star → prime → star → ...
							# The path alternates between primed and starred zeros
							# until we can't continue (no star in column or no prime in row)
							while True:
									# Find a star in the column of the last path element
									# path[-1][1] is the column of the last element
									star_row = find_star_in_column(path[-1][1])
									
									# If no star found, path ends (augmenting path complete)
									if star_row is None:
											break
									
									# Add the star to the path
									# Path now: [..., (prime), (star_row, column)]
									path.append((star_row, path[-1][1]))

									# Find a prime in the row of the star we just added
									# This continues the alternating pattern
									prime_col = find_prime_in_row(star_row)
									
									# If no prime found, path ends
									if prime_col is None:
											break
									
									# Add the prime to the path
									# Path now: [..., (star), (star_row, prime_col)]
									path.append((star_row, prime_col))

							# FLIP STARS AND PRIMES ALONG THE PATH
							# This is the augmentation step - it increases assignments!
							# Primes (2) → Stars (1) = new assignments
							# Stars (1) → Unmarked (0) = remove old assignments
							#
							# Since path alternates and starts/ends with primes,
							# flipping converts: prime→star, star→unmarked, prime→star...
							# Result: We gain one assignment!
							#
							# Example:
							#   Before: path = [(1,0) prime, (2,0) star, (2,2) prime]
							#   After:  (1,0) becomes star (new!), (2,0) unmarked, (2,2) becomes star (new!)
							#   Result: Went from 1 assignment to 2 assignments!
							for r, c in path:
									mask[r][c] = 1 if mask[r][c] == 2 else 0

							# CLEAN UP: Reset everything for next iteration
							# Clear all row and column covers
							row_cover[:] = [False] * n
							col_cover[:] = [False] * n
							
							# Remove all remaining primes (they were temporary markers)
							for i in range(n):
									for j in range(n):
											if mask[i][j] == 2:
													mask[i][j] = 0

							# Re-cover columns with starred zeros (including new ones from flipping)
							# This updates our progress toward complete matching
							cover_starred_columns()
							
							# Exit inner loop - we found an augmenting path and updated matching
							break

					# Continue searching for more uncovered zeros
					# We might find multiple uncovered zeros in one iteration
					zero_pos = find_uncovered_zero()

			# -------------------------------------------------------
			# STEP 6: Adjust the matrix if no uncovered zero exists
			# -------------------------------------------------------
			# When no uncovered zeros exist, we need to create new zeros
			# We do this by adjusting the cost matrix while preserving optimality
			# However, if all columns are already covered, we have a complete matching
			# and should exit the loop (no need to adjust matrix)
			if zero_pos is None:
					# Check if all columns are covered - if so, we're done
					if sum(col_cover) == n:
							break  # Complete matching achieved, exit outer loop
					
					# Find the minimum value in uncovered cells
					# Only look at cells where row is uncovered AND column is uncovered
					# This is the smallest cost we can "transfer"
					uncovered_cells = [
							cost[i][j]
							for i in range(n) if not row_cover[i]
							for j in range(n) if not col_cover[j]
					]
					
					# If no uncovered cells exist (shouldn't happen if columns not all covered),
					# we can't proceed with adjustment
					if not uncovered_cells:
							break
					
					min_uncovered = min(uncovered_cells)

					# Adjust the matrix to create new zeros:
					# - Add min_uncovered to covered rows (makes them more expensive)
					# - Subtract min_uncovered from uncovered columns (makes them cheaper)
					# This creates new zeros in uncovered cells!
					#
					# Why this preserves optimality:
					# - We add the same value to all covered rows
					# - We subtract the same value from all uncovered columns
					# - The relative differences remain the same
					# - We're just "shifting" costs, not changing the optimal solution
					#
					# Example:
					#   Before: uncovered cell (1,1) = 3, min_uncovered = 3
					#   After:  (1,1) becomes 3 - 3 = 0 (new zero created!)
					for i in range(n):
							for j in range(n):
									if row_cover[i]:
											cost[i][j] += min_uncovered
									if not col_cover[j]:
											cost[i][j] -= min_uncovered

	# -------------------------------------------------------
	# STEP 7: Extract the final assignments
	# -------------------------------------------------------
	assignments = []
	for i in range(n_rows):
			for j in range(n_cols):
					if mask[i][j] == 1:
							assignments.append((i, j))

	return assignments