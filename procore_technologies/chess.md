How the Chess Class Works:

    •	Board Initialization: The initialize method sets up an 8x8 board and positions the pieces.
    •	Piece Movement: The move_piece method is responsible for moving a piece from one location to another if the move is valid.
    •	Turn Management: The switch_turns method alternates between white and black players.
    •	Piece Classes: ChessPiece is the base class for all pieces. Specific pieces like Pawn, Rook, etc., would inherit from ChessPiece
    and implement their specific movement rules.

Explanation of start_pos and end_pos

In this ChessGame class, start_pos and end_pos represent coordinates on the chessboard that define the movement of a piece:

    •	start_pos: An array [row, col] representing the piece’s current position on the board. The row and column are indices in the
    @board 2D array.
    •	end_pos: An array [row, col] representing the target position where the piece intends to move.

In the move_piece method, these two positions are used to access specific elements of the @board array, which contains instances
of chess pieces (Pawn, Rook, etc.) or nil if a square is empty.

Example:

    •	start_pos = [6, 0] and end_pos = [4, 0] could represent moving a white pawn from its starting position on row 6, column 0,
    to row 4, column 0.

Validating Movement for Other Chess Pieces

To add movement validation for other pieces, each piece class should implement its specific movement logic in its valid_move? method.
Here’s an example of how to do this for Rook, Bishop, and Knight:

Explanation of Each Piece’s valid_move? Method

    •	Straight Move: The pawn can move forward by one square (or two squares if it’s the pawn’s first move), but only if the square
    directly in front of it is empty.
    •	Diagonal Capture: The pawn can move one square diagonally left or right only if there’s an opponent’s piece on that diagonal
    square. This diagonal movement is not allowed if the square is empty; it’s exclusively for capturing.

So, the pawn’s movement rules are restrictive:

    •	It can only move diagonally when capturing.
    •	If there’s no target piece on the diagonal, it must move straight forward if the path is clear.
    •	Rook: Moves in straight lines, either horizontally or vertically. The valid_move? method first checks if either the row or
    column stays the same. Then, it checks if all squares between start_pos and end_pos are empty. The movement is valid if there’s
    a clear path in either direction.
    •	Bishop: Moves diagonally, so the row and column distances between the start and end positions must be equal. After confirming
    diagonal movement, the method checks each intermediate square along the path to ensure it’s empty. The direction of
    movement (up-left, up-right, down-left, down-right) is determined using row_direction and col_direction.
    •	Knight: Moves in an “L” shape, meaning two squares in one direction and one square in the perpendicular direction. It
    doesn’t require a clear path because it can jump over other pieces. The method validates movement by checking if the move is
    either two steps in one direction and one in the other or vice versa.
      => Knight = Horse => Moves in L Shaped direction

Adding More Pieces

Using similar logic, you can implement movement validation for the other pieces (Queen and King), adapting movement rules specific to
each piece:

    •	Queen: Combines the movement of both the Rook and Bishop, so it can move any number of squares in any direction (straight or diagonal).
    •	King: Can move only one square in any direction (straight or diagonal).

The capture move logic in the Pawn class is designed to handle the specific rule in chess where pawns can capture opponent pieces diagonally
in front of them. Here’s a breakdown of how it works:

Purpose of the Capture Move for PAWN:
In chess, pawns move forward one square, but they capture enemy pieces diagonally. The capture move in this method checks if there’s an
opponent’s piece on a square diagonally adjacent to the pawn’s current position and allows the pawn to move there if so.

How the Capture Move Works

The capture move logic is represented by this code:

if (end_pos[1] - start_pos[1]).abs == 1 && board[end_pos[0]][end_pos[1]]
return true if end_pos[0] == start_pos[0] + direction
end

Here’s what each part does:

    1.	(end_pos[1] - start_pos[1]).abs == 1:
    •	This checks if the column difference between start_pos and end_pos is exactly 1, indicating a diagonal move (left or right) relative
    to the pawn’s current position.
    •	abs is used to make sure the difference is exactly 1, regardless of whether it’s moving left (-1) or right (+1).
    2.	board[end_pos[0]][end_pos[1]]:
    •	This checks if there is any piece present at the end_pos square. If this is true, it means there’s a piece on that square.
    •	Since the pawn can only capture an opponent’s piece, the presence of a piece here is required for the move to be valid.
    3.	return true if end_pos[0] == start_pos[0] + direction:
    •	This part checks that the pawn is moving forward one row, which is defined by the direction variable.
    •	For a white pawn (direction = -1), this ensures it’s moving to a row one above (-1) its current row. For a black pawn (direction = +1),
    it checks that the pawn is moving down to the next row.

If all these conditions are met, the capture move is valid, and the method returns true, allowing the pawn to move diagonally to capture an
opponent’s piece. This capture move logic ensures that pawns can capture pieces according to the standard chess rules.
