# frozen_string_literal: true

class CalculateTimeAsleep
  LOG_REGEX = /\[(\d{4}-\d{2}-\d{2} \d{2}:\d{2})\] (.+)/
  DATE_TIME_REGEX = /(\d{4}-\d{2}-\d{2}) \d{2}:(\d{2})/
  BEGINS_SHIFT_REGEX = /Guard #(\d+) begins shift/
  GUARD = 'Guard'
  SLEEP = 'falls'
  AWAKE = 'wakes'
  AWAKE_MARKER = '.'
  ASLEEP_MARKER = '#'

  attr_reader :guard_log, :guards

  def initialize(guard_log)
    @guard_log = format_guard_log(guard_log)
    @guards = {}
  end

  def calculate_guard_most_asleep
    prepare_data

    guard = find_sleepiest_guard
    time = calculate_time_most_asleep(guard)
    multiplied_result = multiply_result(guard[:number], time[:time])

    display_guard_and_sleep_details(guard, time[:time], multiplied_result)
  end

  def calculate_most_consistent_guard
    prepare_data

    frequencies = calculate_guard_sleep_frequencies

    guard_frequency = find_most_consistent_guard_from_frequencies(frequencies)

    multiplied_result = multiply_result(guard_frequency.first, guard_frequency.last[:time])

    display_consistent_guard_details(guard_frequency.first, guard_frequency.last[:time], multiplied_result)
  end

  private

  def format_guard_log(guard_log)
    logs = guard_log.split("\n")

    logs.map do |log_entry|
      matches = log_entry.match(LOG_REGEX)

      {
        date_time: matches[1],
        log: matches[2]
      }
    end
  end

  def prepare_data
    sort_guard_log
    record_guard_movements
  end

  def sort_guard_log
    @guard_log = guard_log.sort_by { |log| log[:date_time] }
  end

  def record_guard_movements
    current_guard = nil

    guard_log.each do |log|
      log_start = log[:log].split(' ').first

      case log_start
      when GUARD
        current_guard = log[:log].match(BEGINS_SHIFT_REGEX)[1]

        unless guards.has_key?(current_guard)
          guards[current_guard] = {
            sleep_start: 0,
            total_time_asleep: 0,
            raw_logs: []
          }
        end
      when SLEEP
        record_sleep(current_guard, log)
      when AWAKE
        record_wake_up(current_guard, log)
      end
    end
  end

  def record_sleep(guard, log)
    sleep_start = log[:date_time].match(DATE_TIME_REGEX)[2]
    @guards[guard][:sleep_start] = sleep_start.to_i
    @guards[guard][:raw_logs] << log
  end

  def record_wake_up(guard, log)
    sleep_end = log[:date_time].match(DATE_TIME_REGEX)[2]
    calculate_time_asleep(guard, sleep_end)
    @guards[guard][:sleep_start] = 0
    @guards[guard][:raw_logs] << log
  end

  def calculate_time_asleep(guard, sleep_end)
    time_asleep = sleep_end.to_i - guards[guard][:sleep_start]
    @guards[guard][:total_time_asleep] += time_asleep
  end

  def find_sleepiest_guard
    guard = guards.max_by { |_, guard_details| guard_details[:total_time_asleep] }
    {
      number: guard.first,
    }.merge!(guard.last)
  end

  def calculate_guard_sleep_frequencies
    frequencies = {}

    guards.each do |number, guard_details|
      frequencies[number] = calculate_time_most_asleep(guard_details)
    end

    frequencies
  end

  def calculate_time_most_asleep(guard)
    grouped_logs = guard[:raw_logs].group_by { |log| log[:date_time].match(DATE_TIME_REGEX)[1] }

    daily_logs = grouped_logs.map do |date, logs|
      plot_log_for_day(logs)
    end

    frequencies = calculate_sleep_frequencies(daily_logs)
    frequencies.max_by { |frequency| frequency[:frequency] }
  end

  def plot_log_for_day(logs)
    day = []
    60.times { day << AWAKE_MARKER }
    sleep_log = []

    logs.each do |log|
      log_start = log[:log].split(' ').first
      time = log[:date_time].match(DATE_TIME_REGEX)[2].to_i

      case log_start
      when SLEEP
        sleep_log << {
          sleep_start: time,
          sleep_end: nil
        }
      when AWAKE
        sleep_log.last[:sleep_end] = time
      end
    end

    sleep_log.each do |log|
      # exclusive range as sleep_end is marked as awake
      (log[:sleep_start]...log[:sleep_end]).each do |log_time|
        day[log_time] = ASLEEP_MARKER
      end
    end

    day
  end

  def calculate_sleep_frequencies(daily_logs)
    transposed = daily_logs.transpose

    if daily_logs.empty?
      [
        {
          time: 0,
          frequency: 0
        }
      ]
    else
      transposed.map.with_index do |time_log, time|
        {
          time: time,
          frequency: time_log.count(ASLEEP_MARKER)
        }
      end
    end
  end

  def multiply_result(guard_number, time)
    guard_number.to_i * time
  end

  def find_most_consistent_guard_from_frequencies(frequencies)
    frequencies.max_by { |guard_number, frequency| frequency[:frequency] }
  end

  def display_guard_and_sleep_details(guard, time, multiplied_result)
    puts "Most asleep guard: #{guard[:number]}"
    puts "Minutes asleep: #{guard[:total_time_asleep]}"
    puts "Most asleep minute: #{time}"
    puts "Multiplied together: #{multiplied_result}"
  end

  def display_consistent_guard_details(guard_number, time, multiplied_result)
    puts "Most consistent guard: #{guard_number}"
    puts "Most consistent minute: #{time}"
    puts "Multiplied together: #{multiplied_result}"
  end
end
