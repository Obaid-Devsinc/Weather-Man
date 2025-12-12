# frozen_string_literal: true

require 'csv'
require_relative '../utils/report'
require_relative '../utils/helpers'

class WeatherReport
  include WeatherCLIUtility
  include WeatherReportUtility

  attr_reader :year, :path, :flag, :month

  def initialize(arguments)
    @year  = arguments.year
    @path  = arguments.path
    @flag  = arguments.flag
    @month = arguments.month if @flag == '-a' || @flag == '-c'
  end

  def yearly_weather_insights
    stats = {
      max_temp: -Float::INFINITY,
      min_temp: Float::INFINITY,
      max_humidity: -Float::INFINITY,
      max_temp_day: nil,
      min_temp_day: nil,
      max_humidity_day: nil
    }

    dir_name = File.basename(path)

    paths = Dir.glob(File.join(path, "#{dir_name}_#{year}_*.txt"))

    paths.each do |file|
      process_year_file(file, stats, dir_name)
    rescue CSV::MalformedCSVError => e
      puts "Warning: Skipping malformed CSV file #{File.basename(file)}: #{e.message}"
      next
    rescue StandardError => e
      puts "Warning: Error processing #{File.basename(file)}: #{e.message}"
      next
    end

    print_yearly_stats(stats)
  end

  def monthly_weather_insights
    rows = read_weather_rows(path)

    highest_temp = extract_values(rows, 'Max TemperatureC')
    lowest_temp  = extract_values(rows, 'Min TemperatureC')
    humidities   = extract_values(rows, 'Max Humidity')

    puts "Highest Temperature: #{average_of(highest_temp)}C"
    puts "Lowest Temperature: #{average_of(lowest_temp)}C"
    puts "Average Humidity: #{average_of(humidities)}%"
  end

  def visual_weather_insights
    month_num = month.to_i
    month_name = Date::MONTHNAMES[month_num]

    daily_data = load_daily_data_for_month(month_num)

    display_daily_temperatures(daily_data, month_name, year)
  end

  def generate_report
    case flag
    when '-e' then yearly_weather_insights
    when '-a' then monthly_weather_insights
    when '-c' then visual_weather_insights
    else
      error("Invalid flag. Must be '-e', '-a', or '-c'.")
    end
  end
end

# Bonus task also implemented

# def bonus_weather_insights
#   month_num = @month.to_i
#   month_name = Date::MONTHNAMES[month_num]
#
#   daily_data = []
#
#   CSV.foreach(@path, headers: true) do |row|
#     date = row['GST']&.strip
#     next if date.nil?
#     y, m, d = date.split('-').map(&:to_i)
#     next unless y == @year.to_i && m == month_num
#     max_t = row['Max TemperatureC']&.to_i
#     min_t = row['Min TemperatureC']&.to_i
#     daily_data << {
#       day: d.to_s.rjust(2, '0'),
#       max: max_t,
#       min: min_t
#     }
#   end
#
#   puts "#{month_name} #{@year}"
#
#   daily_data.each do |day|
#     max_t = day[:max] || 0
#     min_t = day[:min] || 0
#     next unless max_t.positive? || min_t.positive?
#     print "#{day[:day]} "
#     print "\e[34m#{'+' * min_t}\e[0m " if min_t.positive?
#     print "\e[31m#{'+' * max_t}\e[0m " if max_t.positive?
#     puts "#{day[:min]}C - #{day[:max]}C"
#   end
# end
