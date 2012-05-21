require 'github_api'

class RepositoryObserver < ActiveRecord::Observer
  def before_save(repository)
    if Setting.plugin_redmine_github_hook[:enabled] && repository.type == 'Git' && repository.url.match('.*github.com')
      repository_name = repository.url[/[\/][^\/]+.git/]
      git_dir = Setting.plugin_redmine_github_hook[:git_dir].to_s
      repository_path = git_dir + repository_name
#TODO: need error message if repository already exists.
      if !File.exists?(repository_path)
        if Git.new.mirror_repsitory(url, repository_path)
          repository.url = repository_path
        else
          return false
        end
      end
    end
  end
  def before_destroy(repository)
    
  end
end
