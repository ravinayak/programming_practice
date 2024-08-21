**Roman numerals are represented by seven different symbols: I, V, X, L, C, D and M.**

**Symbol Value**
I 1
V 5
X 10
L 50
C 100
D 500
M 1000

_For example,_
a. 2 is written as II in Roman numeral, just two ones added together.
b. 12 is written as XII, which is simply X + II.
c. The number 27 is written as XXVII, which is XX + V + II.

a. Roman numerals are usually written largest to smallest from left to right.
b. However, the numeral for four is not IIII. Instead, the number four is written as IV.
c. Because the one is before the five we subtract it making four. The same principle
applies to the number nine, which is written as IX.

**There are six instances where subtraction is used:**

a. I can be placed before V (5) and X (10) to make 4 and 9.
b. X can be placed before L (50) and C (100) to make 40 and 90.
c. C can be placed before D (500) and M (1000) to make 400 and 900.

**Invalid Combinations:**
a. A numeral cannot have multiple smaller numerals before a larger numeral if they are not
valid subtractive pairs.
b. The smaller numeral that is subtracted must immediately precede the larger numeral, and
the subtraction must result in one of the valid pairs.

**Why "XCD" is Invalid:**
a. Position of X and C:
b. In "XCD," X (10) precedes C (100) and D (500). According to the rules, X can only
precede L (50) or C (100) to form valid subtractive combinations like XL (40) or XC (90).
c. However, in "XCD," X does not immediately precede L or C. Instead, it precedes C, which is
followed by D, making the sequence invalid because X cannot be placed before C in this context
unless forming a valid pair like "XC".

**No Double Subtraction:**
The sequence "XCD" suggests a double subtraction (X before C, and C before D), which is not allowed.
Subtraction is only allowed with a single smaller numeral before a larger numeral, and it must be
part of the specific valid pairs mentioned above.

**Given a roman numeral, convert it to an integer.**

_Example 1:_

Input: s = "III"
Output: 3
Explanation: III = 3.

_Example 2:_

Input: s = "LVIII"
Output: 58
Explanation: L = 50, V= 5, III = 3.

_Example 3:_

Input: s = "MCMXCIV"
Output: 1994
Explanation: M = 1000, CM = 900, XC = 90 and IV = 4.

Constraints:

1 <= s.length <= 15
s contains only the characters ('I', 'V', 'X', 'L', 'C', 'D', 'M').
It is guaranteed that s is a valid roman numeral in the range [1, 3999].
