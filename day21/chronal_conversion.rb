# frozen_string_literal: true

require_relative 'flow_control'

class ChronalConversion
  attr_reader :instruction_string

  def initialize(instruction_string)
    @instruction_string = instruction_string
  end

  def find_lowest_integer_to_halt
    counts = (0..1_000_000).map do |integer|
      display_progress(integer)

      {
        integer: integer,
        instruction_count: determine_instruction_count(integer)
      }
    end

    fewest = determine_fewest_instructions(counts)

    display_fewest_instructions(fewest)
  end

  private

  def determine_instruction_count(register_start_value)
    FlowControl.new(instruction_string, [register_start_value, 0, 0, 0, 0, 0]).perform_instructions
  end

  def determine_fewest_instructions(counts)
    counts.min_by { |integer, instruction_count| instruction_count }
  end

  def display_progress(integer)
    puts "Calculating instruction count for #{integer}"
  end

  def display_fewest_instructions(fewest_hash)
    puts "Fewest Instructions: Integer: #{fewest_hash[:integer]}, Instruction count: #{fewest_hash[:instruction_count]}"
  end
end
