def chain_strings_dp(strings):
    """
    Dynamic programming solution to find the longest chain of strings
    where each string starts with the last character of the previous string.
    Tries all possible starting strings and uses DP to find optimal solution.
    """
    if not strings:
        return ''
    
    n = len(strings)
    
    def dfs(used_mask, last_char, memo):
        """
        DFS with memoization to find longest chain
        used_mask: bitmask representing which strings have been used
        last_char: last character of current chain
        memo: memoization dictionary
        """
        if used_mask in memo:
            return memo[used_mask]
        
        max_length = 0
        best_chain = []
        
        # Try each unused string
        for i in range(n):
            if not (used_mask & (1 << i)):  # String i not used yet
                if last_char is None or strings[i][0] == last_char:
                    # Use this string
                    new_mask = used_mask | (1 << i)
                    remaining_length, remaining_chain = dfs(new_mask, strings[i][-1], memo)
                    
                    current_length = len(strings[i]) + remaining_length
                    if current_length > max_length:
                        max_length = current_length
                        best_chain = [strings[i]] + remaining_chain
        
        memo[used_mask] = (max_length, best_chain)
        return max_length, best_chain
    
    # Try all possible starting strings
    best_overall_length = 0
    best_overall_chain = []
    
    for start_idx in range(n):
        used_mask = 1 << start_idx
        length, chain = dfs(used_mask, strings[start_idx][-1], {})
        if length > best_overall_length:
            best_overall_length = length
            best_overall_chain = [strings[start_idx]] + chain
    
    return ''.join(best_overall_chain) if best_overall_chain else ''


def chain_strings_greedy(strings):
    """
    Original greedy approach for comparison
    """
    if not strings: 
        return ''
    used = [False] * len(strings)
    result = [strings[0]]
    used[0] = True
    while True:
        last = result[-1][-1]
        found = False
        for i, s in enumerate(strings):
            if not used[i] and s[0] == last:
                result.append(s)
                used[i] = True
                found = True
                break
        if not found:
            break
    return ''.join(result)


# Test cases
test_cases = [
    ["abc", "cde", "efg", "bcd"],
    ["abc", "cde", "efg", "bcd", "ghi"],
    ["hello", "world", "dog", "goat", "tiger"],
    ["a", "ab", "bc", "cd"],
    ["abc", "def", "ghi"],  # No valid chain
    ["abc", "cba", "abc"],  # Cycle possible
]

print("Testing Chain Strings Solutions:")
print("=" * 50)

for i, test in enumerate(test_cases, 1):
    print(f"\nTest {i}: {test}")
    greedy_result = chain_strings_greedy(test)
    dp_result = chain_strings_dp(test)
    
    print(f"Greedy: '{greedy_result}' (length: {len(greedy_result)})")
    print(f"DP:     '{dp_result}' (length: {len(dp_result)})")
    
    if len(dp_result) > len(greedy_result):
        print("✓ DP found a longer chain!")
    elif len(dp_result) == len(greedy_result):
        print("= Same length")
    else:
        print("? Unexpected: Greedy found longer chain")
