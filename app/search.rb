# Wrap the IndexTank search lib
module Search
    
  def self.search(query)
    # parse the advanced options out of the string
    repo_terms = parse_in_option(query)
  end
  
  # parses out the advanced search terms when using "in:"
  def self.parse_in_option(query)
    in_terms = query.scan /in:\s?(\S+)/
    in_terms.flatten
  end
  
end