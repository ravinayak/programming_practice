from typing import List
from math import inf

def minSubArr(nums: List[int], target: int) -> List[int]:
  left = 0
  total = 0
  min_len = inf
  for right in range(len(nums)):
    total += nums[right]
    
    while total >= target:
      if (right - left + 1) < min_len:
        min_len = right - left + 1
        best_pair = (left, right)
      
      total -= nums[left]
      left += 1
      
  
  return [best_pair, min_len]

def main():
  input_output = [
    {
    'nums': [2, 3, 1, 2, 4, 2],
    'target': 7,
    'output': [(2, 4), 3]
    },
    {
      'nums': [1, 4, 4],
      'target': 4,
      'output': [(1, 1), 1]
    }
  ]
  
  for item in input_output:
    output = minSubArr(target = item['target'], nums = item['nums'])
    print('************************************************************************************')
    print(f'Input => Target :: {item['target']}, Nums :: {item['nums']}')
    print(f'Expected Output List:: {str(item['output'][0]):<4}, Actual Output List :: {output[0]}')
    print(f'Expected Min Length :: {item['output'][1]}, Actual Min Length :: {output[1]}')
    print('************************************************************************************')
    
main()
    
  
       
  