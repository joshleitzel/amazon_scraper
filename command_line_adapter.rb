require_relative 'snowballer'

class CommandLineAdapter
  attr_reader :options

  def initialize(options)
    @options = options
  end

  def execute
    log = Logger.new(options[:logfile] || STDOUT)

    suggestions_library = SuggestionsLibrary.new

    queries = options[:queries]

    if queries.nil? || queries.empty?
      # Looks like it’s up to us to generate a fun query!
      vowels = %w(a e i o u)
      consonants = ('a'..'z').to_a.reject { |letter| vowels.include?(letter) }
      queries = [ vowels.sample + consonants.sample ]
    end

    start_time = Time.now

    queries.each do |query|
      SearchRequest.new(query: query, suggestions_library: suggestions_library, log: log)
    end

    if options[:snowball]
      max_additional_requests = options[:snowball]
      Snowballer.new(suggestions_library: suggestions_library, log: log).execute(options[:snowball])
    end

    time_elapsed = Time.now - start_time

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

    query_count = suggestions_library.queries.count
    keyword_count = suggestions_library.keywords.count
    puts("\nSearched #{query_count} quer#{ query_count == 1 ? 'y' : 'ies' } and found #{keyword_count} result#{ keyword_count == 1 ? '' : 's' } in #{time_elapsed.round(2)} seconds")
  end
end
