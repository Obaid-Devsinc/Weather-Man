# frozen_string_literal: true

require 'csv'
require_relative '../modules/error'
require_relative '../modules/report'

# Processes and reports weather data.
class WeatherReport
  include WeatherErrorModule
  include WeatherReportModule

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
