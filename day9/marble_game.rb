# frozen_string_literal: true

class MarbleGame
  GAME_REGEX = /(\d+) players; last marble is worth (\d+) points/
  STARTING_MARBLE = 0

  attr_reader :player_count, :last_marble, :player_scores, :circle, :current_marble, :marble_to_play, :current_player, :display_details

  def initialize(game_string, display_details: false)
    @player_count = game_string.match(GAME_REGEX)[1].to_i
    @last_marble = game_string.match(GAME_REGEX)[2].to_i
    @player_scores = create_player_scores_hash
    @circle = []
    @current_marble = nil
    @marble_to_play = 0
    @current_player = 0
    @display_details = display_details
  end

  def calculate_score
    while current_marble.nil? || current_marble < last_marble
      play_round
    end

    highest_score = find_highest_score

    display_highest_score(highest_score.first, highest_score.last)
  end

  private

  def play_round
    marble_number = marble_to_play

    if multiple_of_23?(marble_number)
      play_23_turn(marble_number)
    else
      place_marble(marble_number)
    end

    display_game_details if display_details

    increment_marble_to_play
    increment_current_player
  end

  def place_marble(marble_number)
    index_of_current_marble = circle.index(current_marble)
    index_to_insert = calculate_index_to_insert_at(index_of_current_marble)

    @circle.insert(index_to_insert, marble_number)

    @current_marble = marble_number
  end

  def calculate_index_to_insert_at(index_of_current_marble)
    return 0 if current_marble.nil?

    new_index = index_of_current_marble + 2

    if new_index > circle.size # size is correct here as we are adding a new record to the array
      new_index % circle.size
    else
      new_index
    end
  end

  def play_23_turn(marble_number)
    removed_score = remove_marble
    score_to_update = removed_score + marble_number
    update_player_score(score_to_update)
  end

  def remove_marble
    index_of_current_marble = circle.index(current_marble)
    index_of_marble_to_remove = index_of_current_marble - 7

    removed_marble = @circle.delete_at(index_of_marble_to_remove)

    @current_marble = circle[index_of_marble_to_remove]

    removed_marble
  end

  def update_player_score(score)
    @player_scores[current_player] += score
  end

  def increment_marble_to_play
    @marble_to_play += 1
  end

  def increment_current_player
    if current_player == player_count - 1
      @current_player = 0
    else
      @current_player += 1
    end
  end

  def create_player_scores_hash
    score_hash = {}

    player_count.times do |player_number|
      score_hash[player_number] = 0
    end

    score_hash
  end

  def multiple_of_23?(marble_number)
    return false if marble_number.zero?

    (marble_number % 23).zero?
  end

  def find_highest_score
    player_scores.max_by { |player, score| score }
  end

  def display_highest_score(player, score)
    puts "Player #{player} had the highest score."
    puts "The score was #{score}"
  end

  def display_game_details
    puts "Player: #{current_player}"
    puts "Marble to play: #{marble_to_play}"
    puts "Current marble: #{current_marble}"
    print circle
    puts
  end
end