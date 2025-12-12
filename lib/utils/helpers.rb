# frozen_string_literal: true

require_relative '../utils/helpers'

module WeatherCLIUtility
  DATE_REGEX = %r{\A\d{4}/\d{1,2}\z}

  # _______General utilty functions__________
  def error(message)
    puts "Error: #{message}"
    exit
  end

  def format_date_short(date_string)
    return 'N/A' if date_string.nil? || date_string.empty?

    date = Date.parse(date_string)
    date.strftime('%b %d')
  rescue Date::Error
    date_string
  end

  def average_of(arr)
    (arr.sum / arr.size).round(2)
  end

  # _______CLI utilty functions__________
  def validate_path(path, type)
    case type
    when 'folder'
      error("The path '#{path}' is not a valid folder.") unless Dir.exist?(path)
    when 'file'
      error("The path '#{path}' is not a valid file.") unless File.file?(path)
    else
      error("Invalid path type '#{type}'")
    end
  end

  def format_validate_date(date)
    error('Invalid date format. Must be in YYYY/MM format (e.g., 2024/01).') unless DATE_REGEX.match?(date)

    year, month = date.split('/').map(&:strip)

    month_num = month.to_i
    error('Invalid month. Must be between 1 and 12.') unless (1..12).cover?(month_num)

    [month_num.to_s, year]
  end
end
