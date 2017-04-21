require 'json'

class SuggestionsLibrary
  attr_reader :queries, :keywords, :suggestions

  def initialize
    @suggestions = []
    @queries = []
    @keywords = []
  end

  def add(query:, keyword:, meta:)
    @queries << query unless query?(query)
    @keywords << keyword unless keyword?(keyword)
    @suggestions << Suggestion.new(query: query, keyword: keyword, meta: meta)
  end

  def to_json
    JSON.pretty_generate(suggestions.map(&:to_hash)) + "\n"
  end

  def to_text
    ([sprintf("%-20s %-30s %-40s\n\n", 'Query', 'Keywords', 'Departments')] + suggestions.map(&:to_text)).join
  end

  def query?(query)
    @queries.include?(query)
  end

  def keyword?(keyword)
    @keywords.include?(keyword)
  end
end
