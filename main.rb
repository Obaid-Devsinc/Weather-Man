require_relative 'lib/cli/cli'
require_relative 'lib/reports/report'

if __FILE__ == $PROGRAM_NAME
  arguments = WeatherReportCLI.new(ARGV)
  WeatherReport.new(arguments).generate_report
end
