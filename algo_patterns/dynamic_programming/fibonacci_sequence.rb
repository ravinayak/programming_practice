# frozen_string_literal: true

# Implement Fibonacci Sequence
# f(0) = 0, f(1) = 1 => Base Cases
# Every other fibonacci number is obtained as the sum of previous 2 fibonacci numbers
# f(5) = f(4) + f(3)

# @param [Integer] nth_fib
# @return [Integer]
#
def calc_rec_fib(nth_fib:)
  fib_rec(nth_fib:, mem: { 0 => 0, 1 => 1 })
end

# Calculates fibonacci sequence for nth fibonacci number recursively
# @param [Integer] nth_fib
# @param [Hash] mem
# @return [Integer] res
#		Time complexity: O(n), since every fibonacci number is evaluated only once, and is memoized for future reference
# 	Space complexity: O(n), since we have to store fibonacci sequence for n-1 numbers in Hash
#
def fib_rec(nth_fib:, mem:)
  return mem[nth_fib] if mem[nth_fib]

  mem[nth_fib] = fib_rec(nth_fib: nth_fib - 1, mem:) + fib_rec(nth_fib: nth_fib - 2, mem:)

  # This is not necessary in Ruby because the value of assignment operation on right hand side is returned by default
  # Returning this explicityly for more clarity, also in other languages, the above statement may not be true
  mem[nth_fib]
end

# Calculates fibonacci sequence for nth fibonacci number non-recursively
# @param [Integer] nth_fib
# @return [Integer]
#		Time complexity: O(n), since every fibonacci number is evaluated only once, and is memoized for future reference
# 	Space complexity: O(1), since we have use only two variables to store current and previous fibonacci sequence
#
def fib_non_rec(nth_fib:)
  return 0 if nth_fib.zero?

  return 1 if nth_fib == 1

  start_fib_seq = 2
  fib_curr = 1
  fib_prev = 0

  while start_fib_seq <= nth_fib
    fib_temp = fib_curr + fib_prev
    fib_prev = fib_curr
    fib_curr = fib_temp
    start_fib_seq += 1
  end

  fib_curr
end

str = 'Fibonacci sequence is evaluated recursively and non-recursively => '
puts "#{str} Rec :: #{calc_rec_fib(nth_fib: 35)}, Non-Rec :: #{fib_non_rec(nth_fib: 35)}"
puts "#{str} Rec :: #{calc_rec_fib(nth_fib: 115)}, Non-Rec :: #{fib_non_rec(nth_fib: 115)}"
puts "#{str} Rec :: #{calc_rec_fib(nth_fib: 8)}, Non-Rec :: #{fib_non_rec(nth_fib: 8)}"
puts "#{str} Rec :: #{calc_rec_fib(nth_fib: 15)}, Non-Rec :: #{fib_non_rec(nth_fib: 15)}"
puts "#{str} Rec :: #{calc_rec_fib(nth_fib: 1)}, Non-Rec :: #{fib_non_rec(nth_fib: 1)}"
puts "#{str} Rec :: #{calc_rec_fib(nth_fib: 2)}, Non-Rec :: #{fib_non_rec(nth_fib: 2)}"
