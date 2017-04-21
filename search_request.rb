require 'net/http'

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
