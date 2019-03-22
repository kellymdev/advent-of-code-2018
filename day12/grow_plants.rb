# frozen_string_literal: true
require 'byebug'

class GrowPlants
  PLANT_OFFSET = 20
  GENERATIONS = 20

  INITIAL_STATE_REGEX = /initial state: ([#.]+)/
  RULE_REGEX = /([#.]{5}) => ([#.])/

  PLANT = '#'
  SOIL = '.'

  attr_reader :initial_state, :rules, :plants

  def initialize(initial_state, rules)
    @initial_state = format_initial_state(initial_state)
    @rules = format_rules(rules)
    @plants = []
  end

  def find_pots_containing_plants
    plot_initial_state

    while plants.size <= GENERATIONS
      grow_plants

      display_current_generation
    end

    sum_of_pot_numbers = calculate_sum_of_pot_numbers

    display_sum_of_pot_numbers(sum_of_pot_numbers)
  end

  private

  def format_initial_state(initial_state)
    initial_state.match(INITIAL_STATE_REGEX)[1].chars
  end

  def format_rules(rules)
    rule_list = {}

    instructions = rules.split("\n")

    instructions.each do |instruction|
      matches = instruction.match(RULE_REGEX)

      rule_list[matches[1]] = matches[2]
    end

    rule_list
  end

  def plot_initial_state
    @plants << new_soil_array + initial_state + new_soil_array
  end

  def new_soil_array
    Array.new(PLANT_OFFSET) { SOIL }
  end

  def grow_plants
    next_generation = []

    current_generation.each.with_index do |pot_contents, index|
      sequence = []

      (-2..2).each do |pot_count|
        if pot_count.zero?
          sequence << pot_contents
        elsif index_out_of_range?(index, pot_count)
          sequence << SOIL
        else
          sequence << current_generation[index + pot_count]
        end
      end

      next_generation[index] = if plant?(rules[sequence.join])
                                 PLANT
                               else
                                 SOIL
                               end
    end

    @plants << next_generation
  end

  def index_out_of_range?(index, pot_count)
    index.zero? && pot_count == -2 || index.zero? && pot_count == -1 || index == 1 && pot_count == -2 || index + pot_count >= current_generation.size
  end

  def plant?(value)
    value == PLANT
  end

  def current_generation
    plants.last
  end

  def calculate_sum_of_pot_numbers
    current_generation.map.with_index do |pot_contents, index|
      next unless plant?(pot_contents)

      index - PLANT_OFFSET
    end.compact.reduce(:+)
  end

  def display_current_generation
    puts current_generation.join
  end

  def display_sum_of_pot_numbers(sum_of_pot_numbers)
    puts "Sum of pot numbers: #{sum_of_pot_numbers}"
  end
end
