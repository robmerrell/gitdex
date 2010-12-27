# Wrap the IndexTank search lib
module Search
    
  def self.search(query)
    # parse the advanced options out of the string
    repo_terms = parse_in_option(query)
    between_terms = parse_between_option(query)
  end
  
  # parses out the advanced search terms when using "in:"
  def self.parse_in_option(query)
    in_terms = query.scan /in:\s?(\S+)/
    in_terms.flatten
  end
  
  def self.parse_between_option(query)
    between_terms = query.scan /between:\s?(\S+) and (\S+)/
    between_terms.flatten!
    
    {:from => between_terms.first, :to => between_terms.last}
  end
  
end