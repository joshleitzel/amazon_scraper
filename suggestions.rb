require 'logger'
require 'optparse'

require_relative 'lib/suggestion'
require_relative 'lib/suggestions_library'
require_relative 'lib/search_request'
require_relative 'lib/command_line_adapter'
require_relative 'lib/snowballer'

options = {}
OptionParser.new do |opts|
  opts.banner = 'Usage: suggestions.rb [options]'

  opts.on('-q', '--query [QUERY]', Array, 'Specify search query') do |queries|
    options[:queries] = queries
  end

  opts.on('-s', '--snowball [MAX_REQUESTS]', Integer, 'Snowball mode') do |snowball|
    options[:snowball] = snowball
  end

  opts.on('-o', '--output [OUTPUT_FILE]', String, 'Specify output file (defaults to STDOUT)') do |output_file|
    options[:output_file] = output_file
  end

  opts.on('-f', '--format [FORMAT]', String, "Output format ('text' or 'json', defaults to text)") do |format|
    options[:format] = format == 'json' ? 'json' : 'text'
  end

  opts.on('-l', '--log [LOGFILE]', String, 'Specify logfile (defaults to STDOUT)') do |logfile|
    options[:logfile] = logfile
  end
end.parse!

CommandLineAdapter.new(options).execute
