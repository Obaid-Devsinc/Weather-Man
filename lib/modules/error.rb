# frozen_string_literal: true

# Handles errors by printing a message and exiting.
module WeatherErrorModule
  def error(message)
    puts "Error: #{message}"
    exit
  end
end
