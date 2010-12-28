# Wrap the IndexTank search lib
module Search
    
  def self.search(query)
    # parse the advanced options out of the string
    repo_terms = parse_in_option(query)
    between_terms = parse_between_option(query)
    
    query = remove_in_option(query)
    query = remove_between_option(query)
    
    # construct the IndexTank search query
    search = ""
    fetch = "repo,message,date,author"
    repo_terms.each_with_index do |repo, index|
      search += "repo:#{repo} "
      search += "OR " if index < repo_terms.size
    end

    # add the other fields to the search string
    query.strip!
    search += "author:#{query} OR committer_name:#{query} OR message:#{query} OR diff_path:#{query} OR diff_files:#{query}"
    
    # connect to IndexTank and search
    api_base = IndexTank::Client.new ENV["INDEXTANK_API_URL"]
    repos_index = api_base.indexes "repos"
    
    repos_index.search search, :fetch => fetch
  end
  
  # parses out the advanced search terms when using "in:"
  def self.parse_in_option(query)
    in_terms = query.scan /in:\s?(\S+)/
    in_terms.flatten
  end
  
  def self.remove_in_option(query)
    query.gsub /in:\s?(\S+)/, ''
  end
  
  def self.parse_between_option(query)
    between_terms = query.scan /between:\s?(\S+) and (\S+)/
    between_terms.flatten!
    
    {:from => between_terms.first, :to => between_terms.last}
  end
  
  def self.remove_between_option(query)
    query.gsub /between:\s?(\S+) and (\S+)/, ''
  end
  
end