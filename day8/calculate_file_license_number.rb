# frozen_string_literal: true

class CalculateFileLicenseNumber
  attr_reader :metadata, :child_nodes_to_investigate

  def initialize(number_list)
    @data = format_data(number_list)
    @child_nodes_to_investigate = []
    @metadata_entries = []
  end

  def sum_metadata_entries
    find_child_nodes

    display_sum(sum)
  end

  private

  def format_data(number_list)
    entries = number_list.split(' ') - ["\n"]

    entries.map do |entry|
      entry.to_i
    end
  end

  def find_child_nodes
    data.each.with_index do |number, index|
      child_node_count = number
      metadata_entry_count = data[index + 1]

      if child_node_count >= 1
        @child_nodes_to_investigate << { index: index }
      end

      if metadata_entry_count >= 1
        (1..metadata_entry_count).each do |counter|
          @metadata_entries << data[index + counter]
          
        end
        
      end
    end
  end

  def display_sum(sum)
    puts "Sum of metadata: #{sum}"
  end
end
