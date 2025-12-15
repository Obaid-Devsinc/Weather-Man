# frozen_string_literal: true

# Provides CLI-related validation methods for paths and dates.
module WeatherCliModule
  DATE_REGEX = %r{\A\d{4}/\d{1,2}\z}.freeze

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
