require "repos"
require "app/search"

set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'

get '/' do
  # split the repos up into 4 groups for the listing
  repos = []
  available_repos.sort.each_slice(5) { |repo_list| repos << repo_list }
  
  haml :home, :locals => { :repos => repos }
end


get '/search' do
  # perform the search
  results = Search.search params[:query]
  
  haml :search, :locals => { :results => results }
end