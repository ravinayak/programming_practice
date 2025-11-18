from typing import List

def coin_change(coins: List[int], target_amount: int):
    dp = [target_amount + 1 for x in range(target_amount + 1)]
    dp[0] = 0
    result = []
    parent = {}
    for denomination in range(1, target_amount + 1):
        for coin in coins:
            if coin > denomination:
                continue
            if dp[denomination] > dp[denomination - coin] + 1:
                dp[denomination] = dp[denomination - coin] + 1
                parent[denomination] = coin
                
    if dp[target_amount] == target_amount + 1:
        return [0, []]
    
    amount = target_amount
    while(amount != 0):
        result.append(parent[amount])
        amount -= parent[amount]
    
    print(f'Minimum Number of Coins :: {len(result)}, Coins :: {result}')

coin_change([5, 1, 3, 9], 11)