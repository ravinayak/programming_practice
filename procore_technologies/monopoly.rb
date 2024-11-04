# Monopoly Game Implementation
#
# This is a Ruby implementation of the classic Monopoly board game. The game follows standard
# Monopoly rules including:
# - Players start with $1500
# - Players collect $200 when passing GO
# - Properties can be bought, mortgaged, and improved with houses/hotels
# - Players can be sent to jail and must pay or roll doubles to get out
# - Game ends when all but one player go bankrupt
#
# Key Classes:
# - MonopolyGame: Main game controller that handles turns and game flow
# - Player: Represents a player with money, properties, and position
# - Board: Contains the game board layout and spaces
# - Property: Represents properties that can be bought and improved
# - Railroad: Special property type with rent based on number owned
# - Utility: Special property type with rent based on dice roll
# - ChanceCards/CommunityChestCards: Card systems for special actions
#
# Usage:
#   game = MonopolyGame.new(['Player 1', 'Player 2'])
#   game.play_game

# Constants for the game
class MonopolyGame
  STARTING_MONEY = 1500
  SALARY = 200 # Passing GO amount
  MAX_HOUSES = 4
  MAX_HOTELS = 1
  JAIL_POSITION = 10
  GO_POSITION = 0

  # Initializes a new Monopoly game with the given player names
  # @param player_names [Array<String>] List of player names to create
  def initialize(player_names)
    @players = player_names.map { |name| Player.new(name) }
    @board = Board.new
    @current_player_index = 0
    @dice_doubles_count = 0
    @chance_cards = ChanceCards.create_deck.shuffle
    @community_chest_cards = CommunityChestCards.create_deck.shuffle
    @game_over = false
  end

  # Main game loop that continues until only one player remains
  def play_game
    until @game_over
      current_player = @players[@current_player_index]
      take_turn(current_player)
      check_bankruptcy(current_player)
      next_player unless @dice_doubles_count > 0
    end

    announce_winner
  end

  # Handles a single player's turn including dice rolls and movement
  # @param player [Player] The player whose turn it is
  def take_turn(player)
    if player.in_jail?
      handle_jail_turn(player)
      return
    end

    doubles_roll = true
    while doubles_roll && @dice_doubles_count < 3
      dice1, dice2 = roll_dice
      total = dice1 + dice2
      doubles_roll = (dice1 == dice2)

      if doubles_roll
        @dice_doubles_count += 1
        if @dice_doubles_count == 3
          go_to_jail(player)
          return
        end
      else
        @dice_doubles_count = 0
      end

      move_player(player, total)
      handle_space(player, total)
    end
  end

  private

  # Simulates rolling two six-sided dice
  # @return [Array<Integer>] Array containing the two dice values
  def roll_dice
    [rand(1..6), rand(1..6)]
  end

  # Moves a player the given number of spaces and handles passing GO
  # @param player [Player] The player to move
  # @param spaces [Integer] Number of spaces to move
  def move_player(player, spaces)
    old_position = player.position
    # Calculate the new position by adding the dice roll (spaces) to current position
    # Use modulo (@board.spaces.size) to wrap around to beginning when passing GO
    # For example: If current position is 38 and roll 6, (38 + 6) % 40 = 4
    # @board.spaces is an array of all spaces on the Monopoly board (40 total)
    # Add dice roll to current position and use modulo to wrap around board
    # Example: Position 38 + roll of 6 = 44, then 44 % 40 = 4 (wraps to position 4)
    new_position = (player.position + spaces) % @board.spaces.size

    # Pass GO
    if new_position < old_position && old_position != JAIL_POSITION
      player.update_money(SALARY)
      puts "#{player.name} passes GO and collects $#{SALARY}!"
    end

    player.position = new_position
    puts "#{player.name} landed on #{@board.spaces[new_position].name}"
  end

  # Executes the action for the space the player landed on
  # @param player [Player] The player who landed on the space
  # @param dice_roll [Integer] The total of the dice roll
  def handle_space(player, dice_roll)
    space = @board.spaces[player.position]
    space.action(player, self, dice_roll)
  end

  # Handles a player's turn while they are in jail
  # @param player [Player] The jailed player
  def handle_jail_turn(player)
    player.jail_turns += 1

    if player.get_out_of_jail_cards > 0
      use_jail_card(player)
      return
    end

    if player.jail_turns >= 3
      if player.money >= 50
        player.update_money(-50)
        release_from_jail(player)
      else
        force_bankruptcy(player)
      end
    else
      dice1, dice2 = roll_dice
      if dice1 == dice2
        release_from_jail(player)
        move_player(player, dice1 + dice2)
        handle_space(player, dice1 + dice2)
      end
    end
  end

  # Sends a player to jail
  # @param player [Player] The player to jail
  def go_to_jail(player)
    player.position = JAIL_POSITION
    player.in_jail = true
    player.jail_turns = 0
    puts "#{player.name} goes to Jail!"
  end

  # Releases a player from jail
  # @param player [Player] The player to release
  def release_from_jail(player)
    player.in_jail = false
    player.jail_turns = 0
    puts "#{player.name} is released from Jail!"
  end

  # Uses a Get Out of Jail Free card
  # @param player [Player] The player using the card
  def use_jail_card(player)
    player.use_get_out_of_jail_card
    release_from_jail(player)
  end

  # Advances to the next player's turn
  def next_player
    @current_player_index = (@current_player_index + 1) % @players.size
  end

  # Checks if a player is bankrupt and handles accordingly
  # @param player [Player] The player to check
  def check_bankruptcy(player)
    if player.money < 0
      if can_raise_money?(player)
        handle_negative_balance(player)
      else
        force_bankruptcy(player)
      end
    end
  end

  # Determines if a player can raise enough money to cover debts
  # @param player [Player] The player to check
  # @return [Boolean] True if player can raise enough money
  def can_raise_money?(player)
    total_assets = player.properties.sum { |prop| prop.mortgage_value }
    total_assets + player.money >= 0
  end

  # Handles a player's negative balance by mortgaging properties
  # @param player [Player] The player with negative balance
  # Handles a player's negative balance by mortgaging properties or selling improvements
  # This method tries to raise money when a player has negative balance by:
  # 1. Finding the property with highest mortgage value using max_by
  #    (max_by returns the element that gives the highest value when passed to the block)
  # 2. For that property:
  #    - If already mortgaged, sells its improvements (houses/hotels)
  #    - If not mortgaged, mortgages it
  # 3. Repeats until player has positive money or no properties left
  # @param player [Player] The player with negative balance
  def handle_negative_balance(player)
    while player.money < 0
      # Find property with highest mortgage value using max_by
      # max_by(&:mortgage_value) is shorthand for { |prop| prop.mortgage_value }
      property = player.properties.max_by(&:mortgage_value)
      break unless property

      if property.mortgaged
        property.sell_improvements
      else
        property.mortgage
      end
    end
  end

  # Forces a player into bankruptcy, removing them from the game
  # @param player [Player] The player going bankrupt
  def force_bankruptcy(player)
    puts "#{player.name} is bankrupt!"
    player.properties.each do |property|
      property.owner = nil
      property.unmortgage
      property.reset_improvements
    end
    @players.delete(player)

    @game_over = true if @players.size == 1
  end

  # Announces the winner of the game
  def announce_winner
    winner = @players.max_by { |p| p.total_worth }
    puts "\nGame Over!"
    puts "#{winner.name} wins with a total worth of $#{winner.total_worth}!"
  end
end

# Enhanced Player class
class Player
  attr_accessor :name, :money, :position, :properties, :in_jail, :jail_turns, :get_out_of_jail_cards

  # Creates a new player with starting money and position
  # @param name [String] The player's name
  def initialize(name)
    @name = name
    @money = MonopolyGame::STARTING_MONEY
    @position = 0
    @properties = []
    @in_jail = false
    @jail_turns = 0
    @get_out_of_jail_cards = 0
  end

  # Checks if player is currently in jail
  # @return [Boolean] True if player is in jail
  def in_jail?
    @in_jail
  end

  # Adds a Get Out of Jail Free card to the player
  def add_get_out_of_jail_card
    @get_out_of_jail_cards += 1
  end

  # Uses a Get Out of Jail Free card if available
  def use_get_out_of_jail_card
    @get_out_of_jail_cards -= 1 if @get_out_of_jail_cards > 0
  end

  # Updates the player's money and prints the transaction
  # @param amount [Integer] Amount to add (positive) or subtract (negative)
  def update_money(amount)
    @money += amount
    puts "#{@name} #{amount >= 0 ? 'receives' : 'pays'} $#{amount.abs}"
  end

  # Calculates player's total worth including properties
  # @return [Integer] Total worth in dollars
  def total_worth
    @money + properties.sum { |p| p.total_value }
  end

  # Checks if player owns all properties of a color group
  # @param color_group [String] The color group to check
  # @return [Boolean] True if player owns all properties in group
  def owns_all_of_color?(color_group)
    return false if color_group.nil?

    owned_in_group = properties.count { |p| p.color_group == color_group }
    total_in_group = Board::PROPERTY_GROUPS[color_group]
    owned_in_group == total_in_group
  end
end

# Enhanced Board class
class Board
  attr_reader :spaces

  PROPERTY_GROUPS = {
    'Brown' => 2,
    'Light Blue' => 3,
    'Pink' => 3,
    'Orange' => 3,
    'Red' => 3,
    'Yellow' => 3,
    'Green' => 3,
    'Dark Blue' => 2
  }.freeze

  # Creates a new game board with all spaces
  def initialize
    setup_spaces
  end

  # Sets up all spaces on the board in correct order
  def setup_spaces
    @spaces = [
      # Start with GO space
      BoardSpace.new('GO'),

      # Brown properties (Mediterranean & Baltic)
      Property.new('Mediterranean Avenue', 60, 'Brown', [2, 10, 30, 90, 160, 250]),
      CommunityChest.new('Community Chest'),
      Property.new('Baltic Avenue', 60, 'Brown', [4, 20, 60, 180, 320, 450]),

      # First tax and railroad
      Tax.new('Income Tax', 200),
      Railroad.new('Reading Railroad', 200),

      # Light Blue properties
      Property.new('Oriental Avenue', 100, 'Light Blue', [6, 30, 90, 270, 400, 550]),
      Chance.new('Chance'),
      Property.new('Vermont Avenue', 100, 'Light Blue', [6, 30, 90, 270, 400, 550]),
      Property.new('Connecticut Avenue', 120, 'Light Blue', [8, 40, 100, 300, 450, 600]),

      # Jail space
      BoardSpace.new('Jail'),

      # Pink properties with Electric Company
      Property.new('St. Charles Place', 140, 'Pink', [10, 50, 150, 450, 625, 750]),
      Utility.new('Electric Company', 150),
      Property.new('States Avenue', 140, 'Pink', [10, 50, 150, 450, 625, 750]),
      Property.new('Virginia Avenue', 160, 'Pink', [12, 60, 180, 500, 700, 900]),

      # Second railroad and Orange properties
      Railroad.new('Pennsylvania Railroad', 200),
      Property.new('St. James Place', 180, 'Orange', [14, 70, 200, 550, 750, 950]),
      CommunityChest.new('Community Chest'),
      Property.new('Tennessee Avenue', 180, 'Orange', [14, 70, 200, 550, 750, 950]),
      Property.new('New York Avenue', 200, 'Orange', [16, 80, 220, 600, 800, 1000]),

      # Free Parking and Red properties
      BoardSpace.new('Free Parking'),
      Property.new('Kentucky Avenue', 220, 'Red', [18, 90, 250, 700, 875, 1050]),
      Chance.new('Chance'),
      Property.new('Indiana Avenue', 220, 'Red', [18, 90, 250, 700, 875, 1050]),
      Property.new('Illinois Avenue', 240, 'Red', [20, 100, 300, 750, 925, 1100]),

      # Third railroad and Yellow properties with Water Works
      Railroad.new('B&O Railroad', 200),
      Property.new('Atlantic Avenue', 260, 'Yellow', [22, 110, 330, 800, 975, 1150]),
      Property.new('Ventnor Avenue', 260, 'Yellow', [22, 110, 330, 800, 975, 1150]),
      Utility.new('Water Works', 150),
      Property.new('Marvin Gardens', 280, 'Yellow', [24, 120, 360, 850, 1025, 1200]),

      # Go To Jail and Green properties
      BoardSpace.new('Go To Jail'),
      Property.new('Pacific Avenue', 300, 'Green', [26, 130, 390, 900, 1100, 1275]),
      Property.new('North Carolina Avenue', 300, 'Green', [26, 130, 390, 900, 1100, 1275]),
      CommunityChest.new('Community Chest'),
      Property.new('Pennsylvania Avenue', 320, 'Green', [28, 150, 450, 1000, 1200, 1400]),

      # Final railroad, Dark Blue properties and Luxury Tax
      Railroad.new('Short Line', 200),
      Chance.new('Chance'),
      Property.new('Park Place', 350, 'Dark Blue', [35, 175, 500, 1100, 1300, 1500]),
      Tax.new('Luxury Tax', 100),
      Property.new('Boardwalk', 400, 'Dark Blue', [50, 200, 600, 1400, 1700, 2000])
    ]
  end
end

# Base Space class
class BoardSpace
  attr_reader :name

  # Creates a new board space
  # @param name [String] The name of the space
  def initialize(name)
    @name = name
  end

  # Executes the action for landing on this space
  # @param player [Player] The player who landed here
  # @param game [MonopolyGame] The current game instance
  # @param dice_roll [Integer] The dice roll that got here
  def action(player, game, dice_roll)
    # Default implementation does nothing
  end
end

# Enhanced Property class
class Property < BoardSpace
  attr_accessor :price, :rent_levels, :houses, :hotel, :color_group, :owner, :mortgaged

  HOUSE_COST = {
    'Brown' => 50,
    'Light Blue' => 50,
    'Pink' => 100,
    'Orange' => 100,
    'Red' => 150,
    'Yellow' => 150,
    'Green' => 200,
    'Dark Blue' => 200
  }.freeze

  # Creates a new property
  # @param name [String] Property name
  # @param price [Integer] Purchase price
  # @param color_group [String] Color group name
  # @param rent_levels [Array<Integer>] Rent amounts for different improvement levels
  def initialize(name, price, color_group, rent_levels)
    super(name)
    @price = price
    @color_group = color_group
    @rent_levels = rent_levels
    @houses = 0
    @hotel = false
    @owner = nil
    @mortgaged = false
  end

  # Calculates current rent based on improvements and ownership
  # @return [Integer] Current rent amount
  def current_rent
    # If the property is mortgaged, no rent is collected
    return 0 if @mortgaged

    # Double rent is charged if owner has monopoly (owns all properties of same color)
    # but has no houses or hotels built
    return @rent_levels[0] * 2 if @houses == 0 && !@hotel && @owner&.owns_all_of_color?(@color_group)

    # Base rent with no improvements
    return @rent_levels[0] if @houses == 0 && !@hotel

    # Hotel rent is the highest rent level (index 5)
    return @rent_levels[5] if @hotel

    # Otherwise return rent based on number of houses (indices 1-4)
    @rent_levels[@houses]
  end

  # Handles landing on this property
  # @param player [Player] The player who landed here
  # @param game [MonopolyGame] The current game instance
  # @param dice_roll [Integer] The dice roll that got here
  def action(player, _game, _dice_roll)
    if @owner.nil?
      handle_unowned_property(player)
    elsif @owner != player && !@mortgaged
      charge_rent(player)
    end
  end

  # Calculates mortgage value
  # @return [Integer] Amount received when mortgaging
  def mortgage_value
    @price / 2
  end

  # Calculates total value including improvements
  # @return [Integer] Total value in dollars
  def total_value
    @price + (@houses * HOUSE_COST[@color_group]) + (@hotel ? HOUSE_COST[@color_group] : 0)
  end

  # Mortgages the property if possible
  def mortgage
    return if @mortgaged || @houses > 0 || @hotel

    @mortgaged = true
    @owner.update_money(mortgage_value)
  end

  # Unmortgages the property if owner can afford it
  def unmortgage
    return unless @mortgaged

    cost = (mortgage_value * 1.1).to_i
    if @owner.money >= cost
      @owner.update_money(-cost)
      @mortgaged = false
    end
  end

  # Adds a house if possible
  def add_house
    return if @houses >= MonopolyGame::MAX_HOUSES || @hotel

    house_cost = HOUSE_COST[@color_group]
    if @owner.money >= house_cost
      @owner.update_money(-house_cost)
      @houses += 1
    end
  end

  # Adds a hotel if possible
  def add_hotel
    return if @hotel || @houses < MonopolyGame::MAX_HOUSES

    house_cost = HOUSE_COST[@color_group]
    if @owner.money >= house_cost
      @owner.update_money(-house_cost)
      @houses = 0
      @hotel = true
    end
  end

  private

  # Handles landing on an unowned property
  # @param player [Player] The player who landed here
  def handle_unowned_property(player)
    if player.money >= @price
      puts "Would you like to buy #{name} for $#{price}? (y/n)"
      # In a real implementation, you'd handle user input here
      # For now, let's assume AI always buys if they can
      buy_property(player)
    else
      auction_property
    end
  end

  # Handles auctioning an unowned property to all players
  # Starts bidding at $1 and increases by $10 increments
  # Players can bid if they have enough money and the current bid is less than 75% of property value
  # Auction ends when no more bids are received
  # Property is sold to highest bidder if there is one
  # @return [void]
  def auction_property
    current_bid = 1
    current_winner = nil

    loop do
      bid_received = false

      @players.each do |player|
        next if player.money < current_bid

        puts "Current bid is $#{current_bid}. #{player.name}, would you like to bid higher? (y/n)"
        # In a real implementation, you'd handle user input here
        # For now, let's assume AI bids if they can afford 75% of property value
        # Skip this player's bid if:
        # 1. Current bid is >= 75% of property value (to avoid overpaying)
        # 2. Player doesn't have enough money for next minimum bid (+$10)
        next unless current_bid < (@price * 0.75) && player.money >= current_bid + 10

        current_bid += 10
        current_winner = player
        bid_received = true
        puts "#{player.name} bids $#{current_bid}"
      end

      break unless bid_received
    end

    buy_property(current_winner) if current_winner
  end

  # Processes property purchase
  # @param player [Player] The buying player
  def buy_property(player)
    player.update_money(-@price)
    @owner = player
    player.properties << self
    puts "#{player.name} buys #{@name} for $#{@price}"
  end

  # Charges rent to a player landing here
  # @param player [Player] The player paying rent
  def charge_rent(player)
    rent = current_rent
    player.update_money(-rent)
    @owner.update_money(rent)
    puts "#{player.name} pays $#{rent} rent to #{@owner.name}"
  end

  # Removes all improvements from property
  def reset_improvements
    @houses = 0
    @hotel = false
  end
end

# Enhanced Railroad class
class Railroad < BoardSpace
  attr_accessor :price, :owner

  # Creates a new railroad
  # @param name [String] Railroad name
  # @param price [Integer] Purchase price
  def initialize(name, price)
    super(name)
    @price = price
    @owner = nil
  end

  # Handles landing on this railroad
  # @param player [Player] The player who landed here
  # @param game [MonopolyGame] The current game instance
  # @param dice_roll [Integer] The dice roll that got here
  def action(player, _game, _dice_roll)
    if @owner.nil?
      buy_railroad(player) if player.money >= @price
    elsif @owner != player
      charge_rent(player)
    end
  end

  # Calculates rent based on number of railroads owned
  # @param owner [Player] The railroad owner
  # @return [Integer] Rent amount
  def calculate_rent(owner)
    # Count how many railroads the owner has
    railroad_count = owner.properties.count { |p| p.is_a?(Railroad) }

    # Calculate rent using the formula:
    # - Base rent is $25
    # - Rent doubles for each additional railroad owned
    # - 1 railroad  => rent = $25
    # - 2 railroads => double(1 railroad rent) = (1 railroad rent)  * 2 = $50
    # - 3 railroads => double(2 railroad rent) = (2 railroads rent) * 2 = $100
    # - 4 railroads => double(3 railroad rent) = (3 railroads rent) * 2 = $200
    # - So with 1 railroad: $25 (25 * 2^0)
    #    with 2 railroads: $50 (25 * 2^1)
    #    with 3 railroads: $100 (25 * 2^2)
    #    with 4 railroads: $200 (25 * 2^3)
    25 * (2**(railroad_count - 1))
  end

  private

  # Processes railroad purchase
  # @param player [Player] The buying player
  def buy_railroad(player)
    player.update_money(-@price)
    @owner = player
    player.properties << self
    puts "#{player.name} buys #{@name} for $#{@price}"
  end

  # Charges rent to a player landing here
  # @param player [Player] The player paying rent
  def charge_rent(player)
    rent = calculate_rent(@owner)
    player.update_money(-rent)
    @owner.update_money(rent)
    puts "#{player.name} pays $#{rent} railroad rent to #{@owner.name}"
  end
end

# Enhanced Utility class
class Utility < BoardSpace
  attr_accessor :price, :owner

  # Creates a new utility
  # @param name [String] Utility name
  # @param price [Integer] Purchase price
  def initialize(name, price)
    super(name)
    @price = price
    @owner = nil
  end

  # Handles landing on this utility
  # @param player [Player] The player who landed here
  # @param game [MonopolyGame] The current game instance
  # @param dice_roll [Integer] The dice roll that got here
  def action(player, _game, dice_roll)
    if @owner.nil?
      buy_utility(player) if player.money >= @price
    elsif @owner != player
      charge_rent(player, dice_roll)
    end
  end

  # Calculates rent based on number of utilities owned and dice roll
  # @param owner [Player] The utility owner
  # @param dice_roll [Integer] The dice roll that got here
  # @return [Integer] Rent amount
  def calculate_rent(owner, dice_roll)
    # Count how many utilities the owner has
    utility_count = owner.properties.count { |p| p.is_a?(Utility) }

    # If owner has both utilities, multiply dice roll by 10
    # If owner has one utility, multiply dice roll by 4
    multiplier = utility_count == 2 ? 10 : 4

    # Calculate final rent by multiplying dice roll by the multiplier
    dice_roll * multiplier
  end

  private

  # Processes utility purchase
  # @param player [Player] The buying player
  def buy_utility(player)
    player.update_money(-@price)
    @owner = player
    player.properties << self
    puts "#{player.name} buys #{@name} for $#{@price}"
  end

  # Charges rent to a player landing here
  # @param player [Player] The player paying rent
  # @param dice_roll [Integer] The dice roll that got here
  def charge_rent(player, dice_roll)
    rent = calculate_rent(@owner, dice_roll)
    player.update_money(-rent)
    @owner.update_money(rent)
    puts "#{player.name} pays $#{rent} utility rent to #{@owner.name}"
  end
end

# Card systems
class Card
  attr_reader :description, :action

  # Creates a new card
  # @param description [String] Card text
  # @param action [Proc] Action to execute when drawn
  def initialize(description, &action)
    @description = description
    @action = action
  end
end

# ChanceCards Implementation
class ChanceCards
  # Creates and returns a shuffled deck of Chance cards
  # @return [Array<Card>] Array of Chance cards
  class << self
    def create_deck
      [
        # Ruby automatically captures the block and makes it available to the method through the &block parameter, even though it appears after the parentheses. This is because in Ruby:
        # Blocks can be attached to any method call
        # The block is implicitly passed as a special last argument
        # The &block syntax in the method definition tells Ruby to capture any block passed to the method
        # Card.new("Advance to GO") do |player, game|
        #   # block content
        # end
        # It's equivalent to if we wrote it with do/end:
        Card.new('Advance to GO (Collect $200)') do |player, _game|
          player.position = MonopolyGame::GO_POSITION
          player.update_money(200)
        end,
        Card.new('Advance to Illinois Avenue') do |player, game|
          player.position = 24
          # When moving directly to a space via a card effect, we pass 0 for the dice roll
          # since the player didn't actually roll dice to get there. The dice roll is only
          # relevant for Utilities, which multiply the roll by a factor to determine rent.
          game.handle_space(player, 0)
        end,
        Card.new('Advance to St. Charles Place') do |player, game|
          player.position = 11
          game.handle_space(player, 0)
        end,
        Card.new('Advance to nearest Utility') do |player, game|
          current_pos = player.position
          if current_pos < 12 || current_pos > 28
            player.position = 12 # Electric Company
          else
            player.position = 28 # Water Works
          end
          game.handle_space(player, game.roll_dice.sum)
        end,
        Card.new('Advance to nearest Railroad') do |player, game|
          current_pos = player.position
          new_pos = case current_pos
                    when 0..5 then 5    # Reading Railroad
                    when 6..15 then 15  # Pennsylvania Railroad
                    when 16..25 then 25 # B&O Railroad
                    when 26..35 then 35 # Short Line
                    else 5 # Reading Railroad
                    end
          player.position = new_pos
          game.handle_space(player, 0)
        end,
        Card.new('Bank pays you dividend of $50') do |player, _game|
          player.update_money(50)
        end,
        Card.new('Get Out of Jail Free') do |player, _game|
          player.add_get_out_of_jail_card
        end,
        Card.new('Go Back 3 Spaces') do |player, game|
          player.position = (player.position - 3) % 40
          game.handle_space(player, 0)
        end,
        Card.new('Go to Jail') do |player, game|
          game.go_to_jail(player)
        end,
        Card.new('Make general repairs on all your property. For each house pay $25. For each hotel pay $100') do |player, _game|
          total_cost = player.properties.sum do |property|
            (property.houses * 25) + (property.hotel ? 100 : 0)
          end
          player.update_money(-total_cost)
        end
      ]
    end
  end
end

# Community Chest cards represent the orange Community Chest cards in Monopoly.
# Unlike Chance cards which focus on movement and property-related actions,
# Community Chest cards typically deal with straightforward money transactions
# (collecting or paying fixed amounts) with a few special cards like Get Out of Jail Free.
class CommunityChestCards
  # Creates and returns a shuffled deck of Community Chest cards
  # @return [Array<Card>] Array of Community Chest cards
  class << self
    def create_deck # rubocop:disable Metrics/MethodLength
      [
        Card.new('Advance to GO (Collect $200)') do |player, _game|
          player.position = MonopolyGame::GO_POSITION
          player.update_money(200)
        end,
        Card.new('Bank error in your favor. Collect $200') do |player, _game|
          player.update_money(200)
        end,
        Card.new("Doctor's fees. Pay $50") do |player, _game|
          player.update_money(-50)
        end,
        Card.new('From sale of stock you get $50') do |player, _game|
          player.update_money(50)
        end,
        Card.new('Get Out of Jail Free') do |player, _game|
          player.add_get_out_of_jail_card
        end,
        Card.new('Go to Jail') do |player, game|
          game.go_to_jail(player)
        end,
        Card.new('Holiday fund matures. Receive $100') do |player, _game|
          player.update_money(100)
        end,
        Card.new('Income tax refund. Collect $20') do |player, _game|
          player.update_money(20)
        end,
        Card.new('Life insurance matures. Collect $100') do |player, _game|
          player.update_money(100)
        end,
        Card.new('Pay hospital fees of $100') do |player, _game|
          player.update_money(-100)
        end,
        Card.new('Pay school fees of $50') do |player, _game|
          player.update_money(-50)
        end,
        Card.new('Receive $25 consultancy fee') do |player, _game|
          player.update_money(25)
        end,
        # This card charges the player repair fees based on their properties:
        # - $40 for each house they own
        # - $115 for each hotel they own
        # It calculates the total cost by:
        # 1. Iterating through all properties owned by the player
        # 2. For each property:
        #    - Multiplies number of houses by $40
        #    - Adds $115 if there's a hotel
        # 3. Sums up all the costs
        # 4. Deducts the total from the player's money
        Card.new('You are assessed for street repairs. $40 per house. $115 per hotel') do |player, _game|
          # player.properties.sum iterates through all properties owned by the player
          # and adds up (sums) the repair costs for each property
          # For each property:
          # - Multiply number of houses by $40
          # - Add $115 if there's a hotel
          # The sum block returns a cost for each property which gets totaled
          total_cost = player.properties.sum do |property|
            (property.houses * 40) + (property.hotel ? 115 : 0)
          end
          player.update_money(-total_cost)
        end,
        Card.new('You have won second prize in a beauty contest. Collect $10') do |player, _game|
          player.update_money(10)
        end,
        Card.new('You inherit $100') do |player, _game|
          player.update_money(100)
        end
      ]
    end
  end
end
