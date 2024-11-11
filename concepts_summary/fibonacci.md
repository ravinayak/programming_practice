fibonacci:

1. Base Case:
   - fib(0) = 0
   - fib(1) = 1
   - F(n) = F(n-1) + F(n-2)
2. Recursive:
   Use Memoization to cut down recursive calls and gain O(n) Time complexity
   mem[n] = fib_rec(n: n-1, mem:) + fib_rec(n: n-2, mem:)
   mem in earlier call = { 0 => 0, 1 => 1}
