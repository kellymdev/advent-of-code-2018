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
  end

  private

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

      find_new_recipe(elf, moves)
    end
  end

  def find_new_recipe(elf, moves)
    
  end
end
