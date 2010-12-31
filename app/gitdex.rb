require "app/repos"
require "app/search"
require "uri"
require "cgi" # used for url encoding

set :views, File.dirname(__FILE__) + '/views'
set :public, File.dirname(__FILE__) + '/public'

configure do
  uri = URI.parse(ENV["REDISTOGO_URL"])
  REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end


get '/' do  
  # split the repos up into 4 groups for the listing
  repos = []
  available_repos.sort.each_slice(5) { |repo_list| repos << repo_list }

  # pull the most recent searches from redis
  searches = REDIS.lrange "searches", 0, 10
  
  haml :home, :locals => { :repos => repos, :searches => searches }
end


get '/search' do
  # remove the oldest search, and push this search onto the list
  if params[:page].nil? || params[:page] == 0
    # get the last element pushed onto the list without removing it
    index = REDIS.llen("searches") - 1
    last = REDIS.lrange("searches", index, index).first
    
    REDIS.lpop("searches") if REDIS.llen("searches") >= 10
    REDIS.rpush("searches", params[:query]) if params[:query] != last
  end
  
  page = params[:page].to_i || 0
  per_page = 10
  
  start = page * per_page
  show_prev = (start > 0)
  
  # perform the search
  results = Search.search params[:query], start
  show_next = (start + per_page < results["matches"])
  
  haml :search, :locals => { :results => results["results"], :show_prev => show_prev, :show_next => show_next, :page => page }
end