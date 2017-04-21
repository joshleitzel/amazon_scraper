class Suggestion
  attr_reader :query, :keyword, :meta, :departments

  def initialize(query:, keyword:, meta:)
    @keyword = keyword
    @meta = meta
    @departments = (meta['nodes'] || []).map { |node| node['name'] }.join('; ')
    @query = query
  end

  def to_hash
    {
      query: query,
      keyword: keyword,
      departments: departments
    }
  end

  def to_text
    sprintf "%-20s %-30s %-40s\n", query, keyword, departments
  end
end
