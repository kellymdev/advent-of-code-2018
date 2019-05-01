# frozen_string_literal: true

class GoblinBattle
  ATTACK_POWER = 3
  STARTING_HIT_POINTS = 200
  WALL = '#'
  OPEN = '.'
  ELF = 'elf'
  GOBLIN = 'goblin'

  attr_reader :battlefield, :round_count

  def initialize(battlefield_string)
    @battlefield = create_battlefield(battlefield_string)
    @round_count = 0
  end

  def battle_goblins
    while battle_in_progress?
      battlefield.each.with_index do |row, row_index|
        row.each.with_index do |cell, column_index|
          if cell_contains_unit?(cell)
            make_move(cell, row_index, column_index)
          end
        end
      end

      increment_round_count if battle_in_progress?
    end

    outcome = calculate_outcome_of_battle
    display_outcome(outcome)
  end

  private

  def create_battlefield(battlefield_string)
    rows = battlefield_string.split("\n")
    grid = rows.map do |row|
      row.split
    end

    grid.each.with_index do |row, row_index|
      row.each.with_index do |cell, column_index|
        if cell == 'G'
          grid[row_index][column_index] = { type: GOBLIN, hit_points: STARTING_HIT_POINTS }
        elsif cell == 'E'
          grid[row_index][column_index] = { type: ELF, hit_points: STARTING_HIT_POINTS }
        end
      end
    end

    grid
  end

  def battle_in_progress?
    grid_contains_unit?(GOBLIN) && grid_contains_unit?(ELF)
  end

  def grid_contains_unit?(unit_type)
    battlefield.flat_map do |row|
      row.select do |cell|
        cell_contains_unit_of_type?(cell, unit_type)
      end
    end.any?
  end

  def cell_contains_unit?(cell_content)
    cell.is_a?(Hash)
  end

  def cell_contains_unit_of_type?(cell_content, unit_type)
    cell_contains_unit?(cell_content) && cell[:type] == unit_type
  end

  def make_move(cell_content, row_index, column_index)
    target_coordinates = identify_target

    if target_coordinates
      attack_the_enemy(target_coordinates)
    else
      move_toward_closest_target
    end
  end

  def identify_target(cell_content, row_index, column_index)
    enemy = target_type(cell_content)

    potential_targets = []

    if row_index > 0
      top_range = battlefield[row_index - 1][column_index]

      if cell_contains_unit_of_type?(top_range, enemy)
        potential_targets << { target: top_range, row: row_index - 1, column: column_index }
      end
    end

    if column_index > 0
      left_range = battlefield[row_index][column_index - 1]

      if cell_contains_unit_of_type?(left_range, enemy)
        potential_targets << { target: left_range, row: row_index, column: column_index - 1 }
      end
    end

    if column_index < battlefield_width - 2
      right_range = battlefield[row_index][column_index + 1]

      if cell_contains_unit_of_type?(right_range, enemy)
        potential_targets << { target: right_range, row: row_index, column: column_index + 1 }
      end
    end

    if row_index < battlefield_height - 2
      bottom_range = battlefield[row_index + 1][column_index]

      if cell_contains_unit_of_type?(bottom_range, enemy)
        potential_targets << { target: bottom_range, row: row_index + 1, column: column_index }
      end
    end

    potential_targets.sort_by { |target| target[:target][:hit_points] }.first
  end

  def target_type(cell_content)
    case cell_content[:type]
    when GOBLIN
      ELF
    when ELF
      GOBLIN
    end
  end

  def attack_the_enemy(target_coordinates)
    target = target_coordinates[:target]
    target[:hit_points] -= ATTACK_POWER

    if target[:hitpoints] <= 0
      remove_target(target_coordinates)
    end

    @battlefield[target_coordinates[:row]][target_coordinates[:column]] = target
  end

  def remove_target(target_coordinates)
    @battlefield[target_coordinates[:row]][target_coordinates[:column]] = OPEN
  end

  def move_toward_closest_target(cell_content, row_index, column_index)
    enemy = target_type(cell_content)

    potential_targets = []
    
    
  end

  def battlefield_height
    battlefield.size
  end

  def battlefield_width
    battlefield.first.size
  end

  def increment_round_count
    @round_count += 1
  end

  def calculate_outcome_of_battle
    points = sum_hit_points_of_remaining_units
    round_count * points
  end

  def sum_hit_points_of_remaining_units
    remaining_units = battlefield.flat_map do |row|
      row.select do |cell|
        cell_contains_unit?(cell)
      end
    end

    remaining_units.map do |unit|
      unit[:hit_points]
    end.reduce(:+)
  end

  def display_outcome(outcome)
    puts "Battle outcome: #{outcome}"
  end
end
