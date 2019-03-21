require_relative 'calculate_file_license_number'

input = <<-INPUT
2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2
INPUT

# Part One
calculator = CalculateFileLicenseNumber.new(input)
calculator.sum_metadata_entries
