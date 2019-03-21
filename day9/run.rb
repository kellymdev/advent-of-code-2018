require_relative 'marble_game'

# input = "9 players; last marble is worth 25 points"
# input = "10 players; last marble is worth 1618 points"
# input = "13 players; last marble is worth 7999 points"
# input = "17 players; last marble is worth 1104 points"
# input = "21 players; last marble is worth 6111 points"
# input = "30 players; last marble is worth 5807 points"

input = "400 players; last marble is worth 71864 points"

# Part One
game = MarbleGame.new(input, display_details: true)
game.calculate_score
