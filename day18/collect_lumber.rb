# frozen_string_literal: true

class CollectLumber
  OPEN_GROUND = '.'
  TREES = '|'
  LUMBERYARD = '#'

  attr_reader :forest_map, :minutes

  def initialize(map_string, minutes = 10)
    @forest_map = format_map(map_string)
    @minutes = minutes
  end

  def calculate_resource_value
    while minutes > 0
      new_map = deep_copy(forest_map)

      forest_map.each.with_index do |row, row_index|
        row.each.with_index do |cell, column_index|
          surroundings = find_surrounding_cells(row_index, column_index)

          new_map[row_index][column_index] = case cell
          when OPEN_GROUND
            determine_open_acre_status(surroundings)
          when TREES
            determine_tree_status(surroundings)
          when LUMBERYARD
            determine_lumberyard_status(surroundings)
          end
        end
      end

      @forest_map = new_map
      @minutes -= 1

      display_map
    end

    value = resource_value
    display_resource_value(value)
  end

  private

  def deep_copy(array)
    Marshal.load(Marshal.dump(array))
  end

  def map_width
    forest_map.first.size
  end

  def map_height
    forest_map.size
  end

  def find_surrounding_cells(row_index, column_index)
    surrounding_cells = []

    top_row = row_index - 1
    bottom_row = row_index + 1
    left_column = column_index - 1
    right_column = column_index + 1

    if top_row >= 0
      if left_column >= 0
        surrounding_cells << forest_map[top_row][left_column]
      end

      surrounding_cells << forest_map[top_row][column_index]

      if right_column < map_width
        surrounding_cells << forest_map[top_row][right_column]
      end
    end

    if left_column >= 0
      surrounding_cells << forest_map[row_index][left_column]
    end

    if right_column < map_width
      surrounding_cells << forest_map[row_index][right_column]
    end

    if bottom_row < map_height
      if left_column >= 0
        surrounding_cells << forest_map[bottom_row][left_column]
      end

      surrounding_cells << forest_map[bottom_row][column_index]

      if right_column < map_width
        surrounding_cells << forest_map[bottom_row][right_column]
      end
    end

    surrounding_cells
  end

  def determine_open_acre_status(surroundings)
    if surroundings.count(TREES) >= 3
      TREES
    else
      OPEN_GROUND
    end
  end

  def determine_tree_status(surroundings)
    if surroundings.count(LUMBERYARD) >= 3
      LUMBERYARD
    else
      TREES
    end
  end

  def determine_lumberyard_status(surroundings)
    if surroundings.count(LUMBERYARD) >= 1 && surroundings.count(TREES) >= 1
      LUMBERYARD
    else
      OPEN_GROUND
    end
  end

  def format_map(map_string)
    rows = map_string.split("\n")
    rows.map do |row|
      row.split('')
    end
  end

  def resource_value
    flattened_map = forest_map.flatten
    trees = flattened_map.count(TREES)
    lumberyards = flattened_map.count(LUMBERYARD)

    display_resources(trees, lumberyards)

    trees * lumberyards
  end

  def display_resources(trees, lumberyards)
    puts "Trees: #{trees}"
    puts "Lumberyards: #{lumberyards}"
  end

  def display_map
    puts "Minutes to go: #{minutes}"

    forest_map.each do |row|
      row.each do |cell|
        print cell
      end

      puts
    end
  end

  def display_resource_value(value)
    puts "Resource value: #{value}"
  end
end
