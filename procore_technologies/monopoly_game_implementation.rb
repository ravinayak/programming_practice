# frozen_string_literal: true

# MonopolyGame Implementation
class MonopolyGameImplementation # rubocop:disable Metrics/ClassLength
  STARTING_MONEY = 1500
  SALARY = 200
  MAX_HOUSES = 4
  MAX_HOTELS = 1
  JAIL_POSITION = 10
  GO_POSITION = 0
  JAIL_RELEASE_MONEY = 50
  BOARD_SPACES = 40

  attr_accessor :player_names, :players, :board, :current_player_index, :dice_doubles_count, :chance_cards, :custom_jest_cards,
                :game_over

  def initialize(player_names:)
    @players = player_names.map { |name| Player.new(name:) }
    @board = Board.new
    @current_player_index = 0
    @dice_doubles_count = 0
    @chance_cards = ChanceCard.create_deck.shuffle
    @custom_jest_cards = CustomJestCard.create_deck.shuffle
    @game_over = false
  end

  def play_game
    turn_count = 0
    max_turns = 1000
    until @game_over || turn_count >= max_turns
      current_player = @players[@current_player_index]
      take_turn(current_player)
      check_bankruptcy(current_player)
      next_player unless @dice_doubles_count.positive?
      turn_count += 1
    end

    if turn_count >= max_turns
      puts "Game ended due to maximum turns reached"
    end

    announce_winner
  end

  def roll_dice
    [rand(1..6), rand(1..6)]
  end

  def take_turn(player)
    if player.in_jail?
      handle_jail_turn(player)
      return
    end

    double_roll = false
    begin
      dice1, dice2 = roll_dice
      total = dice1 + dice2
      double_roll = (dice1 == dice2)
      if double_roll
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
    end while double_roll && @dice_doubles_count < 3
  end

  def go_to_jail(player)
    player.jail_turns = 0
    player.in_jail = true
    player.position = MonopolyGameImplementation::JAIL_POSITION
    puts "#{player.name} is sent to Jail"
  end

  def use_jail_card(player)
    player.use_get_out_of_jail_card
    release_from_jail(player)
  end

  def handle_jail_turn(player)
    player.jail_turns += 1

    if player.get_out_of_jail_cards.positive?
      use_jail_card(player)
      return
    end

    if player.jail_turns == 3
      if player.money >= JAIL_RELEASE_MONEY
        player.update_money(-JAIL_RELEASE_MONEY)
        release_from_jail(player)
      else
        force_bankruptcy(player)
      end
      return
    else

      dice1, dice2 = roll_dice
      total = dice1 + dice2

      if dice1 == dice2
        release_from_jail(player)
        move_player(player, total)
        handle_space(player, total)
      end
    end
  end

  def check_bankruptcy(player)
    return if player.money.positive?

    if player.money.negative?
      if can_raise_money?(player)
        handle_negative_balance(player)
      else
        force_bankruptcy(player)
      end
    end
  end

  def can_raise_money?(player)
    total_assets = player.properties.sum(&:mortgage_value)
    (player.money + total_assets).positive?
  end

  def handle_negative_balance(player)
    puts "Handling negative balance for #{player.name}"
    attempts = 0
    max_attempts = player.properties.size

    while player.money.negative? && attempts < max_attempts
      property = player.properties.max_by(:mortgage_value)
      break unless property

      if property.mortgaged
        property.sell_improvements
      else
        property.mortgage
      end
      attempts += 1
    end
    force_bankruptcy(player) if player.money.negative?
  end

  def force_bankruptcy(player)
    puts "#{player.name} is being bankrupt"
    player.properties.each do |property|
      property.owner = nil
      property.unmortgage
      property.reset_improvements
    end
    @players.delete(player)

    @game_over = true if @players.size == 1
  end

  def release_from_jail(player)
    player.jail_turns = 0
    player.in_jail = false
    puts "#{player.name} is being released from jail"
  end

  def announce_winner
    winner = @players.max_by(&:total_worth)
    puts "#{winner.name} has won the game with #{winner.total_worth}"
  end

  def next_player
    @current_player_index = (@current_player_index + 1) % @players.size
  end

  def move_player(player, spaces)
    old_position = player.position
    new_position = (player.position + spaces) % @board.spaces.size

    if new_position < old_position && old_position != MonopolyGameImplementation::JAIL_POSITION
      player.update_money(SALARY)
      puts "#{player.name} has passed through Go Position, is being awarded #{MonopolyGameImplementation::SALARY}"
    end

    player.position = new_position
  end

  def handle_space(player, dice_roll)
    space = @board.spaces[player.position]
    space.action(player:, game: self, dice_roll:)
  end

  def reset_improvements
    @houses = 0
    @hotel = false
  end
end

# BoardSpace Class
class BoardSpace
  attr_accessor :name, :action

  def initialize(name:, &action)
    @name = name
    @action = action
  end

  def action(player:, game:, dice_roll:)
    # Method to be implemented in subclasses
  end

  def handle_unowned_property(player:, game:)
    if player.money >= @price
      puts "Player :: #{player.name} is purchasing the property :: #{@name}"
      buy_property(player:)
    else
      auction_property(game:)
    end
  end

  def auction_property(game:)
    current_bid = 10
    current_winner = nil

    loop do
      bid_received = false

      game.players.each do |player|
        next unless player.money >= current_bid

        next if current_bid > (@price * 0.75) || player.money < current_bid + 10

        current_bid += 10
        current_winner = player
        bid_received = true
      end

      break unless bid_received
    end

    buy_property(player: current_winner) if current_winner
  end

  def buy_property(player:)
    player.update_money(-@price)
    player.properties << self
    @owner = player
    puts "#{player.name} has purchased property :: #{@name}"
  end

  def charge_rent(player:, rent:)
    @owner.update_money(-rent)
    player.update_money(rent)
  end
end

class CardSpace < BoardSpace
  attr_accessor :name

  def initialize(name:)
    super(name:)
  end
end

# New classes for board spaces that trigger card draws
class ChanceCardSpace < CardSpace
  def action(player:, game:, dice_roll:)
    card = game.chance_cards.pop
    card.action.call(player, game)
    game.chance_cards.unshift(card)  # Put the card back at the bottom of the deck
  end
end

class CustomJestCardSpace < CardSpace
  def action(player:, game:, dice_roll:)
    card = game.custom_jest_cards.pop
    card.action.call(player, game)
    game.custom_jest_cards.unshift(card)  # Put the card back at the bottom of the deck
  end
end

# Railroad class
class Railroad < BoardSpace
  attr_accessor :name, :price, :owner

  def initialize(name:, price:)
    super(name:)
    @price = price
    @owner = nil
  end

  def action(player:, game:, dice_roll:)
    if @owner.nil?
      buy_property(player:) if player.money >= @price
    elsif @owner != player
      rent = current_rent
      charge_rent(player:, rent:)
    end
  end

  def current_rent
    railroad_count = @owner.properties.count { |p| p.is_a?(Railroad) }

    25 * (2**(railroad_count - 1))
  end

  def total_value
    @price
  end
end

# Utility class
class Utility < BoardSpace
  attr_accessor :name, :price, :owner

  def initialize(name:, price:)
    super(name:)
    @price = price
    @owner = nil
  end

  def action(player:, game:, dice_roll:)
    if @owner.nil?
      buy_property(player:) if player.money >= @price
    elsif @owner != player
      rent = current_rent(dice_roll:)
      charge_rent(player:, rent:)
    end
  end

  def current_rent(dice_roll:)
    utility_count = @owner.properties.count { |p| p.is_a?(Utility) }

    multiplier = utility_count == 2 ? 10 : 4

    dice_roll * multiplier
  end

  def total_value
    @price
  end
end

# Property Class
class Property < BoardSpace
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

  attr_accessor :name, :price, :rent_levels, :houses, :hotel, :owner, :mortgaged, :color_group

  def initialize(name:, price:, rent_levels:, color_group:)
    super(name:)
    @price = price
    @rent_levels = rent_levels
    @houses = 0
    @hotel = false
    @owner = nil
    @mortgaged = false
    @color_group = color_group
  end

  def action(player:, game:, dice_roll:) # rubocop:disable Lint/UnusedMethodArgument
    if @owner.nil?
      handle_unowned_property(player:, game:)
    elsif @owner != player && !@mortgaged
      rent = current_rent
      charge_rent(player:, rent:)
    end
  end

  def current_rent
    return 0 if @mortgaged

    return rent_levels[0] * 2 if @houses.zero? && !@hotel && @owner&.owns_all_in_group(color_group:)

    return rent_levels[0] if @houses.zero? && !@hotel

    return rent_levels[5] if @hotel

    rent_levels[@houses]
  end

  def mortage_value
    @price / 2
  end

  def mortgage
    return if @mortgaged || @houses.zero? || @hotel

    @mortgaged = true
    @owner.update_money(mortage_value)
    puts "#{name} has been mortgaged"
  end

  def unmortgage
    return unless @mortgaged

    cost = (mortgage_value * 1.1).to_i
    if @owner.money >= cost
      @owner.update_money(-cost)
      @mortgaged = false
      puts "#{name} has been unmortgaged"
    end
  end

  def add_house
    return if @houses >= MonopolyGameImplementation::MAX_HOUSES || @hotel

    house_cost = Property::HOUSE_COST[@color_group]
    if @owner.money >= house_cost
      @owner.update_money(-house_cost)
      @houses += 1
      puts "#{@owner.name} has owned a new house in property :: #{@name}"
    end
  end

  def add_hotel
    return if @houses < MonopolyGameImplementation::MAX_HOUSES || @hotel

    house_cost = Property::HOUSE_COST[@color_group]
    if @owner.money >= house_cost
      @owner.update_money(-house_cost)
      @houses = 0
      @hotel = true
      puts "#{owner.name} has owned a hotel in property :: #{@name}"
    end
  end

  def total_value
    price + @houses * HOUSE_COST[@color_group] + (@hotel ? HOUSE_COST[@color_group] : 0)
  end
end

# Player Class
class Player
  attr_accessor :name, :position, :jail_turns, :get_out_of_jail_cards, :money, :properties, :in_jail

  def initialize(name:)
    @name = name
    @money = MonopolyGameImplementation::STARTING_MONEY
    @properties = []
    @position = 0
    @jail_turns = 0
    @get_out_of_jail_cards = 0
    @in_jail = false
  end

  def add_get_out_of_jail_card
    @get_out_of_jail_cards += 1
  end

  def use_get_out_of_jail_card
    @get_out_of_jail_cards -= 1 if @get_out_of_jail_cards.positive?
  end

  def total_worth
    money + properties.sum(&:total_value)
  end

  def update_money(amount)
    @money += amount
    puts "#{@name} has updated money :: #{@money}"
  end

  def in_jail?
    @in_jail
  end

  def owns_all_in_group(color_group:)
    return false if color_group.nil?

    owned_in_group = @properties.count do |property| 
      property.respond_to?(:color_group) && property.color_group == color_group
    end
    total_in_group = Board::PROPERTY_GROUPS[color_group]
    owned_in_group == total_in_group
  end
end

# Tax Class
class Tax < BoardSpace
  attr_accessor :name, :price

  def initialize(name:, price:)
    super(name:)
    @price = price
  end

  def action(player:, game:, dice_roll:)
    # Method to be implemented in subclasses
  end
end

# Board class
class Board
  PROPERTY_GROUPS = {
    'Brown' => 2,
    'Light Blue' => 3,
    'Pink' => 3,
    'Orange' => 3,
    'Red' => 3,
    'Yellow' => 3,
    'Green' => 3,
    'Dark blue' => 2
  }.freeze

  attr_accessor :spaces

  def initialize
    setup_spaces
  end

  def setup_spaces
    @spaces = [
      BoardSpace.new(name: 'Go'),

      Property.new(name: 'Mediterranean Avenue', price: 60, color_group: 'Brown', rent_levels: [2, 10, 30, 90, 160, 250]),
      CustomJestCardSpace.new(name: 'CustomJestCard'),
      Property.new(name: 'Baltic Avenue', price: 60, color_group: 'Brown', rent_levels: [4, 20, 60, 180, 320, 450]),

      Tax.new(name: 'IncomeTax', price: 200),
      Railroad.new(name: 'Reading Railroad', price: 200),

      Property.new(name: 'Oriental Avenue', price: 100, color_group: 'Light Blue', rent_levels: [6, 30, 90, 270, 400, 550]),
      ChanceCardSpace.new(name: 'ChanceCard'),
      Property.new(name: 'Vermont Avenue', price: 100, color_group: 'Light Blue', rent_levels: [6, 30, 90, 270, 400, 550]),
      Property.new(name: 'Connecticut Avenue', price: 120, color_group: 'Light Blue',
                   rent_levels: [8, 40, 100, 300, 450, 600]),

      BoardSpace.new(name: 'Jail'),

      Property.new(name: 'St Charles Place', price: 140, color_group: 'Pink', rent_levels: [10, 50, 150, 450, 625, 750]),
      Utility.new(name: 'Electric Company', price: 150),
      Property.new(name: 'States Avenue', price: 140, color_group: 'Pink', rent_levels: [10, 50, 150, 450, 625, 750]),
      Property.new(name: 'Virginia Avenue', price: 160, color_group: 'Pink', rent_levels: [12, 60, 180, 500, 700, 900]),

      Railroad.new(name: 'Pennysylvania Railroad', price: 200),
      Property.new(name: 'St James Place', price: 180, color_group: 'Orange', rent_levels: [14, 70, 200, 550, 750, 950]),
      CustomJestCardSpace.new(name: 'CustomJestCard'),
      Property.new(name: 'Tennesse Avenue', price: 180, color_group: 'Orange', rent_levels: [14, 70, 200, 550, 750, 950]),
      Property.new(name: 'New York Avenue', price: 200, color_group: 'Orange', rent_levels: [16, 80, 220, 600, 800, 1000]),

      BoardSpace.new(name: 'Free Parking'),
      Property.new(name: 'Kentucky Avenue', price: 220, color_group: 'Red', rent_levels: [18, 90, 250, 700, 875, 1050]),
      ChanceCardSpace.new(name: 'ChanceCard'),
      Property.new(name: 'Indiana Avenue', price: 220, color_group: 'Red', rent_levels: [18, 90, 250, 700, 875, 1050]),
      Property.new(name: 'Illinois Avenue', price: 240, color_group: 'Red', rent_levels: [20, 100, 300, 750, 925, 1100]),

      Railroad.new(name: 'B&O Railroad', price: 200),
      Property.new(name: 'Atlantic Avenue', price: 260, color_group: 'Yellow', rent_levels: [22, 110, 330, 800, 975, 1150]),
      Property.new(name: 'Ventnor Avenue', price: 260, color_group: 'Yellow', rent_levels: [22, 110, 330, 800, 975, 1150]),
      Utility.new(name: 'Water Works', price: 150),
      Property.new(name: 'Marvin Gardens', price: 280, color_group: 'Yellow', rent_levels: [24, 120, 360, 850, 1025, 1200]),

      BoardSpace.new(name: 'Go to Jail'),
      Property.new(name: 'Pacific Avenue', price: 300, color_group: 'Green', rent_levels: [26, 130, 390, 900, 1100, 1275]),
      Property.new(name: 'North Carolina Avenue', price: 300, color_group: 'Green',
                   rent_levels: [26, 130, 390, 900, 1100, 1275]),
      CustomJestCardSpace.new(name: 'CustomJestCard'),
      Property.new(name: 'Pennsylvania Avenue', price: 320, color_group: 'Green',
                   rent_levels: [28, 150, 450, 1000, 1200, 1400]),

      Railroad.new(name: 'Short Lines', price: 200),
      ChanceCardSpace.new(name: 'ChanceCard'),
      Property.new(name: 'Park Place', price: 350, color_group: 'Dark Blue', rent_levels: [35, 175, 500, 1100, 1300, 1500]),
      Tax.new(name: 'Luxury Tax', price: 100),
      Property.new(name: 'BoardWalk', price: 400, color_group: 'Dark Blue', rent_levels: [50, 200, 600, 1400, 1700, 2000])
    ]
  end
end

class Card
  attr_accessor :name, :action

  def initialize(name, action)
    @name = name
    @action = action
  end
end

# ChanceCard Implementation
class ChanceCard < Card
  attr_accessor :name, :action

  def initialize(name:, &action)
    super(name, action)
  end

  # rubocop:disable Metrics/MethodLength
  def self.create_deck
    [
      ChanceCard.new(name: 'Advance to Go Position (Collect 200$)') do |player, _game|
        player.position = MonopolyGameImplementation::GO_POSITION
        player.update_money(MonopolyGameImplementation::SALARY)
      end,
      ChanceCard.new(name: 'Advance to Illinois Position') do |player, game|
        player.position = 24
        game.handle_space(player, 0)
      end,
      ChanceCard.new(name: 'Advance to St Charles Place Place') do |player, game|
        player.position = 11
        game.handle_space(player, 0)
      end,
      ChanceCard.new(name: 'Advance to Nearest Utility') do |player, game|
        if player.position < 12 || player.position > 28
          player.position = 12
        else
          player.position = 28
        end
        game.handle_space(player, 0)
      end,
      ChanceCard.new(name: 'Advance to Nearest Railroad') do |player, game|
        current_position = player.position
        player.position = case current_position
                          when 0..5 then 5
                          when 6..15 then 15
                          when 16..25 then 25
                          when 26..35 then 35
                          else 5
                          end
        game.handle_space(player, 0)
      end,
      ChanceCard.new(name: 'Go To Jail') do |player, game|
        game.go_to_jail(player)
      end,
      ChanceCard.new(name: 'Give the player get out of jail card') do |player, _game|
        player.add_get_out_of_jail_card
      end,
      ChanceCard.new(name: 'Go Back 3 Spaces') do |player, game|
        player.position = (player.position - 3) % MonopolyGameImplementation::BOARD_SPACES
        game.handle_space(player, 0)
      end,
      ChanceCard.new(name: 'Bank you pays dividend of 50$') do |player, _game|
        player.update_money(50)
      end,
      ChanceCard.new(name: 'You have been selected for street repairs, 25$ for house, 100$ for hotel') do |player, _game|
        total_cost = 0
        player.properties.each do |property|
          next unless property.is_a?(Property)
          total_cost += 25 * property.houses + (property.hotel ? 100 : 0)
        end
        player.update_money(-total_cost)
      end
    ]
  end
  # rubocop:enable Metrics/MethodLength
end

# CustomJestCard Implementation
class CustomJestCard < Card
  attr_accessor :name, :action

  def initialize(name:, &action)
    super(name, action)
  end

  def self.create_deck
    [
      CustomJestCard.new(name: 'You have inherited 100$') do |player, _game|
        player.update_money(100)
      end,
      CustomJestCard.new(name: 'Advance to Go Position, collect 200$') do |player, _game|
        player.position = MonopolyGameImplementation::GO_POSITION
        player.update_money(MonopolyGameImplementation::SALARY)
      end,
      CustomJestCard.new(name: 'Received consulting fees of 25$') do |player, _game|
        player.update_money(25)
      end,
      CustomJestCard.new(name: 'Sale of Stock - You have earned 50$') do |player, _game|
        player.update_money(50)
      end,
      CustomJestCard.new(name: 'Life Insurance Matures - 100$') do |player, _game|
        player.update_money(100)
      end,
      CustomJestCard.new(name: 'Income Tax Refund - 20$') do |player, _game|
        player.update_money(20)
      end,
      CustomJestCard.new(name: 'You have earned 2nd prize in Beauty Contest, 10$') do |player, _game|
        player.update_money(10)
      end,
      CustomJestCard.new(name: 'Holiday Fund Matures - 100$') do |player, _game|
        player.update_money(100)
      end,
      CustomJestCard.new(name: 'Bank Error has occurred in your favor - 200$') do |player, _game|
        player.update_money(200)
      end,
      CustomJestCard.new(name: 'Hospital Fees - 100$') do |player, _game|
        player.update_money(-100)
      end,
      CustomJestCard.new(name: 'Doctor Fees - 50$') do |player, _game|
        player.update_money(-100)
      end,
      CustomJestCard.new(name: 'School Fees - 50$') do |player, _game|
        player.update_money(-50)
      end,
      CustomJestCard.new(name: 'You have been selected for Street Repairs, 40$ for houses, 115$ for hotel') do |player, _game|
        total_cost = 0
        player.properties.each do |property|
          next unless property.is_a?(Property)

          total_cost += 40 * property.houses + (property.hotel ? 115 : 0)
        end
        player.update_money(-total_cost)
      end,
      CustomJestCard.new(name: 'Go to Jail') do |player, game|
        game.go_to_jail(player)
      end,
      CustomJestCard.new(name: 'Give player 1 get out of jail card') do |player, _game|
        player.add_get_out_of_jail_card
      end
    ]
  end
end

def test
  player_names = ['Raj Kiran', 'James Anderson', 'Neo', 'Charles Ran']
  mg = MonopolyGameImplementation.new(player_names:)
  mg.play_game
end

test
