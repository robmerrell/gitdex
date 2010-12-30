require "app/repos"
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
  page = params[:page].to_i || 0
  per_page = 10
  
  start = page * per_page
  show_prev = (start > 0)
  
  # perform the search
  results = Search.search params[:query], start
  show_next = (start + per_page < results["matches"])
  
  haml :search, :locals => { :results => results["results"], :show_prev => show_prev, :show_next => show_next, :page => page }
end