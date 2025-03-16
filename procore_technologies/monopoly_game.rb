# frozen_string_literal: true

class MonopolyGame
  STARTING_MONEY = 1500
  SALARY = 200
  MAX_HOTELS = 1
  MAX_HOUSES = 4
  GO_POSITION = 0
  JAIL_POSITION = 10
  BOARD_SPACES = 40
  MAX_TURNS = 1000
  JAIL_RELEASE_MONEY = 50

  attr_accessor :players, :board, :dice_doubles_count, :current_player_index, :chance_cards, :custom_jest_cards, :game_over

  def initialize(player_names)
    @players = player_names.map { |name| Player.new(name) }
    @board = Board.new
    @chance_cards = ChanceCard.create_deck.shuffle
    @custom_jest_cards = CustomJestCard.create_deck.shuffle
    @current_player_index = 0
    @dice_doubles_count = 0
    @game_over = false
  end

  def play_game
    turns_count = 0
    while !@game_over && turns_count < MAX_TURNS
      current_player = @players[current_player_index]
      take_turn(current_player)
      check_bankruptcy(current_player)
      next_player unless dice_doubles_count.positive?
      turns_count += 1
    end

    announce_winner
  end

  def take_turn(player)
    if player.in_jail?
      handle_jail_turn(player)
      return
    end

    double_roll = false
    loop do
      dice1, dice2 = roll_dice
      dice_roll = dice1 + dice2
      double_roll = (dice1 == dice2)

      if double_roll
        if dice_doubles_count >= 3
          go_to_jail(player)
          return
        end
      else
        @dice_doubles_count = 0
      end

      move_player(player, dice_roll)
      handle_space(player, dice_roll)
      break unless double_roll && dice_doubles_count < 3
    end
  end

  def handle_jail_turn(player)
    player.jail_turns += 1

    if player.get_out_of_jail_cards.positive?
      player.use_get_out_of_jail_card
      release_from_jail(player)
      return
    end

    if player.jail_turns >= 3
      if player.money >= JAIL_RELEASE_MONEY
        player.update_money(-JAIL_RELEASE_MONEY)
        release_from_jail(player)
      else
        force_bankruptcy(player)
      end
    end

    dice1, dice2 = roll_dice
    dice_roll = dice1 + dice2
    if dice1 == dice2
      release_from_jail(player)
      move_player(player, dice_roll)
      handle_space(player, dice_roll)
    end
  end

  def go_to_jail(player)
    player.position = JAIL_POSITION
    player.jail_turns = 0
    player.in_jail = true
    print "\n JailTime => Player :: #{player.name} has gone to Jail\n"
  end

  def release_from_jail(player)
    player.jail_turns = 0
    player.in_jail = false
    print "\n Release From Jail => Player :: #{player.name} has been released from Jail\n"
  end

  def move_player(player, dice_roll)
    old_position = player.position
    new_position = (old_position + dice_roll) % BOARD_SPACES

    if new_position < old_position && old_position != JAIL_POSITION
      player.update_money(SALARY)
      print "\n GO Position => Player :: #{player.name} has passed through GO Position and earned 200$\n"
    end

    player.position = new_position
  end

  def roll_dice
    [rand(1..6), rand(1..6)]
  end

  def handle_space(player, spaces)
    space = @board.spaces[player.position]
    dice_roll = spaces
    space.action(player, self, dice_roll)
  end

  def check_bankruptcy(player)
    if player.money.negative?
      if can_raise_money?(player)
        handle_negative_balance(player)
        nil
      else
        force_bankruptcy(player)
      end
    end
  end

  def handle_negative_balance(player)
    max_attempts = 1000
    attempt_count = 0
    while player.money.negative? && attempt_count < max_attempts
      property_max = nil
      max_property_value = -1
      attempt_count += 1
      player.properties.each do |property|
        next unless property.is_a?(Property) && max_property_value < property.mortgage_value

        property_max = property
        max_property_value = property.mortgage_value
      end

      break unless property

      if property.mortgaged
        property.sell_improvements
      else
        property.mortgage
      end
    end
  end

  def can_raise_money?(player)
    total_assets = 0
    player.properties.each do |property|
      next unless property.is_a?(Property)

      total_assets += property.mortgage_value
    end
    (player.money + total_assets).positive?
  end

  def force_bankruptcy(player)
    player.properties.each do |property|
      property.owner = nil
      property.unmortgage if property.is_a?(Property)
      property.reset_improvements if property.is_a?(Property)
    end
    @players.delete(player)

    @game_over = true if @players.size == 1
  end

  def next_player
    @current_player_index = (@current_player_index + 1) % @players.size
  end

  def announce_winner
    winner = @players.max_by(&:total_worth)
    print "\n\nWinner :: #{winner.name} has won the game and is worth :: #{winner.total_worth}\n\n"
  end
end

class Player
  attr_accessor :name, :position, :jail_turns, :get_out_of_jail_cards, :money, :properties, :get_out_of_jail_cards, :in_jail

  def initialize(name)
    @name = name
    @position = 0
    @properties = []
    @money = MonopolyGame::STARTING_MONEY
    @jail_turns = 0
    @get_out_of_jail_cards = 0
    @in_jail = false
  end

  def in_jail?
    @in_jail
  end

  def add_get_out_of_jail_card
    @get_out_of_jail_cards += 1
  end

  def use_get_out_of_jail_card
    @get_out_of_jail_cards -= 1 if @get_out_of_jail_cards.positive?
  end

  def update_money(amount)
    @money += amount
  end

  def total_worth
    total_assets = properties.sum(&:total_value)
    @money + total_assets
  end

  def owns_all_in_group(color_group)
    return if color_group.nil?

    owned_in_group = 0
    properties.each do |property|
      return unless property.is_a?(Property) && property.respond_to?(color_group) && property.color_group == color_group

      owned_in_group += 1
    end
    total_in_group = Board::PROPERTY_GROUPS[color_group]
    owned_in_group == total_in_group
  end
end

class BoardSpace
  attr_accessor :name, :action

  def initialize(name)
    @name = name
  end

  def action(player, game, dice_roll)
    # To be implemented in subclasses
  end

  def handle_unowned_property(player, game)
    if player.money >= price
      buy_property(player)
    else
      auction_property(game)
    end
  end

  def buy_property(player)
    print "\nPlayer :: #{player.name} has purchased the property #{name}\n"
    player.update_money(-price)
    player.properties << self
    @owner = player
  end

  def auction_property(game)
    current_bid = 10
    current_winner = nil
    max_turns = 100
    turns_count = 0

    loop do
      bid_received = false

      game.players.each do |player|
        next if player.money < current_bid

        next if current_bid > (price * 0.75) && player.money < current_bid + 10

        current_bid += 10
        current_winner = player
        bid_received = true
      end
      turns_count += 1

      break if !bid_received || turns_count > max_turns
    end

    if current_winner
      buy_property(current_winner)
      print "\n Auction Winner => Winner :: #{current_winner.name} has won the auction for property #{name}\n"
    end
  end

  def charge_rent(player, game, rent)
    if player.money < rent
      game.handle_player_raising_money(player)
    else
      player.update_money(-rent)
      @owner.update_money(rent)
      print "\n Charge Rent => Owner :: #{@owner.name} has charged rent :: #{rent} from #{player.name}\n"
    end
  end
end

class Property < BoardSpace
  HOUSE_COST = {
    'Brown' => 50,
    'Light Blue' => 50,
    'Pink' => 100,
    'Orange' => 100,
    'Red' => 200,
    'Yellow' => 200,
    'Green' => 250,
    'Dark Blue' => 250
  }.freeze

  attr_accessor :name, :price, :owner, :houses, :hotel, :color_group, :rent_levels, :mortgaged

  def initialize(name, price, color_group, rent_levels)
    @name = super(name)
    @price = price
    @rent_levels = rent_levels
    @owner = nil
    @houses = 0
    @hotel = false
    @mortgaged = false
    @color_group = color_group
  end

  def action(player, game, _dice_total)
    if @owner.nil?
      handle_unowned_property(player, game)
    elsif @owner != player && !mortgaged
      rent = current_rent
      charge_rent(player, game, rent)
    end
  end

  def current_rent
    return 0 if mortgaged

    return rent_levels[0] * 2 if houses.zero? && !hotel && owner&.owns_all_in_group(color_group)

    return rent_levels[0] if houses.zero? && !hotel

    return rent_levels[5] if hotel

    rent_levels[houses]
  end

  def mortgage_value
    price / 2
  end

  def mortgage
    return if mortgaged || houses.positive? || hotel

    @mortgaged = true
    @owner.update_money(mortgage_value)
    puts "Owner #{owner.name} has mortgaged the property #{name}"
  end

  def unmortgage
    return unless mortgaged

    cost = (mortgage_value * 1.1).to_i
    return unless @owner.money >=cost

    @owner.update_money(-cost)
    @mortgaged = false
    puts "Owner #{owner.name} has unmortgaged the property #{name}"
  end

  def add_hotel
    return if @mortgaged || hotel || houses < MonopolyGame::MAX_HOUSES

    house_cost = HOUSE_COST[color_group]
    return unless @owner.money >= house_cost
  
    owner.update_money(-house_cost)
    @hotel = true
    @houses = 0
  end

  def sell_improvements
    money_back = property.houses * HOUSE_COST[color_group] + (property.hotel ? HOUSE_COST[color_group] : 0)
    property.houses = 0
    property.hotel = false
    @owner.update_money(money_back)
  end

  def add_house
    return if @mortgaged || hotel || houses >= MonopolyGame::MAX_HOUSES

    house_cost = HOUSE_COST[color_group]
    return unless @owner.money >= house_cost

    owner.update_money(-house_cost)
    @houses += 1
    @hotel = false
  end

  def total_value
    price + houses * HOUSE_COST[color_group] + (hotel ? HOUSE_COST[color_group] : 0)
  end
end

class Railroad < BoardSpace
  attr_accessor :name, :price, :owner

  def initialize(name, price)
    @name = super(name)
    @price = price
    @owner = nil
  end

  def action(player, game, _dice_total)
    if @owner.nil?
      handle_unowned_property(player, game)
    elsif @owner != player
      rent = current_rent
      charge_rent(player, game, rent)
    end
  end

  def current_rent
    railroad_count = owner.properties.count { |property| property.is_a?(Railroad) }

    25 * (2**(railroad_count - 1))
  end

  def total_value
    price
  end
end

class Utility < BoardSpace
  attr_accessor :name, :price, :owner

  def initialize(name, price)
    @name = super(name)
    @price = price
    @owner = nil
  end

  def action(player, game, dice_total)
    if @owner.nil?
      handle_unowned_property(player, game)
    elsif @owner != player
      rent = current_rent(dice_total)
      charge_rent(player, game, rent)
    end
  end

  def current_rent(dice_roll)
    utility_count = owner.properties.count { |property| property.is_a?(Utility) }

    multiplier = utility_count == 2 ? 10 : 4

    dice_roll * multiplier
  end

  def total_value
    price
  end
end

class Card
  attr_accessor :name, :action

  def initialize(name, &action)
    @name = name
    @action = action
  end
end

class CardSpace < BoardSpace
  attr_accessor :name

  def initialize(name)
    super(name)
  end
end

class ChanceCardSpace < CardSpace
  def action(player, game, dice_roll)
    card = game.chance_cards.pop
    card.action.call(player, game, dice_roll)
    game.chance_cards.unshift(card)
  end
end

class CustomJestCardSpace < CardSpace
  def action(player, game, dice_roll)
    card = game.custom_jest_cards.pop
    card.action.call(player, game, dice_roll)
    game.custom_jest_cards.unshift(card)
  end
end

class ChanceCard < Card
  def self.create_deck
    [
      Card.new('Advance to Go Position - 200$') do |player, _game|
        player.position = MonopolyGame::GO_POSITION
        player.update_money(MonopolyGame::SALARY)
      end,
      Card.new('Advance to St Charles Place') do |player, game|
        player.position = 24
        game.handle_space(player, 0)
      end,
      Card.new('Advance to Illinois Place') do |player, game|
        player.position = 11
        game.handle_space(player, 0)
      end,
      Card.new('Advance to Nearest Utility') do |player, game|
        current_position = player.position
        if current_position < 12 || current_position > 28
          player.position = 12
        else
          player.position = 28
        end
        game.handle_space(player, 0)
      end,
      Card.new('Advance to Nearest Railroad') do |player, game|
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
      Card.new('Go to Jail') do |player, game|
        game.go_to_jail(player)
      end,
      Card.new('Give player 1 get out of jail card') do |player, _game|
        player.add_get_out_of_jail_card
      end,
      Card.new('Go Back 3 spaces') do |player, game|
        player.position = (player.position - 3) % MonopolyGame::BOARD_SPACES
        game.handle_space(player, 0)
      end,
      Card.new('You have been selected for street repairs, 25$ for houses, 100$ for hotel') do |player, _game|
        total_cost = 0
        player.properties.each do |property|
          next unless property.is_a?(Property)

          total_cost = total_cost + property.houses * 25 + (property.hotel ? 100 : 0)
        end
        player.update_money(-total_cost)
      end,
      Card.new('Bank has paid you a dividend of 50$') do |player, _game|
        player.update_money(50)
      end
    ]
  end
end

class CustomJestCard < Card
  def self.create_deck
    [
      Card.new('You have inherited 100$') do |player, _game|
        player.update_money(100)
      end,
      Card.new('You have advanced to Go Position Collect 200$') do |player, _game|
        player.update_money(MonopolyGame::SALARY)
        player.position = MonopolyGame::GO_POSITION
      end,
      Card.new('Bank has made an error in your favor collect 200$') do |player, _game|
        player.update_money(MonopolyGame::SALARY)
      end,
      Card.new('From Sale of Stock 50$') do |player, _game|
        player.update_money(50)
      end,
      Card.new('You have won 2nd prize in beauty contest 10$') do |player, _game|
        player.update_money(10)
      end,
      Card.new('Holiday Fund matures - 100$') do |player, _game|
        player.update_money(100)
      end,
      Card.new('Life Insurance matures - 100$') do |player, _game|
        player.update_money(100)
      end,
      Card.new('Income Tax Refund 50$') do |player, _game|
        player.update_money(50)
      end,
      Card.new('Consultancy Fees 25$') do |player, _game|
        player.update_money(25)
      end,
      Card.new('Hospital Fees - 100$') do |player, _game|
        player.update_money(-100)
      end,
      Card.new('School Fees - 50$') do |player, _game|
        player.update_money(-50)
      end,
      Card.new('Doctor Fees - 50$') do |player, _game|
        player.update_money(-50)
      end,
      Card.new('Go to Jail') do |player, game|
        game.go_to_jail(player)
      end,
      Card.new('Player has earned Get out of Jail Card') do |player, _game|
        player.add_get_out_of_jail_card
      end,
      Card.new('You have been selected for Street Repairs') do |player, _game|
        total_cost = 0
        player.properties.each do |property|
          next unless property.is_a?(Property)

          total_cost += property.houses * 25 + (property.hotel ? 100 : 0)
        end
        player.update_money(-total_cost)
      end
    ]
  end
end

class Tax < BoardSpace
  attr_accessor :name, :price

  def initialize(name, price)
    super(name)
    @price = price
  end

  def action(player, game, dice_roll)
    player.update_money(-price)
  end
end

class Board
  attr_accessor :spaces

  PROPERTY_GROUPS = {
    'Brown' => 2,
    'Light Blue' => 3,
    'Pink' => 3,
    'Orange' => 3,
    'Red' => 3,
    'Yellow' => 3,
    'Green' => 3,
    'Dark Blue' => 3
  }.freeze

  def initialize
    setup_spaces
  end

  def setup_spaces
    @spaces = [
      BoardSpace.new('Go'),

      Property.new('Mediterranean Avenue', 60, 'Brown', [2, 10, 30, 90, 160, 250]),
      CustomJestCardSpace.new('CustomJestCardSpace'),
      Property.new('Baltic Avenue', 60, 'Brown', [4, 20, 60, 180, 320, 450]),

      Tax.new('Income Tax', 200),
      Railroad.new('Reading Railroad', 200),

      Property.new('Oriental Avenue', 100, 'Light Blue', [6, 30, 90, 270, 400, 550]),
      ChanceCardSpace.new('ChanceCardSpace'),
      Property.new('Vermont Avenue', 100, 'Light Blue', [6, 30, 90, 270, 400, 550]),
      Property.new('Connecticut Avenue', 120, 'Light Blue', [8, 40, 100, 300, 450, 600]),

      BoardSpace.new('Jail'),

      Property.new('St Charles Place', 140, 'Pink', [10, 50, 150, 450, 625, 750]),
      Utility.new('Electric Company', 150),
      Property.new('States Avenue', 140, 'Pink', [10, 50, 150, 450, 625, 750]),
      Property.new('Virginia Avenue', 160, 'Pink', [12, 60, 180, 500, 700, 900]),

      Railroad.new('Pennsylvania Railroad', 200),
      Property.new('St James Place', 180, 'Orange', [14, 70, 200, 550, 750, 950]),
      CustomJestCardSpace.new('CustomJestCardSpace'),
      Property.new('Tennesse Avenue', 160, 'Orange', [14, 70, 200, 550, 750, 950]),
      Property.new('New York Avenue', 180, 'Orange', [16, 80, 220, 600, 800, 1000]),

      BoardSpace.new('Free Parking'),
      Property.new('Kentucky Avenue', 220, 'Red', [18, 90, 250, 700, 875, 1050]),
      ChanceCardSpace.new('ChanceCardSpace'),
      Property.new('Indiana Avenue', 220, 'Red', [18, 90, 250, 700, 875, 1050]),
      Property.new('Illinois Avenue', 240, 'Red', [20, 100, 300, 750, 925, 1100]),

      Railroad.new('B&O Railroad', 200),
      Property.new('Atlantic Avenue', 260, 'Yellow', [22, 110, 330, 800, 975, 1150]),
      Property.new('Ventnor Avenue', 280, 'Yellow', [22, 110, 330, 800, 975, 1150]),
      Utility.new('Water Works', 150),
      Property.new('Marvin Gardens', 300, 'Yellow', [24, 120, 360, 850, 1025, 1200]),

      BoardSpace.new('Go to Jail'),
      Property.new('Pacific Avenue', 350, 'Green', [26, 130, 390, 900, 1100, 1275]),
      Property.new('North Carolina Avenue', 350, 'Green', [26, 130, 390, 900, 1100, 1275]),
      CustomJestCardSpace.new('CustomJestCardSpace'),
      Property.new('Pennsylvania Avenue', 350, 'Green', [28, 150, 450, 1000, 1200, 1400]),

      Railroad.new('Short Lines', 100),
      ChanceCardSpace.new('ChanceCardSpace'),
      Property.new('Park Place', 400, 'Dark Blue', [35, 175, 500, 1100, 1300, 1500]),
      Tax.new('Luxury Tax', 200),
      Property.new('Boardwalk', 450, 'Dark Blue', [50, 200, 600, 1400, 1700, 2000])
    ]
  end
end

def test
  player_names = ['Raj Kiran', 'James Anderson', 'Neo', 'Charles Ran']
  mg = MonopolyGame.new(player_names)
  mg.play_game
end

test
