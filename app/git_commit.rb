require "ostruct"

class GitCommit
  attr_accessor :repo_path
  
  def initialize(path)
    @repo_path = path + "/.git"
  end
  
  # get all commits
  def commits
    cmd = "git --no-pager --git-dir=#{@repo_path} log --pretty=format:'%H%x09%an%x09%cn%x09%at'"
    commit_logs = `#{cmd}`
    
    commits = []
    
    # parse out the data and store it in a commit object
    commit_logs.each_line do |line|
      commit_info = line.split("\t")
      
      commit = OpenStruct.new
      commit.sha = commit_info[0].strip
      commit.message = message(commit.sha)
      commit.author = commit_info[1].strip
      commit.committer = commit_info[2].strip
      commit.commit_timestamp = commit_info[3].strip
      commit.diff_files = modified_files(commit.sha)
      commit.diff_patch = diff(commit.sha)
      
      commits << commit
    end
    
    return commits
  end


  # get the message of a commit
  def message(sha)
    cmd = "git --no-pager --git-dir=#{@repo_path} show --pretty=format:'%s' -s #{sha}"
    `#{cmd}`
  end
  
  
  # get the diff of the commit
  def diff(sha)
    cmd = "git --no-pager --git-dir=#{@repo_path} show --pretty='format:' #{sha}"
    `#{cmd}`
  end
  
  
  # get the files modified in a commit
  def modified_files(sha)
    cmd = "git --no-pager --git-dir=#{@repo_path} show --pretty='format:' --name-only #{sha}"
    raw_files = `#{cmd}`

    files = []
    raw_files.sub!("\n", "") # remove the first \n
    raw_files.each_line do |line|
      files << line.strip
    end
    
    return files
  end
end
