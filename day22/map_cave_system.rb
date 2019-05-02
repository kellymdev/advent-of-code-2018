# frozen_string_literal: true

class MapCaveSystem
  ROCKY = '.'
  WET = '='
  NARROW = '|'

  RISK_LEVELS = {
    ROCKY => 0,
    WET => 1,
    NARROW => 2
  }

  attr_reader :depth, :target_x, :target_y, :cave

  def initialize(depth, target_x, target_y)
    @depth = depth
    @target_x = target_x
    @target_y = target_y
    @cave = create_cave
  end

  def calculate_cave_risk
    cave.each.with_index do |row, row_index|
      row.each.with_index do |cell, column_index|
        geologic_index = calculate_geologic_index(row_index, column_index)
        erosion_level = calculate_erosion_level(geologic_index)
        region_type = calculate_region_type(erosion_level)

        @cave[row_index][column_index] = {
          geologic_index: geologic_index,
          erosion_level: erosion_level,
          region_type: region_type,
          risk_level: RISK_LEVELS[region_type]
        }
      end
    end

    display_cave_map

    risk = calculate_total_risk
    display_total_risk(risk)
  end

  private

  def mouth_of_cave?(row_index, column_index)
    row_index == 0 && column_index == 0
  end

  def target_area?(row_index, column_index)
    row_index == target_y && column_index == target_x
  end

  def calculate_geologic_index(row_index, column_index)
    if mouth_of_cave?(row_index, column_index) || target_area?(row_index, column_index)
      0
    elsif row_index.zero?
      column_index * 16807
    elsif column_index.zero?
      row_index * 48271
    else
      cave[row_index][column_index - 1][:erosion_level] * cave[row_index - 1][column_index][:erosion_level]
    end
  end

  def calculate_erosion_level(geologic_index)
    (geologic_index + depth) % 20183
  end

  def calculate_region_type(erosion_level)
    case erosion_level % 3
    when 0
      ROCKY
    when 1
      WET
    when 2
      NARROW
    end
  end

  def create_cave
    Array.new(target_y + 1) { Array.new(target_x + 1) { nil } }
  end

  def calculate_total_risk
    cave.flat_map do |row|
      row.map do |cell|
        cell[:risk_level]
      end
    end.reduce(:+)
  end

  def display_total_risk(risk)
    puts "Total risk: #{risk}"
  end

  def display_cave_map
    cave.each do |row|
      row.each do |cell|
        print cell[:region_type]
      end

      puts
    end

    puts
  end
end
