# frozen_string_literal: true

class OrderInstructions
  INSTRUCTION_REGEX = /Step ([A-Z]) must be finished before step ([A-Z]) can begin./

  attr_reader :instructions, :steps, :completed_steps

  def initialize(instructions)
    @instructions = format_instructions(instructions)
    @steps = {}
    @completed_steps = []
  end

  def determine_order
    determine_prerequisites_for_steps

    first_step = determine_first_step
    complete_step(first_step)

    until all_steps_completed? do
      possible_steps = determine_next_available_steps
      next_step = choose_next_step(possible_steps)
      complete_step(next_step)
    end

    display_step_order(completed_steps.join)
  end

  private

  def format_instructions(instructions)
    split = instructions.split("\n")
  end

  def determine_prerequisites_for_steps
    instructions.each do |instruction|
      matches = instruction.match(INSTRUCTION_REGEX)

      prerequisite = matches[1]
      step = matches[2]

      create_step(prerequisite)
      create_step(step)

      @steps[step][:prerequisites] << prerequisite
    end
  end

  def create_step(step_letter)
    return if @steps.has_key?(step_letter)

    @steps[step_letter] = {
      prerequisites: []
    }
  end

  def determine_first_step
    next_step = steps.select { |step, step_data| step_data[:prerequisites].empty? }
    next_step.first.first
  end

  def complete_step(step_letter)
    @completed_steps << step_letter
  end

  def determine_next_available_steps
    possible_steps = steps.select do |step, step_data|
      (step_data[:prerequisites] - completed_steps).empty? && !completed_steps.include?(step)
    end

    possible_steps.keys
  end

  def choose_next_step(possible_steps)
    possible_steps.sort.first
  end

  def all_steps_completed?
    steps.keys.size == completed_steps.size
  end

  def display_step_order(step_order)
    puts "Step order: #{step_order}"
  end
end
