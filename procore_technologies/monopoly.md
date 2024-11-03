Monopoly is a well-known board game involving players moving around a game board to buy, sell, and trade properties, with the goal of accumulating wealth and bankrupting other players.

Here’s a basic Ruby implementation of a Monopoly game, focusing on the core structure and game logic, such as moving around the board, managing properties, and handling player turns.

Monopoly Game Design:

The essential components to model in the game include:

    •	Players: Each player has money, properties, and can take actions (buy, sell, trade).
    •	Board: The game board consists of various spaces (properties, chance/community chest, taxes, jail, etc.).
    •	Properties: Some board spaces are buyable, and each property has a price and rent.
    •	Bank: The bank holds money and handles the transactions.

How the Game Works:

    1.	Players: Each player starts with a set amount of money (e.g., $1500) and moves around the board by rolling dice. Each player has a list of properties and a position on the board.
    2.	Board: The board is made up of spaces that the player can land on. Spaces can be properties that the player can buy or taxes that the player must pay. You can extend the spaces to include “Chance” and “Community Chest” cards, “Go to Jail”, etc.
    3.	Turn Mechanism: Each player takes turns rolling dice to move around the board. After moving, the player lands on a space, and the appropriate action is taken (e.g., buying a property or paying rent).
    4.	Money and Bankruptcy: Players lose money by paying taxes or rent, and gain money by passing “Go” or receiving rent from other players. A player becomes bankrupt if they run out of money.
    5.	Game Over: The game continues until only one player is not bankrupt, who is then declared the winner.
