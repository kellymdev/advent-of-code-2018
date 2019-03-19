# frozen_string_literal: true

class CalculateChecksum
  attr_reader :box_list, :two_letters, :three_letters

  def initialize(box_ids)
    @box_list = format_box_ids(box_ids)
    @two_letters = []
    @three_letters = []
  end

  def calculate
    @box_list.each do |box_id|
      frequencies = calculate_letter_frequencies(box_id)
      find_pairs(box_id, frequencies)
      find_triples(box_id, frequencies)
    end

    checksum = calculate_checksum
    display_checksum(checksum)
  end

  private

  def calculate_letter_frequencies(box_id)
    frequencies = {}

    box_id.chars.each do |letter|
      if frequencies.has_key?(letter)
        frequencies[letter] += 1
      else
        frequencies[letter] = 1
      end
    end

    frequencies
  end

  def format_box_ids(box_ids)
    box_ids.split("\n")
  end

  def find_pairs(box_id, frequencies)
    pairs = frequencies.select { |letter, frequency| frequency == 2 }

    unless pairs.empty?
      @two_letters << box_id
    end
  end

  def find_triples(box_id, frequencies)
    triples = frequencies.select { |letter, frequency| frequency == 3 }

    unless triples.empty?
      @three_letters << box_id
    end
  end

  def calculate_checksum
    @two_letters.size * @three_letters.size
  end

  def display_checksum(checksum)
    puts "Checksum: #{checksum}"
  end
end
