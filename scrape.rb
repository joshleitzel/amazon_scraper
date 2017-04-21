require 'net/http'
require 'json'
require 'logger'
require 'optparse'

# TODO: Remove
require 'byebug'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-q", "--query [QUERY]", Array, "Specify search query") do |queries|
    options[:queries] = queries
  end

  opts.on("-o", "--output [OUTPUT_FILE]", String, "Specify suggestion output file (defaults to STDOUT)") do |output_file|
    options[:output_file] = output_file
  end

  opts.on("-f", "--format [FORMAT]", String, "Output format ('text' or 'json', defaults to text)") do |format|
    options[:format] = format == 'json' ? 'json' : 'text'
  end

  opts.on("-l", "--log [LOGFILE]", String, "Specify logfile (defaults to STDOUT)") do |logfile|
    options[:logfile] = logfile
  end
end.parse!

p 'opts', options

class Suggestion
  attr_reader :query, :keyword, :meta, :departments

  def initialize(query:, keyword:, meta:)
    @keyword = keyword
    @meta = meta
    @departments = (meta['nodes'] || []).map { |node| node['name'] }
    @query = query
  end

  def to_hash
    {
      query: query,
      keyword: keyword,
      meta: meta
    }
  end

  def to_json
    to_hash.to_json
  end

  def to_text
    sprintf "%-20s %-30s %-40s\n", query, keyword, departments.join(', ')
  end
end

class SuggestionsLibrary
  attr_reader :suggestions

  def initialize
    @suggestions = []
  end

  def add(query:, keyword:, meta:)
    @suggestions << Suggestion.new(query: query, keyword: keyword, meta: meta)
  end

  def to_json
    JSON.pretty_generate(suggestions.map(&:to_hash)) + "\n"
  end

  def to_text
    ([sprintf("%-20s %-30s %-40s\n\n", 'Query', 'Keywords', 'Departments')] + suggestions.map(&:to_text)).join
  end
end

class SearchRequest
  attr_accessor :suggestions_library, :query

  def initialize(query:, log:, suggestions_library:)
    @query = query
    @log = log
    @suggestions_library = suggestions_library

    fetch_suggestions_library
  end

  def fetch_suggestions_library
    @log.info "Requesting suggestions_library for #{query}..."
    uri = URI("https://completion.amazon.com/search/complete?method=completion&mkt=1&c=&p=Gateway&l=en_US&sv=desktop&client=amazon-search-ui&x=String&search-alias=aps&q=#{query}&qs=&cf=1&fb=1&sc=1&")
    response = Net::HTTP.get_response(uri)
    response_body = Net::HTTP.get_response(uri).body
    @log.info "Response (query: `#{query}`): #{response.code} #{response.message}"
    @log.info "Response body (query: `#{query}`): #{response_body}..."

    # The response comes back from Amazon as JavaScript. We could use a JS
    # parser to yank out the data we want, but to avoid additional dependencies
    # let's just chop off the beginning and end we don't need.
    response_body = response_body.split("\"#{query}\",")[1]
    response_body = response_body.split(';String();').first
    response_body = "[#{response_body}"

    # `response_body` is now a string representing an array, which we can turn into
    # an actual array using the JSON module
    objects = JSON.parse(response_body)

    keywords = objects[0]
    metadata = objects[1]
    etc = objects[2] # what goes here?
    token = objects[3] # what is this used for?

    # Let's convert these into actual objects we can work with.
    keywords.each_with_index do |keyword, index|
      suggestions_library.add(
        query: query,
        keyword: keyword,
        meta: metadata[index]
      )
    end
  end
end

log = Logger.new(options[:logfile] || STDOUT)

suggestions_library = SuggestionsLibrary.new

options[:queries].each do |query|
  SearchRequest.new(query: query, suggestions_library: suggestions_library, log: log)
end

if options[:format] == 'json'
  output = suggestions_library.to_json
else
  output = suggestions_library.to_text
end

if options[:output_file]
  File.write(options[:output_file], output)
else
  puts(output)
end
