class Snowballer
  attr_reader :suggestions_library

  def initialize(suggestions_library:, log:)
    @suggestions_library = suggestions_library
    @log = log
  end

  def execute(max)
    count = 0

    reprocess_queries
    while !@queries.empty?
      # Don't re-process any queries that we've already processed

      count += 1
      return if count == max

      SearchRequest.new(query: @queries.first, suggestions_library: suggestions_library, log: @log)

      # Re-process query list so new keywords just found are added
      reprocess_queries
    end
  end

  private

  def reprocess_queries
    @queries = suggestions_library.keywords.map do |keyword|
      keyword.split(' ')
    end.flatten.uniq
    @queries = @queries.reject { |query| suggestions_library.query?(query) }
  end
end
