require 'json'

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
