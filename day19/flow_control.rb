# frozen_string_literal: true

class FlowControl
  INSTRUCTION_POINTER_REGEX = /#ip (\d+)/
  INSTRUCTION_REGEX = /(\w{4}) (\d+) (\d+) (\d+)/

  attr_reader :instruction_pointer, :instructions, :registers

  def initialize(instruction_string, starting_registers = Array.new(6) { 0 })
    @instruction_pointer = nil
    @instructions = format_instructions(instruction_string)
    @registers = starting_registers
  end

  def perform_instructions
    while pointer_in_program?
      instruction = instructions[registers[instruction_pointer]]

      @registers[instruction[:output_c]] = send(instruction[:instruction], instruction[:input_a], instruction[:input_b])

      @registers[instruction_pointer] += 1
    end

    display_value_in_register_0
  end

  private

  def pointer_in_program?
    registers[instruction_pointer] >= 0 && registers[instruction_pointer] < instructions.size
  end

  # Addition
  def addr(input_a, input_b)
    registers[input_a] + registers[input_b]
  end

  def addi(input_a, input_b)
    registers[input_a] + input_b
  end

  # Multiplication
  def mulr(input_a, input_b)
    registers[input_a] * registers[input_b]
  end

  def muli(input_a, input_b)
    registers[input_a] * input_b
  end

  # Bitwise AND
  def banr(input_a, input_b)
    registers[input_a] & registers[input_b]
  end

  def bani(input_a, input_b)
    registers[input_a] & input_b
  end

  # Bitwise OR
  def borr(input_a, input_b)
    registers[input_a] | registers[input_b]
  end

  def bori(input_a, input_b)
    registers[input_a] | input_b
  end

  # Assignment
  def setr(input_a, _input_b)
    registers[input_a]
  end

  def seti(input_a, _input_b)
    input_a
  end

  # Greater-than testing
  def gtir(input_a, input_b)
    if input_a > registers[input_b]
      1
    else
      0
    end
  end

  def gtri(input_a, input_b)
    if registers[input_a] > input_b
      1
    else
      0
    end
  end

  def gtrr(input_a, input_b)
    if registers[input_a] > registers[input_b]
      1
    else
      0
    end
  end

  # Equality testing
  def eqir(input_a, input_b)
    if input_a == registers[input_b]
      1
    else
      0
    end
  end

  def eqri(input_a, input_b)
    if registers[input_a] == input_b
      1
    else
      0
    end
  end

  def eqrr(input_a, input_b)
    if registers[input_a] == registers[input_b]
      1
    else
      0
    end
  end

  def format_instructions(instruction_string)
    instruction_list = instruction_string.split("\n")

    pointer_instruction = instruction_list.shift
    pointer_matches = pointer_instruction.match(INSTRUCTION_POINTER_REGEX)
    @instruction_pointer = pointer_matches[1].to_i

    instruction_list.map do |instruction|
      matches = instruction.match(INSTRUCTION_REGEX)

      {
        instruction: matches[1],
        input_a: matches[2].to_i,
        input_b: matches[3].to_i,
        output_c: matches[4].to_i
      }
    end
  end

  def display_value_in_register_0
    puts "Register 0: #{registers[0]}"
  end
end
