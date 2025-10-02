from typing import List

def coin_change(coins: List[int], target_amount: int) -> List[int]:
    dp = [target_amount + 1] * (target_amount + 1)
    dp[0] = 0
    parent = [-1] * (target_amount + 1)
    
    for amt in range(1, target_amount + 1):
        for coin in coins:
            if amt - coin >= 0 and dp[amt - coin] + 1 < dp[amt]:
                dp[amt] = dp[amt - coin] + 1
                parent[amt] = coin
                
    if dp[target_amount] == target_amount + 1:
        return [[], 0]
    
    amt = target_amount
    res = []
    while amt > 0:
        res.append(parent[amt])
        amt -= parent[amt]
        
    return [res, dp[target_amount]]

print(coin_change([5, 1, 3, 9], 11))