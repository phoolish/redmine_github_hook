require_dependency 'repositories_helper'

module GithubRepositoriesHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :git_field_tags
    end
  end
  
  module InstanceMethods
    def git_field_tags_with_github(form, repository)
      git_field_tags form, repository
      if Setting.plugin_redmine_github_hook[:enabled]
        render :partial => "projects/settings/_github_repository.rhtml", :locals => { :project => repository.project }
      end
    end
  end
end

RepositoriesHelper.send(:include, GithubRepositoriesHelperPatch)