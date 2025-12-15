# frozen_string_literal: true

require_relative '../modules/cli'
require_relative '../modules/error'

# Handles CLI input validation and setup for weather reports.
class WeatherReportCLI
  include WeatherCliModule
  include WeatherErrorModule

  YEAR_REGEX = /\A\d{4}\z/.freeze

  attr_reader :flag, :month, :year, :path

  def initialize(argv)
    @flag, @date, @path = argv
    error('Please provide all arguments.') if @flag.nil? || @date.nil? || @path.nil?

    check_validity
  end

  private

  def check_validity
    case flag
    when '-e'
      error('Invalid year format') unless YEAR_REGEX.match?(@date)
      @year = @date
      validate_path(path, 'folder')
    when '-a', '-c'
      @month, @year = format_validate_date(@date)
      validate_path(path, 'file')
    else
      error("Invalid flag '#{flag}'. Must be '-e', '-a', or '-c'.")
    end
  end
end
