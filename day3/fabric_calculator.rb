# frozen_string_literal: true

class FabricCalculator
  INSTRUCTION_REGEX = /#(\d+)\s@\s(\d+),(\d+):\s(\d+)x(\d+)/
  BLANK_SQUARE = '.'
  MULTIPLE_CLAIM_SQUARE = '#'

  attr_reader :plans, :max_width, :max_height, :fabric, :display_grid

  def initialize(plan_list, display_grid:)
    @max_width = 0
    @max_height = 0
    @plans = format_plans(plan_list)
    @fabric = create_fabric
    @display_grid = display_grid
  end

  def calculate
    plans.each do |plan|
      plot_claim(plan)
    end

    display_claim_grid if display_grid

    claims_overlapping = calculate_number_of_claims_overlapping

    display_claims_overlapping(claims_overlapping)
  end

  private

  def format_plans(plan_list)
    instructions = plan_list.split("\n")

    instructions.map do |instruction|
      matches = instruction.match(INSTRUCTION_REGEX)

      claim = {
        claim_number: matches[1],
        left_edge_offset: matches[2].to_i,
        top_edge_offset: matches[3].to_i,
        width: matches[4].to_i,
        height: matches[5].to_i
      }

      update_max_dimensions(claim)

      claim
    end
  end

  def update_max_dimensions(claim)
    width_required = claim[:left_edge_offset] + claim[:width]

    if width_required > max_width
      @max_width = width_required
    end

    height_required = claim[:top_edge_offset] + claim[:height]

    if height_required > max_height
      @max_height = height_required
    end
  end

  def create_fabric
    Array.new(max_height) { Array.new(max_width) { BLANK_SQUARE } }
  end

  def plot_claim(claim)
    claim[:height].times do |y_index|
      claim[:width].times do |x_index|
        y_coordinate = claim[:top_edge_offset] + y_index
        x_coordinate = claim[:left_edge_offset] + x_index

        mark_fabric(claim[:claim_number], x_coordinate, y_coordinate)
      end
    end
  end

  def mark_fabric(claim_number, x_coordinate, y_coordinate)
    marker = if blank_fabric?(x_coordinate, y_coordinate)
               claim_number
             else
               MULTIPLE_CLAIM_SQUARE
             end

    @fabric[y_coordinate][x_coordinate] = marker
  end

  def blank_fabric?(x_coordinate, y_coordinate)
    fabric[y_coordinate][x_coordinate] == BLANK_SQUARE
  end

  def calculate_number_of_claims_overlapping
    fabric.map do |y_index|
      y_index.count(MULTIPLE_CLAIM_SQUARE)
    end.reduce(:+)
  end

  def display_claim_grid
    fabric.each do |row|
      row.each do |cell|
        print cell
      end

      puts
    end
  end

  def display_claims_overlapping(claims_overlapping)
    puts "Claims overlapping: #{claims_overlapping}"
  end
end
