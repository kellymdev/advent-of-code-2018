# frozen_string_literal: true

class MakeHotChocolate
  attr_reader :number_of_recipes, :scores_required, :current_recipes, :recipe_board

  def initialize(number_of_recipes, scores_required: 10)
    @number_of_recipes = number_of_recipes
    @scores_required = scores_required
    @current_recipes = { '1' => 0, '2' => 1 }
    @recipe_board = [3, 7]
  end

  def find_scores
    while recipe_board.size < number_of_recipes + scores_required
      create_new_recipes

      pick_new_current_recipes
    end

    display_scores
  end

  def find_recipe_count
    while missing_puzzle_input?
      create_new_recipes

      pick_new_current_recipes
    end

    recipes = count_recipes
    display_recipe_count(recipes)
  end

  private

  def missing_puzzle_input?
    recipe_string = recipe_board.join
    recipe_string.match(/#{number_of_recipes}/).nil?
  end

  def create_new_recipes
    combined = combine_recipes

    if combined >= 10
      @recipe_board << 1
      @recipe_board << combined % 10
    else
      @recipe_board << combined
    end
  end

  def combine_recipes
    current_recipes.map do |_, recipe_index|
      recipe_board[recipe_index]
    end.reduce(:+)
  end

  def pick_new_current_recipes
    current_recipes.each do |elf, recipe_index|
      moves = 1 + recipe_board[recipe_index]

      current_recipes[elf] = find_new_recipe(elf, moves)
    end
  end

  def find_new_recipe(elf, moves)
    current_index = current_recipes[elf]

    (current_index += moves) % recipe_board.size
  end

  def count_recipes
    recipe_board.size - number_of_recipes.to_s.size
  end

  def display_scores
    puts recipe_board[-scores_required..-1].join('')
  end

  def display_recipe_count(recipes)
    puts "#{recipes} recipes"
  end
end
