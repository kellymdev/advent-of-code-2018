# frozen_string_literal: true

class DeterminePowerLevel
  FUEL_CELL_GROUP_SIZE = 3

  attr_reader :grid_serial_number, :fuel_grid, :fuel_cell_groups

  def initialize(grid_serial_number)
    @grid_serial_number = grid_serial_number
    @fuel_grid = create_fuel_grid
    @fuel_cell_groups = []
  end

  def find_largest_power
    calculate_fuel_remaining

    calculate_fuel_cell_group_powers

    most_powerful = find_most_powerful_fuel_cell_group

    display_most_powerful_group(most_powerful)
  end

  def find_largest_square
    calculate_fuel_remaining

    calculate_large_fuel_cell_group_powers

    largest_square = find_most_powerful_fuel_cell_group

    display_largest_square(largest_square)
  end

  private

  def create_fuel_grid
    Array.new(299) { Array.new(299) { nil } }
  end

  def calculate_fuel_remaining
    fuel_grid.each.with_index do |row, y_value|
      row.each.with_index do |_, x_value|
        fuel = calculate_fuel_level(x_value + 1, y_value + 1) # fuel cells are 1-indexed rather than 0-indexed
        @fuel_grid[y_value][x_value] = fuel
      end
    end
  end

  def calculate_fuel_level(x_coordinate, y_coordinate)
    rack_id = rack_id(x_coordinate)
    power_level = initial_power_level(rack_id, y_coordinate)
    power_level += grid_serial_number
    power_level = power_level * rack_id
    power_level = find_hundreds_digit(power_level)
    power_level - 5
  end

  def rack_id(x_coordinate)
    x_coordinate + 10
  end

  def initial_power_level(rack_id, y_coordinate)
    rack_id * y_coordinate
  end

  def find_hundreds_digit(value)
    value.to_s.chars[-3].to_i
  end

  def calculate_fuel_cell_group_powers(group_size = FUEL_CELL_GROUP_SIZE)
    fuel_grid.each.with_index do |row, y_value|
      next if y_value > fuel_grid_boundary_offset(group_size)

      row.each.with_index do |cell, x_value|
        next if x_value > fuel_grid_boundary_offset(group_size)

        total_power = calculate_group_power(x_value, y_value, group_size)

        group = {
          x_coordinate: x_value + 1,
          y_coordinate: y_value + 1,
          group_size: group_size,
          total_power: total_power
        }

        fuel_cell_groups << group
      end
    end
  end

  def calculate_large_fuel_cell_group_powers
    (FUEL_CELL_GROUP_SIZE..fuel_grid.size).each do |group_size|
      display_group_size(group_size)

      calculate_fuel_cell_group_powers(group_size)
    end
  end

  def calculate_group_power(x_value, y_value, group_size)
    power = 0

    group_size.times do |y_index|
      group_size.times do |x_index|
        power += fuel_grid[y_value + y_index][x_value + x_index]
      end
    end

    power
  end

  def fuel_grid_boundary_offset(group_size)
    fuel_grid.size - group_size - 1
  end

  def find_most_powerful_fuel_cell_group
    fuel_cell_groups.max_by { |group| group[:total_power] }
  end

  def display_most_powerful_group(fuel_cell_group)
    puts "Total largest power: #{fuel_cell_group[:total_power]}"
    puts "Coordinates: #{fuel_cell_group[:x_coordinate]},#{fuel_cell_group[:y_coordinate]}"
  end

  def display_group_size(group_size)
    puts "Calculating group sizes of: #{group_size}"
  end

  def display_largest_square(fuel_cell_group)
    puts "Square with largest power:"
    puts " - Power: #{fuel_cell[:power]}"
    puts " - Coordinates: #{fuel_cell[:x_coordinate]},#{fuel_cell[:y_coordinate]},#{fuel_cell_group[:size]}"
  end
end
