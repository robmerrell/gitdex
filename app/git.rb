module Git
  
  class Commit
    attr_accessor :sha, :author, :committer, :commit_timestamp
    attr_reader :diff_files, :diff, :message
    
    def initialize
      @diff_files = []
    end
    
    def set_message!(repo_path)
      cmd = "git --no-pager --git-dir=#{repo_path} show --pretty=format:'%s' -s #{@sha}"
      @message = `#{cmd}`
    end
    
    def set_diff_files!(repo_path)
      cmd = "git --no-pager --git-dir=#{repo_path} show --pretty='format:' --name-only #{sha}"
      raw_files = `#{cmd}`
      
      raw_files.sub!("\n", "") # remove the first \n
      raw_files.each_line do |line|
        @diff_files << line.strip
      end
    end
    
    def set_diff!(repo_path)
      cmd = "git --no-pager --git-dir=#{repo_path} show --pretty='format:' #{sha}"
      @diff = `#{cmd}`
    end
  end

  
  class Repo
    attr_accessor :repo_path
    attr_accessor :commits
    
    def initialize(path)
      @repo_path = path + "/.git"
      @commits = []
      
      load_commits
    end
    
    private
      # assemble a collection of all commits of the repository
      # this can get rather large and use quite a bit of memory
      # on large repos, but I have RAM to spare at the moment
      def load_commits
        cmd = "git --no-pager --git-dir=#{@repo_path} log --pretty=format:'%H%x09%an%x09%cn%x09%at'"
        commit_logs = `#{cmd}`

        commit_logs.each_line do |line|
          commit_info = line.split("\t")

          commit = Commit.new
          commit.sha = commit_info[0].strip
          commit.author = commit_info[1].strip
          commit.committer = commit_info[2].strip
          commit.commit_timestamp = commit_info[3].strip
          commit.set_message!(@repo_path)
          commit.set_diff!(@repo_path)
          commit.set_diff_files!(@repo_path)

          @commits << commit
        end
      end
  end
  
end
