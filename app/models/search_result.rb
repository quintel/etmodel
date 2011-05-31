class SearchResult
  attr_accessor :title, :description

  def initialize(title, description)
    self.title       = title
    self.description = description
  end
end
