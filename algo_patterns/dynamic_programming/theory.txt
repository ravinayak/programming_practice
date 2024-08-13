Dynamic Programming involves the following 3 requirements:
  1. Optimal Substructure:
        Given problem must be such that it can be broken down into smaller subproblems such
        that solution of smaller subproblems when combined together can solve given problem
    2. Overlapping subproblems:
        Nature of subproblems must be such that they are overlapping in nature meaning that
        we can reuse solution to a subproblem when it repeats itself. This allows us to
        solve the problem in less time using less space, since a number of subproblems which
        repeat themselves are already solved
    3. Recursion:
        This is simply for the sake of mentioning. Any problem which has the above 2 attributes
        of (1) and (2) can be solved through naive recursion technique

Dynamic programming problems can be solved through following 2 approaches:
    1. Recursion:
          Top Down Approach - Memoization
    2. Iterative:
          Bottom Up Approach - Tabulation

In every dynamic programming problem, we have to define some base cases where the problem is solved
This is critical because when we use recursion, at some point the problem must reduce to a problem
which has a solution (base case), then the recursion can move up from the base case and solve other
problems higher in the recursion stack (through Memoization). In Iterative approach, we start from
the base case and go higher up to the actual problem. Base case has solutions which is used to solve
the higher problems