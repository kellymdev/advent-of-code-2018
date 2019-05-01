# frozen_string_literal: true

class Classification
  SAMPLE_REGEX = /Before: \[(\d+), (\d+), (\d+), (\d+)\]\n(\d+) (\d+) (\d+) (\d+)\nAfter:  \[(\d+), (\d+), (\d+), (\d+)\]/

  attr_reader :samples, :ambiguous_sample_count

  def initialize(sample_list)
    @samples = format_sample_list(sample_list)
    @ambiguous_sample_count = 0
  end

  def analyse_samples
    samples.each do |sample|
      opcodes = identify_possible_opcodes(sample)

      if opcodes >= 3
        increment_ambiguous_samples
      end
    end

    display_ambiguous_sample_count
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

  def increment_ambiguous_samples
    @ambiguous_sample_count += 1
  end

  def identify_possible_opcodes(sample)
    possible_opcodes = 0

    if addr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if addi(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if mulr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if muli(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if banr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if bani(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if borr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if bori(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if setr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if seti(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if gtir(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if gtri(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if gtrr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if eqir(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if eqri(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
    end

    if eqrr(sample[:before], sample[:instruction]) == sample[:after]
      possible_opcodes += 1
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

  def display_ambiguous_sample_count
    puts "Samples that behave like three or more opcodes: #{ambiguous_sample_count}"
  end
end
