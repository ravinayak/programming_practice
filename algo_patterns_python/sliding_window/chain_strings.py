from collections import defaultdict

def group_strings(strings):
  if not strings:
    return []

  groups = defaultdict(lambda: [])
  for s in strings:
   if s:
     groups[s[0] + s[-1]].append(s)
  
  print(f'Grouping by start and end char of strings :: {groups}')
  return groups

strings = ["apple", "axe", "eagle", "egg", "error", "cat", "cup"]
group_strings(strings)
  
def chain_strings(strings):
  if not strings:
    return [0, '']
  
  n = len(strings)
  
  def dfs(used_mask, last_char, memo):
    
    if used_mask in memo:
      return memo[used_mask]

    max_len = 0
    best_chain = []
    
    for i in range(n):
      if not (used_mask & (1 << i)):
        if last_char is None or strings[i][0] == last_char:
          new_mask = used_mask | (1 << i)
          remaining_length, remaining_chain = dfs(new_mask, strings[i][-1], memo)
          
          new_length = len(strings[i]) + remaining_length
          if new_length > max_len:
            max_len = new_length
            best_chain = [strings[i]] + remaining_chain
            
    memo[used_mask] = (max_len, best_chain)
    return (max_len, best_chain)
  
  
  best_overall_len = 0
  best_overall_chain = []

  for start_idx in range(n):
    used_mask = 1 << start_idx
    max_len, chain = dfs(used_mask, strings[start_idx][-1], {})
    
    if max_len > best_overall_len:
      best_overall_len = max_len
      best_overall_chain = [strings[start_idx]] + chain
      
  return [best_overall_len, ''.join(best_overall_chain)] if best_overall_len else [0, '']
    
# Test cases
test_cases = [
    ["abc", "cde", "efg", "bcd"],
    ["abc", "cde", "efg", "bcd", "ghi"],
    ["hello", "world", "dog", "goat", "tiger"],
    ["a", "ab", "bc", "cd"],
    ["abc", "def", "ghi"],  # No valid chain
    ["abc", "cba", "abc"],  # Cycle possible
]

for i, test in enumerate(test_cases, 1):
    print(f"\nTest {i}: {test}")
    dp_result = chain_strings(test)
    
    print(f"\n Output :: {dp_result}")