# frozen_string_literal: true

require 'byebug'

class ClassifyOpcodes
  SAMPLE_REGEX = /Before: \[(\d+), (\d+), (\d+), (\d+)\]\n(\d+) (\d+) (\d+) (\d+)\nAfter:  \[(\d+), (\d+), (\d+), (\d+)\]/
  INSTRUCTION_REGEX = /(\d+) (\d+) (\d+) (\d+)/

  attr_reader :samples, :opcodes, :instructions, :registers

  def initialize(sample_list, instruction_list)
    @samples = format_sample_list(sample_list)
    @instructions = format_instructions(instruction_list)
    @opcodes = {}
    @registers = [0, 0, 0, 0]
  end

  def run_program
    identify_opcodes

    perform_instructions

    display_value_of_register_0
  end

  private

  def format_sample_list(sample_list)
    list = sample_list.split("\n\n")
    list.map do |sample|
      matches = sample.match(SAMPLE_REGEX)
      {
        before: [matches[1].to_i, matches[2].to_i, matches[3].to_i, matches[4].to_i],
        instruction: {
          opcode: matches[5].to_i,
          input_a: matches[6].to_i,
          input_b: matches[7].to_i,
          output_c: matches[8].to_i
        },
        after: [matches[9].to_i, matches[10].to_i, matches[11].to_i, matches[12].to_i]
      }
    end
  end

  def format_instructions(instruction_list)
    instructions = instruction_list.split("\n")
    instructions.map do |instruction|
      matches = instruction.match(INSTRUCTION_REGEX)
      {
        opcode: matches[1].to_i,
        input_a: matches[2].to_i,
        input_b: matches[3].to_i,
        output_c: matches[4].to_i
      }
    end
  end

  def identify_opcodes
    samples.each do |sample|
      possible_opcodes = identify_possible_opcodes(sample)

      if possible_opcodes.size == 1
        opcodes[sample[:instruction][:opcode]] = possible_opcodes.first
      end

      sample[:possible_opcodes] = possible_opcodes
    end
  end

  def identify_possible_opcodes(sample)
    possible_opcodes = []

    if addr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'addr'
    end

    if addi(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'addi'
    end

    if mulr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'mulr'
    end

    if muli(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'muli'
    end

    if banr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'banr'
    end

    if bani(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'bani'
    end

    if borr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'borr'
    end

    if bori(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'bori'
    end

    if setr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'setr'
    end

    if seti(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'seti'
    end

    if gtir(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'gtir'
    end

    if gtri(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'gtri'
    end

    if gtrr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'gtrr'
    end

    if eqir(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'eqir'
    end

    if eqri(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'eqri'
    end

    if eqrr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes << 'eqrr'
    end

    possible_opcodes
  end

  # Addition
  def addr(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] + before_values[instruction[:input_b]]
    output[instruction[:output_c]] = result

    output
  end

  def addi(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] + instruction[:input_b]
    output[instruction[:output_c]] = result

    output
  end

  # Multiplication
  def mulr(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] * before_values[instruction[:input_b]]
    output[instruction[:output_c]] = result

    output
  end

  def muli(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] * instruction[:input_b]
    output[instruction[:output_c]] = result

    output
  end

  # Bitwise AND
  def banr(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] & before_values[instruction[:input_b]]
    output[instruction[:output_c]] = result

    output
  end

  def bani(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] & instruction[:input_b]
    output[instruction[:output_c]] = result

    output
  end

  # Bitwise OR
  def borr(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] | before_values[instruction[:input_b]]
    output[instruction[:output_c]] = result

    output
  end

  def bori(before_values, instruction)
    output = before_values.clone
    result = before_values[instruction[:input_a]] | instruction[:input_b]
    output[instruction[:output_c]] = result

    output
  end

  # Assignment
  def setr(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = before_values[instruction[:input_a]]

    output
  end

  def seti(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = instruction[:input_a]

    output
  end

  # Greater-than testing
  def gtir(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = if instruction[:input_a] > before_values[instruction[:input_b]]
      1
    else
      0
    end

    output
  end

  def gtri(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = if before_values[instruction[:input_a]] > instruction[:input_b]
      1
    else
      0
    end

    output
  end

  def gtrr(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = if before_values[instruction[:input_a]] > before_values[instruction[:input_b]]
      1
    else
      0
    end

    output
  end

  # Equality testing
  def eqir(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = if instruction[:input_a] == before_values[instruction[:input_b]]
      1
    else
      0
    end

    output
  end

  def eqri(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = if before_values[instruction[:input_a]] == instruction[:input_b]
      1
    else
      0
    end

    output
  end

  def eqrr(before_values, instruction)
    output = before_values.clone
    output[instruction[:output_c]] = if before_values[instruction[:input_a]] == before_values[instruction[:input_b]]
      1
    else
      0
    end

    output
  end

  def perform_instructions
    instructions.each do |instruction|
      @registers = method(opcodes[instruction[:opcode]]).call(registers, instruction)
    end
  end

  def display_value_of_register_0
    puts "Register 0: #{registers.first}"
  end
end
