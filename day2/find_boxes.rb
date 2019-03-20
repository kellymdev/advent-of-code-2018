# frozen_string_literal: true

class FindBoxes
  attr_reader :box_list, :sorted_boxes, :correct_boxes

  def initialize(box_ids)
    @box_list = format_box_list(box_ids)
    @sorted_boxes = {}
    @correct_boxes = {}
  end

  def find_boxes
    sort_boxes

    find_candidate_boxes

    letters = find_common_letters

    display_common_letters(letters)
  end

  private

  def format_box_list(box_ids)
    box_ids.split("\n")
  end

  def sort_boxes
    box_list.each do |box_id|
      start_letter = box_id[0]

      if sorted_boxes.has_key?(start_letter)
        @sorted_boxes[start_letter] << box_id
      else
        @sorted_boxes[start_letter] = [box_id]
      end
    end
  end

  def find_candidate_boxes
    sorted_boxes.each do |_, box_array|
      compare_boxes(box_array)
    end
  end

  def compare_boxes(box_array)
    box_array.size.times do |counter|
      candidate = box_array[counter].chars

      box_array.each.with_index do |box_id, index|
        next if index == counter

        difference = candidate - box_id.chars

        if difference.size == 1 && correct_boxes?(candidate, box_id.chars, difference)

          @correct_boxes = {
            box1: candidate,
            box2: box_id,
            difference: difference
          }

          return
        end
      end

      return unless correct_boxes.empty?
    end
  end

  def correct_boxes?(box_id1, box_id2, difference)
    return false if box_id1.count(difference.join) > 1

    index_of_difference = box_id1.index(difference.join)

    box_id1.delete_at(index_of_difference)
    box_id2.delete_at(index_of_difference)

    box_id1.join == box_id2.join
  end

  def find_common_letters
    correct_boxes[:box1] - correct_boxes[:difference]
  end

  def display_common_letters(letters)
    puts "Common letters: #{letters.join}"
  end
end
