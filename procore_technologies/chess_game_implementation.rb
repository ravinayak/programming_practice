# Specific Errors
class MoveNotValidError < StandardError; end
class PlayerInvalidColorChoiceError < StandardError; end
class MethodNotImplementedError < StandardError; end
class NoMoreValidMoveError < StandardError; end

ALLOWED_COLORS = %i[white black].freeze

# Player class
class Player
  attr_accessor :name, :user_id, :color

  # Class methods
  class << self
    def used_colors
      @used_colors ||= []
    end

    def add_used_colors(color:)
      @used_colors ||= []
      @used_colors << color
    end

    def reset_used_colors
      @used_colors = []
    end
  end

  def initialize(name:, user_id:, color:)
    @name = name
    @user_id = user_id
    if ALLOWED_COLORS.include?(color) && !self.class.used_colors.include?(color)
      @color = color
      self.class.add_used_colors(color:)
    else
      raise PlayerInvalidColorChoiceError, 'Invalid Player color choice, pick another color from [:white, :black]'
    end
  end
end

# Chess Game Implementation
class ChessGameImplementation
  MAX_MOVES = 1000

  attr_accessor :board, :current_turn, :players

  def initialize
    @board = Array.new(8) { Array.new(8) }
    @players = setup_players
    @current_turn = :white
    setup_board
  end

  def play_game
    moves_count = 0

    while moves_count < MAX_MOVES
      current_player = players[current_turn]
      puts "#{current_player.name} is about to make a move"
      move = generate_random_move(player: current_player)

      if move
        piece, start_pos, end_pos = move.values_at(:piece, :start_pos, :end_pos)
        start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)
        puts "#{current_player.name} has moved #{piece.class} from #{[start_row, start_col]} to #{[end_row, end_col]}"
        move_piece(start_pos:, end_pos:, player: current_player)
      else
        begin
          raise NoMoreValidMoveError, "#{current_player.name} has no more valid moves left"
        rescue NoMoreValidMoveError => e
          puts e.message
          winner_color = current_turn == :white ? :black : :white
          winner = players[winner_color]
          announce_winner(winner:)
          return
        end
      end
      moves_count += 1
    end

    puts 'Game has ended, Could not find any winner because Moves has crossed Maximum Moves'
  end

  private

  def generate_random_move(player:)
    possible_moves = []

    8.times do |start_row|
      8.times do |start_col|
        piece = board[start_row][start_col]
        next unless piece && piece.color == player.color

        8.times do |end_row|
          8.times do |end_col|
            start_pos = [start_row, start_col]
            end_pos = [end_row, end_col]

            next if start_pos == end_pos
            next unless valid_move?(start_pos:, end_pos:, piece:)

            possible_moves << {
              start_pos:,
              end_pos:,
              piece:
            }
          end
        end
      end
    end
    # Returns a random move from the array of possible moves
    # If array is empty, returns nil
    possible_moves.sample
  end

  def announce_winner(winner:)
    puts "Game has ended, Player :: #{winner.name} has won the game"
  end

  def setup_players
    player_one = Player.new(name: 'Automatic Player 1', user_id: 1, color: :white)
    player_two = Player.new(name: 'Automatic Player 2', user_id: 2, color: :black)
    {
      white: player_one,
      black: player_two
    }
  end

  def setup_board
    @board[0] = [
      Rook.new(:black), Knight.new(:black), Bishop.new(:black), Queen.new(:black), King.new(:black),
      Bishop.new(:black), Knight.new(:black), Rook.new(:black)
    ]
    @board[7] = [
      Rook.new(:white), Knight.new(:white), Bishop.new(:white), Queen.new(:white), King.new(:white),
      Bishop.new(:white), Knight.new(:white), Rook.new(:white)
    ]
    8.times do |i|
      @board[1][i] = Pawn.new(:black)
      @board[6][i] = Pawn.new(:white)
    end

    (2..5).each do |i|
      8.times do |j|
        @board[i][j] = nil
      end
    end
  end

  def move_piece(start_pos:, end_pos:, player:)
    raise MoveNotValidError, 'Player is not allowed to make move' if player.color != current_turn

    start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)

    raise MoveNotValidError, 'Start or End position is out of Bounds' if out_of_range_bounds(start_row:, start_col:,
                                                                                             end_row:, end_col:)

    piece = board[start_row][start_col]

    if valid_move?(start_pos:, end_pos:, piece:)
      captured_piece = @board[end_row][end_col]
      @board[start_row][start_col] = nil
      @board[end_row][end_col] = piece

      if captured_piece.is_a?(King)
        winner = players[current_turn]
        announce_winner(winner:)
        return
      end
      switch_turns
    else
      raise MoveNotValidError, 'Player is not allowed to make move'
    end
  end

  def out_of_range_bounds(start_row:, start_col:, end_row:, end_col:)
    start_row.negative? || start_row > 7 || start_col.negative? || start_col > 7 || end_row.negative? ||
      end_row > 7 || end_col.negative? || end_col > 7
  end

  def switch_turns
    @current_turn = current_turn == :white ? :black : :white
  end

  def valid_move?(start_pos:, end_pos:, piece:)
    return unless piece

    return unless piece.color == current_turn

    # Get the piece at the destination (if any)
    end_row, end_col = end_pos
    destination_piece = board[end_row][end_col]

    # Can't capture your own piece
    return false if destination_piece && destination_piece.color == piece.color

    piece.valid_move?(start_pos:, end_pos:, board:)
  end

  def start_end_row_col(start_pos:, end_pos:)
    start_row, start_col = start_pos
    end_row, end_col = end_pos
    [start_row, start_col, end_row, end_col]
  end
end

# Chess Piece Implementation
class ChessPiece
  attr_accessor :color

  def initialize(color)
    @color = color
  end

  def valid_move?(start_pos:, end_pos:, board:) # rubocop:disable Lint/UnusedMethodArgument
    raise MethodNotImplementedError, 'Method has not been implemented in subclass'
  end

  def valid_horizontal_move?(start_pos:, end_pos:, board:)
    start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)

    return false unless start_row == end_row

    col_range = [start_col, end_col].sort
    (col_range[0] + 1...col_range[1]).all? { |col| board[start_row][col].nil? }
  end

  def valid_vertical_move?(start_pos:, end_pos:, board:)
    start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)

    return false unless start_col == end_col

    row_range = [start_row, end_row].sort
    (row_range[0] + 1...row_range[1]).all? { |row| board[row][start_col].nil? }
  end

  def valid_diagonal_move?(start_pos:, end_pos:, board:)
    start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)

    row_diff = (end_row - start_row).abs
    col_diff = (end_col - start_col).abs

    return false unless row_diff == col_diff

    row_dir = end_row > start_row ? +1 : -1
    col_dir = end_col > start_col ? +1 : -1

    (1...row_diff).all? do |i|
      board[start_row + i * row_dir][start_col + i * col_dir].nil?
    end
  end

  def valid_pawn_move?(start_pos:, end_pos:, board:)
    start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)

    direction = color == :white ? -1 : +1
    if board[end_row][end_col].nil? && start_col == end_col
      return true if end_row == start_row + direction
      if (start_row == 1 && end_row == 3 && board[2][start_col].nil?) || (start_row == 6 && end_row == 4 && board[5][start_col].nil?)
        return true
      end
    end

    return true if !board[end_row][end_col].nil? && board[end_row][end_col].color != color &&
                   (end_col - start_col).abs == 1 && end_row == start_row + direction

    false
  end

  def valid_knight_move?(start_pos:, end_pos:, board:) # rubocop:disable Lint/UnusedMethodArgument
    start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)

    row_diff = (end_row - start_row).abs
    col_diff = (end_col - start_col).abs

    (col_diff == 2 && row_diff == 1) || (col_diff == 1 && row_diff == 2)
  end

  def valid_king_move?(start_pos:, end_pos:, board:) # rubocop:disable Lint/UnusedMethodArgument
    start_row, start_col, end_row, end_col = start_end_row_col(start_pos:, end_pos:)

    row_diff = (end_row - start_row).abs
    col_diff = (end_col - start_col).abs

    (row_diff <= 1 && col_diff <= 1) && !(col_diff.zero? && row_diff.zero?)
  end

  private

  def start_end_row_col(start_pos:, end_pos:)
    start_row, start_col = start_pos
    end_row, end_col = end_pos

    [start_row, start_col, end_row, end_col]
  end
end

# Rook class
class Rook < ChessPiece
  def valid_move?(start_pos:, end_pos:, board:)
    valid_horizontal_move?(start_pos:, end_pos:, board:) || valid_vertical_move?(start_pos:, end_pos:, board:)
  end
end

# Knight class
class Knight < ChessPiece
  def valid_move?(start_pos:, end_pos:, board:)
    valid_knight_move?(start_pos:, end_pos:, board:)
  end
end

# Bishop class
class Bishop < ChessPiece
  def valid_move?(start_pos:, end_pos:, board:)
    valid_diagonal_move?(start_pos:, end_pos:, board:)
  end
end

# Queen class
class Queen < ChessPiece
  def valid_move?(start_pos:, end_pos:, board:)
    valid_horizontal_move?(start_pos:, end_pos:, board:) || valid_vertical_move?(start_pos:, end_pos:, board:) ||
      valid_diagonal_move?(start_pos:, end_pos:, board:)
  end
end

# King class
class King < ChessPiece
  def valid_move?(start_pos:, end_pos:, board:)
    valid_king_move?(start_pos:, end_pos:, board:)
  end
end

# Pawn class
class Pawn < ChessPiece
  def valid_move?(start_pos:, end_pos:, board:)
    valid_pawn_move?(start_pos:, end_pos:, board:)
  end
end

def test
  game = ChessGameImplementation.new
  game.play_game
end

test
