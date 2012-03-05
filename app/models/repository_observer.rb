class RepositoryObserver < ActiveRecord::Observer
  def before_save(repository)
    if Setting.plugin_redmine_github_hook[:enabled] && repository.type == 'Git' && repository.url.match('.*github.com')
      respistory_name = repository.url[/[\/][^\/]+.git/]
      repository_url = repository.url
      git_dir = Setting.plugin_redmine_github_hook[:git_dir].to_s
      repository = git_dir + respistory_name

      if !File.exists?(repository)
        if Git.new.mirror_repsitory(url, repository)
          repository.url = repository
        else
          return false
        end
      end
    end
  end
end
