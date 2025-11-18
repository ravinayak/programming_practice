
def n_queens(n: int):
  board = [["." * n] for i in range(n)]

  col = set()
  pos_diagonal = set()
  neg_diagonal = set()
  res = []
  
  def backtrack(r: int):
    if r == n:
      copy = ["".join(row) for row in board]
      res.append(copy)
      return
    
    for c in range(n):
      if c in col or (r+c) in pos_diagonal or (r-c) in neg_diagonal:
        continue
      
      col.add(c)
      pos_diagonal.add(r + c)
      neg_diagonal.add(r - c)
      board[r][c] = 'Q'

      backtrack(r+1)
      
      col.remove(c)
      pos_diagonal.remove(r + c)
      neg_diagonal.remove(r - c)
      board[r][c] = '.'
      
  backtrack(0)

  return res
      
  