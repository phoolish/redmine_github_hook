class Git
  
  # Mirror remote repository.
  def mirror_repsitory(url, repository)
    exec(git_command("clone --mirror #{url}", repository))
  end
  
  # Fetches updates from the remote repository
  def update_repository(repository)
    command = git_command('fetch origin', repository)
    if exec(command)
      command = git_command("fetch origin '+refs/heads/*:refs/heads/*'", repository)
      exec(command)
    end
  end
  
  # Get remote url
  def get_remote_url(repository)
    exec(git_command("remote -v", repository))
  end
  
  private
  
  def git_command(command, git_dir)
    "git --git-dir='#{git_dir}' #{command}"
  end
  
  def exec(command)
    shell = Shell.new(command)
    shell.run
    success = (shell.exitstatus == 0)
    output_from_command = shell.output
    if success
      return output_from_command
    else
      p "Github: Command failed '#{command}' didn't exit properly. Full output: #{output_from_command.inspect}"
    end
  end
end
