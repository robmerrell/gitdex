require "bundler"
require "app/search"
Bundler.require(:default)

desc "Load all of the repositories into IndexTank, expects INDEXTANK_API_URL"
task :load_repos do
  
  repos = [
    "danchoi/vmail",
    "rails/rails",
    "mongoid/mongoid",
    "seancribbs/ripple",
    "evanphx/rubinius",
    "thoughtbot/factory_girl",
    "git/git",
    "jquery/jquery",
    "mongodb/mongo",
    "antirez/redis",
    "ruby/ruby",
    "ry/node",
    "jashkenas/coffee-script",
    "pieter/gitx",
    "apache/httpd",
    "wayneeseguin/rvm",
    "django/django",
    "280north/cappuccino",
    "postgres/postgres",
    "v8/v8"
  ]

  # clean the repos dir
  system "rm -rf repos/*"

  api_base = IndexTank::Client.new ENV["INDEXTANK_API_URL"]
  repos_index = api_base.indexes "repos"

  repos.each do |repo|
    # clone the repo
    cmd = "git clone git://github.com/#{repo}.git repos/#{repo}"
    system cmd

    git = Git.open("repos/#{repo}")

    # iterate through all of the logs and get info about each commit
    git.log('999999999').each do |lobject|
      puts "Processing #{repo} / #{lobject.sha}"
      commit = git.gcommit(lobject.sha)

      diff_files = commit.diff_parent.stats[:files].keys.sort.join("\n")

      # collect info from the commit
      repo_info = {
        :repo => repo,
        :author => commit.author.name,
        :committer_name => commit.committer.name,
        :date => commit.date,
        :message => commit.message,
        :diff_patch => commit.diff_parent.patch,
        :diff_files => diff_files
      }

      # store log info on index tank
      begin
        repos_index.document(lobject.sha).add(repo_info)
      rescue
        puts "failed to store: #{lobject.sha}"
      end
    end
  end
  
end


require "rake/testtask"
desc "Run unit tests"
Rake::TestTask.new("test") { |t|
  t.pattern = 'tests/*_test.rb'
  t.verbose = true
  t.warning = false
}
