# frozen_string_literal: true

require_relative '../utils/helpers'

module WeatherReportUtility
  include WeatherCLIUtility

  # _______Report utilty functions__________

  def read_weather_rows(path)
    CSV.read(path, headers: true)
  end

  def extract_values(rows, column)
    rows.filter_map do |row|
      value = row[column]
      value&.to_f
    end
  end

  def process_year_file(file, stats, dir)
    CSV.foreach(file, headers: true) do |row|
      date = case dir
             when 'lahore_weather', 'Murree_weather'
               row['PKT']&.strip
             when 'Dubai_weather'
               row['GST']&.strip
             end

      next unless date

      find_max_temp(row, stats, date)
      find_min_temp(row, stats, date)
      find_max_humidity(row, stats, date)
    end
  end

  def find_max_temp(row, stats, date)
    return unless row['Max TemperatureC']

    temp = row['Max TemperatureC'].to_f
    return unless temp > stats[:max_temp]

    stats[:max_temp] = temp
    stats[:max_temp_day] = date
  end

  def find_min_temp(row, stats, date)
    return unless row['Min TemperatureC']

    temp = row['Min TemperatureC'].to_f
    return unless temp < stats[:min_temp]

    stats[:min_temp] = temp
    stats[:min_temp_day] = date
  end

  def find_max_humidity(row, stats, date)
    return unless row['Max Humidity']

    hum = row['Max Humidity'].to_f
    return unless hum > stats[:max_humidity]

    stats[:max_humidity] = hum
    stats[:max_humidity_day] = date
  end

  def print_yearly_stats(stats)
    puts "Highest: #{stats[:max_temp]}C on #{format_date_short(stats[:max_temp_day])}"
    puts "Lowest: #{stats[:min_temp]}C on #{format_date_short(stats[:min_temp_day])}"
    puts "Humid: #{stats[:max_humidity]}% on #{format_date_short(stats[:max_humidity_day])}"
  end

  def load_daily_data_for_month(month_num)
    daily_data = []

    CSV.foreach(@path, headers: true) do |row|
      date = row['GST']&.strip
      next if date.nil?

      y, m, d = parse_date(date)
      next unless y == @year.to_i && m == month_num

      daily_data << build_daily_data(row, d)
    end

    daily_data
  end

  def parse_date(date_string)
    date_string.split('-').map(&:to_i)
  end

  def build_daily_data(row, day)
    {
      day: day.to_s.rjust(2, '0'),
      max: row['Max TemperatureC']&.to_i,
      min: row['Min TemperatureC']&.to_i
    }
  end

  def display_daily_temperatures(daily_data, month_name, year)
    puts "#{month_name} #{year}"

    daily_data.each do |day|
      display_temperature(day, :max, "\e[31m") if day[:max]
      display_temperature(day, :min, "\e[34m") if day[:min]
    end
  end

  def display_temperature(day, type, color_code)
    temperature = day[type]

    print "#{day[:day]} "
    print "#{color_code}#{'+' * temperature}\e[0m "
    puts "#{temperature}C"
  end
end
