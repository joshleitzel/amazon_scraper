class CommandLineAdapter
  attr_reader :options

  def initialize(options)
    @options = options

    p 'opts', options
  end

  def execute
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
  end
end
